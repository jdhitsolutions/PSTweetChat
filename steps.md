# Workflow

The GSheet plugin runs once an hour. Need to wait until it has captured all of the current month's tweets.

1. git checkout -b %month%year%
2. Save the PSTweetChat Google Sheet to a csv file
3. Copy the csv file to `scripts\pstweetchat.csv` in this module
4. Run `New-PSTweetTranscript` for the given day:

    ```powershell
    PS C:\scripts\PSTweetChat\scripts> .\New-PSTweetChatTranscript.ps1 -Date "8/2/2019"
    ```

5. git add .
6. git commit -m "%month% %year% updates"
7. git checkout master
8. git merge %month%year%
9. git push
