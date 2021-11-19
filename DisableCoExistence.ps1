# Disable MDM coexistence and restore SCCM functionality
# Warning: Airwatch stops sending certain telemetry while registry key is disabled
# Backup key is saved to %PUBLIC% folder as "MDMbackup.reg"

# James A. Chambers - https://jamesachambers.com

$Enrollments = $null
$AirwatchEnrollment = $null

$Enrollments = Get-ChildItem -Path HKLM:\Software\Microsoft\Enrollments
$AirwatchEnrollment = $Enrollments | Where-Object { $_.GetValue("ProviderID") -eq "AirWatchMDM" }

if ($null -ne $AirwatchEnrollment) {
    $AirwatchRegPath = $AirwatchEnrollment.Name

    $AirwatchRegPath
    $AirwatchEnrollment
FOREACH ($AirwatchRegPath in $AirwatchEnrollment) {
    reg export $AirwatchRegPath C:\Users\Public\MDMbackup.reg
    reg delete $AirwatchRegPath /f
}
    Restart-Service -Name CcmExec -Force
}

exit 0
