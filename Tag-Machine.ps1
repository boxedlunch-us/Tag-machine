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
}
