
-- [[ CONFIGURATION SETTINGS -- START ]]

local PLAY_SOUND_INTERVAL = 0.8 -- PLAY SOUND PER SECOND (number of seconds)
local SOUND_FILE = 12889 -- SOUND PLAYED, REFERENCE https://www.wowhead.com/classic/sounds
local SOUND_CHANNEL = "MASTER" -- SOUND CHANNEL USED FOR VOLUME ("MASTER", "SFX", "AMBIENCE", "MUSIC")
local SOUND_THRESHOLD = 20 -- NUMBER OF SECONDS UNTIL SOUND PLAYS (seconds remaining)
local BREATH_BAR_SCALE = 0.5 -- INCREASE IN SIZE OF BREATH BAR (0, 1)

-- [[ CONFIGURATION SETTINGS -- END ]]

for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    local frame = _G["MirrorTimer"..index]
    local text = _G[frame:GetName().."Text"]
    local lastPlayedSound = 0
    frame:HookScript("OnUpdate", function(self)
        if (self.timer == "BREATH") then
            frame:SetScale(1.5)
            local Min = math.floor(self.value / 60)
            local Sec = math.floor(self.value - (Min * 60))
            text:SetText("Breath (" .. string.format("%01d:%02d",Min,Sec) .. ")")

            if (self.value < SOUND_THRESHOLD) then
                if ((GetTime() - lastPlayedSound) > PLAY_SOUND_INTERVAL) then
                    PlaySound(SOUND_FILE, SOUND_CHANNEL)
                    lastPlayedSound = GetTime()
                end
            end
        end
    end)
end