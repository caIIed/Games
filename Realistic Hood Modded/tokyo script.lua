if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local TimeDecimals     = 1
local Time             = os.clock()

-- [[ Script Settings ]] --

local Script_Name      = 'tokyo'
local Script_Suffix    = '.pf'

local Script_Title     = '' .. Script_Name .. Script_Suffix .. ''

local Version          = '2.0.0'
local Game_Name        = 'Realistic Hood Modded'

-- [[ Settings ]] -- 

local Settings = {
    Enabled = false,
    
    ToggleKey = 'T',
    
    TeamCheck = false,
    VisibleCheck = true, 
    TargetPart = 'Head',
    Method = 'Raycast',
    
    FOVVisible = true,
    FOVRadius = 210,
    FOVColor  = Color3.fromRGB(114, 111, 181),
    FOVSides = 8,
    FOVFilled = false,
    FOVTransparency = 1,
    FOVThickness = 2,

    TargetBox  = true,
    TargetBoxColor = Color3.fromRGB(114, 111, 181),
    TargetBoxSize = 35,
    TargetBoxThickness = 1,
    TargetBoxFilled = false,
    TargetBoxTransparency = 1,

    GunModifications = false,
    NoRecoil = true,
    NoSpread = true,
    HitSound = true,
    HitSoundID = 'HitMarker',
    InfiniteAmmo = true,
    OneShot = true,

    AutoShoot = false,
    AutoShootKey = 'F',
    ClickDelay = 0.01,

    ESPEnabled = false,
    ESPTarget = false,
    ESPNames = true,
    ESPHealthBar = true,

    ESPBoxes = true,
    ESPBoxColor = Color3.fromRGB(255, 255, 255),

    ESPDistance = true,
    ESPDistancePos = 'Bottom',

    ESPHealth = true,
    ESPHealthPos = 'Left',
    ESPHealthColor = Color3.fromRGB(0, 255, 0),

    ESPTool = true,
    ESPToolPos = 'Bottom',

    GunChams = false,
    GunChamsColor = Color3.fromRGB(114, 111, 181),
    GunChamsMaterial = 'ForceField',
    GunChamsTransparency = 0,

    CharacterChams = false,
    CharacterChamsColor = Color3.fromRGB(114, 111, 181),
    CharacterChamsMaterial = 'ForceField',
    CharacterChamsTransparency = 0,

    Beams = false,
    BeamColor = Color3.fromRGB(114, 111, 181),
    BeamWidth = 0.75,
    ShowImpactPoint = false,
    ImpactTransparency = 0.5,
    ImpactColor = Color3.new(1, 1, 1),
    BeamTime = 1,
    BeamTransparency = 0,
    BeamBrightness = 3,
    BeamFaceCamera = true,

    NoBlur = true,
    FullBright = false,
    RageVision = false,
    RageColor = Color3.fromRGB(114, 111, 181),
    RageAmmount = 0.3,

    Blink = false,
    BlinkKey = 'V',
    BlinkSpeed = 1.6,
    Noclip = false,
    NoclipKey = 'X',
    InfiniteJump = false,
};


-- [[ Data Import ]] --
local ESP, ESP_RenderStep, Framework = loadstring(game:HttpGet('https://raw.githubusercontent.com/caIIings/Librarys/main/ESP/NoMercy.lua'))();
ESP.Settings.Enabled = Settings.ESPEnabled;
ESP.Settings.Maximal_Distance = 1000;
ESP.Settings.Object_Maximal_Distance = 1000;
ESP.Settings.Box.Enabled = Settings.ESPBoxes;
ESP.Settings.Box_Outline.Enabled = true;
ESP.Settings.Box.Color = Settings.ESPBoxColor;
ESP.Settings.Healthbar.Enabled = Settings.ESPHealthBar;
ESP.Settings.Health.Enabled = Settings.ESPHealth;
ESP.Settings.Health.Position = Settings.ESPHealthPos;
ESP.Settings.Distance.Enabled = Settings.ESPDistance;
ESP.Settings.Distance.Position = Settings.ESPDistancePos;
ESP.Settings.Tool.Enabled = Settings.ESPTool;
ESP.Settings.Tool.Position = Settings.ESPToolPos;
ESP.Settings.Name.Enabled = Settings.ESPNames;
ESP.Settings.Name.Position = 'Top';

-- [[ Variables ]] --

local Workspace    = game:GetService('Workspace')
local Players      = game:GetService('Players')
local RunService   = game:GetService('RunService')
local InputService = game:GetService('UserInputService')

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()
local Camera      = Workspace.CurrentCamera
local Camera2     = Workspace.Camera

