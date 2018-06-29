Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '492,280'
$Form.text                       = "snipehunt"
$Form.TopMost                    = $false

$compnameTxtbox                  = New-Object system.Windows.Forms.TextBox
$compnameTxtbox.multiline        = $false
$compnameTxtbox.width            = 298
$compnameTxtbox.height           = 20
$compnameTxtbox.Anchor           = 'top,right,left'
$compnameTxtbox.location         = New-Object System.Drawing.Point(163,29)
$compnameTxtbox.Font             = 'Microsoft Sans Serif,10'

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Malicious IP / FQDN :"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(29,29)
$Label1.Font                     = 'Microsoft Sans Serif,10'

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
$restartButton.location          = New-Object System.Drawing.Point(29,114)
$restartButton.Font              = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($compnameTxtbox,$Label1,$result,$pingButton,$closeButton,$restartButton))

$pingButton.Add_Click({ hunter })
$restartButton.Add_Click({ lookup })
$closeButton.Add_Click({ closeForm })

function hunter()
{   $potentiallydangerousip = $compnameTxtbox.text
    $result.text += "`r`n" + "Starting the hunt..."
    $result.text += "`r`n" + "Pulling from https://www.abuseipdb.com/check/$potentiallydangerousip ...."
    $result.text += "`r`n" + "_____________"
    if(Invoke-WebRequest https://www.abuseipdb.com/check/$potentiallydangerousip | Select-Object -ExpandProperty RawContent | select-string "was found in our database!")
    {
        $result.text += "`r`n" + "!!!!! DANGEROUS HOST DETECTED !!!!!"
        $result.text += "`r`n" + "_____________"
        & 'C:\Program Files\Mozilla Firefox\firefox.exe' -new-tab -url https://www.abuseipdb.com/check/$potentiallydangerousip -new-tab -url https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip -new-tab -url https://www.virustotal.com/#/ip-address/$potentiallydangerousip -new-tab -url https://www.threatminer.org/host.php?q=$potentiallydangerousip
    }
    else
    {
        $result.text += "`r`n" + "You're safe for now."
        $result.text += "`r`n" + "_____________"
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
