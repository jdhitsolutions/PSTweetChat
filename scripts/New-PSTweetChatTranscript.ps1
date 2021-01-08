[cmdletbinding(SupportsShouldProcess)]
Param(
    [string]$Date = $(Get-Date -Format d),
    [ValidateScript({ Test-Path $_ })]
    #need to download the gsheet as a CSV file
    [string]$CSV = "$psscriptroot\pstweetchat.csv"
)

#output file
#3 Jan 2020 - updated filename to include a 2 digit month number so that files will sort properly by name
$filename = "{1:00}_PSTweetChat_{0:MMMMyyyy}.md" -f ([datetime]$Date),([datetime]$date).month
$outfile = Join-Path -Path $psscriptroot\..\transcripts -ChildPath $filename

#$original= "Date,Screen Name,Full Name,Tweet Text,Tweet ID,Link(s),Media,Location,Retweets,Favorites,App,Followers,Follows,Listed,Verfied,User Since,TwitterLocation,Bio,Website,Timezone,Profile Image"
$myheader = "Date", "TwitterName", "RealName", "Text", "ID", "Links", "Media", "OnlineLocation", "Retweets", "Favorites", "App", "Followers", "Follows", "Listed", "Verified", "UserSince", "TwitterLocation", "Bio", "WebSite", "TimeZone", "ProfileImage"

#filter out anything via IFTTT which is most likely a retweet
#and skip the header lines since I'm using my own
$data = Get-Content $csv | Select-Object -Skip 2 |
ConvertFrom-Csv -Header $myheader | Where-Object { ($_.id -match "\d{19}") -AND $_.App -ne 'ifttt' -AND ([datetime]$_.Date).ToShortDateString() -eq $Date} |
Sort-Object ID

#create a markdown document
$data | Select-Object  @{Name="Date";Expression = {$_.Date -as [datetime]}},ID, TwitterName, RealName, Text, links, media |
ForEach-Object -begin {
    $md = @"
# PSTweetChat TweetScript

## $(([datetime]$date).tolongdatestring())

"@

} -process {
    write-verbose ("{0} - {1} {2}" -f $_.date, $_.twittername,$_.realname)
    $handle = $_.twittername.substring(1)
    $tdate = "{0:u}" -f $_.date.ToUniversalTime()
    $md += @"

### [$($_.Twittername)](https://twitter.com/$handle) \<$($_.Realname)\>

*$tdate*
> [$($_.text)](https://twitter.com/$handle/status/$($_.ID))

"@

    if ($_.links) {

        foreach ($item in $_.links) {
            $md += @"

+ [$item]($item)

"@
        } #foreach item
    } # if links

    if ($_.media) {
        foreach ($item in $_.media) {
            $md += @"

![embedded media]($item)

"@
        } #foreach item
    } #if media


} -end {

    $md += @"

This transcript is based on tracking the `#PSTweetchat` tag. However, not everyone remembers to insert the tag so this is most likely an incomplete record. The entries are listed in order of Twitter's ID number which may not necessarily mean it is in true chronological order.

_generated $(((Get-Date).ToUniversalTime()|Out-String).trim()) UTC_
"@

}

$md | Out-File -filepath $outfile -Encoding ascii

if ( -not $PSBoundParameters.ContainsKey("WhatIf")) {
    Get-Item -path $outfile
}