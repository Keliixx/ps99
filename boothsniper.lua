local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local message1 = {}
local Players = game:GetService('Players')
local PlayerInServer = #Players:GetPlayers()
local ostime = os.time()
local platform = nil
local teleportingEnabled = true

-- Low-CPU
game:GetService("RunService"):Set3dRenderingEnabled(false)
local RunService = game:GetService("RunService")
UserSettings():GetService("UserGameSettings").MasterVolume = 0
local decalsyeeted = true
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
sethiddenproperty(l,"Technology",2)
sethiddenproperty(t,"Decoration",false)
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat,false)
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = 0
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "1"
if not workspace:FindFirstChild("Platform") then
    platform = Instance.new("Part")
    platform.Name = "Platform"
    platform.Parent = workspace
    platform.Anchored = true
    platform.Position = Vector3.new(9021, -28, 2510)
    platform.Size = Vector3.new(10, 1, 10)
    platform.BrickColor = BrickColor.new("Baby blue")
    platform.Transparency = 0.3
else
    platform = workspace.Platform
end

game:GetService("RunService").Heartbeat:Connect(function()
    local character = game:GetService("Players").LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        local distanceToPlatform = (rootPart.Position - platform.Position).Magnitude
        if distanceToPlatform > 5 then
            rootPart.CFrame = CFrame.new(platform.Position + Vector3.new(0, 2, 0))
        end
    end
end)

for i, v in pairs(w:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") and decalsyeeted then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    elseif v:IsA("SpecialMesh") and decalsyeeted  then
        v.TextureId=0
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.Graphic=1
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"]=1
    end
end
for i = 1,#l:GetChildren() do
    e=l:GetChildren()[i]
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end
w.DescendantAdded:Connect(function(v)
   if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") and decalsyeeted then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    elseif v:IsA("SpecialMesh") and decalsyeeted then
        v.TextureId=0
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.ShirtGraphic=1
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"]=1
            end
        end)
print("Executed LowCPU")

-- Auto Reconnect
task.spawn(function()    
    game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        print("Found An Error, Reonnecting...")
        wait (0.1) game:GetService("TeleportService"):Teleport(game.PlaceId)
            end);
        end)
print("Executed Auto-Reconnect")

local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom)
    local gemamount = game:GetService("Players").LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage = game.Players.LocalPlayer.Name .. " just sniped a "
    if version then
        if version == 2 then
            version = "Rainbow"
        elseif version == 1 then
            version = "Golden"
        end
    else
       version = "Normal"
    end
    
    snipeMessage = snipeMessage .. version
    
    if shiny then
        snipeMessage = snipeMessage .. " Shiny"
    end
    
    snipeMessage = snipeMessage .. " " .. (item)
    
    print(snipeMessage)
    
    message1 = {
        ['content'] = "Very Gud",
        ['embeds'] = {
            {
                ['title'] = snipeMessage,
                ["color"] = tonumber(0x33dd99),
                ["timestamp"] = DateTime.now():ToIsoDate(),
                ['fields'] = {
                    {
                        ['name'] = "Price:",
                        ['value'] = tostring(gems) .. " GEMS",
                    },
                    {
                        ['name'] = "Bought From:",
                        ['value'] = tostring(boughtFrom),
                    },
                    {
                        ['name'] = "x".. tostring(amount),
                        ['value'] = tostring(amount),
                    },
                    {
                        ['name'] = "Gems:",
                    },  ['value'] = tostring(gemamount),
                    {
                        ['name'] = "Pet ID:",
                        ['value'] = tostring(uid),
                    },
                },
            },
        }
    }

    local http = game:GetService("HttpService")
    local jsonMessage = http:JSONEncode(message1)
    local success, response = pcall(function()
            http:PostAsync(getgenv().webhook, jsonMessage)
    end)
    if success == false then
            local response = request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonMessage
        })
    end
end

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    local Library = require(game.ReplicatedStorage:WaitForChild('Library'))
    gems = tonumber(gems)
    local type = {}
    pcall(function()
        type = Library.Directory.Pets[item]
end)

    if type.exclusiveLevel and gems <= 10000 and item ~= "Banana" and item ~= "Coin" then
        local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            processListingInfo(uid, gems, item, version, shiny, amount, username)
        end
    elseif item == "Titanic Christmas Present" and gems <= 25000 then
        local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            processListingInfo(uid, gems, item, version, shiny, amount, username)
        end
    elseif string.find(item, "Exclusive") and gems <= 25000 then
        local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            processListingInfo(uid, gems, item, version, shiny, amount, username)
        end
    elseif type.huge and gems <= 1000001 then
        local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            processListingInfo(uid, gems, item, version, shiny, amount, username)
        end     
    elseif type.titanic and gems <= 10000000 then
        local boughtPet, boughtMessage = game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            processListingInfo(uid, gems, item, version, shiny, amount, username)
        end
    end
end

Booths_Broadcast.OnClientEvent:Connect(function(username, message)
    local playerID = message['PlayerID']
    if type(message) == "table" and message['PlayerID'] then
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
                        checklisting(uid, gems, item, version, shiny, amount, username , playerID)
                    end
                end
            end
        end
    end
end)

local function jumpToServer() 
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true" 
    local req = request({ Url = string.format(sfUrl, 15502339080, "Desc", 100) }) 
    local body = game:GetService("HttpService"):JSONDecode(req.Body) 
    local deep = math.random(1, 3)
    if deep > 1 then 
        for i = 1, deep, 1 do 
            req = request({ Url = string.format(sfUrl .. "&cursor=" .. body.nextPageCursor, 15502339080, "Desc", 100) }) 
            body = game:GetService("HttpService"):JSONDecode(req.Body) 
            task.wait(0.1)
        end 
    end 
    local servers = {} 
    if body and body.data then 
        for i, v in next, body.data do 
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end
    local randomCount = #servers
    if not randomCount then
        randomCount = 2
    end
    game:GetService("TeleportService"):TeleportToPlaceInstance(15502339080, servers[math.random(1, randomCount)], game:GetService("Players").LocalPlayer) 
end

while wait (30) do
    PlayerInServer = #Players:GetPlayers()
    if PlayerInServer < 25 or os.time() >= ostime + 1080 then
        jumpToServer()
        break
    end
    for count = 1, #alts, 1 do
        if game.Players:FindFirstChild(alts[count]) and alts[count] ~= game:GetService("Players").LocalPlayer.Name then
            jumpToServer()
            break
        end
    end
end
