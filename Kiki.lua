-- Death Ball: Auto Parry & Perfect Spam
-- Plataforma: Delta

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local Enabled = true
local Ball = workspace:WaitForChild("DeathBall") -- Asegúrate de que el nombre de la pelota en el workspace sea correcto
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForHumanoidRootPart()
local BallCooldown = false

-- Configuración
local SpamKey = Enum.KeyCode.Q -- Tecla para alternar el spam (opcional)
local ParryDistance = 15 -- Distancia para activar el auto parry

-- Función para detectar si la pelota viene hacia el jugador
local function IsBallTargetingPlayer()
    if not Ball or not Ball:IsDescendantOf(workspace) then return false end
    
    local BallVelocity = Ball.AssemblyLinearVelocity
    local BallPosition = Ball.Position
    local PlayerPosition = HumanoidRootPart.Position
    
    -- Calcular dirección
    local Direction = (PlayerPosition - BallPosition).Unit
    local VelocityDirection = BallVelocity.Unit
    
    -- Si la pelota se mueve y la dirección coincide con la posición del jugador
    if BallVelocity.Magnitude > 5 then
        local DotProduct = Direction:Dot(VelocityDirection)
        if DotProduct > 0.8 then -- 0.8 es un ángulo de aproximación (puedes ajustarlo)
            local Distance = (PlayerPosition - BallPosition).Magnitude
            if Distance < ParryDistance then
                return true
            end
        end
    end
    return false
end

-- Función de Parry (Defensa)
local function Parry()
    -- Aquí debes poner la función de parry del juego. 
    -- Normalmente es disparar un RemoteEvent o una función del carácter.
    -- Ejemplo genérico (necesitas inspeccionar el juego para encontrar el nombre real):
    
    -- Ejemplo 1: Si usa un RemoteEvent
    -- local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ParryRemote")
    -- Remote:FireServer()
    
    -- Ejemplo 2: Si usa una Animación o Input
    -- game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
end

-- Función de Hit/Spam
local function HitBall()
    if BallCooldown then return end
    BallCooldown = true
    
    -- Lógica para golpear la pelota sin fallar (Raycast o posicionamiento)
    -- Esto depende enteramente de cómo funciona el juego Death Ball específico.
    -- Normalmente apuntamos a la pelota y llamamos al evento de golpe.
    
    -- Simulación de llamada al evento de golpe
    -- local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- local HitRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HitRemote")
    -- HitRemote:FireServer(Ball)
    
    task.wait(0.1) -- Pequeño cooldown para evitar timeouts
    BallCooldown = false
end

-- Bucle Principal
RunService.Heartbeat:Connect(function()
    if not Enabled then return end
    
    if IsBallTargetingPlayer() then
        -- Lógica de Auto Parry
        Parry()
        
        -- Lógica de Spam (Si la pelota está muy cerca)
        local Distance = (HumanoidRootPart.Position - Ball.Position).Magnitude
        if Distance < 8 then
            HitBall()
        end
    end
end)

-- Toggle UI o Comando
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then -- Tecla para activar/desactivar
        Enabled = not Enabled
        print("Script Status:", Enabled)
    end
end)
