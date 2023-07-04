# NikonLenses
Convert the Nikon Lens web page to a json to query lens data.

http://www.photosynthesis.co.nz/nikon/lenses.html is an extensive lists of all Nikon Lenses.  
To allow lens queries, a PowerSehll script downloads and converts the html page to a JSON file, which can be used to query thelens data.

For example:
```
# Get all 16mm Fisheye lenses.
$16mmFisheye = $allLensData.Where({ $_.Group -eq "Fisheye" -and $_.Lens.StartsWith("16/") })
```
