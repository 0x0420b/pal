local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.hunter

-- Tailored to the following build: 

--Globals
SB.Bite = 17253
SB.Smack = 49962
SB.WildfireBomb = 259495

local function GroupType()
    return IsInRaid() and 'raid' or IsInGroup() and 'party' or 'solo'
end

local function UseMD()
    if misdirect and group_type == 'raid' and tank.alive and target.enemy and targetoftarget == tank and castable(SB.Misdirection) and -spell(SB.Misdirection) == 0 then
        return cast(SB.Misdirection, 'tank')
    elseif misdirect and group_type == 'party' and tank.alive and target.enemy and targetoftarget == tank and castable(SB.Misdirection) and -spell(SB.Misdirection) == 0 then
        return cast(SB.Misdirection, 'tank')
    elseif misdirect and pet.alive and target.enemy and castable(SB.Misdirection) and -spell(SB.Misdirection) == 0 then
        return cast(SB.Misdirection, 'pet')
    end
end

local function gcd()
    -- Pet Claw
    if pet.target.enemy and castable(SB.Claw) and -spell(SB.Claw) == 0 then
        cast(SB.Claw)
    end
    -- Pet Bite
    if pet.target.enemy and castable(SB.Bite) and -spell(SB.Bite) ==0 then
        cast(SB.Bite)
    end
    -- Pet Smack
    if pet.target.enemy and castable(SB.Smack) and -spell(SB.Smack) == 0 then
        cast(SB.Smack)
    end
end

local function combat()
    ------------
    -- Settings
    ------------
    local usetraps = dark_addon.settings.fetch('spicysv_settings_traps')
    local usemisdirect = dark_addon.settings.fetch('spicysv_settings_misdirect')
    local race = UnitRace('player')
    local group_type = GroupType()
    
    if target.alive and target.enemy and not player.channeling then

        -- Auto use MD in combat
        UseMD()

        -------------
        -- Trap Usage
        -------------
        -- Freezing Trap
        if usetraps and modifier.shift and not modifier.alt and -spell(SB.FreezingTrap) == 0 then
            return cast(SB.FreezingTrap, 'ground')
        end
        -- TarTrap
        if usetraps and modifier.alt and not modifier.shift and -spell(SB.TarTrap) == 0 then
            return cast(SB.TarTrap, 'ground')
        end

        -------------
        -- Interrupts
        -------------
        if toggle('interrupts') and castable(SB.CounterShot) and target.interrupt(50) then
            return cast(SB.CounterShot)
        end

        -------------
        -- Auto Racial
        --------------
        -- if toggle('racial', false) and race then
        --     print (spicy_utils.getracial(race))
        --     --cast(spicy_utils.getracial(race))
        -- end

        -------------
        -- Cooldowns
        -------------
        -- Coordinated Assault
        if toggle('cooldowns', false) and castable(SB.CoordinatedAssault) and -spell(SB.CoordinatedAssault) == 0 then
            return cast(SB.CoordinatedAssault)
        end
        
        ---------------------
        -- Standard Abilities
        ---------------------
        -- Serpent Sting
        if castable(SB.SerpentSting) and not target.debuff(SB.SerpentSting).exists or target.debuff(SB.SerpentSting).remains < 2) then
            return cast(SB.SerpentSting, 'target')
        end
        -- Kill Command
        if -power.focus >= 30 and castable(SB.KillCommand) and -spell(SB.KillCommand) == 0 then
            return cast(SB.KillCommand, 'target')
        -- Wildfire Bomb
        if spell(SB.WildfireBomb).charges >= 1 and castable(SB.WildfireBomb) then
            return cast(SB.WildfireBomb, 'target')
        end
        -- Mongoose Bite
        if not buff.(SB.MongooseFury).exists or buff(SB.MongooseFury).count == 5 and castable(SB.MongooseBite) then
            return cast(SB.MongooseBite, 'target')
        end

        
        ----------------
        -- Pet Management
        -----------------
        -- Revive Pet
        if pet.exists and not pet.alive then
            return cast (SB.RevivePet)
        end
        -- Mend Pet
        if pet.alive and pet.health.percent <= 70 and -spell(SB.MendPet) == 0 then
            return cast(SB.MendPet)
        end

        --------------
        -- Defensives
        --------------
        -- Healthstone
        -- NEED TO DO THIS STILL

        -- Exhilaration
        if player.health.percent <= 50 or pet.health.percent <= 20 and castable(SB.Exhilaration) and -spell(SB.Exhilaration) == 0 then
            return cast(SB.Exhilaration)
        end
        -- Aspect of the Turtle
        if player.health.percent < 50 and not castable(SB.Exhilaration) then
            return cast(SB.AspectOfTheTurtle)
        end
    end        
