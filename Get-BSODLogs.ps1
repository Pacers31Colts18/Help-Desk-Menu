function Get-BSODLogs {
<#
.Synopsis
Gathers BSOD Logs if they exist.
.DESCRIPTION
Gathers BSOD Logs if they exist.
.EXAMPLE
Get-BSODLogs -ComputerName Joe-Win10-01 -Cherwell 123456
.PARAMETER ComputerName
Enter the computer name.
.PARAMETER Cherwell
Enter the associated Cherwell Ticket ID
.NOTES
Written by Joe Loveless 3/5/2019
#>

$Destination = "\\intfirm.com\dfs1\Shared\TEO\TEO_Shared\_Temp\_HEALTHCHECK\"
$Filename = ((Get-Date).Date).ToString("dd/MM/yyyy").Replace("/","-") + "_" + $cherwell
#Log Path for Windows Update Log Files
$LogPath = "\\$ComputerName\c$\Windows\"
$ErrorActionPreference = Write-Host "Memory.dmp file does not exist"
$Connected = Test-Connection -ComputerName "$ComputerName" -count 1 -ErrorAction SilentlyContinue
$TestPath = Test-Path "$LogPath\memory.dmp"

if (($Connected) -and ($TestPath))

#Succeeded
{
Write-Host "$ComputerName is Online and .dmp file exists" -ForegroundColor Green


#Create Folders
New-Item "\\$ComputerName\c$\Logs" -ItemType Directory -Force
Copy-Item -Path $LogPath\memory.dmp -Destination "\\$ComputerName\c$\Logs" -ErrorAction $ErrorActionPreference

#Create a .zip archive with Windows update Logs
Write-Host "Creating archive file..."
Compress-Archive -Path \\$ComputerName\c$\Logs\* -CompressionLevel Optimal -DestinationPath "\\$ComputerName\c$\Logs\$Filename.zip"

#Copy zipped logfile to server share
New-Item -Path "$Destination\$Cherwell\" -ItemType "directory" -ErrorAction SilentlyContinue
Copy-Item \\$ComputerName\c$\Logs\$Filename.zip -Destination "$Destination\$Cherwell\BSOD_$Filename.zip"


#Test Path
Test-Path "$Destination$Cherwell" -PathType Any
Write-Host "Finished: Logs Copied to $Destination$Cherwell" -ForegroundColor Green

#Cleanup Temporary Files
Write-Host "Removing Temporary Files....Please Wait."
Remove-Item \\$ComputerName\c$\Logs -Recurse -Force
}
#Failed 
Else {
Write-Host "Test-Connection Failed. Please check connection to the remote computer." -ForegroundColor Red
}
}