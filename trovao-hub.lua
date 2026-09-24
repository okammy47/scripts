--══════════════════════════════════════════
--⚡ TROVÃO HUB V1 — IGUAL A FOTO
--Equipe Trovão • GL
--══════════════════════════════════════════

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local GRAV_PADRAO = 196
local FOV_PADRAO = Workspace.CurrentCamera.FieldOfView
local alvoGrav = GRAV_PADRAO
local aberto = true

local estado = {
    grav50=false, grav70=false, grav80=false,
    driftCam=false, drone=false,
    fov90=false, speedo=false,
    controle=false
}

-- Trava gravidade + FOV + velocímetro
RunService.Heartbeat:Connect(function()
    if Workspace.Gravity ~= alvoGrav then
        Workspace.Gravity = alvoGrav
    end
    if estado.fov90 then
        Workspace.CurrentCamera.FieldOfView = 90
    else
        Workspace.CurrentCamera.FieldOfView = FOV_PADRAO
    end
    if estado.speedo then
        local c = player.Character
        if c then
            local r = c:FindFirstChild("HumanoidRootPart")
            if r then
                local v = r.AssemblyLinearVelocity
                local kmh = math.round(math.sqrt(v.X^2+v.Z^2)*3.6)
                pcall(function() StarterGui:SetCore("Status", {Speed=kmh.." km/h"}) end)
            end
        end
    end
end)

-- Criar tela toda
local Tela = Instance.new("ScreenGui")
Tela.Name = "TrovaoHubV1"
Tela.Parent = PlayerGui
Tela.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fundo preto
local Janela = Instance.new("Frame")
Janela.Name = "Janela"
Janela.Size = UDim2.new(0,420,0,580)
Janela.Position = UDim2.new(0.5,-210,0.5,-290)
Janela.BackgroundColor3 = Color3.fromRGB(20,20,20)
Janela.BorderColor3 = Color3.fromRGB(220,40,40)
Janela.BorderSizePixel = 3
Janela.Parent = Tela

-- Cabeçalho
local Cab = Instance.new("Frame")
Cab.Name = "Cabecalho"
Cab.Size = UDim2.new(1,0,0,60)
Cab.BackgroundColor3 = Color3.fromRGB(30,10,10)
Cab.BorderColor3 = Color3.fromRGB(220,40,40)
Cab.BorderSizePixel = 2
Cab.Parent = Janela

local Titulo = Instance.new("TextLabel")
Titulo.Name = "Titulo"
Titulo.Size = UDim2.new(1,-120,1,0)
Titulo.Position = UDim2.new(110,0,0,0)
Titulo.BackgroundTransparency = 1
Titulo.Text = "TROVÃO HUB V1"
Titulo.TextColor3 = Color3.fromRGB(255,0,255)
Titulo.Font = Enum.Font.GothamBold
Titulo.TextSize = 26
Titulo.TextXAlignment = Enum.TextXAlignment.Center
Titulo.Parent = Cab

-- Botão Fechar
local BtnFechar = Instance.new("TextButton")
BtnFechar.Name = "Fechar"
BtnFechar.Size = UDim2.new(0,50,0,50)
BtnFechar.Position = UDim2.new(1,-55,0,5)
BtnFechar.BackgroundColor3 = Color3.fromRGB(200,30,30)
BtnFechar.Text = "X"
BtnFechar.TextColor3 = Color3.fromRGB(255,255,255)
BtnFechar.Font = Enum.Font.GothamBold
BtnFechar.TextSize = 22
BtnFechar.Parent = Cab
Instance.new("UICorner",BtnFechar).CornerRadius = UDim.new(0,8)

-- Botão Minimizar
local BtnMin = Instance.new("TextButton")
BtnMin.Name = "Min"
BtnMin.Size = UDim2.new(0,50,0,50)
BtnMin.Position = UDim2.new(1,-110,0,5)
BtnMin.BackgroundColor3 = Color3.fromRGB(60,60,60)
BtnMin.Text = "-"
BtnMin.TextColor3 = Color3.fromRGB(255,255,255)
BtnMin.Font = Enum.Font.GothamBold
BtnMin.TextSize = 22
BtnMin.Parent = Cab
Instance.new("UICorner",BtnMin).CornerRadius = UDim.new(0,8)

-- Conteúdo
local Conteudo = Instance.new("Frame")
Conteudo.Name = "Conteudo"
Conteudo.Size = UDim2.new(1,-20,1,-80)
Conteudo.Position = UDim2.new(0,10,0,70)
Conteudo.BackgroundTransparency = 1
Conteudo.ClipsDescendants = true
Conteudo.Parent = Janela

-- Função criar botão
local function botao(nome, x, y, acao)
    local B = Instance.new("TextButton")
    B.Name = nome
    B.Size = UDim2.new(0,190,0,50)
    B.Position = UDim2.new(x,0,y,0)
    B.BackgroundColor3 = Color3.fromRGB(40,20,20)
    B.BorderColor3 = Color3.fromRGB(80,30,30)
    B.BorderSizePixel = 1
    B.Text = nome..": OFF"
    B.TextColor3 = Color3.fromRGB(255,60,60)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 16
    B.AutoLocalize = false
    B.Parent = Conteudo
    Instance.new("UICorner",B).CornerRadius = UDim.new(0,6)
    
    B.MouseButton1Click:Connect(function() acao(B) end)
    return B
