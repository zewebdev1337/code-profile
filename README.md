# code-profile

Open cwd in VSCode with the appropriate profile.

## Configuration

The program expects a configuration file at `~/.config/code-profile/config.json` with the following structure:

```jsonc
{
  "languages": [
    {
      // Both are case-sensitive!
      "directory": "python",
      "profile": "Python"
    }, 
    {
      "directory": "go",
      "profile": "Go Local"
    }
  ]
}
```

Each object in the `languages` array defines a mapping between a directory name and a Visual Studio Code profile.

## Usage

Once you're inside a directory whose parent directory is defined in the configuration file, regardless of whether it's the immediate parent or not, run `vscode`. VSCode will be launched with the profile associated with the matching parent directory.

**Example:**

Given the configuration file above:

If cwd is `/home/user/Projects/python/applications/gui/app`, running `vscode` will open the project in VSCode with the "Python" profile.

## Installation

```bash
nim c -d:release main.nim
```
OR
```bash
scripts/install # This will build the binary and place it at `/usr/local/bin/vscode`
```