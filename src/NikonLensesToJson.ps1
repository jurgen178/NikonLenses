<#
    Convert the Nikon lenses html page to a json data file.
#>

[string]$url = "http://www.photosynthesis.co.nz/nikon/lenses.html"
[string]$htmlFile = "$PSScriptRoot\lenses.html"
[string]$jsonFile = "$PSScriptRoot\lenses.json"

# Download the lens data.
(New-Object System.Net.WebClient).DownloadFile($url, $htmlFile)

# Regex to parse the groups.
[string]$groupRegex = "(?s)<p><a name=""(?<Group>.+?)"">.*?<table>\s*(?<TableRows>.*?)\s*</table>\s*"

# Regex to parse the tables.
[string]$tableRegex = "(?s)<tr.*?><td>(?<Type>.*?)<td>(?<Lens>.*?)<td>(?<SerialNo>.*?)<td>(?<Date>.*?)<td>(?<Notes>.*?)<td>(?<Optic>.*?)<td>(?<Angle>.*?)<td>(?<Bl>.*?)<td>(?<CloseFocus>.*?)<td>(?<Macro>.*?)<td>(?<FocusThrow>.*?)<td>(?<Filter>.*?)<td>(?<Diam>.*?)<td>(?<Length>.*?)<td>(?<Weight>.*?)<td>(?<Hood>.*?)"

# Read the .html file as text.
[string]$htmlContent = [System.IO.File]::ReadAllText($htmlFile, [System.Text.Encoding]::GetEncoding("iso-8859-1"))

# Parse the html data.
$lenses = [ordered]@{}
[int]$lensCount = 0
foreach ($matchGroup in ([regex]$groupRegex).Matches($htmlContent)) {

    [string]$group = $matchGroup.Groups["Group"].Value
    [string]$tableRows = $matchGroup.Groups["TableRows"].Value

    foreach ($matchTable in ([regex]$tableRegex).Matches($tableRows)) {

        $lensCount++

        $lenses[$group] += , [PSCustomObject]@{
            'Group'      = $group
            'Type'       = $matchTable.Groups["Type"].Value
            'Lens'       = $matchTable.Groups["Lens"].Value -replace "<a href="".*?"">", "" -replace "</a>", ""
            'SerialNo'   = $matchTable.Groups["SerialNo"].Value -replace "<br>", " " -replace ">", " "
            'Date'       = $matchTable.Groups["Date"].Value -replace "<br>", " " -replace ">", " "
            'Notes'      = $matchTable.Groups["Notes"].Value -replace "<br>", " "
            'Optic'      = $matchTable.Groups["Optic"].Value
            'Angle'      = $matchTable.Groups["Angle"].Value
            'Bl'         = $matchTable.Groups["Bl"].Value
            'CloseFocus' = $matchTable.Groups["CloseFocus"].Value
            'Macro'      = $matchTable.Groups["Macro"].Value
            'FocusThrow' = $matchTable.Groups["FocusThrow"].Value
            'Filter'     = $matchTable.Groups["Filter"].Value
            'Diam'       = $matchTable.Groups["Diam"].Value
            'Length'     = $matchTable.Groups["Length"].Value
            'Weight'     = $matchTable.Groups["Weight"].Value  -replace '^(\d+).*$', '$1' -replace "\?", ""
            'Hood'       = $matchTable.Groups["Hood"].Value
        }
    }
}

"$lensCount lenses in $($lenses.count) groups."
# foreach ($lensesInGroup in $lenses.GetEnumerator()) {
#     "$($lensesInGroup.Key) ($($lensesInGroup.Value.count))"

#     $lensesInGroup.Value
#     foreach ($lens in $lensesInGroup.Value) {
#         "$($lens.Lens)"
#         break
#     }
# }

# Save to json file.
$lenses | ConvertTo-Json -depth 100 | Out-File $jsonFile