local GetChildren = game.GetChildren
local GetPlayers = Players.GetPlayers
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GetMouseLocation = InputService.GetMouseLocation

local ValidTargetParts = {'Head', 'HumanoidRootPart'}
local AimbotIndicator

local Funcs = {}

local resume = coroutine.resume 
local create = coroutine.create

local Target_Box = Drawing.new('Square')
Target_Box.Visible = false 
Target_Box.ZIndex = 999 
Target_Box.Color = Color3.fromRGB(114, 111, 181)
Target_Box.Thickness = 2
Target_Box.Size = Vector2.new(35, 35)
Target_Box.Filled = false 

local FOV_Circle = Drawing.new('Circle')
FOV_Circle.Thickness = 1
FOV_Circle.NumSides = 100
FOV_Circle.Radius = 180
FOV_Circle.Filled = false
FOV_Circle.Visible = false
FOV_Circle.ZIndex = 3000
FOV_Circle.Transparency = 1
FOV_Circle.Color = Color3.fromRGB(114, 111, 181)

local BeamPart = Instance.new('Part')
BeamPart.Name = 'BeamPart'
BeamPart.Transparency = 1
BeamPart.Parent = Workspace

local ColorCorrection = Instance.new('ColorCorrectionEffect')
ColorCorrection.Parent = game.Lighting


-- [[ Menu ]] --
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/caIIings/Librarys/main/octohook/Source.lua'))({cheatname = Script_Title, gamename = Game_Name, discordinvite = 'discord.gg/calling', discordcode = 'calling', menukey = Enum.KeyCode.RightBracket})
Library:init()
local Menu = Library.NewWindow({title = Library.cheatname .. ' - Private | ' ..   Library.gamename, size = UDim2.new(0, 500, 0, 520)})

-- // Tabs
local Combat   = Menu:AddTab('Combat')
local Visuals  = Menu:AddTab('Visuals')
local Misc     = Menu:AddTab('Miscellaneous')
local Configs  = Library:CreateSettingsTab(Menu, 'Settings')

-- // Aimbot Section
local Aimbot = Combat:AddSection('Bullet Redirection', 1)

local AimbotToggle = Aimbot:AddToggle({ state = Settings.Enabled, risky = false, text = 'Enabled', flag = 'aimbotflag', callback = function(bool) Settings.Enabled = bool end })
local TeamCheckToggle = Aimbot:AddToggle({ state = Settings.TeamCheck, risky = false, text = 'Team Check', flag = 'teamcheckflag', callback = function(bool) Settings.TeamCheck = bool end })
local VisibleCheckToggle = Aimbot:AddToggle({ state = Settings.VisibleCheck, risky = false, text = 'Visible Check', flag = 'visiblecheckflag', callback = function(bool) Settings.VisibleCheck = bool end })
local AimbotPart = Aimbot:AddList({ text = 'Target Part', selected = 'Head', multi = false, values = { 'Head', 'HumanoidRootPart'}, callback = function(bool) Settings.TargetPart = bool end })

AimbotToggle:AddBind({ text = 'Aimbot', mode = 'toggle', risky = false, flag = 'AimbotKeybind', nomouse = false, noindicator = false, bind = Enum.KeyCode[Settings.ToggleKey], callback = function(bool) AimbotToggle:SetState(bool) end })

-- // FOV Section
local Aimbot2 = Combat:AddSection('FOV', 2)

local FOVToggle = Aimbot2:AddToggle({ state = Settings.FOVVisible, risky = false, text = 'Enabled', flag = 'fovflag', callback = function(bool) Settings.FOVVisible = bool end })
local FOVColorPicker = FOVToggle:AddColor({ text = 'FOV Color', color = Settings.FOVColor, flag = '', callback = function(color) Settings.FOVColor = color end })
local FOVFilled = Aimbot2:AddToggle({ state = Settings.FOVFilled, risky = false, text = 'Filled', flag = 'fovflag', callback = function(bool) Settings.FOVFilled = bool end })
local FOVRadiusSlider = Aimbot2:AddSlider({ text = 'Radius', flag = '', suffix = '°', value = Settings.FOVRadius, min = 0, max = 1200, increment = 1, callback = function(value) Settings.FOVRadius = value end })
local FOVTransparencySlider = Aimbot2:AddSlider({ text = 'Transparency', flag = '', suffix = '°', value = Settings.FOVTransparency, min = 0, max = 1, increment = 0.1, callback = function(v) Settings.FOVTransparency = v end })
local FOVSidesSlider = Aimbot2:AddSlider({ text = 'Sides', flag = '', suffix = '°', value = Settings.FOVSides, min = 0, max = 120, increment = 1, callback = function(v) Settings.FOVSides = v end })
local FOVThicknessSlider = Aimbot2:AddSlider({ text = 'Thickness', flag = '', suffix = '°', value = Settings.FOVThickness, min = 0, max = 12, increment = 1, callback = function(v) Settings.FOVThickness = v end })

