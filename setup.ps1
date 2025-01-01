Param(
    [string]$wit = "wit",
    [string]$gekidouCli,
    [string]$originalRom = "original/RHHJ8J.iso"
)

& $wit extract $originalRom -d extracted/ --verbose --verbose

Get-ChildItem -Path "./extracted/DATA/files/ScriptArc" -Filter "*.arc" | ForEach-Object {
    Write-Host "Extracting $($_.FullName)"
    & $gekidouCli arc -x -i "$($_.FullName)" -o "$($_.FullName)x"
    Remove-Item -Path "$($_.FullName)"
    Move-Item -Path "$($_.FullName)x" -Destination $($_.FullName)
}