# spbm-policy

V1.0

Purpose: This script was built to help demonstrate the power of Storage policy based management.  The script creates the following policies: 
1. vSAN No Protect - FTT-0
2. vSAN Basic Protect, Enhanced Perform, High Capacity Used FTT-1, FTM: Raid 1
3. vSAN Basic Protect, Enhanced Capacity, Low Capacity Used FTT-1, FTM: Raid 5/6</FTT1R5>
4. vSAN Enhanced Protect, Enhanced Perform, High Capacity Used FTT-2, FTM: Raid 1
5. vSAN Enhanced Protect, Enhanced Capacity, Low Capacity Used FTT-2, FTM: Raid 5/6
6. vSAN Maximum Protect, High Capacity Used FTT-3, FTM: Raid 1
7. Example: vSAN IO Limit 2000 IOPS: Basic Protect, Enhanced Perform FTT1, FTM R1


Use: 
When you first unzip the package you will find the following: 
Root Directory
-->config directory
-->policycreationsettings.xml
-->spbm-policy.ps1

Keep in mind the Script is built to run multiple times.  It saves the password in an encrypted format in a file called: config/creds.txt
If you need to execute the script with different credentials, the policycreationsettings.xml file contains the username, first change the username and then remove the config/creds.txt file. 

Step 1:

Modify the following lines of code in the policycreationsettings.xml: 

vCenterName vcenter@virtualmachine.local
vCenterUserName vcenterUser@virtualmachine.local 
output C:\scripts\spbm-output.log

Step 2: 
Modify the following line in the spbm-policy.ps1 script: 

[xml]$ConfigFile = Get-Content "C:\scripts\config\policycreationsettings.xml"

Step 3: 
Execute the Script

Step 4: 
Check vCenter to verify that the policies exist in vCenter. 
