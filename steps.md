# Workflow

The GSheet plugin runs once an hour. Need to wait until it has captured all of the current month's tweets.

+ git checkout -b %month%year%

```powershell
git checkout -b August2019
```

+ Save the PSTweetChat Google Sheet to a local csv file
+ Copy the csv file to `.\cat $cscripts\pstweetchat.csv` in this module. Or run the `scripts\Copy-PSTweetChat.ps1` script.
+ Run `scripts\New-PSTweetTranscript.ps1` for the given day:

```powershell
PS C:\scripts\PSTweetChat\> .\scripts\New-PSTweetChatTranscript.ps1 -Date "1/3/2020"
```

+ review the new markdown file
+ git add .
+ git commit -m "%month% %year% updates"
+ git checkout master
+ git merge %month%year%
+ git push
