<#
.SYNOPSIS
    Idempotent Hyper-V Lab Provisioning Script.

.DESCRIPTION
    Demonstrates the core principle of idempotency by checking for the 
    existence of Hyper-V resources before attempting creation.

.PROTIP
    Always run this script in an Elevated (Administrator) PowerShell session. 
    Hyper-V management requires administrative privileges to modify Virtual 
    Switches and VHDX files.

.TECHNOTE
    This script utilizes the -ErrorAction SilentlyContinue parameter. This is 
    a deliberate design choice for idempotency: we want to check if a resource 
    exists without the script "breaking" if it doesn't find it.
    
.EXAMPLE
    .\Initialize-LabEnvironment.ps1
#>

# Define Lab Parameters
$SwitchName = "TechPress-Internal"
$VMName     = "TP-Lab-DC01"
$VHDPath    = "C:\HyperV\VirtualHardDisks\$VMName.vhdx"

Write-Host "--- Starting Lab Provisioning ---" -ForegroundColor Cyan

# 1. Create the Virtual Switch (Idempotent)
$ExistingSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue

if ($null -eq $ExistingSwitch) {
    Write-Host "Provisioning Virtual Switch: $SwitchName" -ForegroundColor Green
    New-VMSwitch -Name $SwitchName -SwitchType Internal | Out-Null
} else {
    Write-Host "Virtual Switch '$SwitchName' already exists. Skipping." -ForegroundColor Yellow
}

# 2. Create the Virtual Machine (Idempotent)
$ExistingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue

if ($null -eq $ExistingVM) {
    Write-Host "Provisioning Virtual Machine: $VMName" -ForegroundColor Green
    
    # Ensure directory exists for the VHDX
    if (!(Test-Path "C:\HyperV\VirtualHardDisks")) {
        $null = New-Item -Path "C:\HyperV\VirtualHardDisks" -ItemType Directory -Force
    }

    # Provision the VM
    New-VM -Name $VMName `
           -Generation 2 `
           -MemoryStartupBytes 4GB `
           -SwitchName $SwitchName `
           -NewVHDPath $VHDPath `
           -NewVHDSizeBytes 40GB | Out-Null

    Write-Host "Lab Machine $VMName successfully provisioned." -ForegroundColor Green
} else {
    Write-Host "Virtual Machine '$VMName' already exists. Skipping." -ForegroundColor Yellow
}

Write-Host "--- Provisioning Complete ---" -ForegroundColor Cyan
