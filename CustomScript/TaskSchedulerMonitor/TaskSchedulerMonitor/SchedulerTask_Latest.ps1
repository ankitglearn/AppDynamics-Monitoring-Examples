$ScheduledTaskFile=".\schedulertask_list.conf"
$ScheduledTaskFileContent= Get-Content ($ScheduledTaskFile)

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

Foreach ($name in $ScheduledTaskFileContent){
if ($name.sartsWith('#')){
	continue
}
else{
	$ScheduledTaskName = (Get-ScheduledTask -TaskName $name).TaskName
	
	if ($ScheduledTaskName -match $name)
	{
		$LastTaskResult = (Get-ScheduledTask | where TaskName -eq $name | Get-ScheduledTaskInfo).LastTaskResult
		if ($LastTaskResult -eq 0)
		{
			$LastTaskResult=1
		}
		else
		{
			$LastTaskResult=0
		}
		
		if ($flag -eq 0)
		{
			$metric = "name=Custom Metrics|Scheduled Task|$Server|$name|LastTaskResult, value=$LastTaskResult"
			write-host $metric
		}
		else
		{
			$metric = "name=Server|Component:$Component_ID|Custom Metrics|Scheduled Task|$Server|$name|LastTaskResult, value=$LastTaskResult"
			write-host $metric
		}
	
	
	if ((Get-ScheduledTask | where TaskName -eq $name).State -eq 'Ready')
	{
		$Status=1
	}
	else
	{
		$Status=0
	}
	
	if ($flag -eq 0)
		{
			$metric = "name=Custom Metrics|Scheduled Task|$Server|$name|Status, value=$Status"
			write-host $metric
		}
		else
		{
			$metric = "name=Server|Component:$Component_ID|Custom Metrics|Scheduled Task|$Server|$name|Status, value=$Status"
			write-host $metric
		}
}
}
}