-- // Target Visualizer Section
local Aimbot3 = Combat:AddSection('Target Visualizer', 2)

local TargetBoxToggle = Aimbot3:AddToggle({ state = Settings.TargetBox, risky = false, text = 'Enabled', flag = '', callback = function(bool) Settings.TargetBox = bool end })
local TargetBoxFilled = Aimbot3:AddToggle({ state = Settings.TargetBoxFilled, risky = false, text = 'Filled', flag = 'fovflag', callback = function(bool) Settings.TargetBoxFilled = bool end })
local TargetBoxColorPicker = Aimbot3:AddColor({ text = 'Target Visualizer Color', color = Settings.TargetBoxColor, flag = '', callback = function(color) Settings.TargetBoxColor = color end })
local TargetBoxSizeSlider = Aimbot3:AddSlider({ text = 'Size', flag = '', suffix = '°', value = Settings.TargetBoxSize, min = 0, max = 60, increment = 1, callback = function(value) Settings.TargetBoxSize = value end })
local TargetBoxThicknessSlider = Aimbot3:AddSlider({ text = 'Thickness', flag = '', suffix = '°', value = Settings.TargetBoxThickness, min = 0, max = 10, increment = 1, callback = function(value) Settings.TargetBoxThickness = value end })
local TargetBoxTransparencySlider = Aimbot3:AddSlider({ text = 'Transparency', flag = '', suffix = '°', value = Settings.TargetBoxThickness, min = 0, max = 1, increment = 0.1, callback = function(value) Settings.TargetBoxThickness = value end })

-- // Modifications
local Aimbot4 = Combat:AddSection('Gun Modifications', 1)

local ModificationsToggle = Aimbot4:AddToggle({ state = Settings.GunModifications, risky = false, text = 'Enabled', flag = '', callback = function(bool) Settings.GunModifications = bool end })
local Divider1 = Aimbot4:AddSeparator({ text = 'Modifications' })
local NoRecoilToggle = Aimbot4:AddToggle({ state = Settings.NoRecoil, risky = false, text = 'No Recoil', flag = '', callback = function(bool) Settings.NoRecoil = bool end })
local NoSpreadToggle = Aimbot4:AddToggle({ state = Settings.NoSpread, risky = false, text = 'No Spread', flag = '', callback = function(bool) Settings.NoSpread = bool end })
local HitSoundToggle = Aimbot4:AddToggle({ state = Settings.HitSound, risky = false, text = 'Hit Sound', flag = '', callback = function(bool) Settings.HitSound = bool end })
local InfiniteAmmoToggle = Aimbot4:AddToggle({ state = Settings.InfiniteAmmo, risky = false, text = 'Infinite Ammo', flag = '', callback = function(bool) Settings.InfiniteAmmo = bool end })
local OneShotToggle = Aimbot4:AddToggle({ state = Settings.OneShot, risky = false, text = 'One Shot', flag = '', callback = function(bool) Settings.OneShot = bool end })
local HitSoundSelector = Aimbot4:AddList({ text = 'Hit Sound', selected = Settings.HitSoundID, multi = false, values = { 'Hit Marker'}, callback = function(bool) Settings.HitSoundID = bool end })

-- // Combat Settings
local Aimbot5 = Combat:AddSection('Settings', 1)
local AutoShootToggle = Aimbot5:AddToggle({ state = Settings.AutoShoot, risky = true, text = 'Auto Fire (FPS Loss)', flag = '', callback = function(bool) Settings.AutoShoot = bool end })
local AutoShootDelaySlider = Aimbot5:AddSlider({ text = 'Auto Fire Delay', flag = '', suffix = '°', value = Settings.ClickDelay, min = 0, max = 2, increment = 0.01, callback = function(value) Settings.ClickDelay = value end })

AutoShootToggle:AddBind({ text = 'Auto Fire', mode = 'toggle', risky = false, flag = 'AutoFireKeybind', nomouse = false, noindicator = false, bind = Enum.KeyCode[Settings.AutoShootKey], callback = function(bool) AutoShootToggle:SetState(bool) end })

-- // ESP Section
local ESPSection = Visuals:AddSection('ESP', 1)

