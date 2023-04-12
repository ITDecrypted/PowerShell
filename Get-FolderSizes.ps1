# Run this in the directory that you want to count folder sizes in
# Eventually the path can be input as a command-line argument in a future version.
# Simply open PowerShell, copy and paste the following into the console and receive information.

$folders = Get-ChildItem -Name
$folderSizes = foreach($folder in $folders) {Get-ChildItem $folder -Recurse -File | Measure-Object -Property Length -Sum | Add-Member -MemberType NoteProperty -Name Name -Value $folder -PassThru; Write-Host "$folder complete"}
$folderSizes
# End
