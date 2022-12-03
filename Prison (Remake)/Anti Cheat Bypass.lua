local DetectedMethods = {
   'BreakJoints';
   'Destroy';
   'ClearAllChildren';
}

local Rep = game:GetService("ReplicatedStorage")
local OldIndex = nil

OldIndex = hookmetamethod(game, '__index', function(Self, Key)
    if not checkcaller() and Self == Rep and Key == 'iiii'" and Key == 'lIIl' and Key == '17136949562f245c6041' then
        return wait(9e9)
    end

    if DetectedMethods[method] and self == game.Players.LocalPlayer.Character then
        return wait(9e9)
    end

    return OldIndex(Self, Key)
end)

getgenv()['AntiCheatSettings'] = {};
getgenv()['AntiCheatSettings']['Adonis'] = true;
getgenv()['AntiCheatSettings']['HD Admin'] = true;
local Settings ={
   ['Adonis'] = getgenv()['AntiCheatSettings']['Adonis'] or false,
   ['HD Admin'] = getgenv()['AntiCheatSettings']['HD Admin'] or false,
}

if Settings['Adonis'] then
   local GetFullName = game.GetFullName
   local Hook;
   Hook = hookfunction(getrenv().require, newcclosure(function(...)
       local Args = {...}

       if not checkcaller() then
           if (GetFullName(getcallingscript()) == '.ClientMover' and Args[1].Name == 'Client') then
               return wait(9e9)
           end
       end

       return Hook(unpack(Args))
   end))
end
if Settings['HD Admin'] then
   local Hook;
   Hook = hookfunction(getrenv().require, newcclosure(function(...)
       local Args = {...}

       if not checkcaller() then
           if (getcallingscript().Name == 'HDAdminStarterPlayer' and Args[1].Name == 'MainFramework') then
               return wait(9e9)
           end
       end

       return Hook(unpack(Args))
   end))
end

game.Players.LocalPlayer.Character.DescendantAdded:Connect(function(p)
   if p:IsA('BodyGyro') or p:IsA('BodyAngularVelocity') or p:IsA('BodyVelocity') or p:IsA('BodyPosition') then
       p.Name = 'Tempby'
   end
end)
