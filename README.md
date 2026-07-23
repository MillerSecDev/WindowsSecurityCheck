# WindowsSecurityCheck

A read-only PowerShell tool I'm building to learn how Windows security settings can be checked and reported automatically.

## Current Features

- Displays the computer name
- Displays the Windows edition, version, and build number
- Returns the results as a structured PowerShell object
- Reports the status of the Domain, Private, and Public firewall profiles
- Displays the default inbound and outbound firewall actions

## Planned Checks

- Microsoft Defender
- Secure Boot
- Drive encryption
- Local administrator accounts
- Listening network ports

## Safety

The script currently reads system information only. It does not change any Windows or security settings.

