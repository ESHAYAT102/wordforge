$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/ESHAYAT102/wordforge.git"
$BinaryName = "wordforge.exe"
$InstallDir = Join-Path $HOME ".local\bin"
$CloneDir = $null
$Dependencies = @(
    @{ Name = "crwl"; Url = "https://github.com/ESHAYAT102/crwl.git" },
    @{ Name = "lapip"; Url = "https://github.com/ESHAYAT102/lapip.git" },
    @{ Name = "crack"; Url = "https://github.com/ESHAYAT102/crack.git" }
)

if (-not (Get-Command go -ErrorAction SilentlyContinue)) { throw "Go is required to install wordforge" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git is required to install wordforge" }

$InstallDependencies = Read-Host "Install dependency packages (crwl, lapip, crack)? [Y/n]"
$InstallDependencies = [string]::IsNullOrWhiteSpace($InstallDependencies) -or $InstallDependencies -match "^[Yy]$"

try {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

    if ($InstallDependencies) {
        foreach ($Dependency in $Dependencies) {
            $DependencyCloneDir = Join-Path ([System.IO.Path]::GetTempPath()) "$($Dependency.Name)-$([System.Guid]::NewGuid())"
            Write-Host "cloning $($Dependency.Url)"
            git clone --depth 1 $Dependency.Url $DependencyCloneDir
            Write-Host "building $($Dependency.Name)"
            Push-Location $DependencyCloneDir
            try { go build -o (Join-Path $InstallDir "$($Dependency.Name).exe") . }
            finally { Pop-Location }
            Remove-Item -Recurse -Force $DependencyCloneDir
            Write-Host "installed $($Dependency.Name) to $(Join-Path $InstallDir "$($Dependency.Name).exe")"
        }
    }

    $CloneDir = Join-Path ([System.IO.Path]::GetTempPath()) "wordforge-$([System.Guid]::NewGuid())"
    Write-Host "cloning $RepoUrl"
    git clone --depth 1 $RepoUrl $CloneDir
    Write-Host "building wordforge"
    Push-Location $CloneDir
    try { go build -o (Join-Path $InstallDir $BinaryName) . }
    finally { Pop-Location }
    Write-Host "installed $BinaryName to $(Join-Path $InstallDir $BinaryName)"
}
finally {
    if ($CloneDir -and (Test-Path $CloneDir)) { Remove-Item -Recurse -Force $CloneDir }
}
