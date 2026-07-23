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

Write-Host "`nSystem Information" -ForegroundColor Cyan
$systemSummary | Format-Table -AutoSize

Write-Host "`nWindows Firewall Profiles" -ForegroundColor Cyan
$firewallProfiles | Format-Table -AutoSize

