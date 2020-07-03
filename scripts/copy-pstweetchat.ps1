
[cmdletbinding(SupportsShouldProcess)]
Param()

$dl = Get-ChildItem C:\Users\Jeff\downloads\PSTweetchat* -ov csv | Sort-Object lastwritetime | Select-Object -last 1 | Copy-Item -Destination $PSScriptRoot\pstweetchat.csv -PassThru

if ($dl) {
    $dl
    $csv | Remove-Item
}
else {
    Write-Warning "No CSV files found"
}
