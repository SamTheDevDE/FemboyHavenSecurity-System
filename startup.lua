-- Haven-Security Client

if term and term.clear and term.setCursorPos then
    term.clear()
    term.setCursorPos(1, 1)
else
    shell.run("clear")
end

os.pullEvent = os.pullEventRaw

local password = "CHANGEME"
local attempts = 3

local function printHeader()
    print("=======================================")
    print("           Haven-Security              ")
    print("=======================================")
end

while attempts > 0 do
    printHeader()
    print("")
    print("Please enter the password to continue.")
    print("Attempts left: " .. attempts)
    write("[Haven] Password: ")
    local pass = read("*")
    if pass == password then
        print("\nAccess granted! Unlocking cabinet...")
        redstone.setOutput("right", true)
        sleep(2)
        redstone.setOutput("right", false)
        print("Cabinet locked. System rebooting...")
        sleep(1)
        os.reboot()
        break
    else
        attempts = attempts - 1
        print("\nIncorrect password!")
        if attempts > 0 then
            print("Please try again.\n")
            sleep(1)
            if term and term.clear and term.setCursorPos then
                term.clear()
                term.setCursorPos(1, 1)
            end
        else
            print("Access blocked! No attempts left.")
            sleep(2)
            os.reboot()
        end
    end
end