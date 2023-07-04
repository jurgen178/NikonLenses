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
$lightLenses = $allLensData.Where({ $_.Weight.Length -gt 0 -and [int]($_.Weight) -lt 200 })

# Get all heavy lenses >2000g.
$heavyLenses = $allLensData.Where({ [int]($_.Weight) -gt 2000 })

$first5heavyLenses = $heavyLenses.GetEnumerator() | Sort-Object { [int]($_.Weight) } | Select-Object -Last 5
# 2000/11 Reflex A,C (7500g)
# 360-1200/11 ED Ai-S (8250g)
# 50cm/5 T·C S, M39 (8500g)
# 1000/6.3 Reflex F (9900g)
# 1200-1700/5.6-8 IF-ED Ai-P (16000g)
foreach ($lens in $first5heavyLenses) {
    "$($lens.Lens) $($lens.Type) ($($lens.Weight)g)"
}

# Get all constant f/2.8 aperture lenses.
$aperture_2_8 = $allLensData.Where({ $_.Lens -match "/2.8(\s|$)" })

# Get all Z mount VR lenses.
$vr = $allLensData.Where({ $_.Type.Contains("Z") -and $_.Lens.Contains("VR") })

# Get all DX lenses out of the Z mount VR lenses.
$vrdx = $vr.Where({ $_.Type -eq "Z DX" })

# Print result.
# 12-28/3.5-5.6 PZ VR Z DX
# 16-50/3.5-6.3 VR Z DX
# 18-140/3.5-6.3 VR Z DX
# 50-250/4.5-6.3 VR Z DX
foreach ($lens in $vrdx) {
    "$($lens.Lens) $($lens.Type)"
}


# Print all lens data by group.
foreach ($lensGroup in $lenses.PsObject.Properties) {
    "$($lensGroup.Name) ($($lensGroup.Value.count))"

    $lensGroup.Name
    foreach ($lens in $lensGroup.Value) {
        $lens
        #"$($lens.Lens)"
    }
}