end

local function resting()
    -- your resting rotation here!
    local petselection = dark_addon.settings.fetch('spicysv_settings_petselector')
    local group_type = GroupType()
    -- Call Pet out of combat
    if not pet.exists then
        if petselection == 'key_1' then
            return cast(SB.CallPet1)
        elseif petselection == 'key_2' then
            return cast(SB.CallPet2)
        elseif petselection == 'key_3' then
            return cast(SB.CallPet3)
        elseif petselection == 'key_4' then
            return cast(SB.CallPet4)
        elseif petselection == 'key_5' then
            return cast(SB.CallPet5)
        end
    end
    -- handle Misdirection outside of combat
    UseMD()
end

function interface()

    local settings = {
        key = 'spicysv_settings',
        title = 'Survival Hunter',
        width = 250,
        height = 380,
        resize = true,
        show = false,
        template = {
            { type = 'header', text = 'Spicy SV Settings'},
            { type = 'text', text = 'the suggested talent build:'},
            { type = 'text', text = ''},
            { type = 'rule'},
            { type = 'text', text = 'General Settings'},
            { key = 'misdirect', type = 'checkbox',
            text = 'Misdirection',
            desc = 'Auto Misdirect',
            default = false
            },
            { type = 'rule'},
            { type = 'text', text = 'Talents'},
            { type = 'rule'},
            { key = 'traps', type = 'checkbox',
            text = 'Traps',
            desc = 'Auto use Traps',
            default = false
            },
            { type = 'rule'},
            { type = 'text', text = 'Pet Management'},
            { key = 'petselector', type = 'dropdown',
                text = 'Pet Selector',
                desc = 'select your active pet',
                default = 'key_3',
                list = {
                    { key = 'key_1', text = 'Pet 1'},
                    { key = 'key_2', text = 'Pet 2'},
                    { key = 'key_3', text = 'Pet 3'},
                    { key = 'key_4', text = 'Pet 4'},
                    { key = 'key_5', text = 'Pet 5'}
                },
            }
        }
    }

    configWindow = dark_addon.interface.builder.buildGUI(settings)

    dark_addon.interface.buttons.add_toggle({
        name = 'racial',
        label = 'Use Racial',
        on = {
            label = 'Racial',
            color = dark_addon.interface.color.orange,
            color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
        },
        off = {
            label = 'Racial',
            color = dark_addon.interface.color.grey,
            color2 = dark_addon.interface.color.dark_grey
        }
    })
    
    dark_addon.interface.buttons.add_toggle({
        name = 'settings',
        label = 'Rotation Settings',
        font = 'dark_addon_icon',
        on = {
            label = dark_addon.interface.icon('cog'),
            color = dark_addon.interface.color.cyan,
            color2 = dark_addon.interface.color.dark_cyan
        },
        off = {
            label = dark_addon.interface.icon('cog'),
            color = dark_addon.interface.color.grey,
            color2 = dark_addon.interface.color.dark_grey
        },
        callback = function(self)
            if configWindow.parent:IsShown() then
                configWindow.parent:Hide()
            else
                configWindow.parent:Show()
            end
        end
    })
end

dark_addon.rotation.register({
    spec = dark_addon.rotation.classes.hunter.survival,
    name = 'spicy_rotations_survival',
    label = 'The Spiciest SV',
    combat = combat,
    gcd = gcd,
    resting = resting,
    interface = interface,
})