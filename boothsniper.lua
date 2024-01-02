repeat task.wait() until game:IsLoaded()
task.wait(10)

game:GetService("RunService"):Set3dRenderingEnabled(false)
local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local Players = game:GetService('Players')
local getPlayers = Players:GetPlayers()
local PlayerInServer = #getPlayers
local http = game:GetService("HttpService")
local ts = game:GetService("TeleportService")
local rs = game:GetService("ReplicatedStorage")
local playerID, snipeNormal

if not snipeNormalPets then
    snipeNormalPets = false
end

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

for i = 1, PlayerInServer do
   for ii = 1,#alts do
        if getPlayers[i].Name == alts[ii] and alts[ii] ~= Players.LocalPlayer.Name then
            jumpToServer()
        end
    end
end

local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom, boughtStatus, mention)
    local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage ="||".. Players.LocalPlayer.Name .. "||"
    local weburl, webContent, webcolor
    if version then
        if version == 2 then
            version = "Rainbow "
        elseif version == 1 then
            version = "Golden "
        end
    else
       version = ""
    end

    if boughtStatus then
	webcolor = tonumber(0x00ff00)
	weburl = webhook
        snipeMessage = snipeMessage .. " just sniped a "
	if mention then 
            webContent = "<@".. userid ..">"
        else
	    webContent = ""
	end
	if snipeNormal == true then
	    weburl = normalwebhook
	end
    else
	webcolor = tonumber(0xff0000)
	weburl = webhookFail
	snipeMessage = snipeMessage .. " failed to snipe a "
    end
    
    snipeMessage = snipeMessage .. "**" .. version
    
    if shiny then
        snipeMessage = snipeMessage .. " Shiny "
    end

    snipeMessage = snipeMessage .. item .. "**"
    
    local message1 = {
        ['content'] = webContent,
        ['embeds'] = {
            {
		["author"] = {
			["name"] = "Free Money",,
		},
                ['title'] = snipeMessage,
                ["color"] = webcolor,,
                ['fields'] = {
                    {
                        ['name'] = "__Price:__",
                        ['value'] = tostring(gems) .. " 💎",
                    },
                    {
                        ['name'] = "__Bought from:__",
                        ['value'] = tostring(boughtFrom)",
                    },
                    {
                        ['name'] = "__Amount:__",
                        ['value'] = tostring(amount),
                    },
                    {
                        ['name'] = "__Gems Left:__",
                        ['value'] = tostring(gemamount) .. " 💎",
                    },      
                    {
                        ['name'] = "__PetID:__",
                        ['value'] = tostring(uid),
                    },
                },
		["footer"] = {
                        ["icon_url"] = "https://cdn.discordapp.com/attachments/1149218291957637132/1190527382583525416/new-moon-face_1f31a.png?ex=65a22006&is=658fab06&hm=55f8900eef039709c8e57c96702f8fb7df520333ec6510a81c31fc746193fbf2&", -- optional
                        ["text"] = "Heavily Modified by Root, Cool Sniper"
		}
            },
        }
    }

    local jsonMessage = http:JSONEncode(message1)
    local success, webMessage = pcall(function()
	http:PostAsync(weburl, jsonMessage)
    end)
    if success == false then
        local response = request({
            Url = weburl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonMessage
        })
    end
