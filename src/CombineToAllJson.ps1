<#
    Combine all individual data files from the Nikon Lens data pages to one json data file.
#>

[string]$jsonFile = "$PSScriptRoot\allData.json"

# Load the json data files.
[PSCustomObject]$lenses = (Get-Content "$PSScriptRoot\lenses.json" -Raw) | ConvertFrom-Json
[PSCustomObject]$serialno = (Get-Content "$PSScriptRoot\serialno.json" -Raw) | ConvertFrom-Json
[PSCustomObject]$specs = (Get-Content "$PSScriptRoot\specs.json" -Raw) | ConvertFrom-Json
[PSCustomObject]$accessory = (Get-Content "$PSScriptRoot\accessory.json" -Raw) | ConvertFrom-Json

$allData = [ordered]@{}

<#
.DESCRIPTION
    Update the entry with the matching data elements.
#>
function UpdateEntry([PSCustomObject]$entry,
    [PSCustomObject]$dataEntry,
    [string]$dataSrcName,
    [bool]$skipLens) {

    # Update data source name.
    if (-not $dataEntry."DataSrc".Contains($dataSrcName)) {
        $dataEntry."DataSrc" += ", $dataSrcName"
    }

    # Update entry data.
    foreach ($a in $entry.PsObject.Properties) {

        # $skipLens = $false: data is updated with lens data first. Skip only "Groups" but set "Type".
        if (($skipLens -and $a.Name -notin @("Group", "Type", "Lens")) -or 
            (-not $skipLens -and $a.Name -ne "Group")) {

            if ($a.Name -in @("Weight", "Qty")) {

                # Do not combine Weight and Qty values.
                if (-not $dataEntry."$($a.Name)") {
                    $dataEntry."$($a.Name)" = $a.Value
                }
            }
            else {
    
                # Check if value does not already exist.
                if (-not $dataEntry."$($a.Name)".Contains($a.Value)) {
                    $dataEntry."$($a.Name)" += $a.Value
                }
            }
        }
    }
}

<#
.DESCRIPTION
    Create the entry with all possible data elements.
#>
function CreateEntryObject([string]$group, [string]$dataSrcName) {
    , [PSCustomObject]@{
        'Group'       = $group
        'DataSrc'     = $dataSrcName
        'Type'        = ""
        'Lens'        = ""
        'Country'     = ""
        'SerialNo'    = ""
        'StartNo'     = ""
        'Confirmed'   = ""
        'EndNo'       = ""
        'Date'        = ""
        'Notes'       = ""
        'Optic'       = ""
        'Angle'       = ""
        'AngleDX'     = ""
        'f'           = ""
        'Bl'          = ""
        'CloseFocus'  = ""
        'Macro'       = ""
        'FocusThrow'  = ""
        'Filter'      = ""
        'Hood'        = ""
        'AltHood'     = ""
        'Case'        = ""
        'Diam'        = ""
        'Length'      = ""
        'TotalLength' = ""
        'Weight'      = ""
        'Features'    = ""
        'Scr'         = ""
        'Qty'         = ""
        'TC201'       = ""
        'TC301'       = ""
        'TC14A'       = ""
        'TC14B'       = ""
        'TC14E'       = ""
        'TC20E'       = ""
        'Other'       = ""
    }
}

<#
.DESCRIPTION
    Add the entry to allData.
#>
function AddEntry([string]$group, 
    [string]$dataSrcName,
    [PSCustomObject]$entry) {

    # Create the full entry.
    [PSCustomObject]$dataEntry = CreateEntryObject $group $dataSrcName

    # Update the entry with the lens data.
    UpdateEntry $entry $dataEntry $dataSrcName $false

    # Add entry.
    $allData[$group] += , $dataEntry
}

<#
.DESCRIPTION
    Add the data from the data source to allData.
#>
function addDataSrc($dataSrc, [string]$dataSrcName) {
    # Add data to allData.
    foreach ($dataGroup in $dataSrc.PsObject.Properties) {
    
        # Get all entries in group.
        foreach ($entry in $dataGroup.Value) {

            # Get id, and look up the id in allData.
            [string]$id = "$($entry.Type)$($entry.Lens)"

            if ($entry.Lens -eq "38/1.9 NKJ") {
                $id = "$($entry.Type)$($entry.Lens)"
            }
            # Get the matching entry in allData.
            $dataMatches = $allData[$entry.Group] | ? { $id.StartsWith("$($_.Type)$($_.Lens)") }
            
            if ($dataMatches) {
                # Update the data in allData.
                foreach ($dataMatch in $dataMatches) {          
                    UpdateEntry $entry $dataMatch $dataSrcName $true
                }
            }
            else {
                # Add the data in allData.
                AddEntry $entry.Group $dataSrcName $entry
            }
        }
    }
}


# Initalize allData with the lens data.

[string]$dataSrcName = "lenses"

# Get all groups.
foreach ($dataGroup in $lenses.PsObject.Properties) {
    
    # "Add $($dataGroup.Name) ($($dataGroup.Value.count))"

    # Get all entries in group.
    foreach ($entry in $dataGroup.Value) {

        AddEntry $entry.Group $dataSrcName $entry
    }
}

# Add other data sources to allData.

addDataSrc $serialno "serialno"
addDataSrc $specs "specs"
addDataSrc $accessory "accessory"

# Save allData to json file.
$allData | ConvertTo-Json -depth 100 | Out-File $jsonFile