end

-- LINHA 1
botao("Gravidade 50", 0, 0, function(b)
    estado.grav50 = not estado.grav50
    if estado.grav50 then
        alvoGrav = 50
        b.Text = "Gravidade 50: ON"
        b.TextColor3 = Color3.fromRGB(60,255,60)
    else
        alvoGrav = GRAV_PADRAO
        b.Text = "Gravidade 50: OFF"
        b.TextColor3 = Color3.fromRGB(255,60,60)
    end
    Workspace.Gravity = alvoGrav
end)

botao("Gravidade 70", 210, 0, function(b)
    estado.grav70 = not estado.grav70
    if estado.grav70 then
        alvoGrav = 70
        b.Text = "Gravidade 70: ON"
        b.TextColor3 = Color3.fromRGB(60,255,60)
    else
        alvoGrav = GRAV_PADRAO
        b.Text = "Gravidade 70: OFF"
        b.TextColor3 = Color3.fromRGB(255,60,60)
    end
    Workspace.Gravity = alvoGrav
end)

-- LINHA 2
botao("Gravidade 80", 0, 60, function(b)
    estado.grav80 = not estado.grav80
    if estado.grav80 then
        alvoGrav = 80
        b.Text = "Gravidade 80: ON"
        b.TextColor3 = Color3.fromRGB(60,255,60)
    else
        alvoGrav = GRAV_PADRAO
        b.Text = "Gravidade 80: OFF"
        b.TextColor3 = Color3.fromRGB(255,60,60)
    end
    Workspace.Gravity = alvoGrav
end)

local BtnReset = Instance.new("TextButton")
BtnReset.Name = "ResetGrav"
BtnReset.Size = UDim2.new(0,190,0,50)
BtnReset.Position = UDim2.new(210,0,60,0)
BtnReset.BackgroundColor3 = Color3.fromRGB(40,20,20)
BtnReset.BorderColor3 = Color3.fromRGB(80,30,30)
BtnReset.BorderSizePixel = 1
BtnReset.Text = "Reset Gravity"
BtnReset.TextColor3 = Color3.fromRGB(255,60,60)
BtnReset.Font = Enum.Font.GothamBold
BtnReset.TextSize = 16
BtnReset.Parent = Conteudo
Instance.new("UICorner",BtnReset).CornerRadius = UDim.new(0,6)
BtnReset.MouseButton1Click:Connect(function()
    alvoGrav = GRAV_PADRAO
    Workspace.Gravity = GRAV_PADRAO
    StarterGui:SetCore("Notification", {Title="⚡ TROVÃO HUB", Text="Gravidade restaurada!", Duration=2})
end)

-- LINHA 3
botao("Drift Cam", 0, 120, function(b)
    estado.driftCam = not estado.driftCam
    b.Text = "Drift Cam: "..(estado.driftCam and "ON" or "OFF")
    b.TextColor3 = estado.driftCam and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
end)

botao("Drone", 210, 120, function(b)
    estado.drone = not estado.drone
    b.Text = "Drone: "..(estado.drone and "ON" or "OFF")
    b.TextColor3 = estado.drone and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
end)

-- LINHA 4
botao("FOV 90", 0, 180, function(b)
    estado.fov90 = not estado.fov90
    b.Text = "FOV 90: "..(estado.fov90 and "ON" or "OFF")
    b.TextColor3 = estado.fov90 and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
end)

botao("Speed Monitor", 210, 180, function(b)
    estado.speedo = not estado.speedo
    b.Text = "Speed Monitor: "..(estado.speedo and "ON" or "OFF")
    b.TextColor3 = estado.speedo and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
    if not estado.speedo then pcall(function() StarterGui:SetCore("Status", {Speed=""}) end) end
end)

-- LINHA 5
botao("Controle", 0, 240, function(b)
    estado.controle = not estado.controle
    b.Text = "Controle: "..(estado.controle and "ON" or "OFF")
    b.TextColor3 = estado.controle and Color3.fromRGB(60,255,60) or Color3.fromRGB(255,60,60)
end)

-- Créditos
local Cred = Instance.new("TextLabel")
Cred.Name = "Credito"
Cred.Size = UDim2.new(1,0,0,40)
Cred.Position = UDim2.new(0,0,1,-45)
Cred.BackgroundTransparency = 1
Cred.Text = "TikTok: GL.oficial | TikTok: Okammy47"
Cred.TextColor3 = Color3.fromRGB(255,200,0)
Cred.Font = Enum.Font.GothamBold
Cred.TextSize = 14
Cred.Parent = Conteudo

-- Minimizar / Maximizar
BtnMin.MouseButton1Click:Connect(function()
    aberto = not aberto
    Conteudo.Visible = aberto
    BtnMin.Text = aberto and "-" or "+"
end)

-- Fechar
BtnFechar.MouseButton1Click:Connect(function()
    Tela:Destroy()
    pcall(function() StarterGui:SetCore("Notification", {
        Title = "⚡ TROVÃO HUB",
        Text = "Obrigado por usar.\nEquipe Trovão • GL",
        Duration = 4
    }) end)
end)
