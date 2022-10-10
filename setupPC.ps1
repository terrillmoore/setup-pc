##############################################################################
#
# Name: setupPC.ps1
#
# Function:
#       Set up a Windows 11 Professional PC for use at MCCI
#
# Copyright notice and license:
#       See LICENSE.md
#
# Author:
#       Robbie Harris
#       Adapted for MCCI by Terry Moore
#
##############################################################################

# Prep WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

### Make it mine
# Timeout / battery prefs -- leave it online when there's power,
# so we can RDP in.
powercfg /Change monitor-timeout-ac 5
powercfg /Change standby-timeout-ac 0
powercfg /Change monitor-timeout-dc 5
powercfg /Change standby-timeout-dc 30

# turn off content manager stuff
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /d 1 /t REG_DWORD /f
reg add "HKCU\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /d 1 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /d 0 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /d 0 /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /d 0 /t REG_DWORD /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v ContentDeliveryAllowed /d 0 /t REG_DWORD /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /d 0 /t REG_DWORD /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /d 0 /t REG_DWORD /f

# Explorer
$keys = @(
  "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
  )
foreach ($key in $keys) {
  Set-ItemProperty $key AutoCheckSelect 0
  Set-ItemProperty $key Hidden 1
  Set-ItemProperty $key HideFileExt 0
  Set-ItemProperty $key ShowSuperHidden 1
  }

# stop Explorer; it will restart and reload the above keys.
Stop-Process -processname explorer

# Hibernate
powercfg.exe /hibernate on
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSetting" /v ShowHibernateOption /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v ShowHibernateOption /t REG_DWORD /d 1 /f

# remove alexa etc.
$wingetUninstallApps = @(
  "Amazon Alexa"
  "Microsoft 365 - en-us"
  "Disney+"
  "McAfee LiveSafe"
  "WebAdvisor by McAfee"
  "News" 
  "MSN Weather" 
  "Office" 
  "Microsoft OneNote - en-us" 
  "Spotify Music" 
  )
foreach ($app in $wingetUninstallApps) {
  winget uninstall --accept-source-agreements --name $app --purge --silent
}

Install-PackageProvider -Name NuGet -minimumversion 2.8.5.208 -force
# Get-Package -Provider Programs -IncludeWindowsInstaller -Name "Microsoft 365 - en-us" | Uninstall-Package -force
# Get-Package -Provider Programs -IncludeWindowsInstaller -Name "Microsoft OneNote - en-us" | Uninstall-Package -force
# Get-Package -Provider Programs -IncludeWindowsInstaller -Name "McAfee LiveSafe" | Uninstall-Package -force
# Get-Package -Provider Programs -IncludeWindowsInstaller -Name "WebAdvisor by McAfee" | Uninstall-Package -force

# keep defender away from known good
# Add-MpPreference -ExclusionPath D:\ScopePrj, d:\git -Force
#Add-MpPreference -ExclusionExtension obj, lib, c, cpp, cs, h, kql, script  -Force
Add-MpPreference -ExclusionProcess code.exe, devenv.exe -Force

# install users
$initialUsers = @(
  )

foreach ($user in $initialUsers) {
  New-LocalUser -name $user -disabled -nopassword
  Set-LocalUser -name $user -PasswordNeverExpires $false
  Add-LocalGroupMember -Member $user -Group Administrators
  Enable-LocalUser -Name $user
}

# remove appX apps that we don't watn
$AppXApps = @(
  #Unnecessary Windows 10/11 AppX Apps
  "*Microsoft.BingNews*"
  "*Microsoft.GetHelp*"
  "*Microsoft.Getstarted*"
  "*Microsoft.Messaging*"
  "*Microsoft.Microsoft3DViewer*"
  "*Microsoft.MicrosoftOfficeHub*"
  "*Microsoft.MicrosoftSolitaireCollection*"
  "*Microsoft.NetworkSpeedTest*"
  "*Microsoft.Office.Sway*"
  "*Microsoft.OneConnect*"
  "*Microsoft.People*"
  "*Microsoft.Print3D*"
  "*Microsoft.SkypeApp*"
  "*Microsoft.WindowsFeedbackHub*"
  "*Microsoft.Xbox.TCUI*"
  "*Microsoft.XboxApp*"
  "*Microsoft.XboxGameOverlay*"
  "*Microsoft.XboxIdentityProvider*"
  "*Microsoft.XboxSpeechToTextOverlay*"
  "*Microsoft.ZuneMusic*"
  "*Microsoft.ZuneVideo*"
  "*MicrosoftTeams*"
  #Sponsored Windows 10 AppX Apps
  #Add sponsored/featured apps to remove in the "*AppName*" format
  "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
  "*AmazonAlexa*"
  "*Duolingo-LearnLanguagesforFree*"
  "*CandyCrush*"
  "*Wunderlist*"
  "*Flipboard*"
  "*Twitter*"
  "*Facebook*"
  "*Instagram*"
  "*TikTok*"
  "*Prime Video*"
  "*WhatsApp*"
  "*Messenger*"
)

foreach ($App in $AppXApps) {
  Write-Verbose -Message ('Removing Package {0}' -f $App)
  Get-AppxPackage -Name $App | Remove-AppxPackage -ErrorAction SilentlyContinue
  Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
  Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $App | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# install 
$wingetApps = @(
  "git.git" 
  "Microsoft.VisualStudioCode" 
  )
foreach ($app in $wingetApps) {
  winget install --id $app --accept-source-agreements --accept-package-agreements --scope machine
}

# reload the path per https://stackoverflow.com/questions/17794507/reload-the-path-in-powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install code extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.powershell
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension redhat.vscode-xml

# Who doesn't love WSL
wsl --install -d ubuntu

Write-Host "All done! Now reboot for settings to take!"
