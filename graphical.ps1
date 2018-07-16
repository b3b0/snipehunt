Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration
[System.Windows.Forms.Application]::EnableVisualStyles()

Clear-Host
$reportdir = "C:\Users\$env:UserName\snipenet"
$reportfile = "C:\Users\$env:UserName\snipenet\malicious-ip-history.txt"
$todaysreport = "$reportdir\$date.txt"
$date = Get-Date -format "yyyyMMdd"
$iconloc = "C:\Users\$env:UserName\AppData\Local\snipehunt\snipe.ico"
$iconfold = "C:\Users\$env:UserName\AppData\Local\snipehunt"

if( -not (Test-Path $iconfold -PathType Container))
{
    New-Item -ItemType "directory" -Path $iconfold
    Invoke-WebRequest http://www.iconj.com/ico/b/7/b7st9a26ow.ico -OutFile $iconloc
}

if( -not (Test-Path $reportdir -PathType Container))
{
    New-Item -ItemType "directory" -Path $reportdir
}

if ( -not (Test-Path $reportfile -PathType Leaf))
{
    New-Item -ItemType "file" -Path $reportfile
}

# LIBRARY WINDOW
$Form1                            = New-Object system.Windows.Forms.Form
$Form1.ClientSize                 = '300,700'
$Form1.text                       = "Library"
$Form1.TopMost                    = $false
$Form1.Icon = $iconloc

$result1                          = New-Object system.Windows.Forms.TextBox
$result1.multiline                = $true
$result1.width                    = 295
$result1.height                   = 695
$result1.Anchor                   = 'top,right,bottom,left'
$result1.location                 = New-Object System.Drawing.Point(0,0)
$result1.Font                     = 'Microsoft Sans Serif,10'

# MAIN WINDOW
$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '492,280'
$Form.text                       = "SNIPEHUNT"
$Form.TopMost                    = $false
$Form.Icon = $iconloc

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
$Label3.text                     = "a small threat-hunting tool."
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
$restartButton.text              = "Library"
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
$restartButton.Add_Click({ library })
$closeButton.Add_Click({ closeForm })
$clearButton.Add_Click({$result.Clear()})

function hunter()
{
    $stringArray = $result.Text.Split("`n") | ForEach-Object{$_.trim()}
    $result.Clear()
    foreach($potentiallydangerousip in $stringArray)
    {
        if(Invoke-WebRequest https://www.abuseipdb.com/check/$potentiallydangerousip | Select-Object -ExpandProperty RawContent | select-string "was found in our database!")
        {
            if(Get-Content $reportfile | Select-String $potentiallydangerousip)
            {
                $reportdate = Get-Content $reportfile | Select-String $potentiallydangerousip | Out-String | ForEach-Object{$_.split(' ')[1]}
                $result.text += "`r`n" + "$potentiallydangerousip was reported on $reportdate"
            }
            if( -not (Get-Content $reportfile | Select-String $potentiallydangerousip))
            {
                Write-Output "$potentiallydangerousip $date" >> $reportfile
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
        Remove-Item -Path "$reportdir\temp.txt"
        Get-Content $reportfile | select-string $date | Out-String | ForEach-Object{$_.split(' ')} >> "$reportdir\temp.txt"
        Get-Content "$reportdir\temp.txt" | select-string $date -NotMatch | Out-String | ForEach-Object{$_.trim()} > $todaysreport

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

function library()
{
    $Form1.controls.AddRange(@($result1))
    $result1.Clear()
    foreach($entry in Get-Content $reportfile)
    {
        $result1.text += "`r`n" + $entry
    }
    [void]$Form1.ShowDialog()
}

function closeForm(){$Form.close()}

[void]$Form.ShowDialog()
