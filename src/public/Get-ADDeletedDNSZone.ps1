function Get-ADDeletedDNSZone {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,
                    Position = 0)]
        [string]$ZoneName
    )
    
    begin {
        $DomainDN = (Get-ADDomain).DistinguishedName
        [System.Collections.ArrayList]$DeletedZoneDN = @(
            "CN=MicrosoftDNS,CN=System,$DomainDN"
            "DC=DomainDnsZones,$DomainDN"
        )
    }

    process {
        foreach ($DN in $DeletedZoneDN) {
            $FindZoneSplat = @{
                LDAPFilter            = "(&(name=*..Deleted-$($ZoneName)*)(ObjectClass=dnsZone))"
                SearchBase            = $DN
                IncludeDeletedObjects = $true
                Properties           = "*"
            }

            try {
                $DeletedZone = Get-ADObject @FindZoneSplat
                if ($DeletedZone) {
                    Write-Output ($DeletedZone | Select-Object -First 1)
                    break
                }
            }
            catch {
                Write-Error "Error searching in $DN : $_"
            }
        }
    }
}