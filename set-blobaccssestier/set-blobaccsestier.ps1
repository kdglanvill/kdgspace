<#  
.SYNOPSIS  
    Set access tier for all blobs in an Azure Blob Storage container.
  
.DESCRIPTION  
    This script changes the access tier of all blobs in a Azure Blob Storage container to the desired access tier.
 .PARAMETER StorageAccountName 
    Name of the Azure Storage Account
      
.PARAMETER ContainerName  
    Target Azure Blob Container name
.PARAMETER StorageAccountKey  
    Access key for Azure Storage Account
.PARAMETER AccessTier  
    Desired access tier
    
.EXAMPLE  
    $context = New-AzureStorageContext `
        -StorageAccountName $Using:storageaccountName `
        -StorageAccountKey $Using:storageaccountKey `
    $blob=Get-AzureStorageBlob `
    -Container $containerName`
        -Context $context
    $blob.icloudblob.setstandardblobtier("$Using:accessTier")
    
  
.NOTES  
    Author: Dave Boulet   
    Last Updated: 1/10/2018     
#> 
workflow set-blobaccsestier
{
    param
    (
        # Name of the Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountName,

        # Target Azure Blob Storage Container 
        [parameter(Mandatory=$true)] 
        [string] $containerName,

        # Access key for Azure Storage Account
        [parameter(Mandatory=$true)] 
        [string] $storageaccountKey,

        # Current Access Tier
        [parameter(Mandatory=$true)]
        [string] $currentaccessTier,

	    # Desired Access Tier
        [parameter(Mandatory=$true)] 
        [string] $desiredaccessTier

    )
    
    inlinescript
    {
            Write-Output "Creating Storage Context..."

    $context = New-AzureStorageContext `
        -StorageAccountName $Using:storageaccountName `
        -StorageAccountKey $Using:storageaccountKey
        
            Write-Output "Done."

	##Set access tier

            Write-Output "Getting $Using:currentaccessTier  Tier Storage Blobs..."

    $blob = Get-AzureStorageBlob -Container $Using:containerName -Context $context | Where-Object{$_.icloudblob.properties.standardblobtier -eq $Using:currentaccessTier}

    	##Set tier of all the blobs to Archive

            if($null -eq $blob) {

                Write-Output "No blobs were found."

            }
            else{

                Write-Output "Done."

                Write-Output "Found $($blob.count) $using:currentaccessTier Blobs ..."

                Write-Output "Setting access tier to $Using:desiredaccessTier ..."

                $blob.icloudblob.setstandardblobtier("$Using:desiredaccessTier")

                Write-Output "Access tier set to $Using:desiredaccessTier ."

            }
    }
}