local ESPEnabledToggle = ESPSection:AddToggle({ state = Settings.ESPEnabled, risky = false, text = 'Enabled', flag = '', callback = function(bool) Settings.ESPEnabled = bool end })
local ESPNamesToggle = ESPSection:AddToggle({ state = Settings.ESPNames, risky = false, text = 'Names', flag = '', callback = function(bool) Settings.ESPNames = bool end })
local ESPBoxesToggle = ESPSection:AddToggle({ state = Settings.ESPBoxes, risky = false, text = 'Boxes', flag = '', callback = function(bool) Settings.ESPBoxes = bool end })
local ESPBoxesColorPicker = ESPBoxesToggle:AddColor({ text = 'ESP Box Color', color = Settings.ESPBoxColor, flag = '', callback = function(color) Settings.ESPBoxColor = color end })
local ESPHealthBarToggle = ESPSection:AddToggle({ state = Settings.ESPHealthBar, risky = false, text = 'Health Bar', flag = '', callback = function(bool) Settings.ESPHealthBar = bool end })
local ESPHealthTextToggle = ESPSection:AddToggle({ state = Settings.ESPHealth, risky = false, text = 'Health Text', flag = '', callback = function(bool) Settings.ESPHealth = bool end })
local ESPHealthPositionSelector = ESPSection:AddList({ text = 'Health Position', selected = Settings.ESPHealthPos, multi = false, values = { 'Top', 'Bottom', 'Left', 'Right' }, callback = function(bool) Settings.ESPHealthPos = bool end })
local ESPToolToggle = ESPSection:AddToggle({ state = Settings.ESPTool, risky = false, text = 'Tool', flag = '', callback = function(bool) Settings.ESPTool = bool end })
local ESPToolPositionSelector = ESPSection:AddList({ text = 'Tool Position', selected = Settings.ESPToolPos, multi = false, values = { 'Top', 'Bottom', 'Left', 'Right' }, callback = function(bool) Settings.ESPToolPos = bool end })
local ESPDistanceToggle = ESPSection:AddToggle({ state = Settings.ESPDistance, risky = false, text = 'Distance', flag = '', callback = function(bool) Settings.ESPDistance = bool end })
local ESPDistancePositionSelector = ESPSection:AddList({ text = 'Distance Position', selected = Settings.ESPDistancePos, multi = false, values = { 'Top', 'Bottom', 'Left', 'Right' }, callback = function(bool) Settings.ESPDistancePos = bool end })

-- // ESP Section
local GunsSection = Visuals:AddSection('Guns', 2)

local GunChamsToggle = GunsSection:AddToggle({ state = Settings.GunChams, risky = false, text = 'Gun Chams', flag = '', callback = function(bool) Settings.GunChams = bool end })
local GunChamsColorPicker = GunChamsToggle:AddColor({ text = 'Gun Chams Color', color = Settings.GunChamsColor, flag = '', callback = function(color) Settings.GunChamsColor = color end })
local GunChamsMaterialSelector = GunsSection:AddList({ text = 'Gun Chams Material', selected = Settings.GunChamsMaterial, multi = false, values = { 'ForceField', 'Neon', 'SmoothPlastic' }, callback = function(bool) Settings.GunChamsMaterial = bool end })
local GunChamsTransparencySlider = GunsSection:AddSlider({ text = 'Transparency', flag = '', suffix = '°', value = Settings.GunChamsTransparency, min = 0, max = 1, increment = 0.1, callback = function(value) Settings.GunChamsTransparency = value end })
local Divider2 = GunsSection:AddSeparator({ text = 'Character Chams' })
local CharacterChamsToggle = GunsSection:AddToggle({ state = Settings.CharacterChams, risky = false, text = 'Character Chams', flag = '', callback = function(bool) Settings.CharacterChams = bool end })
local CharacterChamsColorPicker = CharacterChamsToggle:AddColor({ text = 'Character Chams Color', color = Settings.CharacterChamsColor, flag = '', callback = function(color) Settings.CharacterChamsColor = color end })
local CharacterChamsMaterialSelector = GunsSection:AddList({ text = 'Character Chams Material', selected = Settings.CharacterChamsMaterial, multi = false, values = { 'ForceField', 'Neon', 'SmoothPlastic' }, callback = function(bool) Settings.CharacterChamsMaterial = bool end })
local CharacterChamsTransparencySlider = GunsSection:AddSlider({ text = 'Transparency', flag = '', suffix = '°', value = Settings.CharacterChamsTransparency, min = 0, max = 1, increment = 0.1, callback = function(value) Settings.CharacterChamsTransparency = value end })


-- // Bullets Section
local BulletSection = Visuals:AddSection('Bullets', 1)

