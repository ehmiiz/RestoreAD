# RestoreAD

🚧 Early in the development phase 🚧

PowerShell module that makes restoring Active Directory objects easy!

Target Cmdlets:

- Get-ADDeletedObject
- Restore-ADDeletedObject

## Why not use `Restore-ADObject`

This module aims to further build on top of the Restore-ADObject cmdlet. I noticed that some objects are not logically stored upon deletion (AD integrated DNS objects). This module makes it easier to display everything that is deleted, and should make restoring a DNS zone much easier.
