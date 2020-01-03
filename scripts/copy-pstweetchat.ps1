
[cmdletbinding(SupportsShouldProcess)]
Param()

Get-ChildItem C:\Users\Jeff\downloads\PSTweetchat* -ov csv | Sort-Object lastwritetime | Select-Object -last 1 | Copy-Item -Destination $PSScriptRoot\pstweetchat.csv -PassThru

$csv | Remove-Item
