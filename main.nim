import os, json

const configFile = getHomeDir() / ".config/code-profile/config.json"
  
# Define the 'Language' and 'Config' types
type 
  # Each 'Language' object contains a 'directory' and 'profile' strings
  Language = object
    directory: string
    profile: string
  
  # Config is a sequence of Language objects
  Config = seq[Language]

proc loadConfig(): Config =
  let jsonNode = parseJson(readFile(configFile))

  for item in jsonNode["languages"].getElems():
    # Add a new 'Language' object to the result sequence
    result.add(Language(
      directory: item["directory"].getStr(),
      profile: item["profile"].getStr()
    ))

# Traverse up the directory tree until we find a parent directory that matches one in the configuration
proc findParent(path: string, config: Config): tuple[found: bool, profile: string] =
  var currentPath = path
  # Loop until we reach the root directory
  while currentPath != "/":
    # Get the directory name
    let dirName = currentPath.splitPath.tail
    # Check each language in the configuration
    for lang in config:
      # If the directory name matches, return the profile
      if lang.directory == dirName:
        return (true, lang.profile)
    # If no match is found, go up one level
    currentPath = currentPath.parentDir
  # If we've reached the root without finding a match, return false
  return (false, "")

# Main function
proc main() =
  # If config file doesn't exist, exit with error message
  if not fileExists(configFile):
    quit "Config not found at " & configFile
    
  # Load config and get cwd
  let 
    config = loadConfig()
    currentDir = getCurrentDir()
    # Try to find a matching parent directory
    (found, profile) = findParent(currentDir, config)
  
  # If no match is found, quit with an error message
  if not found:
    quit "No parent directory matching a defined language was found"
    
  # Construct the command to open the current directory with the matching profile
  let command = "code --profile \"" & profile & "\" \"" & currentDir & "\""

  discard execShellCmd(command)

when isMainModule:
  main()
