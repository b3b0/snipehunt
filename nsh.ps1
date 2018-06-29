Clear-Host

"
._________________________.
|                         |
|--------------|          |
--S-N-I-P-E----|          |
----H-U-N-T----|          |
------v0.1-----|          |
|--------------|          | 
|                         |
|    誰かにさえ             |
|    この悲しみの情熱の自由   |
|    明らかでしょう：          |
|    秋の夕方              |
|    縄跳びが上がる沼地      |
|                         |
|         |---------------|
|         |-R-E-V-E-N-G-E-
|         |-B-E--W-I-T-H--
|         |----Y-O-U------
|         |---------------|
|_________________________|
"

$potentiallydangerousip = Read-Host "IP in question"

if(Invoke-WebRequest https://www.abuseipdb.com/check/$potentiallydangerousip | Select-Object -ExpandProperty RawContent | select-string "was found in our database!")
{
    Clear-Host
    Write-Host "DANGER"
    Write-Host "-------"
    $answer = Read-Host "Will you launch a hunt?"
    if($answer -eq "y")
    {   
        if($IsLinux -eq "True")
        {
            firefox -new-tab -url https://www.abuseipdb.com/check/$potentiallydangerousip -new-tab -url https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip -new-tab -url https://www.virustotal.com/#/ip-address/$potentiallydangerousip -new-tab -url https://www.threatminer.org/host.php?q=$potentiallydangerousip
            whois $potentiallydangerousip
            nslookup $potentiallydangerousip
        }
        else
        {
            & 'C:\Program Files\Mozilla Firefox\firefox.exe' -new-tab -url https://www.abuseipdb.com/check/$potentiallydangerousip -new-tab -url https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip -new-tab -url https://www.virustotal.com/#/ip-address/$potentiallydangerousip -new-tab -url https://www.threatminer.org/host.php?q=$potentiallydangerousip
        }
    }
    else
    {
        Write-Host "not danger"
    }
}
