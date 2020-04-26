function RestoreSubModule{
    param($file)
        $RESTORE = ($file.FullName -replace "XML","BAK")
        Copy-Item $RESTORE $file.FullName
        Write-Host "[$(($file.PSParentPath -split "\\")[($file.PSParentPath -split "\\").Length-3])] RESTORE: $(Test-Path $RESTORE) " -BackgroundColor Yellow -ForegroundColor Black
        Compare-Object (Get-Content $restore).Length (Get-Content $file.fullname).Length
}
function CheckFilesError{
param (
    $configFiles
)

    $i = 0
    do{

        $file = $configFiles[$i]

        If(Test-Path $file.fullname){

            [PSCustomOBject]@{
                Num = $i
                Size = ([Math]::ROUnd(($(Get-ItemProperty $file.fullname).Length/1MB),2))
                Fullname = $file.FullName
            }

        }
    
        $i++
    }until( $i -gt $configFiles.Count )

}
function RevertChanges{
    param(
        $configFiles,
        $mode
    )
    
    switch($mode){
        'All'{
        
            # Revert ALL changes
            CheckFilesError $configFiles | 
                %{ RestoreSubModule $_ } # Restore excessively large files.

        }
        'Large'{
            # Revert Large changes
            CheckFilesError $configFiles | 
                ?{$_.size -gt 0} | 
                %{ RestoreSubModule $_ } # Restore excessively large files.

        }
    }

}

$user = "Vegavak"
$path ="C:\Users\$user\AppData\Roaming\Vortex\mountandblade2bannerlord\mods"

$configFiles = Get-Childitem $path -Recurse | ?{$_.name -match "Submodule.XML"}

# RevertChanges $configFiles -mode Large
RevertChanges $configFiles -mode All
