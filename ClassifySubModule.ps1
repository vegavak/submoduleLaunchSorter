###### FUNCTIONS
function Create-Poll {
<#
    Takes a title and an infinite amount of options and title and does an option select for you. Clean.
#>
    param(
        [String]$title,
        [Parameter(Mandatory=$True,
	    ValueFromPipeline=$True)]
	    [string[]]$options
    )
    begin
    {
        [int]$i=0
        [String]$question=""
        $answers=@()
    }
    process
    {
        Foreach ($opt in $options)
        {
            $answers+=$i # add 0 > max
            $i++
            $question=($question+(""+$i+") "+$opt+"`n"))
        }
        $answers+=$i # add max
        $question=$title+":`n"+$question+"0) Cancel`n"
    }
    end
    {
        $result = Read-Host -Prompt $question
        
        while($answers -notcontains $result){
            Write-Host "Invalid entry. Please try again." -ForegroundColor DarkYellow
            $result = Read-Host 
        }
        if($result -eq "0")
        {
            Write-Warning "Cancel Selected."
            Break # this is the cancel options.
        }
        else
        {
            Write-Warning ($options[$result-1]+" Selected.") 
            Return $result
        }
    }
}
function ClassifySubModule {
    param(
        $classifications,
        $file
    )

    $skip = $false

    # Get the name value to replace
    $original = @((Get-Content $file.FullName) | ?{$_ -match "Name value"})
    if($original.count -gt 1){
        $original = $original[0]
    }

    $originalName = $($original -split '"')[1]
        
    foreach($class in $classifications){
        Write-Verbose $class
        if($originalName.StartsWith($class)){
            $message = "[$class] matched on: $($originalName -split ($Class+' -'))"
            Write-Host $message -ForegroundColor Green
            $skip=$true
            Return ""
        }
    }

    
    if(!$skip){
    
        $select = Create-Poll -options $classifications -title "What should **$originalName** be classified as?"

        $classification = $($classifications[$select-1])

        if( $classification -match "Skip" ){

            Write-Host "Skipping: $originalName" -ForegroundColor DarkGreen

        }else{
     
            Write-Host "Classifying: $classification - $originalName" -BackgroundColor Green
            
            # Write to XML file
            if($originalname -ne $null){
                $replacement = '<Name value = "'+$classification+" - "+$originalname+'"/>'
                # $replacement
                (Get-Content $file.fullname) -replace "$original",$replacement | Set-Content $file.FullName -Verbose
                $check = (Get-Content $file.FullName) -contains $replacement
                switch($check){
                    'false'{ $color = "Red" }
                    'true'{ $color = "Green" }
                }
                Write-Host "File Updated: $Check" -ForegroundColor $color

            }else{
                
                Write-Host "Skipping blank $($file.fullname)" -ForegroundColor DarkRed

            }
            
            <# 
                # Repair
                $repairname = ($file.PSParentPath -split "\\")[($file.PSParentPath -split "\\").Length-1]
                $repairstring = '<Name value = "'+$repairname+'"/>'
                (Get-Content $file.fullname) -replace "myvalue", $repairname | Set-Content $file.FullName
            
            #>
        }# end else

        
    # $foldername = ($file.PSParentPath -split "\\")[($file.PSParentPath -split "\\").Length-1]

    } # end SKIP else

} # end function
###### EDIT AFTER HERE
cls

$classifications = @(
"PREREQ",
"Bugfix",
"QOL",
"Overhaul",
"Character",
"Companion",
"Combat",
"Gameplay",
"Campaign",
"Town Improvement",
"Siege",
"Skip"
)

$user = "Vegavak"
$path ="C:\Users\$user\AppData\Roaming\Vortex\mountandblade2bannerlord\mods"

$configFiles = Get-Childitem $path -Recurse | ?{$_.name -match "Submodule.XML"}

$i = 0

do{

    Write-Host $i -BackgroundColor DarkCyan

    $file = $configFiles[$i]

    Write-Host $file.FullName -BackgroundColor DarkYellow

    ClassifySubModule $classifications $file

    ""
    ""
    
    $i++

}until( $i -gt $configFiles.Count )



