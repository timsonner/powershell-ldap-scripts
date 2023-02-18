param([String]$username, [String]$password)

# Get all the users in current domain
$searchBase = [ADSI]"LDAP://"
$searcher = new-object System.DirectoryServices.DirectorySearcher($searchBase) 
$searcher.filter = "(&(ObjectClass=user)(samaccountname=$username))" 
$users = $searcher.FindAll()

if($users.Count -gt 0)
{
    # Try the given password for all users
    foreach($user in $users)
    {
        # Specify the security context in the directoryentry
        $directoryEntry = new-object System.DirectoryServices.DirectoryEntry($user.path, $username, $password)
        try
        {
            # Try to login with given password
            $directoryEntry.Username
            Write-Host "Login succeeded"
            break
        }
        catch
        {
            Write-Host "Login failed"
        }
    }
}
else
{
    Write-Host "The user is not present in the current domain!"
}