local BeamToggle = BulletSection:AddToggle({ state = Settings.Beams, risky = false, text = 'Bullet Trails', flag = '', callback = function(bool) Settings.Beams = bool end })
local BeamColorPicker = BeamToggle:AddColor({ text = 'Gun Chams Color', color = Settings.BeamColor, flag = '', callback = function(color) Settings.BeamColor = color end })
local BeamFaceCameraToggle = BulletSection:AddToggle({ state = Settings.BeamFaceCamera, risky = false, text = 'Face Camera', flag = '', callback = function(bool) Settings.BeamFaceCamera = bool end })
local BeamTimeSlider = BulletSection:AddSlider({ text = 'Time', flag = '', suffix = '°', value = Settings.BeamTime, min = 0, max = 4, increment = 0.1, callback = function(value) Settings.BeamTime = value end })
local BeamTransparencySlider = BulletSection:AddSlider({ text = 'Transparency', flag = '', suffix = '°', value = Settings.BeamTransparency, min = 0, max = 1, increment = 0.1, callback = function(value) Settings.BeamTransparency = value end })
local BeamBrightnessSlider = BulletSection:AddSlider({ text = 'Brightness', flag = '', suffix = '°', value = Settings.BeamBrightness, min = 0, max = 8, increment = 1, callback = function(value) Settings.BeamBrightness = value end })
local BeamWidthSlider = BulletSection:AddSlider({ text = 'Width', flag = '', suffix = '°', value = Settings.BeamWidth, min = 0, max = 8, increment = 0.01, callback = function(value) Settings.BeamWidth = value end })

-- // Map Section
local MapSection = Visuals:AddSection('Map', 2)

local NoBlurToggle = MapSection:AddToggle({ state = Settings.NoBlur, risky = false, text = 'No Blur', flag = '', callback = function(bool) Settings.NoBlur = bool end })
local FullBrightToggle = MapSection:AddToggle({ state = Settings.FullBright, risky = false, text = 'Full Bright', flag = '', callback = function(bool) Settings.FullBright = bool end })
local SkyBoxList = MapSection:AddList({ 
    text = 'Sky Box', 
    selected = Settings.SkyBox, 
    multi = false, 
    values = { 'Default', 'Galaxy' }, 
    callback = function(bool) 
        local Sky = game:GetService('Lighting').Sky
        if bool == 'Galaxy' then
            Sky.SkyboxBk = 'rbxassetid://159454299'
            Sky.SkyboxDn = 'rbxassetid://159454296'
            Sky.SkyboxFt = 'rbxassetid://159454293'
            Sky.SkyboxLf = 'rbxassetid://159454286'
            Sky.SkyboxRt = 'rbxassetid://159454300'
            Sky.SkyboxUp = 'rbxassetid://159454288'
        elseif bool == 'Default' then
            Sky.SkyboxBk = 'rbxassetid://600830446'
            Sky.SkyboxDn = 'rbxassetid://600831635'
            Sky.SkyboxFt = 'rbxassetid://600832720'
            Sky.SkyboxLf = 'rbxassetid://600886090'
            Sky.SkyboxRt = 'rbxassetid://600833862'
            Sky.SkyboxUp = 'rbxassetid://600835177'
        end
    end 
})
local Divider3 = MapSection:AddSeparator({ text = 'Rage' })
local RageVisionToggle = MapSection:AddToggle({ state = Settings.RageVision, risky = false, text = 'Rage Vision', flag = '', callback = function(bool) Settings.RageVision = bool end })
local RageVisionColorPicker = RageVisionToggle:AddColor({ text = 'Rage Color', color = Settings.RageColor, flag = '', callback = function(color) Settings.RageColor = color end })
local RageVisionAmmount = MapSection:AddSlider({ text = 'Rage Strength', flag = '', suffix = '°', value = Settings.RageAmmount, min = 0, max = 1, increment = 0.1, callback = function(value) Settings.RageAmmount = value end })

-- // Movement Section
local MovementSection = Misc:AddSection('Movement', 1)

local BlinkSpeedToggle = MovementSection:AddToggle({ state = Settings.Blink, risky = false, text = 'Blink', flag = '', callback = function(bool) Settings.Blink = bool end })
local BlinkSpeedSlider = MovementSection:AddSlider({ text = 'Blink Speed', flag = '', suffix = '°', value = Settings.BlinkSpeed, min = 0, max = 6, increment = 0.1, callback = function(value) Settings.BlinkSpeed = value end })
local NoclipToggle = MovementSection:AddToggle({ state = Settings.Noclip, risky = false, text = 'Noclip', flag = '', callback = function(bool) Settings.Noclip = bool end })
local InfinitJump = MovementSection:AddToggle({ state = Settings.InfiniteJump, risky = false, text = 'Infinite Jump', flag = '', callback = function(bool) Settings.InfiniteJump = bool end })

