

param(

	[Parameter(Position=0, Mandatory=$false)][String]$Team = "delhi"
)

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")


#region WriteLog function

function WriteLog($LogMessage, $LogDateTime, $LogType) 
{

	write-host 
	"$LogType, ["+ $LogDateTime +"]: "+ $LogMessage | Add-Content -Path $LogFilepath
}

#endregion


# Get Start Time
$startTime = (Get-Date)

$RunTime =get-date -Format "MMdyyyhhmmss"

# Get build folder parent directory
$scriptpath = $MyInvocation.MyCommand.Path
$ScriptDir = Split-Path $scriptpath


# Get Application folder path in the build folder

$LogFolderPath = $ScriptDir + "\" + "Logs" 


# Check if Log  folder already exists. If not create a folder for logging purposes 

if(!(Test-Path $LogFolderPath))
{
	New-Item -ItemType directory -Path $LogFolderPath 
}


[string] $logdate =get-date -Format "yyyyMMdd"


$LogFolderFilepath =$LogFolderPath + "\" + "$logdate" 

if(!(Test-Path $LogFolderFilepath))
{
	New-Item -ItemType directory -Path $LogFolderFilepath 
}


# creating logfile path string
$LogFilepath =$LogFolderFilepath +"\"+ "Logfile.txt"


$LogDateTime = get-date

WriteLog "***Getting the Scores for $Team" $LogDateTime "Information" 
write-host "***Getting the Scores for $Team" -ForegroundColor Yellow 

TRY
{

	$PreviousScore = $null;
	while($true)
	{
		[xml]$data = (Invoke-WebRequest -UseBasicParsing  'http://static.cricinfo.com/rss/livescores.xml').Content 
		if($?)
		{
			$CurrentScore = "";
			$finalScore = "";
			$wickdown = "";
			$currWicket = "";
			$PrevWicket = "";
            
            if($data.rss.channel.LastChild.title -match 'No Match in progress..')
            {

            WriteLog "***Score Does not change for  $team" $LogDateTime "Information" 
			write-host "***No Match in progress.." -ForegroundColor Yellow 
            break

            }


			foreach ($xnode in $data.rss.channel.childnodes)
			{

				if(($xnode.title -like "*$($Team)*") -and ($xnode.title -match "[0-9]"))
				{
					$CurrentScore = $CurrentScore + $xnode.title + "`n"
				}

			}


			function WicketDown($CurrentScore,$PreviousScore)

 {

				$currWicket = ($CurrentScore.Split("/")[1]).split(" ")[1]

				$PrevWicket = ($PreviousScore.Split("/")[1]).split(" ")[1]

				if($currWicket -ne $PrevWicket)

				{

					return 1;
				}
				else
				{

					return 0;

				}

			}


			if ([string]::IsNullOrEmpty($PreviousScore))

			{


				$PreviousScore = $CurrentScore;
				$finalScore = $CurrentScore;

			}
			elseif (($PreviousScore -eq $CurrentScore ) -and (-not([string]::IsNullOrEmpty($PreviousScore))))

			{

				$finalScore = $null;

			}

			elseif (($PreviousScore -ne $CurrentScore ) -and (-not([string]::IsNullOrEmpty($PreviousScore))))

			{

				$PreviousScore = $CurrentScore;
				$finalScore = $CurrentScore;

				$wickdown = WicketDown($CurrentScore,$PreviousScore)


			}
			else
			{


			}




			$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon

			$objNotifyIcon.Icon = [System.Drawing.SystemIcons]::Information
			$objNotifyIcon.BalloonTipIcon = "Info"



			if($finalScore -and $wickdown -ne '1')
			{
				$objNotifyIcon.BalloonTipText = $finalScore
				$objNotifyIcon.BalloonTipTitle = "Cricket Score:"
				$objNotifyIcon.Visible = $True
				$objNotifyIcon.ShowBalloonTip(30000)
			}


			elseif($finalScore -and $wickdown -eq '1')
			{
				$objNotifyIcon.BalloonTipText = $finalScore
				$objNotifyIcon.BalloonTipTitle = "Cricket Score:"
				$objNotifyIcon.BalloonTipIcon = "Error" ;
				$objNotifyIcon.Visible = $True
				$objNotifyIcon.ShowBalloonTip(30000)
			}


			else
			{

				$LogDateTime = get-date

				WriteLog "***Score Does not change for  $team" $LogDateTime "Information" 
				write-host "***Score Does not change for  $team" -ForegroundColor Yellow 

			}

		}
		$objNotifyIcon.Dispose();
		Start-Sleep -seconds 10
	}
}
Catch
{


	$ErrorOccured = $true
	#region log exception in log file

	$LogMessage = $_.Exception.Message
	$LogDateTime = get-date
	WriteLog $LogMessage $LogDateTime "Error"

	WriteLog "$Action failed with Error" $LogDateTime "Error"

	$ErrorActionPreference="Continue"

	#endregion

}


Finally
{

	$LogDateTime = get-date

	WriteLog "*** Script exection stoppped " $LogDateTime "Information" 

}