end

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    local Library = require(rs:WaitForChild('Library'))
    local purchase = rs.Network.Booths_RequestPurchase
    gems = tonumber(gems)
    local ping = false
    snipeNormal = false
    local type = {}
    pcall(function()
        type = Library.Directory.Pets[item]
    end)

    if amount == nil then
        amount = 1
    end

    local price = gems / amount

    if type.exclusiveLevel and price <= 10000 and item ~= "Banana" and item ~= "Coin" then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Titanic Christmas Present" and price <= 25000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
	processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "Exclusive") and price <= 25000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
	processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif type.huge and price <= 1000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            ping = true
	end
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)  
    elseif type.titanic and price <= 10000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        if boughtPet == true then
	    ping = true
	end
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif gems == 1 and snipeNormalPets == true then
	snipeNormal = true
	local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)  
    end
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
    local playerIDSuccess, playerError = pcall(function()
	playerID = message['PlayerID']
    end)
    if playerIDSuccess then
        if type(message) == "table" then
            local listing = message["Listings"]
            for key, value in pairs(listing) do
                if type(value) == "table" then
                    local uid = key
                    local gems = value["DiamondCost"]
                    local itemdata = value["ItemData"]

                    if itemdata then
                        local data = itemdata["data"]

                        if data then
                            local item = data["id"]
                            local version = data["pt"]
                            local shiny = data["sh"]
                            local amount = data["_am"]
                            checklisting(uid, gems, item, version, shiny, amount, username, playerID)
                        end
                    end
                end
            end
	    end
    end
end)

--// SETTINGS!!
local MINIMUM_PLAYERS = 1

--// Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

--// Variables
local PlaceId = game.PlaceId
local fileName = string.format("%s_servers.json", tostring(PlaceId))
local ServerHopData = { 
    CheckedServers = {},
    LastTimeHop = nil,
    CreatedAt = os.time() -- We can use it later to clear the checked servers
    -- TODO: Save the cursor? Prob this can help on fast-hops
}

-- Load data from disk/workspace
if isfile(fileName) then
    local fileContent = readfile(fileName)
    ServerHopData = HttpService:JSONDecode(fileContent)
end

-- Optional log feature
if ServerHopData.LastTimeHop then
    print("Took", os.time() - ServerHopData.LastTimeHop, "seconds to server hop")
end

local ServerTypes = { ["Normal"] = "desc", ["Low"] = "asc" }

function Jump(serverType)
    serverType = serverType or "Normal" -- Default parameter
    if not ServerTypes[serverType] then serverType = "Normal" end
    
    local function GetServerList(cursor)
        cursor = cursor and "&cursor=" .. cursor or ""
        local API_URL = string.format('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=100', tostring(PlaceId), ServerTypes[serverType])
        return HttpService:JSONDecode(game:HttpGet(API_URL .. cursor))
    end

    local currentPageCursor = nil
    while true do 
        local serverList = GetServerList(currentPageCursor)
        currentPageCursor = serverList.nextPageCursor
           
        for _, server in ipairs(serverList.data) do
            if server.playing and tonumber(server.playing) >= MINIMUM_PLAYERS and tonumber(server.playing) < Players.MaxPlayers and not table.find(ServerHopData.CheckedServers, tostring(server.id)) then     
                -- Save current data to disk/workspace
                ServerHopData.LastTimeHop = os.time() -- Last time that tried to hop
                table.insert(ServerHopData.CheckedServers, server.id) -- Insert on our list
                writefile(fileName, HttpService:JSONEncode(ServerHopData)) -- Save our data
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer) -- Actually teleport the player
                -- Change the wait time if you take long times to hop (or it will add more than 1 server in the file)
                wait(0.25)
            end
        end
        
        if not currentPageCursor then break else wait(0.25) end
    end  
end

-- check current server ping
function CheckPingStat()
    if pingValue >= pingThreshold then
        print("Ping Is Higher Than 310, Sevrer Hopping...")
        SendInfo1()
        task.wait(1)
        Jump("Normal")
    else
        print("Ping is sufficent. No Server Hop Needed")
    end
end

-- check current server player count
local function CheckPlayerCount()
    if playerCount < 25 then
        print("Server Hopping.")
        SendInfo2()
        task.wait(1)
        Jump("Normal")
    else
        print("Player Count Is Sufficent. No Server Hop Needed.")
    end
end

-- Check PingStat And PlayerCoutnt Every A Minute
task.spawn(function()
    while task.wait(60) do
        CheckPingStat()
        CheckPlayerCout()
    end
end)

-- Server Hop After A Hour
task.spawn(function()
    while task.wait(3600) do
        Jump("Normal")
    end
end)

print("Executed Scripts")
