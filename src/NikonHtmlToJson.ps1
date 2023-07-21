<#
    Convert the Nikon lenses html page to a json data file.
#>

# Regex to parse the groups.
[string]$groupRegex = "(?s)<p><a name=""(?<Group>.+?)"">.*?<table>\s*(?<TableRows>.*?)\s*</table>\s*"

<#
.DESCRIPTION
    Download the data html, parse the data html and create the json data file.
#>
function CreateJson([string]$name, [string]$tableRegex, [ScriptBlock]$dataSet) {

    [string]$url = "http://www.photosynthesis.co.nz/nikon/$name.html"
    [string]$htmlFile = "$PSScriptRoot\$name.html"
    [string]$jsonFile = "$PSScriptRoot\$name.json"

    # Download the lens data.
    (New-Object System.Net.WebClient).DownloadFile($url, $htmlFile)

    # Read the .html file as text.
    [string]$htmlContent = [System.IO.File]::ReadAllText($htmlFile, [System.Text.Encoding]::GetEncoding("iso-8859-1"))

    # Parse the html data.
    $data = [ordered]@{}
    [int]$dataCount = 0
    foreach ($matchGroup in ([regex]$groupRegex).Matches($htmlContent)) {

        [string]$group = $matchGroup.Groups["Group"].Value
        [string]$tableRows = $matchGroup.Groups["TableRows"].Value

        foreach ($matchTable in ([regex]$tableRegex).Matches($tableRows)) {

            $dataCount++
            $data[$group] += , (& $dataSet)
        }
    }

    "$dataCount $name in $($data.count) groups."

    # Save to json file.
    $data | ConvertTo-Json -depth 100 | Out-File $jsonFile
}

# lenses data set.
CreateJson "lenses" "(?s)<tr.*?><td>(?<Type>.*?)<td>(?<Lens>.*?)<td>(?<SerialNo>.*?)<td>(?<Date>.*?)<td>(?<Notes>.*?)<td>(?<Optic>.*?)<td>(?<Angle>.*?)<td>(?<Bl>.*?)<td>(?<CloseFocus>.*?)<td>(?<Macro>.*?)<td>(?<FocusThrow>.*?)<td>(?<Filter>.*?)<td>(?<Diam>.*?)<td>(?<Length>.*?)<td>(?<Weight>.*?)<td>(?<Hood>.*?)" { [PSCustomObject]@{
        'Group'      = $group
        'Type'       = $matchTable.Groups["Type"].Value
        'Lens'       = $matchTable.Groups["Lens"].Value -replace "<a href="".*?"">", "" -replace "</a>", ""
        'SerialNo'   = $matchTable.Groups["SerialNo"].Value -replace "<br>", " "
        'Date'       = $matchTable.Groups["Date"].Value -replace "<br>", " "
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
        'Weight'     = $matchTable.Groups["Weight"].Value -replace '^(\d+).*$', '$1' -replace "\?", ""
        'Hood'       = $matchTable.Groups["Hood"].Value
    }
}

# serialno data set.
CreateJson "serialno" "(?s)<tr.*?><td>(?<Type>.*?)<td>(?<Lens>.*?)<td>(?<Country>.*?)<td>(?<Scr>.*?)<td>(?<Notes>.*?)<td>(?<StartNo>.*?)<td>(?<Confirmed>.*?)<td>(?<EndNo>.*?)<td>(?<Qty>.*?)<td>(?<Date>.*?)" { [PSCustomObject]@{
        'Group'     = $group
        'Type'      = $matchTable.Groups["Type"].Value
        'Lens'      = $matchTable.Groups["Lens"].Value -replace "<a href="".*?"">", "" -replace "</a>", ""
        'Country'   = $matchTable.Groups["Country"].Value
        'Scr'       = $matchTable.Groups["Scr"].Value
        'Notes'     = $matchTable.Groups["Notes"].Value -replace "<br>", " "
        'StartNo'   = $matchTable.Groups["StartNo"].Value
        'Confirmed' = $matchTable.Groups["Confirmed"].Value
        'EndNo'     = $matchTable.Groups["EndNo"].Value
        'Qty'       = $matchTable.Groups["Qty"].Value
        'Date'      = $matchTable.Groups["Date"].Value
    }
}

# specs data set.
CreateJson "specs" "(?s)<tr.*?><td>(?<Type>.*?)<td>(?<Lens>.*?)<td>(?<Optic>.*?)<td>(?<Angle>.*?)<td>(?<AngleDX>.*?)<td>(?<f>.*?)<td>(?<Bl>.*?)<td>(?<CloseFocus>.*?)<td>(?<Macro>.*?)<td>(?<FocusThrow>.*?)<td>(?<Filter>.*?)<td>(?<Diam>.*?)<td>(?<Length>.*?)<td>(?<TotalLength>.*?)<td>(?<Weight>.*?)<td>(?<Features>.*?)" { [PSCustomObject]@{
        'Group'       = $group
        'Type'        = $matchTable.Groups["Type"].Value
        'Lens'        = $matchTable.Groups["Lens"].Value -replace "<a href="".*?"">", "" -replace "</a>", ""
        'Optic'       = $matchTable.Groups["Optic"].Value
        'Angle'       = $matchTable.Groups["Angle"].Value
        'AngleDX'     = $matchTable.Groups["AngleDX"].Value
        'f'           = $matchTable.Groups["f"].Value
        'Bl'          = $matchTable.Groups["Bl"].Value
        'CloseFocus'  = $matchTable.Groups["CloseFocus"].Value
        'Macro'       = $matchTable.Groups["Macro"].Value
        'FocusThrow'  = $matchTable.Groups["FocusThrow"].Value
        'Filter'      = $matchTable.Groups["Filter"].Value
        'Diam'        = $matchTable.Groups["Diam"].Value
        'Length'      = $matchTable.Groups["Length"].Value
        'TotalLength' = $matchTable.Groups["TotalLength"].Value
        'Weight'      = $matchTable.Groups["Weight"].Value -replace '^(\d+).*$', '$1' -replace "\?", ""
        'Features'    = $matchTable.Groups["Features"].Value
    }
}

# accessory data set.
CreateJson "accessory" "(?s)<tr.*?><td>(?<Type>.*?)<td>(?<Lens>.*?)<td>(?<Filter>.*?)<td>(?<Hood>.*?)<td>(?<AltHood>.*?)<td>(?<f>.*?)<td>(?<Case>.*?)<td>(?<TC201>.*?)<td>(?<TC301>.*?)<td>(?<TC14A>.*?)<td>(?<TC14B>.*?)<td>(?<TC14E>.*?)<td>(?<TC20E>.*?)<td>(?<Other>.*?)" { [PSCustomObject]@{
        'Group'   = $group
        'Type'    = $matchTable.Groups["Type"].Value
        'Lens'    = $matchTable.Groups["Lens"].Value -replace "<a href="".*?"">", "" -replace "</a>", ""
        'Filter'  = $matchTable.Groups["Filter"].Value
        'Hood'    = $matchTable.Groups["Hood"].Value
        'AltHood' = $matchTable.Groups["AltHood"].Value
        'Case'    = $matchTable.Groups["Case"].Value
        'TC201'   = $matchTable.Groups["TC201"].Value
        'TC301'   = $matchTable.Groups["TC301"].Value
        'TC14A'   = $matchTable.Groups["TC14A"].Value
        'TC14B'   = $matchTable.Groups["TC14B"].Value
        'TC14E'   = $matchTable.Groups["TC14E"].Value
        'TC20E'   = $matchTable.Groups["TC20E"].Value
        'Other'   = $matchTable.Groups["Other"].Value
    }
}
