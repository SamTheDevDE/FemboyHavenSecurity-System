local rednet = require("rednet")

-- Example user database
local users = {
    sam = "example"
}

-- Track authenticated clients
local authenticated = {}

local function handleAuth(senderId, data)
    if users[data.username] and users[data.username] == data.password then
        authenticated[senderId] = true
        return {
            type = "auth_response",
            success = true,
            message = "Welcome, " .. data.username .. "!"
        }
    else
        return {
            type = "auth_response",
            success = false,
            message = "Invalid credentials."
        }
    end
end

local function handleInfo(senderId, data)
    if not authenticated[senderId] then
        return "Not authenticated."
    end
    print("Info from " .. senderId .. ": " .. (data.info or ""))
    return "Info received: " .. (data.info or "")
end

local function startServer()
    rednet.open("left")
    print("Server is listening for messages...")

    while true do
        local senderId, message = rednet.receive()
        local data = textutils.unserialize(message)
        local response

        if type(data) == "table" and data.type == "auth" then
            response = handleAuth(senderId, data)
            rednet.send(senderId, textutils.serialize(response))
        elseif type(data) == "table" and data.type == "info" then
            response = handleInfo(senderId, data)
            rednet.send(senderId, response)
        else
            rednet.send(senderId, "Unknown or unauthorized request.")
        end
    end
end

startServer()