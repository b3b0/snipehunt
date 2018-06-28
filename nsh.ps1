Clear-Host

"
---------------
    N A N O
  S N I P E
    H U N T
---------------
"

$potentiallydangerousip = Read-Host "IP in question"

if(Invoke-WebRequest https://www.abuseipdb.com/check/$potentiallydangerousip | Select-Object -ExpandProperty RawContent | select-string "was found in our database!")
{
    "DANGER
    -------"
    $answer = Read-Host "Will you launch a hunt?"
    if($answer -eq "y" -or "yes)
    {
        & 'C:\Program Files\Mozilla Firefox\firefox.exe' -new-tab -url https://www.abuseipdb.com/check/$potentiallydangerousip -new-tab -url https://www.threatcrowd.org/ip.php?ip=$potentiallydangerousip -new-tab -url https://www.virustotal.com/#/ip-address/$potentiallydangerousip -new-tab -url https://www.threatminer.org/host.php?q=$potentiallydangerousip
    {
}
else
{
    Write-Host "not danger"
}
