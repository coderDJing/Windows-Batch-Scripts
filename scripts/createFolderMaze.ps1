<#
.SYNOPSIS
Creates a folder maze based on a password.

.DESCRIPTION
This script creates a folder maze structure where the correct path is determined by the password.
Each level of the maze contains both correct and incorrect paths, making it a challenge to find
the right sequence of folders that matches the password.

.NOTES
- The password must only contain alphanumeric characters (a-z, A-Z, 0-9)
- Each character in the password represents a folder in the correct path
- Wrong paths are generated randomly to create confusion
#>

# Set password and base path
$password = "abc123"

# Validate if password only contains alphanumeric characters
if ($password -notmatch "^[a-zA-Z0-9]+$") {
    Write-Error "Password can only contain letters and numbers!"
    exit 1
}

$basePath = Join-Path $PSScriptRoot "folderMaze"
$chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()

# Create base folder
if (Test-Path $basePath) {
    Remove-Item -Path $basePath -Recurse -Force
}
New-Item -Path $basePath -ItemType Directory | Out-Null

# Create folders for the correct path
function New-CorrectPath {
    param (
        [string]$currentPath,
        [int]$level
    )
    
    # Exit if we've reached the password length
    if ($level -ge $password.Length) {
        return
    }
    
    # Get the current password character for this level
    $currentChar = $password[$level]
    
    # Create the correct password folder
    $correctFolder = Join-Path $currentPath $currentChar
    New-Item -Path $correctFolder -ItemType Directory | Out-Null
    
    # Create a random folder (ensure it's different from the password character)
    do {
        $wrongChar = $chars | Get-Random
    } while ($wrongChar -eq $currentChar)
    
    $wrongFolder = Join-Path $currentPath $wrongChar
    New-Item -Path $wrongFolder -ItemType Directory | Out-Null
    
    # Continue creating next level
    if ($level + 1 -lt $password.Length) {
        New-CorrectPath -currentPath $correctFolder -level ($level + 1)
        New-WrongPath -currentPath $wrongFolder -level ($level + 1)
    }
}

# Create folders for the wrong paths
function New-WrongPath {
    param (
        [string]$currentPath,
        [int]$level
    )
    
    # Exit if we've reached the password length
    if ($level -ge $password.Length) {
        return
    }
    
    # Create two different random folders
    do {
        $wrongChar1 = $chars | Get-Random
        $wrongChar2 = $chars | Get-Random
    } while ($wrongChar1 -eq $wrongChar2)
    
    $wrongFolder1 = Join-Path $currentPath $wrongChar1
    $wrongFolder2 = Join-Path $currentPath $wrongChar2
    
    New-Item -Path $wrongFolder1 -ItemType Directory | Out-Null
    New-Item -Path $wrongFolder2 -ItemType Directory | Out-Null
    
    # Continue creating next level
    if ($level + 1 -lt $password.Length) {
        New-WrongPath -currentPath $wrongFolder1 -level ($level + 1)
        New-WrongPath -currentPath $wrongFolder2 -level ($level + 1)
    }
}

# Create first level: one correct folder (first character of password) and one random folder
$firstChar = $password[0]
$firstCorrectPath = Join-Path $basePath $firstChar
New-Item -Path $firstCorrectPath -ItemType Directory | Out-Null

# Create random folder for first level
do {
    $wrongChar = $chars | Get-Random
} while ($wrongChar -eq $firstChar)

$firstWrongPath = Join-Path $basePath $wrongChar
New-Item -Path $firstWrongPath -ItemType Directory | Out-Null

# Start creating subsequent levels
New-CorrectPath -currentPath $firstCorrectPath -level 1
New-WrongPath -currentPath $firstWrongPath -level 1