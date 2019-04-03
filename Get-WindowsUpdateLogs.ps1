function Get-WindowsUpdateLogs {
<#
.Synopsis
Gathers the Windows Update Logs
.DESCRIPTION
Gathers the Windows Update Logs
.EXAMPLE
Get-WindowsUpdateLogs -ComputerName Joe-Win10-01 -Cherwell 123456
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
$LogPath = ([Environment]::GetFolderPath("Desktop")+"\windowsupdate.log")


if (
Test-Connection -ComputerName "$ComputerName" -count 1 -ErrorAction SilentlyContinue)
#Succeeded
{
Write-Host "$ComputerName is Online...Finding Windows Update Logs" -ForegroundColor Green

#New-Item $LogPath -ItemType Directory -Force


    #Run WLAN Report
    Invoke-Command -ComputerName "$ComputerName" -ScriptBlock {Invoke-Expression Get-WindowsUpdateLog}
    
    #Wait for Report to Generate
    Start-Sleep -Seconds 10

    #Copy Report
    Write-Host "Copying Windows Update Logs to Server..."
    New-Item -Path $Destination\$Cherwell -ItemType "directory" -ErrorAction SilentlyContinue
    Copy-Item -Path "$LogPath" -Destination "$Destination\$Cherwell\wulog_$Filename.log"

    #Test Path
    Test-Path $Destination -PathType Any
    Write-Host "Finished: Windows Update Log Copied to $Destination$Cherwell" -ForegroundColor Green
  
    Exit-PSSession
    }
#Failed 
Else {
Write-Host "Test-Connection Failed. Please check connection to the remote computer." -ForegroundColor Red
   }


    }
