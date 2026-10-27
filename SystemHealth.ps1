
# ======================================
# MSSA Project 1 - System Health Checker
# ======================================

# Display the project heading
Write-Host "=== SYSTEM HEALTH CHECKER ===" -ForegroundColor Cyan

# Get the computer name
$ComputerName = $env:COMPUTERNAME
Write-Host "Computer Name: $ComputerName"

# Retrieve operating system information
$OS = Get-CimInstance Win32_OperatingSystem
Write-Host "Operating System: $($OS.Caption)"

# Calculate system uptime
$Uptime = (Get-Date) - $OS.LastBootUpTime
Write-Host "System Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours"

# Get memory information
$TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
$FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)

Write-Host "Total RAM: $TotalRAM GB"
Write-Host "Free RAM: $FreeRAM GB"

# Display local disk information
Write-Host "`n=== DISK INFORMATION ===" -ForegroundColor Yellow

Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
        @{Name="FreeSpaceGB";Expression={
            [math]::Round($_.FreeSpace / 1GB, 2)
        }},
        @{Name="TotalSizeGB";Expression={
            [math]::Round($_.Size / 1GB, 2)
        }} |
    Format-Table -AutoSize

Write-Host "`nSystem health check complete!" -ForegroundColor Green
