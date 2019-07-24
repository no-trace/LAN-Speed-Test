# LAN-Speed-Test
Powershell script for testing SMB transfer speeds

Usage:
&nbsp;&nbsp;&nbsp;&nbsp;.\Test-Speed.ps1 <filesize in MB> <local path> <remote path>
&nbsp;&nbsp;&nbsp;&nbsp;All 3 arguments are required

Examples:
&nbsp;&nbsp;&nbsp;&nbsp;.\Test-Speed.ps1 500 C: Z:\FolderName
&nbsp;&nbsp;&nbsp;&nbsp;.\Test-Speed.ps1 1000 "C:\Test Dir" "\\TEST-SVR\Share Name\Folder Name"
