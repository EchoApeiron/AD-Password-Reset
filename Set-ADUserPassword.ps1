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

### Function Definitions 
function Close-Console
{
    $console = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($console, 0)
}

### Let's hide the console now and start building our form 
Close-Console

### Structure and Build our Form Our Form 
[xml]$mainFormXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Width="375" Height="225" HorizontalAlignment="Left" VerticalAlignment="Top">
  <Grid>
    <Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Domain" Margin="15,18,0,0" Name="DomainLabel"></Label>
    <Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="User Name" Margin="11,52,0,0" Name="UserNameLabel"></Label>
    <Label HorizontalAlignment="Left" VerticalAlignment="Top" Content="Password" Margin="16,90,0,0" Name="PasswordLabel"></Label>
    <ComboBox HorizontalAlignment="Left" VerticalAlignment="Top" Width="250" Margin="82,20,0,0" Name="DomainSelect"></ComboBox>
    <TextBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="29" Width="250" TextWrapping="Wrap" Margin="82,52,0,0" FontSize="14" Text="aUserName" Name="UserText"></TextBox>
    <PasswordBox HorizontalAlignment="Left" VerticalAlignment="Top" Height="23" Width="250" Margin="82,90,0,0" Name="PasswordText"></PasswordBox>
    <Button Content="Reset" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Margin="145,146,0,0" Name="ResetButton"></Button>
  </Grid>
</Window>
"@

[xml]$confirmFormXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Width="250" Height="250">
  <Grid Margin="-3,0,3,0">
    <TextBlock HorizontalAlignment="Left" VerticalAlignment="Top" TextWrapping="Wrap" Text="TextBlock" Margin="37,25,0,0" Background="#e4e4e7" Width="178" Height="113" Name="ConfirmText"></TextBlock>
    <Button Content="OK" HorizontalAlignment="Left" VerticalAlignment="Top" Width="75" Margin="92,154,0,0" Name="ConfirmButton"></Button>
  </Grid>
</Window>
"@

try {
    $xmlMainReader = (New-Object System.Xml.XmlNodeReader $mainFormXaml)
    $mainForm = [Windows.Markup.XamlReader]::Load($xmlMainReader)
    $xmlConfirmReader = (New-Object System.Xml.XmlNodeReader $confirmFormXaml)
    $confirmForm = [Windows.Markup.XamlReader]::Load($xmlConfirmReader)
}
catch {
    throw "Unable to load form from provided XAML data."
}

### Build our Controls from the Form Created 

# Main Form Controls 
$domainSelect = $mainForm.FindName("DomainSelect")
$userText = $mainForm.FindName("UserText")
$passwordText = $mainForm.FindName("PasswordText")
$resetButton = $mainForm.FindName("ResetButton")

# Confirm Form Controls 
$confirmText = $confirmForm.FindName("ConfirmText")
$confirmButton = $confirmForm.FindName("ConfirmButton")

### Work with Form Elements to Perform Operations 

#Populate the Domain Selection List
$domainSelect.AddChild("Domain One")
$domainSelect.AddChild("Domain Two")

# Proceed to reset password since user has clicked the button
$resetButton.Add_Click({
    Write-Host $domainSelect.Text
    Write-Host $userText.Text 
    Write-Host $passwordText.Password

    $confirmText.Text = @"
Some random text that I'm going to just type a lot of stuff into the box to see how it renders. I will just type a bit more random shit. 
"@
    # Operations complete display success/failure to the user
    $confirmForm.Show()
})

### Build control form operations for confirm form 
$confirmButton.Add_Click({
  $confirmForm.Visibility = "Hidden"
})

### Present the form to the user now 
$mainForm.ShowDialog()