BlinkSpeedToggle:AddBind({ text = 'Blink Key', mode = 'toggle', risky = false, flag = 'BlinkSpeedKeybind', nomouse = false, noindicator = false, bind = Enum.KeyCode[Settings.BlinkKey], callback = function(bool) BlinkSpeedToggle:SetState(bool) end })
NoclipToggle:AddBind({ text = 'Noclip Key', mode = 'toggle', risky = false, flag = 'NoclipKeybind', nomouse = false, noindicator = false, bind = Enum.KeyCode[Settings.NoclipKey], callback = function(bool) NoclipToggle:SetState(bool) end })

-- [[ Functions ]] --
local ExpectedArguments = {
    Raycast = {
        ArgCountRequired = 3,
        Args = {
            'Instance', 'Vector3', 'Vector3', 'RaycastParams'
        }
    }
}

-- // Exploit Section
local ExploitSection = Misc:AddSection('Exploits', 2)


local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then
        return false
    end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end

local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local function getMousePosition()
    return GetMouseLocation(InputService)
end

local function IsPlayerVisible(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = LocalPlayer.Character
    
    if not (PlayerCharacter or LocalPlayerCharacter) then return end 
    
    local PlayerRoot = FindFirstChild(PlayerCharacter, Settings.TargetPart) or FindFirstChild(PlayerCharacter, 'HumanoidRootPart')
    
    if not PlayerRoot then return end 
    
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end

local function getClosestPlayer()
    if not Settings.TargetPart then return end
    local Closest
    local DistanceToMouse
    for _, Player in next, GetPlayers(Players) do
        if Player == LocalPlayer then continue end

        local Character = Player.Character
        if not Character then continue end
        
        if Settings.VisibleCheck and not IsPlayerVisible(Player) then continue end

        local HumanoidRootPart = FindFirstChild(Character, 'HumanoidRootPart')
        local Head = FindFirstChild(Character, 'Head')
        local Humanoid = FindFirstChild(Character, 'Humanoid')
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end


        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (getMousePosition() - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or Settings.FOVRadius or 2000) then
            Closest = ((Settings.TargetPart == 'Random' and Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]) or Character[Settings.TargetPart])
            DistanceToMouse = Distance
        end
    end
    return Closest
end

function Funcs:Beam(v1, v2)

    local Part = Instance.new('Part')
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CFrame = CFrame.new(v1)
    Part.Anchored = true
    Part.Parent = BeamPart

    local Attachment = Instance.new('Attachment')
    Attachment.Parent = Part

    local Part2 = Instance.new('Part')
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.Transparency = ShowImpactPoint and Settings.ImpactTransparency or 1
    Part2.CanCollide = false
    Part2.CFrame = CFrame.new(v2)
    Part2.Anchored = true
    Part2.Color = Settings.ImpactColor
    Part2.Parent = BeamPart

    local Attachment2 = Instance.new('Attachment')
    Attachment2.Parent = Part2

    local Beam = Instance.new('Beam')
    Beam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Settings.BeamColor), ColorSequenceKeypoint.new(1, Settings.BeamColor) })
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.LightEmission = 3.5
    Beam.LightInfluence = 0
    Beam.Texture = 'http://www.roblox.com/asset/?id=7151778302'
    Beam.TextureMode = Enum.TextureMode.Wrap
    Beam.TextureSpeed = 3
    Beam.TextureLength = 8
    Beam.Transparency = NumberSequence.new(Settings.BeamTransparency)
    Beam.ZOffset = 1
    Beam.Width0 = Settings.BeamWidth
    Beam.Width1 = Settings.BeamWidth
    Beam.Segments = 10
    Beam.Brightness = Settings.BeamBrightness
    Beam.FaceCamera = Settings.BeamFaceCamera
    Beam.Enabled = true
    Beam.Parent = Part
    task.wait(Settings.BeamTime)
    Beam.Transparency = NumberSequence.new(1)
    Part:Destroy()
    Part2:Destroy()
end

function GetGun()
    if LocalPlayer.Character then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:FindFirstChild('ACS_Settings') then
                return v
            end
        end
    end
    return nil
end

function GetGunName()
    if LocalPlayer.Character then
        for i, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:FindFirstChild('ACS_Settings') then
                return v.Name
            end
        end
    end
    return nil
end

