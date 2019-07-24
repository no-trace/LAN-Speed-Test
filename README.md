# LAN-Speed-Test
Powershell script for testing SMB transfer speeds

Usage:
    .\Test-Speed.ps1 <filesize in MB> <local path> <remote path>
    All 3 arguments are required

Examples:
    .\Test-Speed.ps1 500 C: Z:\FolderName
    .\Test-Speed.ps1 1000 "C:\Test Dir" "\\TEST-SVR\Share Name\Folder Name"'
