### Load Required Modules/Assemblies 
Add-Type -AssemblyName PresentationFramework

### Structure and Build our Form Our Form 
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Width="375" Height="225" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="0,47,0,0">
  <Grid Margin="0,0,0,0">
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

try {
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
}
catch {
    throw "Unable to load form from provided XAML data."
}

### Build our Controls from the Form Created 
$DomainSelect = $window.FindName("DomainSelect")
$UserText = $window.FindName("UserText")
$PasswordText = $window.FindName("PasswordText")
$ResetButton = $window.FindName("ResetButton")

### Work with Form Elements to Perform Operations 

#Populate the Domain Selection List

# Proceed to reset password since user has clicked the button
$ResetButton.Add_Click({
    
})

### Present the form to the user now 
$window.ShowDialog()