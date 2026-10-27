
# ==========================================
# MSSA Project 1 - System Health Checker V2
# ==========================================

$ErrorActionPreference = "Stop"

Write-Host "`n=== SYSTEM HEALTH CHECKER V2 ===" -ForegroundColor Cyan

# Gather system information
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor
$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

# Computer details
$ComputerName = $env:COMPUTERNAME
$Uptime = (Get-Date) - $OS.LastBootUpTime

# CPU usage (sampled by Windows)
$CPUUsage = [math]::Round(
    ($CPU | Measure-Object -Property LoadPercentage -Average).Average,
    1
)

# Memory calculations
$TotalRAM = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
$FreeRAM = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)
$UsedRAMPercent = [math]::Round(
    (1 - ($OS.FreePhysicalMemory / $OS.TotalVisibleMemorySize)) * 100,
    1
)

Write-Host "`n--- SYSTEM INFORMATION ---" -ForegroundColor Yellow
Write-Host "Computer: $ComputerName"
Write-Host "OS: $($OS.Caption)"
Write-Host "Uptime: $($Uptime.Days) days, $($Uptime.Hours) hours"

Write-Host "`n--- CPU & MEMORY ---" -ForegroundColor Yellow
Write-Host "CPU Usage: $CPUUsage%"
Write-Host "Total RAM: $TotalRAM GB"
Write-Host "Available RAM: $FreeRAM GB"
Write-Host "Memory Usage: $UsedRAMPercent%"

if ($CPUUsage -ge 90) {
    Write-Warning "High CPU utilization detected."
}

if ($UsedRAMPercent -ge 90) {
    Write-Warning "High memory utilization detected."
}

# Disk health
Write-Host "`n--- DISK HEALTH ---" -ForegroundColor Yellow

foreach ($Disk in $Disks) {
    if ($Disk.Size -le 0) {
        continue
    }

    $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $TotalGB = [math]::Round($Disk.Size / 1GB, 2)
    $FreePercent = [math]::Round(
        ($Disk.FreeSpace / $Disk.Size) * 100, 1
    )

    Write-Host "$($Disk.DeviceID) - $FreeGB GB free of $TotalGB GB"

    if ($FreePercent -lt 15) {
        Write-Warning "$($Disk.DeviceID) is running low on disk space!"
    }
}

# Monitor important Windows services
Write-Host "`n--- WINDOWS SERVICES ---" -ForegroundColor Yellow

$Services = @("Winmgmt", "EventLog", "Dnscache", "wuauserv")

foreach ($ServiceName in $Services) {
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($null -eq $Service) {
        Write-Host "$ServiceName : NOT FOUND" -ForegroundColor Yellow
    }
    elseif ($Service.Status -eq "Running") {
        Write-Host "$ServiceName : RUNNING" -ForegroundColor Green
    }
    else {
        Write-Host "$ServiceName : $($Service.Status)" -ForegroundColor Yellow
    }
}

# Export health report
Write-Host "`n--- EXPORTING REPORT ---" -ForegroundColor Yellow

$Report = [PSCustomObject]@{
    ComputerName  = $ComputerName
    Date          = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    CPUUsage      = $CPUUsage
    TotalRAMGB    = $TotalRAM
    AvailableRAMGB = $FreeRAM
    MemoryUsedPct = $UsedRAMPercent
    UptimeDays    = $Uptime.Days
}

$ReportFolder = Join-Path $PSScriptRoot "Reports"

if (-not (Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder | Out-Null
}

$FileName = "HealthReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$ReportPath = Join-Path $ReportFolder $FileName

$Report | Export-Csv -Path $ReportPath -NoTypeInformation

Write-Host "Report saved to: $ReportPath" -ForegroundColor Green
Write-Host "`nHealth check complete!" -ForegroundColor Cyan
