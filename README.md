# `setup-pc`

Set up a Windows 11 Pro PC using PowerShell.

To use this script:

1. Set up the PC (automatic update, etc.)
2. log in as administrator
3. get the script onto the machine.
4. Launch an administrator PowerShell windows.

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
8. Remote desktop access will be enabled.

## User definition

If a file named `users.json` exists in the current directory, it is read to get the list of users to be created. This file must be a JSON array, with the following general format:

```json
[
  {
    "name": "user1",
    "fullname": "User1 Full Name",
    "description": "User1 description"
  },
  {
    "name": "user2",
    "fullname": "User2 Full Name",
    "description": "User2 description"
  }
]
```

A JSON schema is provided, "`users-schema.json`". You can set your copy of VS Code to validate `users.json` by adding the following to `.vscode/settings.json`.

```json
  "json.schemas": [
    {
      "fileMatch": ["users.json", "!*.schema.json"],
      "url": "./users-schema.json"
    }
  ]
```
