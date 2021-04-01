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


# Use Choco for installing the apps
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install 7zip arduino git github-desktop grepwin plantuml termite vscode visualstudio2019community

# Code extensions
code --install-extension ms-dotnettools.csharp
code --install-extension ms-python.python
code --install-extension ms-vscode.powershell
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension jebbs.plantuml
#code --install-extension platformio.platformio-ide
code --install-extension redhat.vscode-xml
code --install-extension sissel.shopify-liquid
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension vsciot-vscode.vscode-arduino
code --install-extension yiwwan.vscode-scope

Write-Host "All done! Now reboot for settings to take!"