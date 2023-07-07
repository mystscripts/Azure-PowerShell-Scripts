$details = @()

$resourceGroups = Get-AzResourceGroup
foreach ($resourceGroup in $resourceGroups) {
    $resources = Get-AzResource -ResourceGroupName $resourceGroup.ResourceGroupName
    foreach ($resource in  $resources) {
        if ($resource.Tags -ne $null) { 
            $tags = $resource.Tags
            foreach ($tag in $tags) {
                $details += [pscustomobject] @{
                    ResourceGroupName = $resourceGroup.ResourceGroupName
                    ResourceType = $resource.ResourceType
                    ResourceName = $resource.Name
                    ResourceTags = $tag.GetEnumerator() | Select-Object -Property @{N='Tags';E={$_.Key + ":" + $_.Value}} 
                }
            }
        }
    }
}

$details | Select-Object ResourceGroupName, ResourceType, ResourceName, ResourceType, @{N='ResourceTags';E={$_.ResourceTags.Tags -join ","}} | Export-Csv C:\Temp\FileName.csv -NoTypeInformation
