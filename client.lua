-- door_terminal.lua

local channel = 958  -- must match server
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
rednet.send(0, {
    type = "auth",
    username = username,
    password = password
}, channel)

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
