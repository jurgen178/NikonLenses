<#
    Example queries for the Nikon Lens json data file.
#>

# Load the json data file.
[string]$jsonFile = "$PSScriptRoot\lenses.json"
$lenses = (Get-Content $jsonFile -Raw) | ConvertFrom-Json

# Get the lens data.
$allLensData = $lenses.PsObject.Properties.Value

"$($allLensData.count) lenses"

# Filter the result for specific lens data.

# Get all 6/2.8 lenses with AI.
$ai = $allLensData.Where({ $_.Type.Contains("Ai") -and $_.Lens -eq "6/2.8" })

# Get all AI-S 6/2.8 lenses.
$ais = $allLensData.Where({ $_.Type -eq "Ai-S" -and $_.Lens -eq "6/2.8" })

# Get all 16mm Fisheye lenses.
$16mmFisheye = $allLensData.Where({ $_.Group -eq "Fisheye" -and $_.Lens.StartsWith("16/") })

# Get all AF lenses out of the 16mm Fisheye lenses.
$AF16mmFisheye = $16mmFisheye.Where({ $_.Type -match "AF" })

# Get all 24-85 lenses.
$24_85 = $allLensData.Where({ $_.Lens.StartsWith("24-85/") })

# Get all light lenses <200g.
$lightLenses = $allLensData.Where({ $_.Weight.Length -gt 0 -and [int](($_.Weight -replace '^(\d+).*$', '$1')) -lt 200 })

# Get all heavy lenses >2000g.
$heavyLenses = $allLensData.Where({ [int](($_.Weight -replace '^(\d+).*$', '$1')) -gt 2000 })

# Get all constant f/2.8 aperture lenses.
$aperture_2_8 = $allLensData.Where({ $_.Lens -match "/2.8(\s|$)" })


# Print all lens data by the groups.
foreach ($lensGroup in $lenses.PsObject.Properties) {
    "$($lensGroup.Name) ($($lensGroup.Value.count))"

    $lensGroup.Name
    foreach ($lens in $lensGroup.Value) {
        $lens
        #"$($lens.Lens)"
    }
}

