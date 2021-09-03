#requires -version 7.0

$branch = "{0:MMMMyyyy}" -f (Get-Date)
git checkout -b $branch
&$PSScriptRoot\Copy-PSTweetChat.ps1
&$PSScriptRoot\New-PSTweetChatTranscript.ps1 -date (Get-Date -format d)
git add .
git commit -m "$branch updates"
git checkout master
git merge $branch
Write-Host "Review transcript in VSCode and then push to GitHub."
code C:\scripts\PSTweetChat\transcripts