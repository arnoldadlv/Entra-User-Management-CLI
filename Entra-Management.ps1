<# try {
    Connect-MgGraph -ErrorAction Stop
    
}
catch {
    Write-Error "Unable to connect to Microsoft Graph. Please make sure you are signed in first."
}
    #>

function Show-EnvironmentMenu {
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "|       Select Environment         |" -ForegroundColor Cyan
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "| 1. Commercial (Default)          |"
    Write-Host "| 2. GCC                           |"
    Write-Host "| 3. GCC High                      |"
    Write-Host "| 4. DoD                           |"
    Write-Host "| 5. Exit                          |"
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
}

function Get-EnvironmentChoice {
    Write-Host
    $envChoice = Read-Host "Enter your choice (1-5)"
    return $envChoice
}

function Connect-ToEnvironment {
    $connected = $false
    do {
        Show-EnvironmentMenu
        $envChoice = Get-EnvironmentChoice

        switch ($envChoice) {
            1 {
                Write-Host "Connecting to Commercial Environment..." -ForegroundColor Yellow
                try {
                    Connect-MgGraph -ErrorAction Stop
                    Write-Host "Connected to Commercial Environment." -ForegroundColor Green
                    $connected = $true
                }
                catch {
                    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            2 {
                Write-Host "Connecting to GCC Environment" -ForegroundColor Yellow
                try {
                    Connect-MgGraph -Environment USGov -ErrorAction Stop
                    Write-Host "Connected to GCC Enviornment" -ForegroundColor Green
                    $connected = $true
                }
                catch {
                    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            3 {
                Write-Host "Connecting to GCC High Environment" -ForegroundColor Yellow
                try {
                    Connect-MgGraph -Environment USGov -ErrorAction Stop
                    Write-Host "Connected to GCC High Environment" -ForegroundColor Green
                    $connected = $true
                }
                catch {
                    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            4 {
                Write-Host "Connecting to US DoD Environment" -ForegroundColor Yellow
                try {
                    Connect-MgGraph -Environment USGovDoD -ErrorAction Stop
                    Write-Host "Connected to US DoD Environment" -ForegroundColor Green
                    $connected = $true
                }
                catch {
                    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            5 {
                Write-Host "Exiting..." -ForegroundColor Cyan
                exit
            }
            default {
                Write-Host "Invalid choice. Please select a valid option." -ForegroundColor Red
            }
        }
    } while (-not $connected) {
        
    }
}
Connect-ToEnvironment
function Show-MainMenu {
    # Clear-Host
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "|    User Management Tool Menu     |" -ForegroundColor Cyan
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "| 1. List all users                |"
    Write-Host "| 2. Update a User                 |"
    Write-Host "| 3. Create a New User             |"
    Write-Host "| 4. Create a group                |"
    Write-Host "| 5. Manage User Licenses          |"
    Write-Host "| 6. Exit                          |"
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
}

function Get-MenuChoice {
    Write-Host
    $choice = Read-Host = "Enter your choice (1-6)"
    return $choice
}

function Get-FindaUserMenuChoice {
    Write-Host
    $choice = Read-Host = "Enter your choice (1-5)"
    return $choice
}

#Lists all Users in Entra tenant
function Show-AllUsers {
    Write-Host "Getting all Entra ID Users..."
    $users = Get-MgUser -All
    foreach ($user in $users) {
        Write-Host "DisplayName: $($user.DisplayName), Email: $($user.Mail), ID: $($user.id)" -ForegroundColor Green
    }

}

#Shows "Find User" Menu
function Show-FindaUserMenu {
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "|         Find User Menu           |"
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "| 1. Search by Name                |"
    Write-host "| 2. Search by UPN (Email)         |"
    Write-host "| 3. Search by Department          |"
    Write-host "| 4. Display All Users             |"
    Write-host "| 5. Return to Main Menu           |"
    Write-host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "DEBUG: Entering Find User Menu"


}

function Show-UpdateAUserMenu {
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "|         Update a User            |" -ForegroundColor Green
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "| 1. Update Name                   |"
    Write-host "| 2. Update Email                  |"
    Write-host "| 3. Offboard User                 |"
    Write-host "| 4. Add User to group             |"
    Write-host "| 5. Return to Main Menu           |"
    Write-host "+----------------------------------+" -ForegroundColor Cyan
}

function Invoke-UpdateAUserSubMenu {
    do {
        Show-UpdateAUserMenu
        $submenuChoice = Read-Host "Enter your choice: (1-5)"

        switch ($submenuChoice) {
            1 {
                Write-Host "Option 1: Update Name"
            }
            2 {
                Write-Host "Option 2: Update user's email"
            }
            3 {
                Write-Host "Option 3: Offboard a user"
                Revoke-User
            }
            4 {
                Write-Host "Option 4: Add user to a groupSearch"
                Add-UserTogroup
            }
            5 {
                Write-Host "Return to Main Menu"
            }
            default {
                Write-Host "That is not a valid option. Please try again" -ForegroundColor Red
            }
        }
    } while ($submenuChoice -ne 5)
}


function Update-UsersFirstName {
    $usersPrincipalName = Read-Host "What user do you want to update? Enter their User Principal Name: "
    $desiredFirstName = Read-Host "Enter the name you wish to replace the user with: "
    
    Update-MgUser -UserId $usersPrincipalName -GivenName $desiredFirstName
    Write-Host "Updating user info..."

    Get-MgUser $usersPrincipalName 

}

#Offboard User
function Revoke-User {
    $userSearch = Read-Host "What user do you wish to offboard? Enter a portion of their name or email"
    try {
        $potentialUsers = Get-MgUser -Filter "startswith(displayName, '$userSearch')"
        if (-not $potentialUsers) {
            $potentialUsers = Get-MgUser -Filter "endswith(displayName, '$userSearch')"
        }
        if (-not $potentialUsers) {
            $potentialUsers = Get-MgUser -Filter "startswith(userPrincipalName, '$userSearch')"
        } 
        if (-not $potentialUsers) {
            $potentialUsers = Get-MgUser -Filter "endswith(userPrincipalName, '$userSearch')"
        } 
        if (-not $potentialUsers) {
            Write-Host "No users found matching '$userSearch'. Please try again." -ForegroundColor Red
            Pause
            continue
        }
        #Matching users that were found
        Write-Host "Matching users: " -ForegroundColor Green
        $index = 1
        $users = @($potentialUsers)
        foreach ($user in $users) {
            Write-Host "$index. DisplayName: $($user.DisplayName), Email: $($user.Mail), ID: $($user.id)" -ForegroundColor Green
            $index++
        }

        #Ensures a valid object in the $users array is selected
        $userSelection = -1
        do {
            $userSelection = [int](Read-Host "Enter the number corresponding to the user you wish to offboard" ) - 1
            if ($userSelection -lt 0 -or $userSelection -ge $users.Count) {
                Write-Host "Invalid selection. Try again." -ForegroundColor Red
                $userSelection = -1
            }
        } while ($userSelection -lt 0 -or $userSelection -ge $users.Count) 

        #$userSelection = [int](Read-Host "Enter the number corresponding to the user you wish to offboard" ) - 1
        
        #Confirms if user truly needs to be offboarded
        $confirmation = Read-Host "Are you sure you want to offboard $($users[$userSelection].Id)? (Y/N)"
        if ($confirmation.ToLower() -eq 'y') {
            Write-Host "You are now offboarding $($users[$userSelection].Id)" -ForegroundColor Yellow
            Update-MgUser -UserId $users[$userSelection].Id -AccountEnabled:$false
            Revoke-MgUserSignInSession -UserId $users[$userSelection].Id > $null
        }
        elseif ($confirmation.ToLower() -eq 'n') {
            Write-Host "You are now returning to the menu" -ForegroundColor Yellow
            return
        }
        #Disables user account
        #Write-Host "Offboarding user..." -ForegroundColor Yellow
        #Write-Host "You are offboarding $($users[$userSelection].Id)" -ForegroundColor Cyan
        #Update-MgUser -UserId $users[$userSelection.Id] -ForegroundColor Cyan
    }
    catch {
        Write-Host "Could not find any user..." -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Pause
}

function Add-UserToGroup {
    $userSearch = Read-Host "What user do you wish to add to a group? Enter a portion of their name or email"
    try {
        # Fetch potential users
        $potentialUsers = Get-MgUser -Filter "startswith(displayName, '$userSearch')"
        if (-not $potentialUsers) {
            $potentialUsers = Get-MgUser -Filter "startswith(UserPrincipalName, '$userSearch')"
        }
        if (-not $potentialUsers) {
            Write-Host "No users found matching '$userSearch'. Please try again." -ForegroundColor Red
            return
        }

        # Display matching users
        Write-Host "Matching users: " -ForegroundColor Green
        $users = @($potentialUsers)
        for ($i = 0; $i -lt $users.Count; $i++) {
            Write-Host "$($i + 1). DisplayName: $($users[$i].DisplayName), Email: $($users[$i].Mail), ID: $($users[$i].Id)" -ForegroundColor Green
        }

        # Ensure a valid user selection
        $userSelection = -1
        do {
            $userSelection = [int](Read-Host "Enter the number corresponding to the user you wish to add to a group") - 1
            if ($userSelection -lt 0 -or $userSelection -ge $users.Count) {
                Write-Host "Invalid selection. Try again." -ForegroundColor Red
                $userSelection = -1
            }
        } while ($userSelection -lt 0 -or $userSelection -ge $users.Count)

        $selectedUser = $users[$userSelection]

        # Search for the group
        $groupSearch = Read-Host "What group are you looking for?"
        $potentialGroups = Get-MgGroup -Filter "startswith(displayName, '$groupSearch')"
        if (-not $potentialGroups) {
            Write-Host "No groups found matching '$groupSearch'. Please try again." -ForegroundColor Red
            return
        }

        # Display matching groups
        Write-Host "Matching groups: " -ForegroundColor Green
        $groups = @($potentialGroups)
        for ($i = 0; $i -lt $groups.Count; $i++) {
            Write-Host "$($i + 1). DisplayName: $($groups[$i].DisplayName), ID: $($groups[$i].Id)" -ForegroundColor Green
        }

        # Ensure a valid group selection
        $groupSelection = -1
        do {
            $groupSelection = [int](Read-Host "Enter the number corresponding to the group you wish to select") - 1
            if ($groupSelection -lt 0 -or $groupSelection -ge $groups.Count) {
                Write-Host "Invalid selection. Try again." -ForegroundColor Red
                $groupSelection = -1
            }
        } while ($groupSelection -lt 0 -or $groupSelection -ge $groups.Count)

        $selectedGroup = $groups[$groupSelection]

        # Add user to the group
        Write-Host "Adding $($selectedUser.DisplayName) to $($selectedGroup.DisplayName)..." -ForegroundColor Yellow
        New-MgGroupMember -GroupId $selectedGroup.Id -DirectoryObjectId $selectedUser.Id > $null

        # Display updated group members
        $groupMembers = Get-MgGroupMember -GroupId $selectedGroup.Id
        Write-Host "Here are the updated members in $($selectedGroup.DisplayName):" -ForegroundColor Yellow
        foreach ($member in $groupMembers) {
            $memberDetails = Get-MgUser -UserId $member.Id
            Write-Host $memberDetails.UserPrincipalName -ForegroundColor Cyan
        }
    }
    catch {
        Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    }
}

#Runs the Search by Name option
function Search-UserByName {
    $userSearchTerm = Read-Host "Enter the users first name: "
    $userSearchTerm = "'$userSearchTerm'"
    $user = Get-MgUser -Filter "startswith(displayName, $userSearchTerm)" 
    
    try {
        $user = Get-MgUser -Filter "startswith(displayName, $userSearchTerm)"
        
        if (-not $users ) {
            $users = Get-Mguser -Filter "endswith(displayName, $userSearchTerm)"
        }

        if (-not $users) {
            Write-Host "No users were found" -ForegroundColor Red
        }
    }
    catch {
        <#Do this if a  exception happens#>
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }

    foreach ($user in $users) {
        Write-Host "DisplayName: $($user.DisplayName), Email: $($user.Mail), ID: $($user.id)" -ForegroundColor Green 
    }
    Write-Host "DEBUG: Executing Search-UserByName"

}


#Create a new user
function Invoke-CreateANewUser {
    $userDisplayName = Read-Host "What is the users name? (First and Last Name)"
    $names = $userDisplayName -split ' '
    $firstName = $names[0]
    $lastName = ($names | Select-Object -Skip 1) -join ' '

    # Prompt the user to enter the domain and validate it exists in their tenant
    do {
        $verifiedDomains = (Get-MgDomain).Id
        $orgDomain = Read-Host "What is your organization's domain name? (Available domains: $($verifiedDomains -join ', '))"
        if ($orgDomain -notin $verifiedDomains) {
            Write-Host "The domain '$orgDomain' is not a verified domain in your organization. Please enter a valid domain." -ForegroundColor Red
        }
    } while ($orgDomain -notin $verifiedDomains)


    if (-not $verifiedDomains) {
        Write-Host "This domain isn't apart of your tenant. Exiting..." -ForegroundColor Red
        return
    }


    #Determine naming convention for org
    Write-Host "Select the naming convention for userPrincipalName:"
    Write-Host "1. FirstName.LastName (e.g., john.doe@example.com)"
    Write-Host "2. FirstInitialLastName (e.g., jdoe@example.com)"

    $namingConventinon = Read-Host "Enter your choice (1-2)"

    switch ($namingConventinon) {
        1 {
            #FirstName.LastName
            $userPrincipalName = ("$firstName.$lastName" -replace ' ', '').ToLower() + "@$orgDomain"
            Write-Host "Using naming convention FirstName.LastName" -ForegroundColor Cyan

        }
        2 {
            #First InitialLastName
            $userPrincipalName = ("$($firstName.Substring(0, 1))$lastName" -replace ' ', '').ToLower() + "@$orgDomain"
            Write-Host "Using naming convention FirstInitialLastName" -ForegroundColor Cyan
        }
        default {
            Write-Host "Defaulting to First Initial LastName..." -ForegroundColor Yellow
            $userPrincipalName = ("$($firstName.Substring(0, 1))$lastName" -replace ' ', '').ToLower() + "@$orgDomain"

        }
    }
    Write-Host "Generated UPN of $($userPrincipalName)"
    #Edit this depending on org standards
    $userPrincipalName = ("$($firstName.Substring(0, 1))$lastName" -replace ' ', '').ToLower() + "@$orgDomain"

    $checkExistingUser = Get-MgUser -Filter "userPrincipalName eq '$userPrincipalName'"
    if ($checkExistingUser) {
        Write-Host "A user with the UserPrincipalName $($userPrincipalName) already exists." -ForegroundColor Red
        return
    }
    $email = $userPrincipalName
    $mailNickName = $userPrincipalName.Split('@')[0]
    $newUsersPassword = Read-Host "Enter the new users password"

    $passwordProfile = @{
        Password                      = $newUsersPassword
        ForceChangePasswordNextSignIn = $true
    }

    Write-Host "The users first name is: $($firstName)"
    Write-Host "The users last name is: $($lastName)"
    Write-Host "THe users UserPrinicpalName is: $($userPrincipalName)"
    Write-Host "The users email is: $($email)"
    Write-Host "The users mailnickname is: $($mailNickName)"
    Write-Host "Creating user..." -ForegroundColor Yellow
    try {
        New-MgUser -DisplayName $userDisplayName -GivenName $firstName -Surname $lastName -UserPrincipalName $userPrincipalName -PasswordProfile $passwordProfile -Mail $email -AccountEnabled:$true -MailNickname $mailNickName > $null
        Write-Host "New user has been created..." -ForegroundColor Green
        $users = Get-MgUser -UserId $userPrincipalName
        foreach ($user in $users) {
            Write-Host "DisplayName: $($user.DisplayName), UserId: $($user.Id), Mail: $($user.Mail), UserPrincipalName: $($userPrincipalName)" -ForegroundColor Cyan
        }

    }
    catch {
        Write-Host "An error occured while creating the user: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
}

function New-Group {
    $groupName = Read-Host "What is the name of the group you wish to create? (DisplayName)"
    $displayName = $groupName
    $mailNickName = ($groupName -replace ' ', '').ToLower()

    do {
        $confirmation = Read-Host "You are going to create a security group with DisplayName: '$displayName'. Do you want to continue? (Y/N)"
        if ($confirmation.ToLower() -notin @('y', 'n')) {
            Write-Host "Invalid input. Please enter Y or N." -ForegroundColor Red
        }
    } while ($confirmation.ToLower() -notin @('y', 'n'))

    if ($confirmation.ToLower() -eq 'y') {
        try {
            Write-Host "Creating group..." -ForegroundColor Yellow
            $newGroup = New-MgGroup -DisplayName $displayName -SecurityEnabled -MailEnabled:$false -MailNickname $mailNickName
            $validateGroup = Get-MgGroup -GroupId $newGroup.Id
            Write-Host "You have successfully created the group: $($validateGroup.DisplayName)" -ForegroundColor Green
        }
        catch {
            Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    }
}

#Runs the main menu
do {
    Show-MainMenu
    $mainChoice = Get-MenuChoice

    switch ($mainChoice) {
        1 {
            Write-Host "Option 1: List all Users" -ForegroundColor Yellow
            Show-AllUsers

        }
        2 {
            Write-Host "Option 2: Update a User" -ForegroundColor Yellow
            Invoke-UpdateAUserSubMenu
        }
        3 {
            Write-Host "Option 3: Create a New User" -ForegroundColor Yellow
            Invoke-CreateANewUser
        }
        4 {
            Write-Host "Option 4: Create a Security Group" -ForegroundColor Yellow
            New-Group
        }
        5 {
            Write-Host "Option 5: Manage User Licenses" -ForegroundColor Yellow
        }
        6 {
            Write-Host "Option 6: Exit" -ForegroundColor Yellow
        }
    }
    if ($mainChoice -ne 6) {
        Read-Host "Press any key to continue"
    }
}
while ($mainChoice -ne 6)