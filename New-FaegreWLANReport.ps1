function New-FaegreWLANReport {
<#
.Synopsis
   Runs a netsh wlan report.
.DESCRIPTION
Runs a netsh wlan report and copies to a specified server.
.EXAMPLE
New-FaegreWLANReport -ComputerName Joe-Win10-01 -Cherwell 123456
.PARAMETER ComputerName
Enter the computer name.
.PARAMETER Cherwell
Enter the associated Cherwell Ticket ID
.NOTES
Written by Joe Loveless 3/5/2019
#>

    [CmdletBinding(
        PositionalBinding=$False)]
    Param
    (   

        # Computer Name
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$False,
                   HelpMessage="Enter the Computer Name."
                   )]
         [String]$ComputerName,

        # Cherwell
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$False,
                   HelpMessage="Enter the Cherwell Ticket ID."
                   )]
                  [int32]$Cherwell    
        
                         )

        $Destination = "\\intfirm.com\dfs1\Shared\TEO\TEO_Shared\_Temp\_HEALTHCHECK\"
        $Filename = ((Get-Date).Date).ToString("dd/MM/yyyy").Replace("/","-") + "_" + $cherwell

if (
Test-Connection -ComputerName "$ComputerName" -count 1 -ErrorAction SilentlyContinue)
#Succeeded
   {     
    Write-Host "$ComputerName is Online" -ForegroundColor Green
    Enter-PSSession -ComputerName "$ComputerName"
  
    #Run WLAN Report
    Invoke-Command -ComputerName "$ComputerName" -ScriptBlock {Invoke-Expression 'netsh wlan show wlanreport'}
    
    #Wait for Report to Generate
    Start-Sleep -Seconds 10

    #Copy Report
    Write-Host "Copying Report to Server"
    New-Item -Path $Destination\$Cherwell -ItemType "directory" -ErrorAction SilentlyContinue
    Copy-Item -Path \\$ComputerName\c$\ProgramData\Microsoft\Windows\WlanReport\wlan-report-latest.html -Destination "$Destination\$Cherwell\wlan-report-latest_$Filename.html"

    #Test Path
    Test-Path $Destination -PathType Any
    Write-Host "Finished: Report Copied to $Destination$Cherwell" -ForegroundColor Green
  
    Exit-PSSession
    }
#Failed 
Else {
Write-Host "Test-Connection Failed. Please check connection to the remote computer." -ForegroundColor Red
   }


    }
