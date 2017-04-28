<#
Title: Storage Policy Recommendations
Name: spbm-policy.ps1
Author: Jared Lutgen
Date: April 25, 2017
Version 1.0
Intended for vSAN 6.5 - Could work for previous versions. 
#>

# Modify the following line 
[xml]$ConfigFile = Get-Content "C:\scripts\config\policycreationsettings.xml"

# To modify the settings below please leverage the provided XML file.  DO NOT MODIFY ANYTHING BELOW!
# vCenter Hostname and Creds
$vccenter = $ConfigFile.PolicyCreation.changeme.vCenterName 
$vcuser = $ConfigFile.PolicyCreation.changeme.vCenterUserName

#Check to see if the creds are passed for multiple runs. This Saves the password so you only have to type it in once. 
if (-not(Test-Path -Path (Join-Path (Resolve-Path config) creds.txt))) 
    {
        Write-Host "Please Enter your vCenter Password"
        Read-Host -AsSecureString | ConvertFrom-SecureString | out-file (Join-Path (Resolve-Path config) creds.txt)
    }

#Connect to vCenter
$password = Get-Content (Join-Path (Resolve-Path config) creds.txt) | ConvertTo-SecureString
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $vcuser,$password

Connect-VIServer -Server $vccenter -Credential $creds

# Start of Policy Creation
# FTT0 
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.FTT0General -Description $ConfigFile.PolicyCreation.variables.policyDesc.FTT0General -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 0)) | out-file $ConfigFile.PolicyCreation.changeme.output -Append

# FTT1 
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.FTT1R1 -Description $ConfigFile.PolicyCreation.variables.policyDesc.FTT1R1 -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 1),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.replicaPreference") -Value "RAID-1 (Mirroring) - Performance")) | out-file $ConfigFile.PolicyCreation.changeme.output -Append
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.FTT1R5 -Description $ConfigFile.PolicyCreation.variables.policyDesc.FTT1R5 -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 1),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.replicaPreference") -Value "RAID-5/6 (Erasure Coding) - Capacity")) | out-file $ConfigFile.PolicyCreation.changeme.output -Append

# FTT2
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.FTT2R1 -Description $ConfigFile.PolicyCreation.variables.policyDesc.FTT2R1 -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 2),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.replicaPreference") -Value "RAID-1 (Mirroring) - Performance")) | out-file $ConfigFile.PolicyCreation.changeme.output -Append
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.FTT2R5 -Description $ConfigFile.PolicyCreation.variables.policyDesc.FTT2R5 -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 2),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.replicaPreference") -Value "RAID-5/6 (Erasure Coding) - Capacity")) | out-file $ConfigFile.PolicyCreation.changeme.output -Append

# FTT3
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.FTT3R1 -Description $ConfigFile.PolicyCreation.variables.policyDesc.FTT3R1 -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 3),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.replicaPreference") -Value "RAID-1 (Mirroring) - Performance")) | out-file $ConfigFile.PolicyCreation.changeme.output -Append

# Example Policies
New-SpbmStoragePolicy -Name $ConfigFile.PolicyCreation.variables.policyNames.Example1 -Description $ConfigFile.PolicyCreation.variables.policyDesc.Example1 -AnyOfRuleSets (New-SpbmRuleSet(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value 1),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.replicaPreference") -Value "RAID-1 (Mirroring) - Performance"),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.iopsLimit" ) -Value 2000)) | out-file $ConfigFile.PolicyCreation.changeme.output -Append

############################################################
#Disconnect VI Server -    #
############################################################
Disconnect-VIServer -Server $vccenter -Confirm:$false -Force
