
workflow parallelEventCheck {
    param(
        [String[]]$ComputerName,
        [string]$EventMessage,
        [string[]]$ApplicationList,
        [int]$eventCount
    )

    foreach –parallel -ThrottleLimit 5 ($Appname in $ApplicationList) {

        inlinescript {
            if (!([String]::IsNullOrEmpty($using:EventMessage))) {
                Get-EventLog -LogName $Using:Appname -Newest $Using:eventCount -Message "*$Using:EventMessage*" | select Index, MachineName, TimeGenerated, TimeWritten, Source, EventID, EntryType, Message, Category, InstanceId | sort timegenerated -Descending
            }
            else {
                Get-EventLog -LogName $Using:Appname -Newest $Using:eventCount | select Index, MachineName, TimeGenerated, TimeWritten, Source, EventID, EntryType, Message, Category, InstanceId | sort timegenerated -Descending

            }

        }

    }

}#parallelEventCheck



Clear-Host
$eventdata = parallelEventCheck -PSComputerName Server1, Server2 `
    -EventMessage 'Data Element ID' `
    -eventCount 100 `
    -ApplicationList 'application', 'orderservices' | select * -ExcludeProperty PSSourceJobInstanceId, PSComputerName | Out-GridView
