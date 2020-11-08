### Load Required Modules/Assemblies 

# Required for System.Xml.XmlNodeReader
Add-Type -AssemblyName PresentationFramework

# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
# We are assuming you may run this from an off domain computer... don't ask 
Import-Module ActiveDirectory -WarningAction SilentlyContinue

### Function Definitions 
function Close-Console
{
    $console = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($console, 0)
}

### Structure and Build our Form Our Form 
[xml]$mainFormXaml = Get-Content .\main_form.xaml
[xml]$confirmFormXaml = Get-Content .\confirm_form.xaml

try {
    $xmlMainReader = (New-Object System.Xml.XmlNodeReader $mainFormXaml)
    $mainForm = [Windows.Markup.XamlReader]::Load($xmlMainReader)
    $xmlConfirmReader = (New-Object System.Xml.XmlNodeReader $confirmFormXaml)
    $confirmForm = [Windows.Markup.XamlReader]::Load($xmlConfirmReader)
}
catch [System.Management.Automation.RuntimeException] {
  throw "Assembly wasn't loaded properly."
}
catch {
    throw "Unable to load form from provided XAML data."
}

# Now that our forms are loaded properly we can close the console. 
Close-Console

### Build our Controls from the Form Created 
# Main Form Controls 
$domainSelect = $mainForm.FindName("DomainSelect")
$userText = $mainForm.FindName("UserText")
$passwordText = $mainForm.FindName("PasswordText")
$resetButton = $mainForm.FindName("ResetButton")

# Confirm Form Controls 
$confirmText = $confirmForm.FindName("ConfirmText")
$confirmButton = $confirmForm.FindName("ConfirmButton")

### Build control form operations for confirm form 
$confirmButton.Add_Click({
  $confirmForm.Visibility = "Hidden"
})

### Work with Form Elements to Perform Operations 

#Populate the Domain Selection List
try {
  foreach ($d in $(Get-ADDomain)) {
    $domainSelect.AddChild($d.DNSRoot.ToString())
  }
}
catch {
  $domainSelect.AddChild("No Domains Available")
}


# Proceed to reset password since user has clicked the button
$resetButton.Add_Click({
    try {
      Set-ADAccountPassword -Identity $userText.Text -NewPassword $(ConvertTo-SecureString -String $passwordText -AsPlainText -Force) -Server $domainSelect.SelectedItem.ToString()
    }
    catch [System.Security.Authentication.AuthenticationException] {
      $confirmText.Text = @"
You do not  have the proper credentials to perform AD password resets. 

Please consult the administrator or switch to an account that does have proper credentials.
"@
    }
    catch {
      $confirmText.Text = @"
Some unknown error has occured.

Please consult your administrator in regards to this error.
"@
    }
    
    if (!($Error)) {
      $confirmText.Text = @"
Password has been successfully updated for user $($userText.Text).

Please notify user of the updated password through a secure means. 
"@
    }



    # Operations complete display success/failure to the user
    $confirmForm.Show()
})

### Present the form to the user now 
$mainForm.ShowDialog()