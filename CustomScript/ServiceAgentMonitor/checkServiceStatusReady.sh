#!/bin/bash
 
# Run the status command as svc_infa_admin from the correct directory
output=$(sudo su - svc_infa_admin -c "cd /apps/iics/apps/agentcore && ./consoleAgentManager.sh getstatus")
 
# Check for the READY status
if echo "$output" | grep -q "READY"; then
    echo "name=Custom Metrics|AppStatus|Ready,value=1"
else
    echo "name=Custom Metrics|AppStatus|Ready,value=0"
fi