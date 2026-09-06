$ErrorActionPreference = "Stop"
$BinaryPath = Join-Path $HOME ".local\bin\wordforge.exe"

if (Test-Path $BinaryPath) {
    Remove-Item -Force $BinaryPath
    Write-Host "removed wordforge.exe from $BinaryPath"
} else {
    Write-Host "wordforge.exe was not found at $BinaryPath"
}
