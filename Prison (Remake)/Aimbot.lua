-- \\ Settings \\ --

local Settings = {
    Enabled    = false,
    Key        = 'q',
    Part       = 'Torso',
    Prediction = 0.134,
    Dot        = true,
    Color      = Color3.fromRGB(135, 102, 183),
};

-- \\ Services \\ --
local Workspace  = game:GetService('Workspace')
local Players    = game:GetService('Players')
local RunService = game:GetService('RunService')

-- \\ Variables \\ --
local Player     = Players.LocalPlayer
local Camera     = Workspace.CurrentCamera
local Mouse      = Player:GetMouse()

local Target     = Player

-- \\ Dot \\ --
local DotPart               = Instance.new('Part')
DotPart.Anchored            = true
DotPart.CanCollide          = false
DotPart.Size                = Vector3.new(5, 5, 5)
DotPart.Material            = 'Neon'
DotPart.Transparency        = 1
DotPart.Color               = Color3.fromRGB(0, 0, 0)
DotPart.Name                = 'minorware'
DotPart.Parent              = Workspace

local DotFrame              = Instance.new('BillboardGui')
DotFrame.Name               = 'minorware'
DotFrame.Adornee            = Adornee
DotFrame.Size               = UDim2.new(0.5, 0, 0.5, 0)
DotFrame.AlwaysOnTop        = true
DotFrame.Parent             = DotPart

local Dot                   = Instance.new('Frame')   
Dot.Size                    = UDim2.new(1, 0, 1, 0)
Dot.BackgroundTransparency  = 0
Dot.BackgroundColor3        = Settings.Color
Dot.Name                    = 'minorware'
Dot.Parent                  = DotFrame 

local DotRounding           = Instance.new('UICorner')
DotRounding.Parent          = Dot
DotRounding.CornerRadius    = UDim.new(1, 1)

-- \\ Keybind \\ --
Mouse.KeyDown:Connect(function(Key)
    if Key == (Settings.Key) then
        Target = GetClosestPlayerToCursor()
        Settings.Enabled = not Settings.Enabled
    end
end)

-- \\ Functions \\ --
function GetClosestPlayerToCursor()
    local ClosestPlayer
    local ShortestDistance = math.huge

    for i, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild('HumanoidRootPart') then
            local Pos = Camera:WorldToViewportPoint(v.Character[Settings.Part].Position)
            local magnitude = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude

            if magnitude < ShortestDistance then
                ClosestPlayer = v
                ShortestDistance = magnitude
            end
        end
    end
    return ClosestPlayer
end

Checks = function()
    local Check1 = (Settings.Enabled == true)
    local Check2 = (Target ~= Player)
    return (Check1)
end

RunService.Heartbeat:Connect(function()
    if Settings.Enabled then
        DotPart.CFrame = CFrame.new(Target.Character:WaitForChild(Settings.Part).Position + (Target.Character:WaitForChild(Settings.Part).Velocity * Vector3.new(Settings.Prediction, 0, Settings.Prediction)))
    elseif Settings.Enabled == false then
        DotPart.CFrame = CFrame.new(9999, 9999, 9999)
    end
    if Settings.Dot then
        Dot.BackgroundTransparency = 0
    elseif Settings.Dot == false then
        Dot.BackgroundTransparency = 1
    end
end)

-- \\ Aimbot \\ --

local OldNamecall; OldNamecall = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
    local NameCallmethod, Arguments = (getnamecallmethod or game_namecall_method)(), {...};
    if NameCallmethod == 'FireServer' and self.IsA(self, 'RemoteEvent') and self.Name == 'Shoot' then
        if (Checks()) then
            Arguments[1] = Target.Character[Settings.Part].CFrame + (Target.Character[Settings.Part].Velocity * Vector3.new(Settings.Prediction, 0, Settings.Prediction))
        end
    end
    return OldNamecall(self, unpack(Arguments));
end));
