# b3b0
# https://github.com/b3b0

Clear-Host
Write-Host "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
Write-Host "SNIPEHUNT-CLI 2.0.1 - https://github.com/b3b0/snipehunt"
Write-Host "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
$potentiallydangerousip = Read-Host "IP in question"
if(Invoke-WebRequest https://www.abuseipdb.com/check/$potentiallydangerousip -UseBasicParsing | Select-Object -ExpandProperty RawContent | select-string "was found in our database!")
{
    Clear-Host
    Write-Host "-------"
    Write-Host "DANGER" -ForegroundColor Red
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
            & 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'  --new-tab https://www.abuseipdb.com/check/$potentiallydangerousip --new-tab https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip --new-tab https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip --new-tab "https://www.virustotal.com/#/ip-address/$potentiallydangerousip" --new-tab https://www.threatminer.org/host.php?q=$potentiallydangerousip
           #& 'C:\Program Files\Mozilla Firefox\firefox.exe' -new-tab -url https://www.abuseipdb.com/check/$potentiallydangerousip -new-tab -url https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip -new-tab -url https://www.virustotal.com/#/ip-address/$potentiallydangerousip -new-tab -url https://www.threatminer.org/host.php?q=$potentiallydangerousip
        }
    }
    else
    {
        Write-Host "-------"
        Write-Host "SAFE" -ForegroundColor Green
        Write-Host "-------"
    }
}
