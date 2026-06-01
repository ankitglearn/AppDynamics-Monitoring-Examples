$ScheduledTaskFile = ".\schedulertask_list.conf"
$ScheduledTaskFileContent = Get-Content $ScheduledTaskFile

$Component_ID = ""
$Server = ""

if ($Component_ID -eq "")
{
    $flag = 0
}
else
{
    $flag = 1
}

foreach ($name in $ScheduledTaskFileContent) {
    if ($name.StartsWith('#')) {
        continue
    } else {
            $LastTaskResult = schtasks /query /tn "$name" /fo LIST /v 2>$null | Select-String "Last Result" | ForEach-Object { ($_ -split ":")[-1].Trim() }
            if ($LastTaskResult -eq "0") {
                $LastTaskResult = 1
            } else {
                $LastTaskResult = 0
            }
            if ($flag -eq 0) {
                $metric = "name=Custom Metrics|Scheduled Task|$Server|$name|LastTaskResult, value=$LastTaskResult"
                Write-Host $metric
            } else {
                $metric = "name=Server|Component:$Component_ID|Custom Metrics|Scheduled Task|$Server|$name|LastTaskResult, value=$LastTaskResult"
                Write-Host $metric
            }
        #}
        $TaskStatus = schtasks /query /tn "$name" /fo LIST /v 2>$null | Select-String "Status" | ForEach-Object { ($_ -split ":")[-1].Trim() }
        if ($TaskStatus -match "Ready") {
            $Status = 1
        } else {
            $Status = 0
        }
        if ($flag -eq 0) {
            $metric = "name=Custom Metrics|Scheduled Task|$Server|$name|Status, value=$Status"
            Write-Host $metric
        } else {
            $metric = "name=Server|Component:$Component_ID|Custom Metrics|Scheduled Task|$Server|$name|Status, value=$Status"
            Write-Host $metric
        }
    }
}