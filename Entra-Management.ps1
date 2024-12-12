function Show-MainMenu {
    # Clear-Host
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "|    User Management Tool Menu     |" -ForegroundColor Cyan
    Write-Host "+----------------------------------+" -ForegroundColor Cyan
    Write-Host "| 1. Find a User                   |"
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

function Search-UserByName {
    $userFirstName = Read-Host "Enter the users first name: "
    $userFirstName = "'$userFirstName'"
    $results = Get-MgUser -Filter "startswith(displayName, $userFirstName)"
    $results
    Write-Host "DEBUG: Executing Search-UserByName"

}

#Runs the main menu
do {
    Show-MainMenu
    $mainChoice = Get-MenuChoice

    switch ($mainChoice) {
        1 {
            Write-Host "Option 1: Find a User" -ForegroundColor Yellow
            Show-FindaUserMenu
            $subChoice = Get-MenuChoice
            switch ($subChoice) {
                1 {
                    Write-Host "Option 1: Search by Name" -ForegroundColor Yellow
                    Search-UserByName
                    break
                }
            }
            break

        }
        2 {
            Write-Host "Option 2: Update a User" -ForegroundColor Yellow
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