# Workflow

The GSheet plugin runs once an hour. Need to wait until it has captured all of the current month's tweets.

+ git checkout -b %month%year%

```powershell
git checkout -b August2019
```

+ Save the PSTweetChat Google Sheet to a local csv file
+ Copy the csv file to `scripts\pstweetchat.csv` in this module
+ Run `New-PSTweetTranscript` for the given day:

```powershell
PS C:\scripts\PSTweetChat\> .\scripts\New-PSTweetChatTranscript.ps1 -Date "8/2/2019"
```

+ review the new markdown file
+ git add .
+ git commit -m "%month% %year% updates"
+ git checkout master
+ git merge %month%year%
+ git push
