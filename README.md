# NikonLenses
Convert the Nikon Lens web page to a json to query lens data.

http://www.photosynthesis.co.nz/nikon/lenses.html is an extensive lists of all Nikon Lenses.  
A PowerShell script downloads and converts the html page to a JSON file, which can be used to query the lens data.

For example:
```
# Get all 16mm Fisheye lenses.
$16mmFisheye = $allLensData.Where({ $_.Group -eq "Fisheye" -and $_.Lens.StartsWith("16/") })
```

Use NikonLensesToJson.ps1 to create the lenses.json file, and NikonLenses.ps1 for example queries.
