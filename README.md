# PowerShell System Health Checker

A Windows system monitoring tool developed using PowerShell as part of my Microsoft Software & Systems Academy (MSSA) Server & Cloud Administration cohort.

## Project Overview

The System Health Checker is a PowerShell script designed to collect important Windows system information and help identify potential performance issues.

It automates several common administrative checks, reducing the need to manually inspect system settings and performance information.

## Features

- **System Information:** Displays computer name, operating system, and uptime.
- **CPU Monitoring:** Reports current Windows-reported processor utilization.
- **Memory Monitoring:** Displays total RAM, available RAM, and memory usage percentage.
- **Disk Monitoring:** Reports disk capacity and warns when available space falls below 15%.
- **Windows Service Monitoring:** Checks the status of selected Windows services.
- **CSV Reporting:** Automatically generates a timestamped report containing system performance information.

## Technologies Used

- Windows PowerShell
- Windows Management Instrumentation (WMI/CIM)
- Visual Studio Code
- Git and GitHub
- CSV reporting

## How to Run

1. Download or clone this repository onto a Windows computer.
2. Open the project folder in Visual Studio Code.
3. Open a PowerShell terminal.
4. Run:

```powershell
.\SystemHealth.ps1
```

PowerShell execution policies may restrict scripts. Review the script before running it, and use an execution policy permitted by your environment.

## Project Structure

```text
System-Health-Checker/
├── SystemHealth.ps1
├── .gitignore
└── README.md
```

The script automatically creates a local `Reports` folder when executed. Generated reports are excluded from Git tracking.

## What I Learned

Throughout this project, I practiced:

- Retrieving Windows system information using PowerShell.
- Working with variables, conditional statements, and foreach loops.
- Monitoring Windows services and system resources.
- Generating automated CSV reports.
- Troubleshooting PowerShell execution policies.
- Managing source code using Git and GitHub.
- Using `.gitignore` to exclude generated files.

## Future Improvements

- Add interactive menu options.
- Improve monitoring thresholds and service health detection.
- Include more detailed CPU and memory statistics.
- Generate HTML-based health reports.
- Expand error handling and reporting.

## Author

Salvador Chavez Jr.

Microsoft Software & Systems Academy — Server & Cloud Administration

U.S. Navy Veteran | IT Professional