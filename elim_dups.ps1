# WE ALREADY HAVE THE LIST OF POTENTIAL DUPLICATES.
# NO NEED TO ITERATE THROUGH THE _ENTIRE_ ARCHIVE.

# Get the entire archive
# $path = ".\" # or whatever path is of interest. Default is current directory.
# $ds = Get-ChildItem $path -Recurse -File

# Create a list in a .txt file
# Will take input as command-line argument in the future
# $filelist = ".\filelist.txt"
# Get-ChildItem -Recurse -File | Select-Object -ExpandProperty FullName | Out-File $filelist -Width 400
# $ds = Get-Content -Path $filelist

# Use a pre-defined list in a .txt file
$filelist = ".\filelist.txt"
$ds = Get-Content -Path $filelist
# Remove trailing whitespace 
$ds | Foreach {$_.TrimEnd()} | Set-Content $filelist
$ds = Get-Content -Path $filelist

# Store the archive and its first kb into an object
$mya = [System.Collections.ArrayList]@{}
foreach ($file in $ds)
{
    $result = ($file | Get-Item | Get-Content -Encoding Byte -TotalCount 1000)
    $mco = [PSCustomObject]@{Name=$file;Bytes=$result}

    # Don't add files into the list that weren't able to have a partial hash
    # Due to system error.
    if ($mco.Bytes -ne $null)
    {
        $mya.Add($mco)
    }
}



Write-Host "Printing mya"
Write-Host $mya
Write-Host "Done"

$grouped = $mya | Group-Object -Property { [BitConverter]::ToString($_.Bytes) }

$cd = [System.Collections.ArrayList]@{}

foreach ($pile in $grouped)
{
    if ($pile.Count -gt 1)
    {
        $cd.Add($pile)
    }
}

foreach ($items in $cd)
{
    $pastFirst = $false
    foreach ($item in $items.Group.Name)
    {
        if ($pastFirst -eq $false)
        {
            Write-Host "Keeping $item"
            $pastFirst = $true
            continue
        }
        Remove-Item -Path $item
        Write-Host "$item deleted"
    }
}
