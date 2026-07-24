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

# Collect Windows Firewall logging settings.
$firewallLogging = Get-NetFirewallProfile -PolicyStore ActiveStore |
    Select-Object Name, LogAllowed, LogBlocked, LogFileName, LogMaxSizeKilobytes

# Collect the active network connection profiles.
$networkProfiles = Get-NetConnectionProfile |
    Select-Object Name, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity

# Collect members of the local Administrators group.
$localAdminMembers = Get-LocalGroupMember -Name "Administrators" |
    Select-Object Name, ObjectClass, PrincipalSource, SID

# Collect listening TCP ports.
$listeningPorts = Get-NetTCPConnection -State Listen |
    Select-Object LocalAddress, LocalPort, State, OwningProcess |
    Sort-Object -Property LocalPort

# Collect Microsoft Defender protection status.
$defenderStatus = Get-MpComputerStatus |
    Select-Object AMRunningMode, AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, IsTamperProtected, AntivirusSignatureAge, AntivirusSignatureLastUpdated

# Collect Controlled Folder Access status.
$controlledFolderAccessValue = (
    Get-MpPreference
).EnableControlledFolderAccess

$controlledFolderAccessStatus = switch ($controlledFolderAccessValue) {
    0 { "Disabled" }
    1 { "Enabled" }
    2 { "Audit Mode" }
    3 { "Block Disk Modification Only" }
    4 { "Audit Disk Modification Only" }
    default { "Unknown" }
}

# Collect the five most recently installed Windows updates.
$recentWindowsUpdates = Get-HotFix |
    Sort-Object InstalledOn -Descending |
    Select-Object -First 5 HotFixID, Description, InstalledOn

# Check whether Secure Boot is enabled.
try {
    $secureBootStatus = Confirm-SecureBootUEFI -ErrorAction Stop
}
catch {
    $secureBootStatus = "Unknown - administrator access or UEFI support required"
}

# Collect TPM security processor status.
try {
    $tpmStatus = Get-Tpm -ErrorAction Stop |
        Select-Object TpmPresent, TpmReady, TpmEnabled, TpmActivated, TpmOwned, ManufacturerIdTxt, ManufacturerVersion, AutoProvisioning, LockedOut, RestartPending
}
catch {
    $tpmStatus = [PSCustomObject]@{
        TpmPresent         = "Unknown"
        TpmReady           = "Unknown"
        TpmEnabled         = "Unknown"
        TpmActivated       = "Unknown"
        TpmOwned           = "Unknown"
        ManufacturerIdTxt  = "Unknown"
        ManufacturerVersion = "Unknown"
        AutoProvisioning   = "Unknown"
        LockedOut          = "Unknown"
        RestartPending     = "Unknown"
        Note               = "Administrator access may be required"
    }
}

# Collect drive encryption status.
try {
    $driveEncryptionStatus = Get-BitLockerVolume -MountPoint C: -ErrorAction Stop |
        Select-Object MountPoint, VolumeType, VolumeStatus, EncryptionPercentage, ProtectionStatus, EncryptionMethod
}
catch {
    $driveEncryptionStatus = [PSCustomObject]@{
        MountPoint           = "C:"
        VolumeType           = "Unknown"
        VolumeStatus         = "Unknown"
        EncryptionPercentage = "Unknown"
        ProtectionStatus     = "Unknown"
        EncryptionMethod     = "Unknown"
        Note                 = "Administrator access may be required"
    }
}

# Check whether Remote Desktop is enabled.
$remoteDesktopEnabled = (
    Get-ItemProperty `
        -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" `
        -Name "fDenyTSConnections"
).fDenyTSConnections -eq 0

# Check whether the built-in Guest account is enabled.
$guestAccountEnabled = (Get-LocalUser -Name "Guest").Enabled

# Check whether SMBv1 is enabled.
try {
    $smb1Enabled = (
        Get-WindowsOptionalFeature `
            -Online `
            -FeatureName SMB1Protocol `
            -ErrorAction Stop
    ).State -eq "Enabled"
}
catch {
    $smb1Enabled = "Unknown - administrator access required"
}

# Check whether User Account Control is enabled.
$uacEnabled = (
    Get-ItemProperty `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
        -Name "EnableLUA"
).EnableLUA -eq 1

Write-Host "`nSystem Information" -ForegroundColor Cyan
$systemSummary | Format-Table -AutoSize

Write-Host "`nActive Network Profiles" -ForegroundColor Cyan
$networkProfiles | Format-Table -AutoSize

Write-Host "`nWindows Firewall Profiles" -ForegroundColor Cyan
$firewallProfiles | Format-Table -AutoSize

Write-Host "`nWindows Firewall Logging" -ForegroundColor Cyan
$firewallLogging | Format-Table -AutoSize

Write-Host "`nMicrosoft Defender Status" -ForegroundColor Cyan
$defenderStatus | Format-List

Write-Host "`nControlled Folder Access Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Mode = $controlledFolderAccessStatus
} | Format-List

Write-Host "`nRecent Windows Updates" -ForegroundColor Cyan
$recentWindowsUpdates | Format-Table -AutoSize

Write-Host "`nSecure Boot Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Enabled = $secureBootStatus
} | Format-List

Write-Host "`nTPM Status" -ForegroundColor Cyan
$tpmStatus | Format-List

Write-Host "`nDrive Encryption Status" -ForegroundColor Cyan
$driveEncryptionStatus | Format-List

Write-Host "`nRemote Desktop Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Enabled = $remoteDesktopEnabled
} | Format-List

Write-Host "`nGuest Account Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Enabled = $guestAccountEnabled
} | Format-List

Write-Host "`nLocal Administrator Accounts" -ForegroundColor Cyan
$localAdminMembers | Format-Table -AutoSize

Write-Host "`nUser Account Control Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Enabled = $uacEnabled
} | Format-List

Write-Host "`nSMBv1 Status" -ForegroundColor Cyan
[PSCustomObject]@{
    Enabled = $smb1Enabled
} | Format-List

Write-Host "`nListening TCP Ports" -ForegroundColor Cyan
$listeningPorts | Format-Table -AutoSize

