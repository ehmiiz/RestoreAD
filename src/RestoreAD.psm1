# Get public and private function definition files
$Public = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

# Import functions
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

# Get list of public functions for export
$PublicFunctions = $Public.BaseName

# Export public functions and aliases
Export-ModuleMember -Function $PublicFunctions -Alias *
