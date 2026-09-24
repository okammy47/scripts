--══════════════════════════════════════════
--⚡ TROVÃO HUB — Feito por OKAMMY
--Time Trovão • GL
--══════════════════════════════════════════

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = player:WaitForChild("PlayerGui")

-- Valores padrão
local GRAV_PADRAO = 196
local alvoGrav = GRAV_PADRAO
local FOV_PADRAO = Camera.FieldOfView
local fovFollow = true
local layoutAtivo = false

-- Estados
local estado = {
    grav50 = false, grav70 = false, grav80 = false,
    driftCam = false, photoMode = false,
    semFovFollow = false, layout = false,
    noSit = false, speedo = false
}

-- Trava gravidade e velocímetro
RunService.Heartbeat:Connect(function()
    if Workspace.Gravity ~= alvoGrav then
        Workspace.Gravity = alvoGrav
    end
    if estado.speedo then
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local v = root.AssemblyLinearVelocity
                local kmh = math.round(math.sqrt(v.X^2 + v.Z^2) * 3.6)
                pcall(function() StarterGui:SetCore("Status", {Speed = kmh .. " km/h"}) end)
            end
        end
    end
end)

-- Pegar carro
local function getCar()
    local c = player.Character
    if not c then return nil end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h or not h.SeatPart then return nil end
    return h.SeatPart.Parent
end

-- Criar botões de tela (Layout)
local function criarLayout()
    if layoutAtivo then return end
    layoutAtivo = true

    local Tela = Instance.new("ScreenGui")
    Tela.Name = "TrovaoBotoes"
    Tela.Parent = PlayerGui
    Tela.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local function botao(nome, texto, posX, posY, cor)
        local btn = Instance.new("TextButton")
        btn.Name = nome
        btn.Size = UDim2.new(0, 70, 0, 70)
        btn.Position = UDim2.new(posX, -35, posY, -35)
        btn.BackgroundColor3 = cor
        btn.BackgroundTransparency = 0.4
        btn.Text = texto
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 28
        btn.AutoLocalize = false
        btn.Parent = Tela

        local circ = Instance.new("UICorner")
        circ.CornerRadius = UDim.new(1,0)
        circ.Parent = btn
        return btn
    end

    -- Botões nas posições que você pediu:
    local frente = botao("Frente", "W", 0.92, 0.92, Color3.fromRGB(0,200,0))
    local tras = botao("Tras", "S", 0.80, 0.92, Color3.fromRGB(200,100,0))
    local esq = botao("Esq", "A", 0.08, 0.92, Color3.fromRGB(0,100,255))
    local dir = botao("Dir", "D", 0.20, 0.92, Color3.fromRGB(0,100,255))

    -- Acelerar pra frente
    frente.InputBegan:Connect(function()
        while frente and frente.Visible do
            local carro = getCar()
            if carro then
                local root = carro:FindFirstChildWhichIsA("BasePart")
                if root then
                    root:ApplyImpulse(Camera.CFrame.LookVector * 15 * root.AssemblyMass)
                end
            end
            task.wait(0.03)
        end
    end)

    -- Andar pra trás
    tras.InputBegan:Connect(function()
        while tras and tras.Visible do
            local carro = getCar()
            if carro then
                local root = carro:FindFirstChildWhichIsA("BasePart")
                if root then
                    root:ApplyImpulse(-Camera.CFrame.LookVector * 12 * root.AssemblyMass)
                end
            end
            task.wait(0.03)
        end
    end)

    -- Virar esquerda
    esq.InputBegan:Connect(function()
        while esq and esq.Visible do
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0.08, 0)
            task.wait(0.02)
        end
    end)

    -- Virar direita
    dir.InputBegan:Connect(function()
        while dir and dir.Visible do
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, -0.08, 0)
            task.wait(0.02)
        end
    end)
end

-- Remover botões
local function removerLayout()
    local tela = PlayerGui:FindFirstChild("TrovaoBotoes")
    if tela then tela:Destroy() end
    layoutAtivo = false
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ TROVÃO HUB",
   LoadingTitle = "", LoadingSubtitle = "", ShowText = "",
   ToggleUIKeybind = "J", KeySystem = false,
})

local Main = Window:CreateTab("⚡ TROVÃO HUB")

-- Linha 1
Main:CreateToggle({
   Name = "Gravidade 50", CurrentValue = false,
   Callback = function(v)
       estado.grav50 = v
       alvoGrav = v and 50 or GRAV_PADRAO
       Workspace.Gravity = alvoGrav
   end,
})
Main:CreateToggle({
   Name = "Gravidade 70", CurrentValue = false,
   Callback = function(v)
       estado.grav70 = v
       alvoGrav = v and 70 or GRAV_PADRAO
       Workspace.Gravity = alvoGrav
   end,
})

-- Linha 2
Main:CreateToggle({
   Name = "Gravidade 80", CurrentValue = false,
   Callback = function(v)
       estado.grav80 = v
       alvoGrav = v and 80 or GRAV_PADRAO
       Workspace.Gravity = alvoGrav
   end,
})
Main:CreateButton({
   Name = "Reset Gravity",
   Callback = function()
       alvoGrav = GRAV_PADRAO
       Workspace.Gravity = GRAV_PADRAO
   end,
})

-- Linha 3
Main:CreateToggle({
   Name = "Drift Cam", CurrentValue = false,
   Callback = function(v) estado.driftCam = v end,
})
Main:CreateToggle({
   Name = "Photo Mode", CurrentValue = false,
   Callback = function(v) estado.photoMode = v end,
})

-- Linha 4
Main:CreateToggle({
   Name = "Remove Auto FOV Follow", CurrentValue = false,
   Callback = function(v) estado.semFovFollow = v end,
})

-- Linha 5
Main:CreateToggle({
   Name = "Layout", CurrentValue = false,
   Callback = function(v)
       estado.layout = v
       if v then criarLayout() else removerLayout() end
   end,
})
Main:CreateToggle({
   Name = "NoSit", CurrentValue = false,
   Callback = function(v) estado.noSit = v end,
})

-- Linha 6
Main:CreateToggle({
   Name = "Speedometer", CurrentValue = false,
   Callback = function(v)
       estado.speedo = v
       if not v then pcall(function() StarterGui:SetCore("Status", {Speed = ""}) end) end
   end,
})

-- Créditos com os TikTok que você pediu!
local Cred = Window:CreateTab("👑")
Cred:CreateParagraph({
   Title = "",
   Content = "TikTok: GL.oficial\nTikTok: Okammy47",
})
