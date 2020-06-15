


#ERROR REPORTING ALL
Set-StrictMode -Version latest


#region parameters for script
<#param(

	[Parameter(Position=0, Mandatory=$false)][String[]]$UNCpaths
	[Parameter(Position=1, Mandatory=$false)][String]$SegmentCheck,
	[Parameter(Position=2, Mandatory=$false)][String[]]$SearchData
)
#> 
#end region 



$ErrorActionPreference = "silentlycontinue"

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$outputFiles = "$dir\outputfiles\"
$inputFiles = "$dir\inputfiles"
$inputDatatoCheck = $dir
$UNCpaths = "C:\Users\USER\Desktop\Folder","C:\Users\USER\Desktop\Folder2" #Provide UNC paths to search files


$SearchData = 'Montevideo,SecondSearchKeyword' #GIve the First Search term (Mandatory)
$controls = $SearchData.split(",");
$Segmentcheck =''  #GIve the Keyword to search further (optional)

if (-not(Test-Path -Path $inputFiles))
{

New-Item -Path $inputFiles -ItemType Directory -Force

}


$InitArr = @()
$finalArr = @()

foreach ($control in $controls)
{

	$InitArr +=$control
}



Try
{

	Function removeOP
{

remove-item $outputFiles\*
	Remove-Item $inputFiles\*
}



workflow FileCopy-Parallel {

	param([string[]]$UNCpaths,[string[]]$InputFilePath)
	foreach –parallel ($path in $UNCpaths){


		InlineScript {
			robocopy $using:path $using:InputFilePath /MT:30


		}

	}

} 



workflow getStringMatch
{

	param([string[]]$Inputfilepath,[string[]]$SearchStrings,[string] $Segmentcheck,[string] $outputFiles)





	$SearchArray = @();

	foreach –parallel($Search In $SearchStrings)
	{




		InlineScript {


			$SearchFilePaths = Get-ChildItem -Path $Using:InputFilePath\*.*  | Select-String -SimpleMatch "$Using:Search" -List |select path,filename

      
			if (-not ([string]::IsNullOrEmpty($Using:SegmentCheck)))
			{


				foreach ($filepath in $SearchFilePaths)
				{


					$PathObj = @();

					$PathObj = Select-String -Path $filepath.path -SimpleMatch $Using:Segmentcheck -List |select Filename,Path


					$newpath = $PathObj.Path
					$fileName = $PathObj.Filename

	              
        

					if ($PathObj)
					{
						$SearchArray += [pscustomobject] [ordered] @{ SearchValue=$Using:Search
							Status="Found"}


						$newfilepath = $Using:Search + "_"+$fileName


						Copy-Item -Path $newpath -Destination $Using:outputFiles\$newfilepath

						
					}


					else
					{


                            $SearchArray += [pscustomobject] [ordered] @{ SearchValue=$Using:Search
							Status="Could not Find the Segment"}

						


					}
				}


                return $SearchArray

			}
			else
			{


				foreach ($filepath in $SearchFilePaths)
				{


					$path = $filepath.path
					$fileName = $filepath.filename


                   
					if ($filepath)
					{

						$SearchArray += [pscustomobject] [ordered] @{ SearchValue=$Using:Search
							Status="Found"}


						$filenameext = [System.IO.Path]::GetFileNameWithoutExtension($path)

						$newfilepath = $Using:Search + "_"+$fileName

						Copy-Item -Path $path -Destination $Using:outputFiles\$newfilepath

						


					}
								
				}

                    return $SearchArray


				}
			}

            Trap {
                        Continue
                 }

		}




}



removeOP
FileCopy-Parallel -UNCpaths $UNCpaths -InputFilePath $inputFiles
$searchinfo = getStringMatch -Inputfilepath $inputFiles -SearchStrings $controls -SegmentCheck $Segmentcheck -outputFiles $outputFiles

$finalArr +=$searchinfo

foreach ( $arr in $InitArr )

{

	if (-not ($searchinfo |Where-Object {$_.SearchValue -eq $arr}))
	{

		$finalArr +=[pscustomobject] [ordered] @{ SearchValue=$arr
			Status="NotFound in Archive"}
	}
	else
	{

	}

}


$finalArr|select SearchValue,Status

}

Catch
{

	$ex = $_.Exception
	$ex.Message| Out-File $dir\ErrorLog.txt
	continue

}