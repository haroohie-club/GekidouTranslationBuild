Param(
    [string]$gekidouCli,
    [string]$assetsFolder,
    [string]$stringsFolder,
    [string]$langCode = "en",
    [string]$copyTo
)

if (-not (Test-Path -Path ./patch/Gekidou/files)) {
    New-Item -Path ./patch/Gekidou/files -ItemType Directory
}
if (-not (Test-Path -Path ./patch/Riivolution)) {
    New-Item -Path ./patch/Riivolution -ItemType Directory
}

if (Test-Path -Path ./pack){
    Remove-Item -Recurse -Force -Path ./pack
}
Copy-Item -Path "./extracted/DATA/" -Destination "./pack" -Recurse -Force

Copy-Item -Path "./riivolution/$langCode.xml" -Destination "./patch/Riivolution/Gekidou.xml"

$arcs = @()

Get-ChildItem -Path "$stringsFolder" -Filter "*.en.json" -Recurse | ForEach-Object {
    $binName = [System.IO.Path]::GetFileNameWithoutExtension([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
    $binFile = "$([System.IO.Path]::GetDirectoryName(([System.IO.Path]::GetRelativePath($stringsFolder, $_.FullName))))/$binName"
    $binFile -match '([\/\w_]+\/[\w_]+\.arc)'
    $arcs += $Matches.0

    Write-Host "Writing bin to ./pack/$binFile"
    & $gekidouCli adv-script -r -i "./extracted/DATA/$binFile" -j "$($_.FullName)" -o "./pack/$binFile"
}

$arcs | Select-Object -Unique | ForEach-Object {
    Write-Host "Packing $_"
    & $gekidouCli arc -p -i "./pack/$_" -o "./patch/Gekidou/$_"
}

if ($copyTo) {
    Write-Host "Copying output to '$copyTo'..."
    Copy-Item -Path "./patch/Gekidou" -Destination $copyTo -Recurse -Force
}