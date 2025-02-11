# Rename file to Restore-ADDeletedDNSZone.ps1
function Restore-ADDeletedDNSZone {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 0)]
        [string]$ZoneName,

        [Parameter()]
        [switch]$Force
    )

    begin {
        #Requires -Version 5.0 -Modules DnsServer, ActiveDirectory
        Import-Module ActiveDirectory, DnsServer -ErrorAction Stop

        $DomainDN = (Get-ADDomain).DistinguishedName
        [System.Collections.ArrayList]$script:DeletedZoneDN = @(
            "CN=MicrosoftDNS,CN=System,$DomainDN"
            "DC=DomainDnsZones,$DomainDN"
        )
    }

    process {
        try {
            $TheDeletedZone = Get-ADDeletedDNSZone -ZoneName $ZoneName
            if (-not $TheDeletedZone) {
                Write-Error "No deleted DNS zone found with name: $ZoneName"
                return
            }

            $TheDeletedRecords = Get-ADDeletedDNSZoneRecords -ZoneName $ZoneName

            Write-Verbose "Starting the zone restore for $ZoneName..."
            
            # Restore the zone
            $TheDeletedZone | Restore-ADObject -NewName $ZoneName -Verbose:$VerbosePreference -ErrorAction Stop
            
            # Restore the records if any exist
            if ($TheDeletedRecords) {
                $TheDeletedRecords | Restore-ADObject -Verbose:$VerbosePreference -ErrorAction Stop
            }
            
            # Restart DNS service
            Restart-Service DNS -Verbose:$VerbosePreference -ErrorAction Stop
            
            Write-Output "DNS zone $ZoneName has been successfully restored."
        }
        catch {
            Write-Error "Failed to restore DNS zone: $_"
        }
    }
}