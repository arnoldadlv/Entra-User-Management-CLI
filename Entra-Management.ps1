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
    Write-Host "| 4. Offboard a User               |"
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
    Write-Host "|         Update a User            |"
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "| 1. Update Name                   |"
    Write-host "| 2. Update Email                  |"
    Write-host "| 3.                               |"
    Write-host "| 4.                               |"
    Write-host "| 5. Return to Main Menu           |"
    Write-host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "DEBUG: Entering Update a User Menu"


}

function Update-UsersFirstName {
    $usersPrincipalName = Read-Host "What user do you want to update? Enter their User Principal Name: "
    $desiredFirstName = Read-Host "Enter the name you wish to replace the user with: "
    
    Update-MgUser -UserId $usersPrincipalName -GivenName $desiredFirstName
    Write-Host "Updating user info..."

    Get-MgUser $usersPrincipalName 

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
            Show-UpdateAUserMenu
        }
        3 {
            Write-Host "Option 3: Create a New User" -ForegroundColor Yellow
        }
        4 {
            Write-Host "Option 4: Offboard a User" -ForegroundColor Yellow
        }
        5 {
            Write-Host "Option 5: Manage User Licenses" -ForegroundColor Yellow
        }
        6 {
            Write-Host "Option 6: Exit" -ForegroundColor Yellow
        }
    }
    if ($mainChoice -ne 6) {
        Pause
    }
}
while ($mainChoice -ne 6)