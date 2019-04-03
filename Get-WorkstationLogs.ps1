function Get-FaegreWorkstationLogs {
<#
.Synopsis
   Add Printers to print server
.DESCRIPTION
   Adds shared printers to print server.  If you are adding HP Universal or Canon Universal it will use the driver with the printer.  If not one use "Other", it will assign the "Generic/Text only" driver that you can change after it is installed.
.EXAMPLE
  New-FaegrePrinter -PrinterName 'INDT-24-2' -PrintServer S03P-Print1 -PrinterIPAddress 10.20.24.12 -PortName 10.20.24.12 -Driver HPUniversal
.INPUTS
   in-progress
.OUTPUTS
   The results of the SetACL commands will scroll.
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   Add Printers from CSV
#>
    [CmdletBinding(
        PositionalBinding=$False)]
    Param
    (   

        # Computer Name
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$False,
                   HelpMessage="Enter the Computer's name.")]
        [String]$ComputerName,

    [ValidateSet('True','False')]
    [string]$CMClientLogs = 'True',

    [ValidateSet('True','False')]
    [string]$PantherLogs = 'True',

    [ValidateSet('True', 'False')]
    [string]$WindowsUpdateLogs = 'True',

    [ValidateSet('True', 'False')]
    [string]$BSODLogs = 'True',
  

    [string]$Destination = "\\MJ05KKD6\c$\ClientLogs"
        
    )
     Begin
     
              
         {
$ErrorActionPreference = 'Stop'
Add-Type -Assembly 'System.IO.Compression.FileSystem'

if($CMClientLogs -eq 'True'){
    $ClientLogZipPath = "\\$ComputerName\c$\CMClientLogs.zip"  
    $CMLogPath = (Get-ItemProperty -Path 'HKLM:\Software\Microsoft\CCM\Logging\@global' -Name 'LogDirectory' -ErrorAction Stop).LogDirectory
    $null = New-Item -ItemType Directory -Path \\$ComputerName\c$\ClientLogs -Force
    $null = Copy-Item -Path $LogPath -Destination "\\$ComputerName\c$\CMClientLogs" -Force -Recurse
    $null = [IO.Compression.ZipFile]::CreateFromDirectory("\\$ComputerName\c$\CMClientLogs", $ClientLogZipPath)
    If(-not (Test-Path "$($Destination)\$ComputerName")) { $null = New-Item -ItemType Directory -Path "$($Destination)\$ComputerName" }
    $null = Copy-Item -Path $ClientLogZipPath -Destination "$($Destination)\$ComputerName" -Force
    $null = Remove-Item -Path $ClientLogZipPath -Force
    $null = Remove-item -Path "\\$ComputerName\c$\CMClientLogs" -Force -Recurse
    }
 
if ($PantherLogs -eq 'True'){
    $PantherLogZipPath = "\\$ComputerName\c$\PantherLogs.zip"
    $null = [IO.Compression.ZipFile]::CreateFromDirectory("\\$ComputerName\c$\Windows\Panther", $PantherLogZipPath)
    $null = Copy-Item -Path "\\$ComputerName\c$\PantherLogs.zip" -Destination "$($Destination)\$ComputerName" -Force
    $null = Remove-Item -Path "\\$ComputerName\c$\PantherLogs.zip" -Force
    }
    
    
if($WindowsUpdateLogs -eq 'True'){
    $WindowsUpdateLogZipPath = "\\$ComputerName\c$\WindowsUpdateLogs.zip"
    $null = New-item -ItemType Directory -Path "\\$ComputerName\c$\WinUpdateLog" -Force
    $null = Get-WindowsUpdateLog -LogPath "\\$ComputerName\c$\WinUpdateLog\WindowsUpdate.log"
    $null = [IO.Compression.ZipFile]::CreateFromDirectory("\\$ComputerName\c$\WinUpdateLog", $WindowsUpdateLogZipPath)
    $null = Copy-Item -Path "\\$ComputerName\c$\WindowsUpdateLogs.zip" -Destination "$($Destination)\$ComputerName" -Force
    Remove-Item -Path "\\$ComputerName\c$\WindowsUpdateLogs.zip" -Force
    Remove-Item -Path "\\$ComputerName\c$\WinUpdateLog" -Force -Recurse
    }
if($BSODLogs -eq 'True'){
   $BSODZipPath = "\\$ComputerName\c$\BSODLogs.zip"
   $null = [IO.Compression.ZipFile]::CreateFromDirectory("\\$ComputerName\c$\Windows\MiniDump","$BSODZipPath")
   $null = Copy-Item -Path "\\$ComputerName\c$\BSODLogs.zip" -Destination "$($Destination)\$ComputerName" -Force
   $null = Remove-Item -Path "\\$ComputerName\c$\BSODLogs.zip" -Force
   }
   
    
    }
    }