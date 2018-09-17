param( 
    [string[]]$Computername
)

foreach ($computer in $Computername) {
    $os = Get=CimInstance -Computername $Computer -ClassName win32_operatingsystem
    $cs = Get-CimInstance -Computername $Computer -ClassName win32_computersystem
    $properties = @{ClassName = $Computer
                    SPVersion = $os.servicepackmajorversion
                    OSVersion = $os.Version
                    Model = $cs,Model
                    Mfgr = $cs.Manufacturer}
    New-Object -TypeName PSObject -Property $properties
}