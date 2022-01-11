# Prep WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

### Make it mine
# Hibernate
powercfg /Change standby-timeout-ac 0
powercfg.exe /hibernate on
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSetting" /v ShowHibernateOption /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v ShowHibernateOption /t REG_DWORD /d 1 /f
# Mouse
reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d 20 /f
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Mouse" /v MouseTrails /t REG_SZ /d 7 /f
# Mouse pointer size to 3
reg add "HKCU\Software\Microsoft\Accessibility" /v CursorSize /t REG_DWORD /d 3 /f
# Powershell here menu
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLinkedConnections /t REG_DWORD /d 00000001 /f
reg add HKCR\Directory\shell\powershellmenu /d "Open PowerShell Here" /f
reg add HKCR\Directory\shell\powershellmenu\command /d "powershell.exe -NoExit -Command Set-Location -LiteralPath '%L'" /f
# Powershell fonts
$psList= '%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe', 'HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
foreach ($i in $psList) {
  reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v FaceName /t REG_SZ /d "Consolas" /f
  reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v FontFamily /t REG_DWORD /d 54 /f
  reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v FontSize /t REG_DWORD /d 917504 /f
  reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v FontWeight /t REG_DWORD /d 400 /f
}

# Use Choco for installing the apps
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# github-desktop
choco install 7zip arduino arduino-cli git grepwin plantuml termite vscode visualstudio2022community

#refresh envionment based on new installs from choco
$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
refreshenv

# https://mermaid-js.github.io/mermaid

# Code extensions
code --install-extension ms-dotnettools.csharp
code --install-extension ms-python.python
code --install-extension ms-vscode.powershell
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension docsmsft.docs-markdown
# docsmsft.docs-images docsmsft.docs-yaml
code --install-extension jebbs.plantuml
#code --install-extension platformio.platformio-ide
code --install-extension redhat.vscode-xml
code --install-extension sissel.shopify-liquid
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension vsciot-vscode.vscode-arduino
code --install-extension yiwwan.vscode-scope

# keep defender away from known good
Add-MpPreference -ExclusionPath D:\ScopePrj, d:\git -Force
#Add-MpPreference -ExclusionExtension obj, lib, c, cpp, cs, h, kql, script  -Force
Add-MpPreference -ExclusionProcess code.exe, devenv.exe -Force


Write-Host "All done! Now reboot for settings to take!"