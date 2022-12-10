---------------------------------
-- \|/ The Streets Visuals \|/ --
-- \|/     by call :3      \|/ --

local CNew, CKNew, C3 = ColorSequence.new, ColorSequenceKeypoint.new, Color3.fromRGB;
local Settings       = {
    Trails           = {
        Enabled      = true,
        Time         = true,
        TimeLength   = 0.7,
        Texture      = '',
        Material     = Enum.Material.Neon,
        Transparency = NumberSequence.new(0.3),
        Brightness   = 3,
        Color        = CNew{CKNew(0, C3(51, 0, 255)), CKNew(0.4, C3(66, 3, 255)), CKNew(1, C3(25, 25, 25))}
                       },

    Bullets          = {
        Enabled      = true,
        Material     = Enum.Material.Neon,
        Transparency = 1,
        Color        = Color3.fromRGB(66, 3, 255),
        Effects      = true,
        EffectID     = 'rbxassetid://11581424342'
                       },

    Guns             = {
        Enabled      = true,
        Shotty       = true,
        Glock        = true,
        Knife        = true,
        Material     = Enum.Material.Neon,
        Transparency = 0.35,
        Color        = Color3.fromRGB(66, 3, 255)
                       },

    UserInterface    = {
        Ammo         = true,
        Cash         = true,
        CustomHUD    = false,
        Logo         = false,
        LogoID       = 'rbxassetid://11581658842',
        HUDColor     = Color3.fromRGB(66, 3, 255)
                       },
};

-- \|/ Services \|/ -----------------------------
local Players    = game:GetService('Players')
local RunService = game:GetService('RunService')

-- \|/ Variables  \|/ --
local Client     = Players.LocalPlayer

local ScreenGui  = Instance.new('ScreenGui')
local Frame      = Instance.new('Frame')
local ImageLabel = Instance.new('ImageLabel')
-------------------------------------------------

