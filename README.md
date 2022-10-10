# `setup-pc`

Set up a Windows 11 Pro PC using PowerShell.

To use this script:

1. Set up the PC (automatic update, etc.)
2. log in as administrator
3. get the script onto the machine.
4. Launch an administrator powershell windows.

    ```powershell
    set-ExecutionPolicy Bypass Process
    {path}\setupPC
    ```

It will run for a while, and in the end you'll have a clean PC, set up as follows.

1. Won't sleep on AC; useful for remote access.
2. Hibernation enabled
3. Explorer set up with file extensions and hidden files visible, no checkboxes.
4. An attempt at disabling some of the consumer things that appear on Win11 Pro.
5. Alexa and similar things removed.
6. A set of initial local users (no password, must change password at next login)
7. Git for Windows, Visual Studio Code, Windows subsystem for Linux and a bunch of extensions for code installed.

