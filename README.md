---

# WSL and Docker VHDX Compaction Script

## Overview

This PowerShell script is designed to safely compact the Virtual Hard Disk (VHDX) file used by the Docker and WSL (Windows Subsystem for Linux) instances without manual intervention.

The script performs the following actions:

1. Shuts down all running WSL instances to ensure data integrity during compaction.
2. Runs `diskpart` commands to compact the specified VHDX file.
3. Restarts the WSL to resume normal operations.
4. Checks and restarts Docker services if they are installed and running.

## Prerequisites

- Windows 10 or later with WSL and Docker installed.
- Administrative privileges are required to run disk compaction with `diskpart`.
- PowerShell 5.1 or higher.

## Usage

1. Open PowerShell as an Administrator. This is required because compacting a VHDX file requires elevation.
2. Navigate to the directory containing the script.
3. Execute the script by typing: `.\WSL_Docker_Compact.ps1` (Replace `WSL_Docker_Compact.ps1` with the actual script name if different.)

## What The Script Does

Here's a breakdown of the script's steps:

```powershell
# Shuts down WSL to release any locks on the VHDX file.
Write-Host "Shutting down WSL..." -ForegroundColor Yellow
wsl --shutdown

# Diskpart section: Compacts the VHDX file.
Write-Host "Compacting VHDX file..." -ForegroundColor Yellow
# The specific commands used for compaction are stored in a temporary file and executed with diskpart.

# Restarts WSL to verify it's operational without starting a session.
Write-Host "Verifying WSL is operational..." -ForegroundColor Yellow
wsl -e bash -c "echo 'Default WSL distribution is operational.'"

# Checks for Docker's current state and either restarts the service or launches Docker Desktop.
Write-Host "Restarting Docker service..." -ForegroundColor Yellow
# Different scenarios are handled based on whether Docker runs as a service or needs to be started as an application.

Write-Host "Default WSL instance restarted and verified as operational." -ForegroundColor Green
```

## Considerations

- Before running the script for the first time, check the path to the VHDX file and ensure it matches your local setup.
- Ensure that no vital work is running in WSL or Docker since this script will shut them down without warning.
- It's recommended to back up critical data before running disk maintenance scripts.

## Support

This script is provided as-is, and it is recommended to test it in a non-production environment before deploying it in a business setting. For further support or customization, please contact your system administrator or IT department.

---

After creating the README file, ensure that it accompanies the PowerShell script to assist others who may use or further develop the script. Adjust the file as necessary to fit into your environment or to match additional features you may add to the script.