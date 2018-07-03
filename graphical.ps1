Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

Clear-Host
$reportdir = "C:\Users\$env:UserName\snipenet\"
$reportfile = "C:\Users\$env:UserName\snipenet\malicious-ip-history.txt"
$todaysreport = "$reportdir$date.txt"
$date = Get-Date -format "yyyyMMdd"

if( -not (Test-Path $reportdir -PathType Container))
{
    New-Item -ItemType "directory" -Path $reportdir
}

if ( -not (Test-Path $reportfile -PathType Leaf))
{
    New-Item -ItemType "file" -Path $reportfile
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '492,280'
$Form.text                       = "SNIPEHUNT v0.4"
$Form.TopMost                    = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "IP Addresses - one per line:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(166,44)
$Label1.Font                     = 'Microsoft Sans Serif,7'

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "   SNIPEHUNT:"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(27,10)
$Label2.Font                     = 'Microsoft Sans Serif,10'

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "a threat-hunting tool."
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(27,27)
$Label3.Font                     = 'Microsoft Sans Serif,8'

$result                          = New-Object system.Windows.Forms.TextBox
$result.multiline                = $true
$result.width                    = 294
$result.height                   = 138
$result.Anchor                   = 'top,right,bottom,left'
$result.location                 = New-Object System.Drawing.Point(166,66)
$result.Font                     = 'Microsoft Sans Serif,10'

$pingButton                      = New-Object system.Windows.Forms.Button
$pingButton.text                 = "Hunt"
$pingButton.width                = 102
$pingButton.height               = 30
$pingButton.location             = New-Object System.Drawing.Point(27,67)
$pingButton.Font                 = 'Microsoft Sans Serif,10'

$closeButton                     = New-Object system.Windows.Forms.Button
$closeButton.text                = "Close"
$closeButton.width               = 102
$closeButton.height              = 30
$closeButton.Anchor              = 'right,bottom'
$closeButton.location            = New-Object System.Drawing.Point(359,228)
$closeButton.Font                = 'Microsoft Sans Serif,10'

$restartButton                   = New-Object system.Windows.Forms.Button
$restartButton.text              = "Lookup"
$restartButton.width             = 102
$restartButton.height            = 30
$restartButton.location          = New-Object System.Drawing.Point(27,114)
$restartButton.Font              = 'Microsoft Sans Serif,10'

$clearButton                   = New-Object system.Windows.Forms.Button
$clearButton.text              = "Clear"
$clearButton.width             = 102
$clearButton.height            = 30
$clearButton.location          = New-Object System.Drawing.Point(27,161)
$clearButton.Font              = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($compnameTxtbox,$Label1,$Label2,$Label3,$result,$pingButton,$closeButton,$restartButton,$clearButton))

$pingButton.Add_Click({ hunter })
$restartButton.Add_Click({ lookup })
$closeButton.Add_Click({ closeForm })
$clearButton.Add_Click({$result.Clear()})

function hunter()
{
    $stringArray = $result.Text.Split("`n") | % {$_.trim()}
    $result.Clear()
    foreach($potentiallydangerousip in $stringArray)
    {
        if(Invoke-WebRequest https://www.abuseipdb.com/check/$potentiallydangerousip | Select-Object -ExpandProperty RawContent | select-string "was found in our database!")
        {
            if(Get-Content $reportfile | Select-String $potentiallydangerousip)
            {
                $reportdate = Get-Content $reportfile | Select-String $potentiallydangerousip | cut -d " " -f 2
                $result.text += "`r`n" + "$potentiallydangerousip was reported on $reportdate"
            }
            else 
            {
                echo "$potentiallydangerousip $date" >> $reportfile
                $result.text += "`r`n" + "$potentiallydangerousip has been reported!"
            }
        }
        else 
        {
            $result.text += "`r`n" + "$potentiallydangerousip is clean."
        }    
    }
    $a = new-object -comobject wscript.shell 
    $intAnswer = $a.popup("Do you want to hunt?",0,"Proceed with hunt?",4) 
    If ($intAnswer -eq 6) 
    { 
        Get-Content $reportfile | grep $date | cut -d " " -f 1 > $todaysreport
        foreach($maliciousip in Get-Content $todaysreport)
        {
            & 'C:\Program Files\Mozilla Firefox\firefox.exe' -new-tab -url https://www.abuseipdb.com/check/$maliciousip
        } 
    } 
    else 
    { 
       Start-sleep(1)
    }
}

function lookup()
{
    $potentiallydangerousip = $compnameTxtbox.text
    $result.text += "`r`n" +"Performing DNS resolution..."
    $result.text += "`r`n" + "_____________"
    $lookupresults = (nslookup $potentiallydangerousip) -join "`n"
    $result.text += "`r`n" + $lookupresults
    $result.text += "`r`n" + "_____________"
}

function closeForm(){$Form.close()}
    
[void]$Form.ShowDialog()
