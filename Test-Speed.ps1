Write-Host "
Created July 2019 by T.K. Garrett
"

# Functions
function How-To {
    Write-Host '
    Usage:
        .\Test-Speed.ps1 <filesize in MB> <local path> <remote path>
        All 3 arguments are required

    Examples:
        .\Test-Speed.ps1 500 C: Z:\FolderName
        .\Test-Speed.ps1 1000 "C:\Test Dir" "\\TEST-SVR\Share Name\Folder Name"'
    }

# Status message coloring
function Success-Box { 
    Write-Host "[+] " -ForegroundColor Green -NoNewline
    }
function Fail-Box { 
    Write-Host "[-] " -ForegroundColor Red -NoNewline
    }

# Usage
If ($args[2] -eq $null) {
    Fail-Box; Write-Host "Not enough arguments!"
    How-To
    Exit
    }
If ($args[3] -ne $null) {
    Fail-Box; Write-Host "Too many arguments! (If you have spaces in your file path(s), try using quotes.)"
    How-To
    Exit
    }
If ($args[0] -notmatch "^\d+$") {
    Fail-Box; Write-Host "The first argument should be a number! (The size of the test file in megabytes)"
    How-To
    Exit
    }

# Declare test parameters
$testFileSizeMB = $args[0]
$localTestPath = $args[1]
$serverTestPath = $args[2]
$testFileName = "test.file"

# Create test file with random data
Success-Box; Write-Host "Creating test file.............................................: ${localTestPath}\${testFileName}"

If (-Not (Test-Path $localTestPath)) {
    New-Item -ItemType directory -Path $localTestPath >null
    }
$bytes = $testFileSizeMB * 1MB
$out = new-object byte[] $bytes; (new-object Random).NextBytes($out); [IO.File]::WriteAllBytes("${localTestPath}\${testFileName}", $out)
If (-Not (Test-Path "${localTestPath}\${testFileName}")) {
    Fail-Box; Write-Host "Could not create test file!"
    exit
    }

# Upload test - Copy test file from local machine to server and print transfer rate
Success-Box; Write-Host "Copying test file to remote location...........................: ${localTestPath}\${testFileName} to ${serverTestPath}\${testFileName}"
$uploadStartTime = Get-Date
Copy-Item "${localTestPath}\${testFileName}" -Destination "${serverTestPath}\${testFileName}"
$uploadEndTime = Get-Date
$uploadCopyTime = (New-TimeSpan $uploadStartTime $uploadEndTime).TotalSeconds
$megabits = $testFileSizeMB * 8
$uploadTransferRate = [int]($megabits / $uploadCopyTime)

# Remove local test file before performing download test
Success-Box; Write-Host "Deleting local test file before performing download test.......: ${localTestPath}\${testFileName}"
Remove-Item "${localTestPath}\${testFileName}"

# Download test - Copy test file from server to local machine and print transfer rate
Success-Box; Write-Host "Downloading test file from remote location.....................: ${serverTestPath}\${testFileName} to ${localTestPath}\${testFileName}"
$downloadStartTime = Get-Date
Copy-Item "${serverTestPath}\${testFileName}" -Destination "${localTestPath}\${testFileName}"
$downloadEndTime = Get-Date
$downloadCopyTime = (New-TimeSpan $downloadStartTime $downloadEndTime).TotalSeconds
$megabits = $testFileSizeMB * 8
$downloadTransferRate = [int]($megabits / $downloadCopyTime)

# Perform clean-up of test files
Success-Box; Write-Host "Cleaning up files"
Remove-Item "${localTestPath}\${testFileName}"
Remove-Item "${serverTestPath}\${testFileName}"

# Print results
Write-Host "
[RESULTS]
Local path......: ${localTestPath}
Test path.......: ${serverTestPath}
File size.......: ${testFileSizeMB} MB
Upload time.....: ${uploadCopytime} seconds
Upload speed....: ${uploadTransferRate} Mbps
Download time...: ${downloadCopyTime} seconds
Download speed..: ${downloadTransferRate} Mbps"

If (($uploadTransferRate -gt 1000) -Or ($downloadTransferRate -gt 1000)) {
    Write-Host ""
    Write-host "(It looks like your transfer speed was greater than 1000 Mbps at some point. Something may have gone wrong. Unless, of course, your network is using technology that allows for faster transfers.)" -ForegroundColor Yellow
    }