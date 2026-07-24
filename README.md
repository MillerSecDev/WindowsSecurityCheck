# WindowsSecurityCheck

A read-only PowerShell tool I'm building to learn how Windows security settings can be checked and reported automatically.

## Current Features

- Displays the computer name
- Displays the Windows edition, version, and build number
- Returns the results as a structured PowerShell object
- Reports the status of the Domain, Private, and Public firewall profiles
- Displays the default inbound and outbound firewall actions
- Displays the active network name, adapter, category, and IP connectivity
- Reports Microsoft Defender protection status and signature freshness
- Reports whether Secure Boot is enabled
- Reports system drive encryption and BitLocker protection status
- Lists members of the local Administrators group and their account sources

## Planned Checks

- Listening network ports

## Safety

The script only reads and reports system and security information. It does not change any Windows or security settings.

The Secure Boot and drive encryption checks require administrator access. Without it, the script reports those statuses as unknown and continues running.

