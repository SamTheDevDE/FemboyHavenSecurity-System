local rednet = require("rednet")

local function prompt(msg)
    io.write(msg)
    return io.read()
end

local function connectToServer(serverId)
    rednet.open("left")
    -- Send authentication request
    local username = prompt("Enter username: ")
    local password = prompt("Enter password: ")
    local authRequest = {
        type = "auth",
        username = username,
        password = password
    }
    rednet.send(serverId, textutils.serialize(authRequest))
    local id, response = rednet.receive(5)
    if not response then
        print("No response from server.")
        return
    end
    local data = textutils.unserialize(response)
    if data and data.type == "auth_response" and data.success then
        print("Authenticated! Message: " .. (data.message or ""))
        -- Example: send more info after auth
        local info = prompt("Send info to server: ")
        local infoRequest = {
            type = "info",
            info = info
        }
        rednet.send(serverId, textutils.serialize(infoRequest))
        local _, infoResp = rednet.receive(5)
        if infoResp then
            print("Server replied: " .. infoResp)
        end
    else
        print("Authentication failed: " .. (data and data.message or "Unknown error"))
    end
end

local function main()
    local serverId = tonumber(prompt("Enter server ID: "))
    connectToServer(serverId)
end

main()