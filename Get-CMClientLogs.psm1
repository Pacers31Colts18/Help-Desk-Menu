function Get-CMClientLogs {
<#
.Synopsis
Gathers SCCM Client Log Files
.DESCRIPTION
Gathers SCCM Client Log Files
.EXAMPLE
Get-CMClientLogs -ComputerName Joe-Win10-01 -Cherwell 12345
.PARAMETER ComputerName
Enter the computer name.
.PARAMETER Cherwell
Enter the associated Cherwell Ticket ID
.NOTES
Written by Joe Loveless 3/5/2019
#>

$Destination = "\\intfirm.com\dfs1\Shared\TEO\TEO_Shared\_Temp\_HEALTHCHECK\"
$Filename = ((Get-Date).Date).ToString("dd/MM/yyyy").Replace("/","-") + "_" + $cherwell
#Log Path for SCCM Client Log Files
$LogPath = Get-ItemProperty -path HKLM:\Software\Microsoft\CCM\Logging\@Global
$Log = $logpath.LogDirectory

if (
Test-Connection -ComputerName "$ComputerName" -count 1 -ErrorAction SilentlyContinue)
#Succeeded
{
Write-Host "$ComputerName is Online...Finding SCCM Client Logs" -ForegroundColor Green

#Create Folders
New-Item "\\$ComputerName\c$\Logs" -ItemType Directory -Force
Copy-Item -Path $Log\* -Destination "\\$ComputerName\c$\Logs"

#Create a .zip archive with SCCM logs
Write-Host "Creating archive file..."
Compress-Archive -Path \\$ComputerName\c$\Logs\* -CompressionLevel Optimal -DestinationPath "\\$ComputerName\c$\Logs\$Filename.zip"

#Copy zipped logfile to server share
New-Item -Path "$Destination\$Cherwell\" -ItemType "directory" -ErrorAction SilentlyContinue
Copy-Item \\$ComputerName\c$\Logs\$Filename.zip -Destination "$Destination\$Cherwell\CMLogs_$Filename.zip"


#Test Path
Test-Path "$Destination$Cherwell" -PathType Any
Write-Host "Finished: Logs Copied to $Destination$Cherwell" -ForegroundColor Green

#Cleanup Temporary Files
Remove-Item \\$ComputerName\c$\Logs -Recurse
}
#Failed 
Else {
Write-Host "Test-Connection Failed. Please check connection to the remote computer." -ForegroundColor Red
}
}