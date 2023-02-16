# Get the current domain name
$domain = $env:USERDNSDOMAIN

# Query DNS for LDAP SRV record
$dnsQuery = "_ldap._tcp.$domain"
$dnsResult = Resolve-DnsName -Type SRV $dnsQuery | Sort-Object -Property Priority

if ($dnsResult.Count -eq 0) {
    Write-Output "Failed to find LDAP server for domain"
} else {
    # Extract LDAP server name and port from DNS query result
    $ldapServer = $dnsResult[0].NameTarget
    $ldapPort = $dnsResult[0].Port

    Write-Output "LDAP server for domain ${domain}: ${ldapServer}:${ldapPort}"
}
