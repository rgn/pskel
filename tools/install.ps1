#Param(
#	[Switch] $Global
#)
## local install path
#$installRoot = $env:PSModulePath.Split(";")[0];
#If ($Global.IsPresent)
#{
#	// global install path
#	$installRoot = "$PSHome\Modules";
#}
Copy-Item -Path ..\* -Destination "$installRoot\%ProjectName%" -Force
