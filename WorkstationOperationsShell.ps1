<##================================================##
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
WorkstationOperationsShell.ps1
.NOTES
Version 1.0
Written by Joe
Created:    03/19/2019
Updated:    
##================================================##>

#Requires -RunAsAdministrator

## Get Directory Location ##
$Script:Location = Get-Location
$PSCommandPath = $Script:Location

##Global Variables##
$Global:ComputerName
$Global:Cherwell
$RemoteUser = $env:USERNAME


## Define Functions ##

     
Function Banner {
    $a = @"

    *** Intfirm Workstation Operations Shell ****
"@
    $a
}
# Welcome
Function Welcome ($RemoteUser) {
    #Import Active Directory Module
    Import-Module ActiveDirectory
    Clear-Host
    Banner
    }
# Cherwell
Function Cherwell {

    $Global:Cherwell = Read-Host "Please enter the Cherwell Incident / Service Request number"
    $Global:ComputerName = Read-Host "Please enter the Computer Name"
    CherwellHeader $Cherwell $RemoteUser $ComputerName
    MainMenu $Cherwell $RemoteUser $ComputerName
}

# Cherwell Header
Function CherwellHeader ($Global:Cherwell, $RemoteUser, $Global:ComputerName) {
    Welcome $RemoteUser
    $a = @"

    Current User:       $RemoteUser
    Cherwell Ticket:    $Global:Cherwell
    Computer Name:      $Global:ComputerName

"@
    $a
}
# Main Menu
Function MainMenu ($Global:Cherwell, $RemoteUser) {
    $b = @"

*** Main Menu ***

Please select operation action

 1. Change Cherwell Ticket Number

 2. WLAN Report
 3. SCCM Client Logs
 4. Panther Logs
 5. Windows Update Logs
 6. BSOD Logs

 0. Exit

"@
    $b
    Start-Sleep 1
    $opt = Read-Host "Selection"
    switch ($opt) {
        1 {
            Cherwell
        }
        2 {
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Import-Module $Script:Location\New-FaegreWLANReport.psm1
            New-FaegreWLAnReport
            Write-Host "`n"
            Pause
#Remove New-FaegreWLANReport Module
            Remove-Module New-FaegreWLANReport
#Reload Header and Menu
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Start-Sleep 1
            Welcome $RemoteUser
    $a = @"

    Current User:       $RemoteUser
    Cherwell Ticket:    $Global:Cherwell
    Computer Name:      $Global:ComputerName

"@
    $a
            MainMenu $Cherwell $RemoteUser $ComputerName
            
        }
        3 {
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Import-Module $Script:Location\Get-CMClientLogs.psm1
            Get-CMClientLogs
            Write-Host "`n"
            Pause
#Remove New-FaegreWLANReport Module
            Remove-Module Get-CMClientLogs
#Reload Header and Menu
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Start-Sleep 1
            Welcome $RemoteUser
    $a = @"

    Current User:       $RemoteUser
    Cherwell Ticket:    $Global:Cherwell
    Computer Name:      $Global:ComputerName

"@
    $a
            MainMenu $Cherwell $RemoteUser $ComputerName
        }
        4 {
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Import-Module $Script:Location\Get-PantherLogs.psm1
            Get-PantherLogs
            Write-Host "`n"
            Pause
#Remove New-FaegreWLANReport Module
            Remove-Module Get-PantherLogs
#Reload Header and Menu
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Start-Sleep 1
            Welcome $RemoteUser
    $a = @"

    Current User:       $RemoteUser
    Cherwell Ticket:    $Global:Cherwell
    Computer Name:      $Global:ComputerName

"@
    $a
            MainMenu $Cherwell $RemoteUser $ComputerName
        }
        
        5 {
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Import-Module $Script:Location\Get-WindowsUpdateLogs.psm1
            Get-WindowsUpdateLogs
            Write-Host "`n"
            Pause
#Remove New-FaegreWLANReport Module
            Remove-Module Get-WindowsUpdateLogs1
#Reload Header and Menu
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Start-Sleep 1
            Welcome $RemoteUser
    $a = @"

    Current User:       $RemoteUser
    Cherwell Ticket:    $Global:Cherwell
    Computer Name:      $Global:ComputerName

"@
    $a
            MainMenu $Cherwell $RemoteUser $ComputerName
        }
        
        6 {
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Import-Module $Script:Location\Get-BSODLogs.psm1
            Get-BSODLogs
            Write-Host "`n"
            Pause
#Remove New-FaegreWLANReport Module
            Remove-Module Get-BSODLogs
#Reload Header and Menu
            CherwellHeader $Cherwell $RemoteUser $ComputerName
            Start-Sleep 1
            Welcome $RemoteUser
    $a = @"

    Current User:       $RemoteUser
    Cherwell Ticket:    $Global:Cherwell
    Computer Name:      $Global:ComputerName

"@
    $a
            MainMenu $Cherwell $RemoteUser $ComputerName
        }
        
        0 {ExitSession}
    }
}
# Exit Sessions
Function ExitSession {
    Clear-Host
    Get-PSSession | Remove-PSSession
    $Title = "Intfirm '$ComputerName' - Connected"
    $a = (Get-Host).UI.RawUI
    $a.WindowTitle = $Title
    Write-Host "`You are now disconnected from "$ComputerName"...`n" -foregroundcolor Yellow
    Exit-PSSession
    Exit
}
Function Pause {
    # Check if running Powershell ISE
    If ($psISE) {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("Press any key to continue...")
    }
    Else {
        Write-Host "Press any key to continue..." -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    $x
}
Function Reset {
    # Remove-Module ExchangeMaintenance
    Welcome
}
# Run Functions
Banner
Login
Welcome $RemoteUser
Cherwell
# End

# WLAN Report Menu
Import-Module $Script:Location\New-FaegreWLANReport.psm1
Function New-FaegreWLANReport ($Cherwell, $RemoteUser, $Global:Cherwell, $Global:ComputerName) {

New-FaegreWLANReport -ComputerName $ComputerName -Cherwell $Cherwell
}

# SCCM Client Logs Menu
Import-Module $Script:Location\Get-CMClientLogs.psm1
Function Get-CMClientLogs ($Cherwell, $RemoteUser, $Global:Cherwell, $Global:ComputerName) {

Get-CMClientLogs -ComputerName $ComputerName -Cherwell $Cherwell
}

#Panther Logs Menu
Import-Module $Script:Location\Get-PantherLogs.psm1
Function Get-PantherLogs ($Cherwell, $RemoteUser, $Global:Cherwell, $Global:ComputerName) {

Get-PantherLogs -ComputerName $ComputerName -Cherwell $Cherwell
}

#Windows Update Logs Menu
Import-Module $Script:Location\Get-WindowsUpdateLogs.psm1
Function Get-WindowsUpdateLogs ($Cherwell, $RemoteUser, $Global:Cherwell, $Global:ComputerName) {

Get-WindowsUpdateLogs1 -ComputerName $ComputerName -Cherwell $Cherwell
}

#BSOD Logs Menu
Import-Module $Script:Location\Get-BSODLogs.psm1
Function Get-BSODLogs ($Cherwell, $Remoteuser, $Global:Cherwell, $Global:ComputerName) {

Get-BSODLogs -ComputerName $ComputerName -Cherwell $Cherwell
}
