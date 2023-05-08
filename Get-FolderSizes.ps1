$folders = Get-ChildItem -Name
$folderSizes = foreach($folder in $folders) {Get-ChildItem $folder -Recurse -File | Measure-Object -Property Length -Sum | Add-Member -MemberType NoteProperty -Name Name -Value $folder -PassThru; Write-Host "$folder complete"}
$folderSizes

$totalSum = 0
foreach($item in $folderSizes) { $totalSum += $item.Sum }
$totalSum
