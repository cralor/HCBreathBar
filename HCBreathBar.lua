
-- [[ CONFIGURATION SETTINGS -- START ]]

local PLAY_SOUND_INTERVAL = 0.8 -- PLAY SOUND PER SECOND (number of seconds)
local SOUND_FILE = 12889 -- SOUND PLAYED, REFERENCE https://www.wowhead.com/classic/sounds
local SOUND_CHANNEL = "MASTER" -- SOUND CHANNEL USED FOR VOLUME ("MASTER", "SFX", "AMBIENCE", "MUSIC")
local SOUND_THRESHOLD = 20 -- NUMBER OF SECONDS UNTIL SOUND PLAYS (seconds remaining)
local BREATH_BAR_SCALE = 150 -- INCREASE IN SIZE OF BREATH BAR (%)

-- [[ CONFIGURATION SETTINGS -- END ]]

local alert = CreateFrame("Frame", nil, UIParent)
alert:SetWidth(1)
alert:SetHeight(1)
alert:SetPoint("TOP", 0, -50)
alert.text = alert:CreateFontString(nil, "ARTWORK")
alert.text:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
alert.text:SetText("Do NOT use SPACEBAR to surface.") -- AVOID DISCONNECTING FROM THE SERVER WHILE UNDER WATER
alert.text:SetPoint("CENTER", 0, 0)
alert:Hide()

for index = 1, MIRRORTIMER_NUMTIMERS, 1 do
    local frame = _G["MirrorTimer"..index]
    local text = _G[frame:GetName().."Text"]
    local lastPlayedSound = 0
    frame:HookScript("OnUpdate", function(self)
        if (self.timer == "BREATH") then
            if InCombatLockdown() then
                alert:Show()
            else
                alert:Hide()
            end
            frame:SetScale(BREATH_BAR_SCALE / 100)
            local Min = math.floor(self.value / 60)
            local Sec = math.floor(self.value - (Min * 60))
            text:SetText("Breath (" .. string.format("%01d:%02d",Min,Sec) .. ")")

            if (self.value < (SOUND_THRESHOLD / 2)) then
                if ((GetTime() - lastPlayedSound) > (PLAY_SOUND_INTERVAL / 2)) then
                    PlaySound(SOUND_FILE, SOUND_CHANNEL)
                    lastPlayedSound = GetTime()
                end
            elseif (self.value < SOUND_THRESHOLD) then
                if ((GetTime() - lastPlayedSound) > PLAY_SOUND_INTERVAL) then
                    PlaySound(SOUND_FILE, SOUND_CHANNEL)
                    lastPlayedSound = GetTime()
                end
            end
        end
    end)
end