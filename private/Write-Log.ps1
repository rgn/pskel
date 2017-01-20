function Write-Log
{
	<#
    .SYNOPSIS
        Decorate an object with
            - A TypeName
            - New properties
            - Default parameters

    .DESCRIPTION
        Helper function to log to file

    .PARAMETER Message
        Message to log.

    .PARAMETER Level
        Log level.
	
		Valid levels are: INFO, WARN, ERROR, FATAL, DEBUG
        
    .PARAMETER LogFile
        File to log to.
	
		Default output is $LogRoot\current.log
                
    .EXAMPLE
		#
        # Write log message to current log without a level.
		Write-Log "My message"
			
    .EXAMPLE
        #
        # Write a log message to current log with a level.
        Write-Log -Level "WARN" -Message "My warning message"
		
	.EXAMPLE
        #
        # Write a log message to specific log file.
        Write-Log "My warning message" -LogFile "C:\Temp\mylog.txt"

    .NOTES
        Currently not filtering of levels is implemented.
        
    .LINK
        http://github.com/rgn/PSkel

    .FUNCTIONALITY
        PowerShell Language
    #>

[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[string]
$Message,

[Parameter(Mandatory=$False)]
[ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
[String]
$Level = "INFO",

[Parameter(Mandatory=$False)]
[string]
$LogFile
)

Begin
{
	If ($Logfile -eq $null)
	{
		$LogFile = "$LogRoot\current.log"
	}

	
	$TimeStamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
}

Process
{
	$Line = "$Stamp $Level $Message"

	Add-Content $LogFile -Value $Line -Force

	switch ($Level.ToUpper()) 
    { 
        "INFO"  { Write-Host $Line } 
        "WARN"  { Write-Warning $Line } 
        "ERROR" { Write-Error $Line } 
        "FATAL" { Write-Error $Line } 
        "DEBUG" { Write-Debug $Line } 
        default {
			Write-Warning "`$Level` is not a valid level."
			Write-Host $Line
		}
    }			
}

}