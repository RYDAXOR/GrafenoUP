return string.dump(loadstring([[
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🔥 Grafreno Hub | Anime Card Clash 🔫",
   LoadingTitle = "🔫 Grafreno Hub 💥",
   LoadingSubtitle = "by Debaby",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Example Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key | Youtube Hub",
      Subtitle = "Key System",
      Note = "Key In Discord Server",
      FileName = "YoutubeHubKey1", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/AtgzSPWK"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("🏠 Home", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "You executed the script",
   Content = "Grafeno on Top",
   Duration = 5,
   Image = 13047715178,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
         print("The user tapped Okay!")
      end
   },
},
})


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Variável para controlar o estado do AutoFarm
local isFarming = false

-- Toggle para ativar/desativar o farming
local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag é o identificador para o arquivo de configuração
   Callback = function(Value)
        if Value then
            isFarming = true
            print("FARMING ATIVADO")
            StartFarming()  -- Inicia a função de farming quando ativado
        else
            isFarming = false
            print("FARMING DESATIVADO")
            StopFarming()   -- Desativa a função de farming quando desativado
        end
   end,
})

local VirtualUser = game:service("VirtualUser")
local antiAfkConnection

local Toggle = MainTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = false,
   Flag = "Toggle2", 
   Callback = function(Value)
        print("Anti AFK:", Value)

        if Value then
            -- Ativa o Anti-AFK quando o Auto Farm está ligado
            antiAfkConnection = game.Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            print("Anti-AFK ativado.")
        else
            -- Desativa o Anti-AFK quando o Auto Farm está desligado
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
            print("Anti-AFK desativado.")
        end
   end,
})

local collecting = false -- Estado do Auto Farm

local Toggle = MainTab:CreateToggle({
   Name = "Auto PickUp",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
        collecting = Value
        if collecting then
            print("Auto Farm ativado")
            StartCollecting()
        else
            print("Auto Farm desativado")
        end
   end,
})

local Toggle = MainTab:CreateToggle({
    Name = "Auto Infinity",  -- Nome do toggle alterado
    CurrentValue = false,
    Flag = "Toggle2",  -- A flag também foi alterada para evitar conflitos
    Callback = function(Value)
        if Value then
            isInfinity = true
            print("AUTO INFINITY ATIVADO")
            StartInfinity()  -- Inicia a função de Auto Infinity quando ativado
        else
            isInfinity = false
            print("AUTO INFINITY DESATIVADO")
            StopInfinity()  -- Desativa a função de Auto Infinity quando desativado
        end
    end,
})

local isInfinity = false

-- Função para iniciar o Auto Infinity
function StartInfinity()
    -- Comando que será repetido enquanto o Auto Infinity estiver ativo
    local args = {}
    game:GetService("ReplicatedStorage"):WaitForChild("qVL", 9e9):WaitForChild("79f1b6e9-0e5d-49fa-b11e-063dcbcb1544", 9e9):FireServer(unpack(args))

    -- Loop que mantém o Auto Infinity ativo enquanto a variável isInfinity for verdadeira
    while isInfinity do
        wait(1)  -- Espera 1 segundo entre cada execução, você pode ajustar o intervalo conforme necessário
        game:GetService("ReplicatedStorage"):WaitForChild("qVL", 9e9):WaitForChild("79f1b6e9-0e5d-49fa-b11e-063dcbcb1544", 9e9):FireServer(unpack(args))
    end
end

-- Função para parar o Auto Infinity
function StopInfinity()
    -- Comando que será executado quando o Auto Infinity for desativado
    local args = {}
    game:GetService("ReplicatedStorage"):WaitForChild("qVL", 9e9):WaitForChild("3f16431e-3674-4dde-99fd-6883960c71dd", 9e9):FireServer(unpack(args))
    
    -- Desativa o loop de Auto Infinity
    isInfinity = false
    print("AUTO INFINITY DESATIVADO")
end


-- Função para coletar itens
local function collectItems()
    if not collecting then return end -- Sai da função se estiver desativado

    local player = game.Players.LocalPlayer
    local PickupFolder = game.Workspace:WaitForChild("Folder")  -- Pasta de pickups no mapa

    for _, drop in ipairs(PickupFolder:GetChildren()) do
        if not collecting then return end -- Sai do loop se desativado

        if drop:IsA("Model") and drop.PrimaryPart then
            local itemPosition = drop.PrimaryPart.Position
            local character = player.Character or player.CharacterAdded:Wait()
            if character then
                character:SetPrimaryPartCFrame(CFrame.new(itemPosition))
                wait(2)

                local humanoid = character:WaitForChild("Humanoid")

                -- Faz o jogador pular continuamente enquanto coleta
                local jumping = true
                spawn(function()
                    while collecting and jumping do
                        humanoid.Jump = true
                        wait(0.01)
                    end
                end)

                local collectTrigger = drop:FindFirstChild("CollectTrigger")
                if collectTrigger and collectTrigger:IsA("Part") then
                    collectTrigger.Touched:Connect(function(hit)
                        if hit and hit.Parent == character then
                            print("Item coletado:", drop.Name)
                        end
                    end)
                end
            end
        end
    end
end

-- Função principal de coleta de itens
function StartCollecting()
    spawn(function()
        while collecting do
            collectItems()
            wait(5)
        end
    end)
end



