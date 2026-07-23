# WindowsSecurityCheck.ps1
# A read-only Windows security auditing tool.

$computerInfo = Get-ComputerInfo

$systemSummary = [PSCustomObject]@{
    ComputerName    = $computerInfo.CsName
    OperatingSystem = $computerInfo.OsName
    OSVersion       = $computerInfo.OsVersion
    BuildNumber     = $computerInfo.OsBuildNumber
}

$systemSummary

