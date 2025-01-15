# Define the paths
$PATHA = "C:\PathA"  # Replace with your target directory
$PATHB = "C:\PathB"  # Replace with your source directory

# Check if PATHA exists
if (-Not (Test-Path -Path $PATHA)) {
    Write-Output "Error: PATHA does not exist. Exiting script."
    exit 1
}

# Check if PATHB exists
if (-Not (Test-Path -Path $PATHB)) {
    Write-Output "Error: PATHB does not exist. Exiting script."
    exit 1
}

# Remove all files and subdirectories in PATHA
Get-ChildItem -Path $PATHA -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction Stop
Write-Output "All files and subdirectories in PATHA have been removed."

# Copy all files and subdirectories from PATHB to PATHA
Copy-Item -Path (Join-Path -Path $PATHB -ChildPath '*') -Destination $PATHA -Recurse -Force -ErrorAction Stop
Write-Output "All files and subdirectories from PATHB have been copied to PATHA."
