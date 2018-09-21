param( 
    [string[]]$Computername
)

foreach ($computer in $Computername) {
    $os = Get-CimInstance -Computername $Computer -ClassName win32_operatingsystem
    $cs = Get-CimInstance -Computername $Computer -ClassName win32_computersystem
    $properties = @{ComputerName = $Computer
                    SPVersion = $os.servicepackmajorversion
                    OSVersion = $os.Version
                    Model = $cs.Model
                    Mfgr = $cs.Manufacturer}
    $obj = New-Object -TypeName PSObject -Property $properties
    Write-Output $obj
}