resume(create(function()
    RunService.RenderStepped:Connect(function()
        if Settings.TargetBox and Settings.Enabled then
            if getClosestPlayer() then 
                local Root = getClosestPlayer().Parent.PrimaryPart or getClosestPlayer()
                local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Camera, Root.Position);
            
                Target_Box.Visible = true
                Target_Box.Color = Settings.TargetBoxColor
                Target_Box.Thickness = Settings.TargetBoxThickness
                Target_Box.Size = Vector2.new(Settings.TargetBoxSize, Settings.TargetBoxSize)
                Target_Box.Filled = Settings.TargetBoxFilled
                Target_Box.Transparency = Settings.TargetBoxTransparency

                Target_Box.Position = Vector2.new(RootToViewportPoint.X, RootToViewportPoint.Y)
            else 
                Target_Box.Visible = false 
                Target_Box.Position = Vector2.new()
            end
        end
        if Settings.Enabled and Settings.FOVVisible then 
            FOV_Circle.Visible = true
            FOV_Circle.Color = Settings.FOVColor
            FOV_Circle.Thickness = Settings.FOVThickness
            FOV_Circle.NumSides = Settings.FOVSides
            FOV_Circle.Radius = Settings.FOVRadius
            FOV_Circle.Transparency = Settings.FOVTransparency
            if Settings.FOVFilled then
                FOV_Circle.Filled = true
                FOV_Circle.Transparency = 0.4
            else
                FOV_Circle.Filled = false
                FOV_Circle.Transparency = Settings.FOVTransparency
            end

            FOV_Circle.Position = getMousePosition()
        else
            FOV_Circle.Visible = false
            FOV_Circle.Position = getMousePosition()
        end
        if Settings.GunModifications then
            if LocalPlayer.Character:FindFirstChildOfClass('Tool') then
                Gun = LocalPlayer.Character[GetGunName()]
                local Script = Gun.ACS_Settings
                local Module = require(Script)
                if Settings.InfiniteAmmo then
                    Module['Ammo'] = math.huge
                    Module['MaxStoredAmmo'] = math.huge
                    Module['StoredAmmo'] = math.huge
                end
                if Settings.NoRecoil then
                    Module['gunRecoil']['gunRecoilTilt'] = { 0, 0 }
                    Module['gunRecoil']['gunRecoilUp'] = { 0, 0 }
                    Module['gunRecoil']['gunRecoilLeft'] = { 0, 0 }
                    Module['gunRecoil']['gunRecoilRight'] = { 0, 0 }
                    Module['camRecoil']['camRecoilUp'] = { 0, 0 }
                    Module['camRecoil']['camRecoilRight'] = { 0, 0 }
                    Module['camRecoil']['camRecoilLeft'] = { 0, 0 }
                    Module['camRecoil']['camRecoilTilt'] = { 0, 0 }
                end
                if Settings.NoSpread then
                    Module['MinSpread'] = 0
                    Module['MaxSpread'] = 0
                end
                if Settings.OneTap then
                    Module['LimbDamage'] = { 900, 900 } 
                    Module['TorsoDamage'] = { 900, 900 }
                    Module['HeadDamage'] = { 900, 900 }
                    Module['MinDamage'] = 900
                end
            end
        end
        if Settings.AutoShoot and Target_Box.Visible then
            if LocalPlayer.Character:FindFirstChildOfClass('Tool') then
                mouse1click()
                wait(Settings.ClickDelay)
            end
        end
        if LocalPlayer.Character:FindFirstChildOfClass('Tool') then
            if Camera:FindFirstChild('Viewmodel') then
                for i, v in pairs(Camera.Viewmodel:GetDescendants()) do
                    if Settings.GunChams then
                        if v:IsA('BasePart') or v:IsA('MeshPart') then
                            if v.Name ~= 'Right Arm' and v.Name ~= 'Left Arm' and v.Name ~= 'AimPart' then
                                v.Color = Settings.GunChamsColor
                                v.Material = Settings.GunChamsMaterial
                                v.Transparency = Settings.GunChamsTransparency
                            end
                        end
                    end
                    if Settings.CharacterChams then
                        if v:IsA('BasePart') and v.Name == 'Right Arm' or v.Name == 'Left Arm' then
                            v.Color = Settings.CharacterChamsColor
                            v.Material = Settings.CharacterChamsMaterial
                            v.Transparency = Settings.CharacterChamsTransparency
                        elseif v:IsA('Shirt') then
                            v:Destroy()
                        end
                    end
                    if Settings.HitSound and Settings.GunModifications then
                        if v:IsA('Sound') and v.Name == 'Fire' or v.Name == 'Fire2' or v.Name == 'Suppressor' then
                            if Settings.HitSoundID == 'HitMarker' then
                                v.SoundId = 'rbxassetid://3748780065'
                            end
                        end
                    end
                end
            end
        end
        if Settings.Beams then
            if InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                task.wait(0.01)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head') then
                    Gun = GetGun()
                    if Gun then
                        local Closest =  getClosestPlayer()
                        if Settings.Enabled and Closest and Target_Box.Visible then
                            Funcs:Beam(Camera and Camera.CFrame.p or LocalPlayer.Character.Head.Position, Closest.Position)
                            task.wait(1.1)
                        else
                            Funcs:Beam(Camera and Camera.CFrame.p or LocalPlayer.Character:FindFirstChild('Head').Position, Mouse.Hit.Position)
                            task.wait(1.1)
                        end
                    end
                end
            end
        end
        
        ESP.Settings.Enabled = Settings.ESPEnabled;

        ESP.Settings.Box.Enabled = Settings.ESPBoxes;
        ESP.Settings.Box.Color = Settings.ESPBoxColor;
        
        ESP.Settings.Healthbar.Enabled = Settings.ESPHealthBar;
        ESP.Settings.Healthbar.Position = Settings.ESPHealthPos;
        ESP.Settings.Healthbar.Color = Settings.ESPHealthColor;
        
        ESP.Settings.Health.Enabled = Settings.ESPHealth;
        ESP.Settings.Health.Position = Settings.ESPHealthPos;
    
        
        ESP.Settings.Distance.Enabled = Settings.ESPDistance;
        ESP.Settings.Distance.Position = Settings.ESPDistancePos;
        
        ESP.Settings.Tool.Enabled = Settings.ESPTool;
        ESP.Settings.Tool.Position = Settings.ESPToolPos;
        
        ESP.Settings.Name.Enabled = Settings.ESPNames;
    end)
end))

