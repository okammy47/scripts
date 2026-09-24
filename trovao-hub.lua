--══════════════════════════════════════════
--⚡ TROVÃO HUB V1
--Equipe Trovão • GL
--══════════════════════════════════════════

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = player:WaitForChild("PlayerGui")

local GRAV_PADRAO = 196
local FOV_PADRAO = Camera.FieldOfView
local alvoGrav = GRAV_PADRAO
local layoutAtivo = false
local droneAtivo = false
local dronePos = nil

local estado = {
    grav50=false, grav70=false, grav80=false,
    driftCam=false, drone=false,
    fov90=false, speedo=false
}

RunService.Heartbeat:Connect(function()
    if Workspace.Gravity ~= alvoGrav then
        Workspace.Gravity = alvoGrav
    end
    if estado.fov90 then
        Camera.FieldOfView = 90
    else
        Camera.FieldOfView = FOV_PADRAO
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
    if droneAtivo and dronePos then
        local m = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then m+=Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then m-=Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then m-=Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then m+=Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m+=Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then m-=Vector3.new(0,1,0) end
        dronePos += m*0.5
        Camera.CFrame = CFrame.new(dronePos, dronePos+Camera.CFrame.LookVector)
    end
end)

local function getCar()
    local c = player.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h or not h.SeatPart then return end
    return h.SeatPart.Parent
end

local function criarControles()
    if layoutAtivo then return end
    layoutAtivo = true
    local t = Instance.new("ScreenGui")
    t.Name = "ControlesTrovao"
    t.Parent = PlayerGui
    t.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local function btn(nome,txt,px,py,cor)
        local b = Instance.new("TextButton")
        b.Name = nome
        b.Size = UDim2.new(0,65,0,65)
        b.Position = UDim2.new(px,0,py,0)
        b.BackgroundColor3 = cor
        b.BackgroundTransparency = 0.35
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 24
        b.AutoLocalize = false
        b.Parent = t
        Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)
        return b
    end
    local frente = btn("Frente","W",0.82,0.85,Color3.fromRGB(0,200,0))
    local tras = btn("Tras","S",0.70,0.85,Color3.fromRGB(200,100,0))
    local esq = btn("Esq","A",0.10,0.85,Color3.fromRGB(0,100,255))
    local dir = btn("Dir","D",0.22,0.85,Color3.fromRGB(0,100,255))
    local function dirCarro()
        local car = getCar()
        if not car then return end
        local r = car:FindFirstChildWhichIsA("BasePart")
        if not r then return end
        return r.CFrame.LookVector, r.CFrame.RightVector, r
    end
    frente.InputBegan:Connect(function()
        while frente.Visible do
            local fv,_,r = dirCarro()
            if fv and r then r:ApplyImpulse(fv*20*r.AssemblyMass) end
            task.wait(0.03)
        end
    end)
    tras.InputBegan:Connect(function()
        while tras.Visible do
            local fv,_,r = dirCarro()
            if fv and r then r:ApplyImpulse(-fv*15*r.AssemblyMass) end
            task.wait(0.03)
        end
    end)
    esq.InputBegan:Connect(function()
        while esq.Visible do
            local _,rv,r = dirCarro()
            if rv and r then r:ApplyImpulse(-rv*12*r.AssemblyMass) end
            task.wait(0.03)
        end
    end)
    dir.InputBegan:Connect(function()
        while dir.Visible do
            local _,rv,r = dirCarro()
            if rv and r then r:ApplyImpulse(rv*12*r.AssemblyMass) end
            task.wait(0.03)
        end
    end)
end

local function removerControles()
    local t = PlayerGui:FindFirstChild("ControlesTrovao")
    if t then t:Destroy() end
    layoutAtivo = false
end

local function toggleDrone(ativar)
    droneAtivo = ativar
    if ativar then
        dronePos = Camera.CFrame.Position
    else
        dronePos = nil
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TROVÃO HUB V1",
   ToggleUIKeybind = "J",
   KeySystem = false,
   CloseCallback = function()
       pcall(function() StarterGui:SetCore("Notification", {
           Title = "⚡ TROVÃO HUB",
           Text = "Obrigado por usar.\nEquipe Trovão • GL",
           Duration = 5
       }) end)
       return true
   end,
})

local Main = Window:CreateTab("⚡ TROVÃO HUB")

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
Main:CreateToggle({
   Name = "Drift Cam", CurrentValue = false,
   Callback = function(v) estado.driftCam = v end,
})
Main:CreateToggle({
   Name = "Drone", CurrentValue = false,
   Callback = function(v)
       estado.drone = v
       toggleDrone(v)
   end,
})
Main:CreateToggle({
   Name = "FOV 90", CurrentValue = false,
   Callback = function(v) estado.fov90 = v end,
})
Main:CreateToggle({
   Name = "Speed Monitor", CurrentValue = false,
   Callback = function(v)
       estado.speedo = v
       if not v then pcall(function() StarterGui:SetCore("Status", {Speed=""}) end) end
   end,
})
Main:CreateToggle({
   Name = "Controle", CurrentValue = false,
   Callback = function(v)
       if v then criarControles() else removerControles() end
   end,
})

local Cred = Window:CreateTab("👑")
Cred:CreateParagraph({
   Title = "",
   Content = "TikTok: GL.oficial\nTikTok: Okammy47",
})
