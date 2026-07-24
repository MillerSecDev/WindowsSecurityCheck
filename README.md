# WindowsSecurityCheck

A read-only PowerShell tool I'm building to learn how Windows security settings can be checked and reported automatically.

## Current Features

- Displays the computer name
- Displays the Windows edition, version, and build number
- Displays a structured system information summary
- Displays the active network name, adapter, category, and IP connectivity
- Reports the status of the Domain, Private, and Public firewall profiles
- Displays the default inbound and outbound firewall actions
- Reports Microsoft Defender protection status and signature freshness
- Reports whether Secure Boot is enabled
- Reports system drive encryption and BitLocker protection status
- Reports whether Remote Desktop is enabled
- Reports whether the built-in Guest account is enabled
- Lists members of the local Administrators group and their account sources
- Reports whether SMBv1 is enabled
- Lists listening TCP ports, local addresses, and owning process IDs

## Requirements

- Designed for Windows 10 and Windows 11
- Tested with Windows PowerShell 5.1 on Windows 11
- Administrator access for complete Secure Boot and drive encryption results

## Usage

1. Clone or download this repository.
2. Open PowerShell in the project folder.
3. Allow scripts for the current PowerShell session:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
   ```

4. Run the security check:

   ```powershell
   .\WindowsSecurityCheck.ps1
   ```

For complete Secure Boot and drive encryption results, run PowerShell as Administrator.

## Safety

The script only reads and reports system and security information. It does not change any Windows or security settings.

The Secure Boot and drive encryption checks require administrator access. Without it, the script reports those statuses as unknown and continues running.

