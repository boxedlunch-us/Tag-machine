<#
.SYNOPSIS
    Assigns tag to specified VM
.DESCRIPTION
    Checking for existence of tag, assigns tag or creates and assigns new tag to virtual machine
.EXAMPLE
    ##Example of use##
.PARAMETER vm
    Virtual Machine name
.PARAMETER tag
    IExisting or new tag
.PARAMETER tagCategory
    Existing tag category
.PARAMETER vCenter
    Name of vCenter Appliance
.PARAMETER vCenterCred
    (Only used interactively) credentials for vCenter in PSCredential form
.PARAMETER user
    Username for logging into vCenter
.PARAMETER password
    Plaintext password for logging into vCenter
.NOTES
    Author: Ricky Nelson
    Date:  20190725
#>
param(
    # Virtual machine to be tagged 
    [Parameter(Mandatory=$true)]
    [string]
    $vm,
    # Tag name
    [Parameter(Mandatory=$true)]
    [string]
    $tag,
    # Tag Category
    [Parameter(Mandatory=$true)]
    [string]
    $tagCategory,
    # Tag Category
    [Parameter(Mandatory=$true)]
    [string]
    $vCenter,
    # vCenter Credential; object type:(Get-Credential/PSCredential)
    [Parameter(Mandatory=$false)]
    [pscredential]
    $vCenterCred,
    # Username to be passed for quiet execution
    [Parameter(Mandatory=$false)]
    [string]
    $user,
    # Password to be passed for quiet execution
    [Parameter(Mandatory=$false)]
    [string]
    $password
)
if($vCenterCred){
    Connect-VIServer -Server $vCenter -Credential $vCenterCred
}elseif($user -and $password){
    Connect-VIServer -Server $vCenter -User $user -Password $password
}else{
    Connect-VIServer -server $vCenter
}

if(!$global:DefaultVIServers){
    Write-Output "Not connected to vCenter server; terminating script"
    break;
}

# Get tag specified in paramters. If tag does not exist, it is created with a placeholder
$tagAssign = Get-Tag -Name $tag -Category $tagCategory -ErrorAction SilentlyContinue
$vmAssign = get-vm -Name $vm

if(!$tagAssign){
    write-output "Tag does not exist. Creating..."
    $tagAssign = new-tag -Name $tag -Category $tagCategory -Description "Description Pending"
}

# Assign specified or newly created tag
New-TagAssignment -Tag $tagAssign -Entity $vmAssign

Disconnect-VIServer $vCenter -Confirm:$false