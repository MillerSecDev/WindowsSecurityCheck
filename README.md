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

## Planned Checks

- Secure Boot
- Drive encryption
- Local administrator accounts
- Listening network ports

## Safety

The script only reads and reports system and security information. It does not change any Windows or security settings.

