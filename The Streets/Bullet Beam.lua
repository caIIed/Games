local BulletTracers = true

-- \\ Services \\ --
local Players       = game:GetService('Players')
local RunService    = game:GetService('RunService')
local Workspace     = game:GetService('Workspace')

-- \\ Variables \\ --
local Player        = Players.LocalPlayer
local Mouse         = Player:GetMouse()

local Functions     = {}

local BeamPart      = Instance.new('Part')
BeamPart.Parent     = Workspace

Mouse.TargetFilter  = BeamPart

-- \\ Functions \\ --
function GetGun()
    if Player.Character then
        for i, v in pairs(Player.Character:GetChildren()) do
            if v:IsA('Tool') and v:FindFirstChild('Ammo') then
                return v
            end
        end
    end
    return nil
end

local InvisibleTrail = function(Trail)
    if Trail and Trail:IsA('Trail') then
        Trail.Transparency = NumberSequence.new(1)
    end
end

function Functions:Beam(Pos1, Pos2)
    local Part = Instance.new('Part')
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CFrame = CFrame.new(Pos1)
    Part.Anchored = true
    Part.Parent = BeamPart

    local Attachment = Instance.new('Attachment')
    Attachment.Parent = Part

    local Part2 = Instance.new('Part')
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.Transparency = 1
    Part2.CanCollide = false
    Part2.CFrame = CFrame.new(Pos2)
    Part2.Anchored = true
    Part2.Color = Color3.fromRGB(0, 0, 0)
    Part2.Parent = BeamPart

    local Attachment2 = Instance.new('Attachment')
    Attachment2.Parent = Part2

    local Beam = Instance.new('Beam')
    Beam.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(93, 88, 157)), ColorSequenceKeypoint.new(1, Color3.fromRGB(93, 88, 157))})
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.LightEmission = 4.5
    Beam.LightInfluence = 0
    Beam.Texture = 'http://www.roblox.com/asset/?id=7151778302'
    Beam.TextureMode = Enum.TextureMode.Wrap
    Beam.TextureSpeed = 3
    Beam.TextureLength = 8
    Beam.Transparency = NumberSequence.new(0)
    Beam.ZOffset = 1
    Beam.Width0 = 1
    Beam.Width1 = 1
    Beam.Segments = 10
    Beam.Brightness = 2.4
    Beam.FaceCamera = true
    Beam.Enabled = true
    Beam.Parent = Part
    task.wait(4)
    Beam.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))})
    Part:Destroy()
    Part2:Destroy()
end

-- \\ Loop \\ --
RunService.RenderStepped:Connect(function()
    task.wait(0.5)
    Gun = GetGun()
    if Player and Player.Character then
        if Gun then
            LastAmmo = Gun.Ammo.Value
            Gun.Ammo:GetPropertyChangedSignal('Value'):Connect(function()
                if BulletTracers and Gun:WaitForChild('Ammo').Value < LastAmmo --[[ and Gun.Name == 'Glock' ]] then
                    LastAmmo = Gun.Ammo.Value
                    Functions:Beam(Gun.Handle.Position, Mouse.hit.p)
                end
            end)
        end
    end
end)

-- \\ Connections \\ --
Player.Character.DescendantAdded:Connect(InvisibleTrail)
Player.CharacterAdded:Connect(function()
Player.Character.DescendantAdded:Connect(InvisibleTrail)
end)
