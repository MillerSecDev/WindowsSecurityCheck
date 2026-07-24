# WindowsSecurityCheck.ps1
# A read-only Windows security auditing tool.

$computerInfo = Get-ComputerInfo

$systemSummary = [PSCustomObject]@{
    ComputerName    = $computerInfo.CsName
    OperatingSystem = $computerInfo.OsName
    OSVersion       = $computerInfo.OsVersion
    BuildNumber     = $computerInfo.OsBuildNumber
}

# Collect the active Windows Firewall settings.
$firewallProfiles = Get-NetFirewallProfile -PolicyStore ActiveStore |
    Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

# Collect the active network connection profiles.
$networkProfiles = Get-NetConnectionProfile |
    Select-Object Name, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity

# Collect Microsoft Defender protection status.
$defenderStatus = Get-MpComputerStatus |
    Select-Object AMRunningMode, AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, IsTamperProtected, AntivirusSignatureAge, AntivirusSignatureLastUpdated

# Check whether Secure Boot is enabled.
try {
    $secureBootStatus = Confirm-SecureBootUEFI -ErrorAction Stop
}
catch {
    $secureBootStatus = "Unknown - administrator access or UEFI support required"
}

Write-Host "`nSystem Information" -ForegroundColor Cyan
$systemSummary | Format-Table -AutoSize

Write-Host "`nActive Network Profiles" -ForegroundColor Cyan
$networkProfiles | Format-Table -AutoSize

Write-Host "`nWindows Firewall Profiles" -ForegroundColor Cyan
$firewallProfiles | Format-Table -AutoSize

Write-Host "`nMicrosoft Defender Status" -ForegroundColor Cyan
$defenderStatus | Format-List

Write-Host "`nSecure Boot Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Enabled = $secureBootStatus
} | Format-List

