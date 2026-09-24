--══════════════════════════════════════════
--⚡ PAINEL DO OKAMMY
--Feito por: OKAMMY
--══════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ PAINEL DO OKAMMY",
   LoadingTitle = "Painel do Okammy",
   LoadingSubtitle = "Seu, do zero",
   ShowText = "Okammy",
   ToggleUIKeybind = "J",
   KeySystem = false,
})

local Nitro = Window:CreateTab("⚡ Nitro")
Nitro:CreateToggle({
   Name = "Ativar Nitro", CurrentValue = true,
   Callback = function(v) end,
})

local Fumaca = Window:CreateTab("💨 Fumaça")
Fumaca:CreateToggle({
   Name = "Ativar Fumaça", CurrentValue = true,
   Callback = function(v) end,
})

local Pulo = Window:CreateTab("🦘 Pulo")
Pulo:CreateToggle({
   Name = "Ativar Pulo", CurrentValue = false,
   Callback = function(v) end,
})

local Grav = Window:CreateTab("🌍 Gravidade")
Grav:CreateSlider({
   Name = "Gravidade", Range = {0, 1000}, Increment = 1, CurrentValue = 196,
   Callback = function(v) workspace.Gravity = v end,
})

local Ades = Window:CreateTab("🛞 Aderência")
Ades:CreateSlider({
   Name = "Aderência", Range = {0, 4}, Increment = 0.05, CurrentValue = 1,
   Callback = function(v) end,
})

local Cred = Window:CreateTab("👑 Créditos")
Cred:CreateParagraph({
   Title = "FEITO POR OKAMMY ✨",
   Content = "Seu painel • Do zero\nOkammy © 2026",
})
