
$Date = "3/1/2019"

#output file
$filename = "PSTweetChat_{0:MMMMyyyy}.md" -f ([datetime]$Date),([datetime]$Date)
$outfile = Join-Path -Path $psscriptroot -ChildPath $filename

#need to download the gsheet as a CSV file
$csv = "$psscriptroot\pstweetchat.csv"

#$original= "Date,Screen Name,Full Name,Tweet Text,Tweet ID,Link(s),Media,Location,Retweets,Favorites,App,Followers,Follows,Listed,Verfied,User Since,TwitterLocation,Bio,Website,Timezone,Profile Image"
$myheader="Date","TwitterName","RealName","Text","ID","Links","Media","OnlineLocation","Retweets","Favorites","App","Followers","Follows","Listed","Verified","UserSince","TwitterLocation","Bio","WebSite","TimeZone","ProfileImage"

#filter out anything via IFTTT which is most likely a retweet
#and skip the header lines since I'm using my own
$data = get-content $csv | Select-object -Skip 2 |
convertfrom-csv -Header $myheader | where-object {$_.App -ne 'ifttt' -AND $_.Date -eq $Date} |
Sort-object ID

#create a markdown document
$data | Select-Object  ID, TwitterName, RealName, Text, links, media | Foreach-object -begin {
    $md = @"
# PSTweetChat TweetScript

## $(([datetime]$date).tolongdatestring())

"@

} -process {
    $handle = $_.twittername.substring(1)
    $md += @"

### [$($_.Twittername)](https://twitter.com/$handle) \<$($_.Realname)\>

> [$($_.text)](https://twitter.com/$handle/status/$($_.ID))

"@

    if ($_.links) {

   foreach ($item in $_.links) {
       $md+= @"

+ [$item]($item)

"@
   } #foreach item
    } # if links

    if ($_.media) {
      foreach ($item in $_.media) {
       $md+=@"

![embedded media]($item)

"@
    } #foreach item
   } #if media


} -end {

    $md += @"

This transcript is based on tracking the #PSTweetchat tag. Not everyone remembers to insert the the tag so this is certainly an incomplete record. The entries are listed in order of Twitter's ID number which may not necessarily mean it is in complete chronological order.

_generated $(((get-date).ToUniversalTime()|Out-String).trim()) UTC_"
"@

}

$md | Out-File -filepath $outfile -Encoding ascii

