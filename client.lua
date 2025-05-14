-- door_terminal.lua

local protocol = "security"
local hostname = "main_server"
local serverID = rednet.lookup(protocol, hostname)
local side = "back"  -- side with the modem
local doorSide = "left"  -- side where redstone controls the door

rednet.open(side)

term.clear()
term.setCursorPos(1,1)

write("Username: ")
local username = read()
write("Password: ")
local password = read("*")  -- hides password input

-- Send auth request
if not serverID then
    print("Failed to find security server.")
    return
end

-- Send auth request with correct protocol
rednet.send(serverID, {
    type = "auth",
    username = username,
    password = password
}, protocol)


-- Wait for response
local senderID, response = rednet.receive(channel, 5)

if response and response.type == "response" and response.granted then
    print("Access Granted.")
    redstone.setOutput(doorSide, true)
    sleep(3)
    redstone.setOutput(doorSide, false)
else
    print("Access Denied.")
end