-- Função para iniciar o Farming (teleportar, flutuar, interagir)
function StartFarming()
    -- Pega o modelo "eternal_dragon"
    local eternalDragon = workspace:WaitForChild("raid"):WaitForChild("eternal_dragon")
    
    -- Função para teletransportar o jogador
    local function teleportToEternalDragon()
        -- Verifica se o modelo "eternal_dragon" existe
        if eternalDragon then
            -- Tenta encontrar a PrimaryPart do modelo
            local primaryPart = eternalDragon.PrimaryPart
            
            if primaryPart then
                -- Se a PrimaryPart estiver definida, teletransporta para ela
                character:SetPrimaryPartCFrame(primaryPart.CFrame)
                print("Jogador teleportado para a PrimaryPart do 'eternal_dragon'.")  -- Debug
            else
                -- Caso o modelo não tenha PrimaryPart, usa o WorldPivot.Position
                local modelPosition = eternalDragon:GetPivot().Position
                character:SetPrimaryPartCFrame(CFrame.new(modelPosition))
                print("Jogador teleportado para a posição do 'eternal_dragon' (sem PrimaryPart).")  -- Debug

                -- Aguarda um momento antes de verificar novamente a PrimaryPart
                wait(2)  -- Tempo de espera para garantir que o modelo está pronto para o teletransporte final

                -- Tenta novamente pegar a PrimaryPart depois que o jogador chegou à posição inicial
                primaryPart = eternalDragon.PrimaryPart

                if primaryPart then
                    -- Agora, se a PrimaryPart foi definida, teletransporta o jogador para a PrimaryPart
                    character:SetPrimaryPartCFrame(primaryPart.CFrame)
                    print("Jogador teleportado novamente para a PrimaryPart do 'eternal_dragon'.")  -- Debug
                end
            end

            -- Espera o "Blue Eyes White Dragon" aparecer após o teletransporte
            local blueEyesDragon = eternalDragon:WaitForChild("Blue Eyes White Dragon")

            -- Verifica se o ProximityPrompt está presente no "Blue Eyes White Dragon"
            local prompt = blueEyesDragon:FindFirstChild("ProximityPrompt")

            if prompt then
                print("ProximityPrompt encontrado no 'Blue Eyes White Dragon'.")  -- Debug
                prompt.Enabled = true

                -- Função para ativar automaticamente o ProximityPrompt quando o jogador estiver na área
                local function activateProximityPrompt()
                    local distance = (character.HumanoidRootPart.Position - blueEyesDragon.Position).Magnitude

                    -- Verifica se o jogador está dentro do raio de ativação (ajuste o valor 10 conforme necessário)
                    if distance <= prompt.MaxActivationDistance then
                        -- Forçar o personagem a ficar flutuando sobre o modelo
                        local floatHeight = -0  -- Altura de flutuação sobre o modelo
                        local targetPosition = blueEyesDragon.Position + Vector3.new(0, floatHeight, 0)

                        -- Coloca o personagem fixo na posição, sem mover a rotação
                        character:SetPrimaryPartCFrame(CFrame.new(targetPosition))

                        -- Dispara o ProximityPrompt
                        fireproximityprompt(prompt)
                    end
                end

                -- Chama a função para verificar a proximidade e ativar o ProximityPrompt
                game:GetService("RunService").Heartbeat:Connect(function()
                    if isFarming then  -- Verifica se o farming está ativado
                        activateProximityPrompt()
                    end
                end)
            else
                print("ProximityPrompt não encontrado no 'Blue Eyes White Dragon'.")  -- Debug
            end
        else
            print("'eternal_dragon' não encontrado.")  -- Debug
        end
    end

    -- Chama a função de teleporte
    teleportToEternalDragon()
end

-- Função para parar o Farming (desativar tudo)
function StopFarming()
    -- Desconecta qualquer função de flutuação e interação
    print("Farming parado. Desconectando qualquer teleporte ou interação.")
    
    local blueEyesDragon = workspace:WaitForChild("raid"):WaitForChild("eternal_dragon"):WaitForChild("Blue Eyes White Dragon")
    local prompt = blueEyesDragon:FindFirstChild("ProximityPrompt")

    if prompt then
        -- Impede que o ProximityPrompt seja ativado
        prompt.Enabled = false
        print("ProximityPrompt desativado.")
    end

    -- Caso o jogador tenha ficado flutuando sobre o modelo, restaurar a posição original
    local safePosition = CFrame.new(147.431931, 7.39073801, -297.371735, 0.632919192, 0, 0.774217844, 0, 1, 0, -0.774217844, 0, 0.632919192)
    local originalPosition = character.HumanoidRootPart.Position
    -- Aqui, você pode restaurar a posição do jogador (exemplo: voltar para a posição original)
    character:SetPrimaryPartCFrame(CFrame.new(originalPosition))  -- Deixa o personagem em sua posição original.
    character:SetPrimaryPartCFrame(safePosition)
    
end



local TPTab = Window:CreateTab("🎲 Misc", nil) -- Title, Image


function CustomNotify(title, content, duration)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 100)
    Frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 2
    Frame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0.3, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextSize = 20
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Parent = Frame

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, 0, 0.6, 0)
    ContentLabel.Position = UDim2.new(0, 0, 0.3, 0)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = content
    ContentLabel.TextSize = 16
    ContentLabel.Font = Enum.Font.SourceSans
    ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ContentLabel.TextWrapped = true
    ContentLabel.Parent = Frame

    -- Remover a notificação após um tempo
    task.delay(duration or 5, function()
        ScreenGui:Destroy()
    end)
end
print("Script carregado com sucesso!")
-- Resto do seu código
]]))
