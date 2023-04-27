# Set the execution policy to allow the script to run
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
#MakeAdmin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
$arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -verb RunAs -ArgumentList $arguments
  Break
}
#start logging now after console is admin
$log = "C:\temp\FalconUnininstallLog.txt"
start-transcript -Path $log -force -Verbose
### END TEMPLATE ###

# Download the file and save it to the specified location
# add your own download link
$downloadUrl = ""
$outputPath = "C:\temp\CsUninstallTool.exe"
New-Item -ItemType Directory -Path (Split-Path $outputPath) -Force | Out-Null
Write-Verbose "Downloading file from $downloadUrl to $outputPath"
Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath

#run application to remove software
cmd.exe /c "C:\temp\CsUninstallTool.exe /quiet"

# Check if the application is removed from the default install path
$defaultInstallPath = "C:\ProgramData\Package Cache\"
$searchPattern = "WindowsSensor"
$installedAppPath = Get-ChildItem -Path $defaultInstallPath -Filter $searchPattern -Recurse -ErrorAction SilentlyContinue
if ($installedAppPath) {
    Write-Error "Error: WindowsSensor is still present in the default install path" 
} else {
        Write-Verbose "WindowsSensor successfully removed from the default install path"
}
