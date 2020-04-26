function BackupSubModule{
    param($file)
    $backup = ($file.FullName -replace "XML","BAK")
    Copy-Item $file.FullName $backup
    Write-Host "[$(($file.PSParentPath -split "\\")[($file.PSParentPath -split "\\").Length-3])] BACKED UP: $(Test-Path $backup) " -BackgroundColor Yellow -ForegroundColor Black
}

$user = "Vegavak"
$path ="C:\Users\$user\AppData\Roaming\Vortex\mountandblade2bannerlord\mods"

$configFiles = Get-Childitem $path -Recurse | ?{$_.name -match "Submodule.XML"}

$b = 0

do{

    Write-Host $b -BackgroundColor DarkCyan

    $file = $configFiles[$b]

    Write-Host $file.FullName -BackgroundColor DarkYellow

    BackupSubModule $file

    ""
    ""
    
    $b++

}until( $b -gt $configFiles.Count )