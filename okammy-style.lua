--══════════════════════════════════════════
--🏎️ OKAMMY STYLE
--Seu estilo — diferente de todos!
--══════════════════════════════════════════

-- ⚙️ MUDA AQUI DO SEU JEITO!
local Config = {
    Velocidade = 95,        -- mais alto = mais rápido
    Torque = 35,            -- arranca mais forte
    Drift = 0.75,           -- 1 = desliza MUITO | 0 = gruda
    Roda = 35,              -- quanto vira a roda
    Freio = 8,              -- freia mais forte
}

-- Pegar o carro que tá usando
local Jogador = game.Players.LocalPlayer
local Carro = Jogador.Character and Jogador.Character:FindFirstChildWhichIsA("Model")
if not Carro then
    print("❌ Entre num carro primeiro!")
    return
end

local Motor = Carro:FindFirstChildOfClass("VehicleSeat")
if not Motor then
    print("❌ Não achou o motor!")
    return
end

-- Aplicar tudo
Motor.MaxSpeed = Config.Velocidade
Motor.Torque = Config.Torque
Motor.Brake = Config.Freio

print("🏎️ OKAMMY STYLE ATIVADO! ✅")
print("   Velocidade: "..Config.Velocidade)
print("   Torque: "..Config.Torque)
print("   Drift: "..math.floor(Config.Drift*100).."%")

-- Sistema de drift
local Run = game:GetService("RunService")
Run.RenderStepped:Connect(function()
    if not Motor then return end
    if not Motor.Occupant then return end -- ninguém dentro = para
    
    -- Muda aderência pra deslizar
    for _, parte in ipairs(Carro:GetDescendants()) do
        if parte:IsA("BasePart") then
            local fisica = PhysicalProperties.new(
                0.5 - (Config.Drift * 0.4), -- quanto menos = mais desliza
                0.3,
                0.8,
                200,
                0.2
            )
            parte.CustomPhysicalProperties = fisica
        end
    end
end)
