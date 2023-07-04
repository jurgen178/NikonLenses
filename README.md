# NikonLenses
This project convert the Nikon Lens http://www.photosynthesis.co.nz/nikon/lenses.html web page to a json to simplify lens data queries.

The web page is an extensive list of all Nikon Lenses, but as a simple web page also limited to data queries. A PowerShell script is used to download and convert the html page to a JSON file to allow lens data queries.

For example:
```
# Get all 16mm Fisheye lenses.
$16mmFisheye = $allLensData.Where({ $_.Group -eq "Fisheye" -and $_.Lens.StartsWith("16/") })
```

Use [NikonLensesToJson.ps1](https://github.com/jurgen178/NikonLenses/blob/main/src/NikonLensesToJson.ps1) to create the lenses.json file, and [NikonLenses.ps1](https://github.com/jurgen178/NikonLenses/blob/main/src/NikonLenses.ps1) for example queries.
