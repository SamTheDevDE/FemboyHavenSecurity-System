-- security_server.lua

local users = {
    samthedev = "masterKey"
}

local channel = 958  -- you can change this, just match on client

rednet.open("back")  -- change "back" to the modem side

print("Security Server is online.")

while true do
    local senderID, message = rednet.receive(channel)
    
    if type(message) == "table" and message.type == "auth" then
        local username = message.username
        local password = message.password

        if users[username] and users[username] == password then
            rednet.send(senderID, {type="response", granted=true}, channel)
            print("Granted access to " .. username)
        else
            rednet.send(senderID, {type="response", granted=false}, channel)
            print("Denied access to " .. (username or "unknown"))
        end
    end
end
