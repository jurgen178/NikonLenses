# Nikon Lens Queries
This project convert the Nikon Lens http://www.photosynthesis.co.nz/nikon/lenses.html web page to a json to simplify lens data queries.

The web page is an extensive list of all Nikon Lenses, but as a simple web page also limited to data queries. A PowerShell script is used to download and convert the html page to a JSON file to allow lens data queries.

(Permission granted from photosynthesis.co.nz)

For example:
```
# Get all 16mm Fisheye lenses.
$16mmFisheye = $allLensData.Where({ $_.Group -eq "Fisheye" -and $_.Lens.StartsWith("16/") })

foreach ($lens in $16mmFisheye) {
    "$($lens.Lens) $($lens.Type)"
}
```

```
16/3.5 F
16/3.5 K
16/3.5 Ai
16/2.8 Ai
16/2.8 Ai-S
16/2.8 D AF
```

```
# Get all heavy lenses >2000g.
$heavyLenses = $allLensData.Where({ [int]($_.Weight) -gt 2000 })

# Get the first 5 heaviest lenses.
$first5heavyLenses = $heavyLenses.GetEnumerator() | Sort-Object { [int]($_.Weight) } -Descending | Select-Object -First 5

foreach ($lens in $first5heavyLenses) {
    "$($lens.Lens) $($lens.Type) ($($lens.Weight)g)"
}
```

```
1200-1700/5.6-8 IF-ED Ai-P (16000g)
1000/6.3 Reflex F (9900g)
50cm/5 T·C S, M39 (8500g)
360-1200/11 ED Ai-S (8250g)
2000/11 Reflex A,C (7500g)
```

Use [NikonLensesToJson.ps1](https://github.com/jurgen178/NikonLenses/blob/main/src/NikonLensesToJson.ps1) to create the lenses.json file, and [NikonLenses.ps1](https://github.com/jurgen178/NikonLenses/blob/main/src/NikonLenses.ps1) for example queries.
