# Workflow

1. Save the PSTweetChat Google Sheet to a csv file
2. Copy the csv file to scripts\pstweetchat.csv in this module
3. Run `New-PSTweetTranscript` for the given day

```powershell
PS C:\scripts\PSTweetChat\scripts> .\New-PSTweetChatTranscript.ps1 -Date "4/5/2019"
```

4. git commit
5. git push