Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent $scriptDir

Write-Host "[setup] Setup Windows development environment"
Write-Host "[setup] Install packages with winget file:"
Write-Host "        $rootDir\os\windows\winget-packages.json"
Write-Host "[setup] Apply PowerShell profile:"
Write-Host "        $rootDir\os\windows\powershell\profile.ps1"