--[[

      DO NOT EDIT ANYTHING PAST THIS POINT.
       (Unless You Know What You're Doing)

]]--


-- \|/ Functions \|/ ----------------------------
getgenv().Trails = function(T)
    if Settings.Trails.Enabled then
        if T and T:IsA('Trail') then
            T.Color        = Settings.Trails.Color
            T.Brightness   = Settings.Trails.Brightness
            T.Texture      = Settings.Trails.Texture
            T.Transparency = Settings.Trails.Transparency
            if Settings.Trails.Time then
                T.Lifetime = Settings.Trails.TimeLength
            end
        end
    elseif Settings.Trails.Enabled ~= true then
            T.Color        = CNew(C3(255, 255, 255))
            T.Lifetime     = 0.2
            T.Brightness   = 1
            T.Texture      = ''
        end
    end
end

getgenv().Bullets = function(B)
    if Settings.Bullets.Enabled then
        if B and B:IsA('Part') and B.Name == 'Bullet' then
            B.Color        = Settings.Bullets.Color
            B.Material     = Settings.Bullets.Material
            B.Transparency = Settings.Bullets.Transparency
        end
    elseif Settings.Bullets.Enabled ~= true then
        if B and B:IsA('Part') and T.Name == 'Bullet' then
            T.Color        = C3(17, 17, 17)
            T.Material     = Enum.Material.Plastic
        end
    end
end

getgenv().Effects = function(E)
    if Settings.Bullets.Effects then
        if E and E:IsA('ParticleEmitter') and E.Name == 'Shell' then
            E.Texture = Settings.Bullets.EffectID
            E.Color   = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        end
    end
end

Client.Character.DescendantAdded:Connect(Trails)
Client.CharacterAdded:Connect(function()
Client.Character.DescendantAdded:Connect(Trails)
end)

Client.Character.DescendantAdded:Connect(Bullets)
Client.CharacterAdded:Connect(function()
Client.Character.DescendantAdded:Connect(Bullets)
end)

Client.Character.DescendantAdded:Connect(Effects)
Client.CharacterAdded:Connect(function()
Client.Character.DescendantAdded:Connect(Effects)
end)
-------------------------------------------------------------------------


-- \|/ Loop \|/ ---------------------------------------------------------
RunService.heartbeat:Connect(function()
    if Settings.Guns.Enabled then
        if Settings.Guns.Shotty then
            if Client.Character:FindFirstChild('Shotty') then
                for i,v in next, Client.Character.Shotty:GetChildren() do
                    if v:IsA('BasePart') and v.Name ~= 'Handle' then
                        v.Material     = Settings.Guns.Material
                        v.Color        = Settings.Guns.Color
                        v.Transparency = Settings.Guns.Transparency
                    end
                    if v:IsA('BasePart') and v.Name == 'Handle' then
                        v.Material     = Settings.Guns.Material
                        v.Color        = Settings.Guns.Color
                        v.Transparency = 1
                    end
                end
            end
        end
    end
    if Settings.Guns.Enabled then
        if Settings.Guns.Glock then
            if Client.Character:FindFirstChild('Glock') then
                for i,v in next, Client.Character.Glock:GetChildren() do
                    if v:IsA('BasePart') and v.Name ~= 'Barrel' then
                        v.Material     = Settings.Guns.Material
                        v.Color        = Settings.Guns.Color
                        v.Transparency = Settings.Guns.Transparency
                    end
                    if v:IsA('BasePart') and v.Name == 'Barrel' then
                        v.Material     = Settings.Guns.Material
                        v.Color        = Settings.Guns.Color
                        v.Transparency = 1
                    end
                end
            end
        end
    end
    --
    if Settings.Guns.Enabled then
        if Settings.Guns.Shotty then
            if Client.Character:FindFirstChild('Shotty') then
                for i,v in next, Client.Character.Shotty:GetChildren() do
                    if v:IsA('UnionOperation') then
                        v.UsePartColor = true
                    end
                end
            end
        end
    end
    if Settings.Guns.Enabled then
        if Settings.Guns.Glock then
            if Client.Character:FindFirstChild('Glock') then
                for i,v in next, Client.Character.Glock:GetChildren() do
                    if v:IsA('UnionOperation') then
                        v.UsePartColor = true
                    end
                end
            end
        end
    end
    --
    if Settings.Guns.Enabled then
        if Settings.Guns.Knife then
            if Client.Character:FindFirstChild('Knife') then
                for i,v in next, Client.Character.Knife:GetChildren() do
                    if v:IsA('MeshPart') then
                        v.Material     = Settings.Guns.Material
                        v.Color        = Settings.Guns.Color
                        v.Transparency = Settings.Guns.Transparency
                        v.TextureID    = ''
                    end
                end
            end
        end
    end
    local HUD = Client.PlayerGui:WaitForChild('HUD')
    local Tool = Client.Character:FindFirstChildOfClass('Tool')
    if Settings.UserInterface.Ammo then
        if Client.Character:FindFirstChildOfClass('Humanoid') then 
            if Tool and Tool:FindFirstChild('Ammo') then
                HUD.Ammo.RichText = true
                HUD.Ammo.Text     = '\n\n Ammo: <font color="rgb(66, 3, 255)">' .. Tool.Ammo.Value .. '</font>\nClips:  <font color="rgb(66, 3, 255)">'.. Tool.Clips.Value .. '</font>'
                HUD.Ammo.Font     = Enum.Font.TitilliumWeb
                HUD.Ammo.TextSize = 32
            end
        end
    end
    if Settings.UserInterface.Cash then
        HUD:WaitForChild('Cash').TextColor3             = Settings.UserInterface.HUDColor
        HUD:WaitForChild('Cash').TextStrokeColor3       = Color3.fromRGB(255, 255, 255)
        HUD:WaitForChild('Cash').Font                   = Enum.Font.TitilliumWeb
        HUD:WaitForChild('Cash').TextSize               = 32
    end
    if Settings.UserInterface.CustomHUD then
        HUD:WaitForChild('HP').BackgroundColor3       = Color3.fromRGB(0, 0, 0)
        HUD:WaitForChild('HP').BorderColor3           = Color3.fromRGB(5, 5, 5)
        HUD:WaitForChild('HP').Bar.BackgroundColor3   = Settings.UserInterface.HUDColor
        HUD:WaitForChild('HP').Bar.BorderColor3       = Color3.fromRGB(5, 5, 5)
    
        HUD:WaitForChild('KO').BackgroundColor3       = Color3.fromRGB(0, 0, 0)
        HUD:WaitForChild('KO').BorderColor3           = Color3.fromRGB(5, 5, 5)
        HUD:WaitForChild('KO').Bar.BackgroundColor3   = Settings.UserInterface.HUDColor
        HUD:WaitForChild('KO').Bar.BorderColor3       = Color3.fromRGB(5, 5, 5)
    
        HUD:WaitForChild('Stam').BackgroundColor3     = Color3.fromRGB(0, 0, 0)
        HUD:WaitForChild('Stam').BorderColor3         = Color3.fromRGB(5, 5, 5)
        HUD:WaitForChild('Stam').Bar.BackgroundColor3 = Settings.UserInterface.HUDColor
        HUD:WaitForChild('Stam').Bar.BorderColor3     = Color3.fromRGB(5, 5, 5)



        HUD.Mute.BackgroundColor3              = Color3.fromRGB(5, 5, 5)
        HUD.Mute.BorderColor3                  = Settings.UserInterface.HUDColor
        HUD.Mute.BorderSizePixel               = 2
        HUD.Mute.TextColor3                    = Color3.fromRGB(255, 255, 255)
        HUD.Mute.TextStrokeColor3              = Color3.fromRGB(0, 0, 0)
        HUD.Mute.BackgroundTransparency        = 0.3
        HUD.Mute.TextStrokeTransparency        = 0.3
        HUD.Mute.TextTransparency              = 0.3
        
        HUD.Shop.BackgroundColor3              = Color3.fromRGB(5, 5, 5)
        HUD.Shop.BorderColor3                  = Settings.UserInterface.HUDColor
        HUD.Shop.BorderSizePixel               = 2
        HUD.Shop.TextColor3                    = Color3.fromRGB(255, 255, 255)
        HUD.Shop.TextStrokeColor3              = Color3.fromRGB(0, 0, 0)
        HUD.Shop.TextSize                      = 45
        HUD.Shop.BackgroundTransparency        = 0.3
        HUD.Shop.TextStrokeTransparency        = 0.3
        HUD.Shop.TextTransparency              = 0.3
    
        HUD.Groups.BackgroundColor3            = Color3.fromRGB(5, 5, 5)
        HUD.Groups.BorderColor3                = Settings.UserInterface.HUDColor
        HUD.Groups.BorderSizePixel             = 2
        HUD.Groups.TextColor3                  = Color3.fromRGB(255, 255, 255)
        HUD.Groups.TextStrokeColor3            = Color3.fromRGB(0, 0, 0)
        HUD.Groups.TextSize                    = 37
        HUD.Groups.BackgroundTransparency      = 0.3
        HUD.Groups.TextStrokeTransparency      = 0.3
        HUD.Groups.TextTransparency            = 0.3
    
        HUD.ImageButton.BackgroundColor3       = Color3.fromRGB(5, 5, 5)
        HUD.ImageButton.BorderColor3           = Settings.UserInterface.HUDColor
        HUD.ImageButton.BorderSizePixel        = 2
        HUD.ImageButton.ImageColor3            = Color3.fromRGB(255, 255, 255)
        HUD.ImageButton.BackgroundTransparency = 0.3
        HUD.ImageButton.ImageTransparency      = 0.3
    end
end)
----------------------------------------------------------------


-- \|/ Logo \|/ ------------------------------------------------
ScreenGui.Parent                  = game.CoreGui
ScreenGui.ZIndexBehavior          = Enum.ZIndexBehavior.Sibling

Frame.Parent                      = ScreenGui
Frame.BackgroundColor3            = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency      = 1
Frame.Position                    = UDim2.new(0.85, 0, 0.75, 0)
Frame.Size                        = UDim2.new(0, 175, 0, 190)

ImageLabel.Parent                 = Frame
ImageLabel.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Size                   = UDim2.new(0, 190, 0, 205)
ImageLabel.Image                  = Settings.UserInterface.LogoID
-----------------------------------------------------------------


-- \|/ Logo Scripting \|/ ---------------------------------------
if Settings.UserInterface.Logo then
    ImageLabel.ImageTransparency = 0
else
    ImageLabel.ImageTransparency = 1
end

task.spawn(function()
    while wait() do
        ImageLabel.Rotation = 25
        wait(1)
        ImageLabel.Rotation = 0
        wait(1)
        ImageLabel.Rotation = -25
        wait(1)
        ImageLabel.Rotation = 0
        wait(1)
    end
end)
-----------------------------------------------------------------


-- \|/ Notification \|/ --------------------------------------------------------------------------------------------------
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/caIIings/Linoria-Rewrite/main/Library.lua'))()
Library.AccentColor = Color3.fromRGB(66, 3, 255)
Library:Notify('\"Gengar\" Theme Loaded! | Made By: call#0001')
--------------------------------------------------------------------------------------------------------------------------
