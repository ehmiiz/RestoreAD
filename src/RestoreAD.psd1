@{
    RootModule = 'RestoreAD.psm1'
    ModuleVersion = '1.0.0'
    GUID = 'cbcb738f-6ac9-4323-9381-a677c9045eb2'
    Author = 'Your Name'
    Description = 'Module for restoring deleted AD-integrated DNS zones'
    PowerShellVersion = '5.0'
    RequiredModules = @('DnsServer', 'ActiveDirectory')
    FunctionsToExport = @('Restore-ADDeletedDNSZone', 'Get-ADDeletedDNSZone')
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = @()
}