if Settings.NoBlur then
    game.Lighting:WaitForChild('Blur'):Destroy()
end

resume(create(function()
    RunService.Heartbeat:Connect(function()
        if Settings.FullBright then
            game:GetService('Lighting').Brightness = 4
            game:GetService('Lighting').FogEnd = 100000
            game:GetService('Lighting').GlobalShadows = false
            game:GetService('Lighting').ClockTime = 12
        end
        if Settings.RageVision then
            ColorCorrection.TintColor = Settings.RageColor
            ColorCorrection.Brightness = Settings.RageAmmount
        else
            ColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
            ColorCorrection.Brightness = 0
        end
    end)
end))

resume(create(function()
    RunService.Stepped:Connect(function()
        if Settings.Blink then
            HumanoidRootPart = LocalPlayer.Character:WaitForChild('HumanoidRootPart')
            Humanoid = LocalPlayer.Character:WaitForChild('Humanoid')
            MoveDirection = Humanoid.MoveDirection
            if not InputService:GetFocusedTextBox() and (InputService:IsKeyDown(Enum.KeyCode.W) or InputService:IsKeyDown(Enum.KeyCode.S) or InputService:IsKeyDown(Enum.KeyCode.A) or InputService:IsKeyDown(Enum.KeyCode.D)) then
                HumanoidRootPart.CFrame += ((MoveDirection.Magnitude > 0 and MoveDirection or HumanoidRootPart.CFrame.LookVector) * Settings.BlinkSpeed)
            end
        end
        if Settings.Noclip then
            for i,v in next, LocalPlayer.Character:GetDescendants() do
                if v and v:IsA('BasePart') then
                    v.CanCollide = false
                end
            end
        end
    end)
end))

InputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Jumping')
    end
end)


-- [[ Rendering ESP ]] --

for _, Player in pairs(Players:GetPlayers()) do
    if Player == LocalPlayer then continue; end;
    ESP:Player(Player);
end;

Players.PlayerAdded:Connect(function(Player)
    ESP:Player(Player);
end);

Players.PlayerAdded:Connect(function(Player)
    local obj = ESP:GetObject(Player)
    if obj then
        obj:Destroy();
    end;
end)

-- [[ Hooks ]] --
local oldNamecall
oldNamecall = hookmetamethod(game, '__namecall', newcclosure(function(...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]
    if Settings.Enabled and self == Workspace and not checkcaller() then
        if Method == 'Raycast' and Settings.Method == Method then
            if ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                local A_Origin = Arguments[2]

                local HitPart = getClosestPlayer()
                if HitPart then
                    Arguments[3] = getDirection(A_Origin, HitPart.Position)
                    return oldNamecall(unpack(Arguments))
                end
            end
        end
    end
    return oldNamecall(...)
end))

local TimeTakenToLoad = (string.format('%.'..tostring(TimeDecimals)..'f', os.clock() - Time))
Library:SendNotification('Loaded in Aprox, ' .. TimeTakenToLoad .. '! ', 5, Color3.fromRGB(114, 111, 181));
