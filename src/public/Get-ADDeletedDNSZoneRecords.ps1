function Get-ADDeletedDNSZoneRecords {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ZoneName
    )

    $DeletedZone = Get-ADDeletedDNSZone -ZoneName $ZoneName
    if (-not $DeletedZone) {
        Write-Warning "Zone: $ZoneName not found."
        return
    }

    $DeletionTimeStamp = $DeletedZone.whenChanged

    foreach ($DN in $DeletedZoneDN) {
        Get-ADObject -Filter { 
            WhenChanged -ge $DeletionTimeStamp -and 
            ObjectClass -eq 'dnsNode' -and 
            isDeleted -eq $true 
        } -SearchBase $DN -IncludeDeletedObjects
    }
}