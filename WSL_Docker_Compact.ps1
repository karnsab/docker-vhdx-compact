# Shutdown the WSL instance
Write-Host "Shutting down WSL..." -ForegroundColor Yellow
wsl --shutdown

# Use the Here-String to store the diskpart commands
Write-Host "Preparing disk compaction commands..." -ForegroundColor Yellow
$vhdxPath = "$env:USERPROFILE\AppData\Local\Docker\wsl\data\ext4.vhdx"
$diskpartCommands = @"
select vdisk file=`"$vhdxPath`"
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@

# Write the diskpart commands to a temporary file
$tempFile = [System.IO.Path]::GetTempFileName()
$diskpartCommands | Out-File -FilePath $tempFile -Encoding ascii

# Invoke diskpart with the script and wait for it to complete
Write-Host "Compacting VHDX file..." -ForegroundColor Yellow
Start-Process "diskpart.exe" -ArgumentList "/s `"$tempFile`"" -NoNewWindow -Wait
Write-Host "VHDX compaction completed." -ForegroundColor Green

# Clean up the temporary file
Remove-Item -Path $tempFile -Force

# Restart the WSL service after compaction
Write-Host "Restarting WSL..." -ForegroundColor Yellow
wsl --shutdown
Start-Sleep -Seconds 5 # Give it some time before trying to start WSL again

# Restart Docker Desktop if it's installed.
# Check if Docker for Windows is installed and start (or restart) it
if (Get-Service "com.docker.service" -ErrorAction SilentlyContinue) {
    Write-Host "Restarting Docker service..." -ForegroundColor Yellow
    Restart-Service com.docker.service -Force
    Write-Host "Docker service restarted." -ForegroundColor Green
} elseif (Get-Command "Docker" -ErrorAction SilentlyContinue) {
    Write-Host "Starting Docker Desktop..." -ForegroundColor Yellow
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    Write-Host "Docker Desktop started." -ForegroundColor Green
} else {
    Write-Host "Docker does not seem to be installed" -ForegroundColor Red
}

# Starting a default WSL instance
# Starting a default WSL instance with a non-interactive command
Write-Host "Starting default WSL instance with a non-interactive command..." -ForegroundColor Yellow
wsl -e bash -c "echo 'Default WSL distribution is operational.'"
Write-Host "Default WSL instance restarted and verified as operational." -ForegroundColor Green