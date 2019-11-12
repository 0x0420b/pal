-- Affliction Warlock for 8.1 by Ferib - 07/2019
-- Talents: Any
-- Holding Alt = Drain Life -> target
-- Holding Shift = Fear -> target
-- Holding Control = Seed of Corruption -> target
-- Multitarget will cause Seed of Corruption on current target (buggy)

-- NOTE: in order to make proper use of multidotting, use TargetNearbyEnemy (default key: tab) in order to target your targets, or else the rotation bugs on targeting (sometimes)

local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.warlock

local function combat()
  if target.alive and target.enemy and not player.channeling() then
	local usecorruption = true --dark_addon.settings.fetch('furrylock_corruption_dot')
	local useagony = true --dark_addon.settings.fetch('furrylock_agony_dot')
	
    if player.spell(SB.SummonDarkglare).lastcast and -spell(SB.DarksoulMisery) == 0 and talent (7,3) then
      return cast(SB.DarksoulMisery)
    end
    if player.spell(SB.UnstableAffliction).lastcast and -spell(SB.DeathBolt) == 0 and talent(1,3) then
      return cast(SB.DeathBolt)
    end
    --if GetItemCooldown(159615) == 0 and player.power.soulshards.actual == 0 then
   --    macro('/use 13') 
   -- end
    -- Keybinds
    if modifier.alt then
      return cast(SB.DrainLife, 'target')
    end
    if modifier.shift then
      return cast(SB.Fear, 'target')
    end
	if IsControlKeyDown() and player.power.soulshards.actual > 0 then
		return cast(SB.SeedOfCorruption, 'target')
	end

    -- Lets maintain our dots on our target
    if not target.debuff(SB.CorruptionDebuff) or target.debuff(SB.CorruptionDebuff).remains <= 4.2 then
      return cast(SB.Corruption, 'target')
    end
    if not target.debuff(SB.Agony) or target.debuff(SB.Agony).remains <= 4.4 then
      return cast(SB.Agony, 'target')
    end
    if not target.debuff(SB.SiphonLife) or target.debuff(SB.SiphonLife).remains <= 4.5 and talent(2,3) then
      return cast(SB.SiphonLife)
    end
	-- maintain focus dots while multi targetting
	if toggle('dot_focus', false) then
		if focus.alive and focus.enemy then
			if useagony and not focus.debuff(SB.Agony) or focus.debuff(SB.Agony).remains <= 5 then
			  return cast(SB.Agony, 'focus')
			end
			if usecorruption and not focus.debuff(SB.CorruptionDebuff) or focus.debuff(SB.CorruptionDebuff).remains <= 5 then
			  return cast(SB.Corruption, 'focus')
			end
		end
	end

    -- Lets get into some CD's
    if -target.debuff(SB.CorruptionDebuff) and -target.debuff(SB.Agony) and player.power.soulshards.actual == 0 and -target.debuff(SB.UAdebuffTwo) and toggle('cooldowns', false) and -spell(SB.SummonDarkglare) == 0 and (-target.debuff(SB.SiphonLife) or not talent(2,3)) then
      return cast(SB.SummonDarkglare)
    end
    if player.power.soulshards.actual == 5 then
      return cast(SB.UnstableAffliction, 'target')
    end
    if talent(6,2) and -spell(SB.Haunt) == 0 then
      return cast(SB.Haunt)
    end
    if talent(4,2) and -spell(SB.PhantonSing) == 0 then
      return cast(SB.PhantonSing)
    end
    if talent(4,3) and -spell(SB.VileTaint) == 0 then
      return cast(SB.VileTaint)
    end
    if player.power.soulshards.actual > 0 then
      return cast(SB.UnstableAffliction, 'target')
    end
	--if toggle('multitarget', false) and not target.debuff(SB.SeedOfCorruption) and player.power.soulshards.actual > 0 then
    --  return cast(SB.SeedOfCorruption, 'target')
    --end
	
	
	
    if talent(1,2) then 
      return cast(SB.DrainSoul)
    end
    if not player.channeling() and not talent(1,2) then
      return cast(SB.ShadowBolt) 
    end
	
  end
end

local function gcd()
	local usesoulstone = true --dark_addon.settings.fetch('furrylock_soulstone')
	local usehealthstone = true --dark_addon.settings.fetch('furrylock_healthstone.checked')
	local healthstonepercent = 25 --dark_addon.settings.fetch('furrylock_healthstone.spin')
	if player.combat then
		if toggle('dot_all', false) then
			local usecorruption = true --dark_addon.settings.fetch('furrylock_corruption_dot')
			local useagony = true --dark_addon.settings.fetch('furrylock_agony_dot')
		   local index = 0
		   local NotMain = true
		   local MainTarget = UnitGUID("target")
		   TargetNearestEnemy()
		   while(NotMain)
		   do
			  -- check bug Agony & Corruption
			  --local HasAgony = false
			  --local HasCorruption = false
			  local AgonyDur
			  local CorruptionDur

			  for i = 1, 40 do
				 name, a, b, c, d, dur = UnitDebuff("target", i, "PLAYER")
				 if (name == "Agony") then
					--HasAgony = true  
					AgonyDur = dur   
				 elseif(name == "Corruption") then
					--HasCorruption = true  
					CorruptionDur = dur   
				 end
			  end
			  -- update buffs
			  if useagony and (AgonyDur == nil or AgonyDur-5 < GetTime()) and target.alive then
				CastSpellByName("Agony")
			  end
			  if usecorruption and (CorruptionDur == nil or CorruptionDur-5 < GetTime()) and target.alive then
				CastSpellByName("Corruption")
			  end
			  --Check for next
			  TargetNearestEnemy()
			  --Check Stuff
			  if(MainTarget == UnitGUID("target") or index == 30) then
				 NotMain = false
			  end
			  index = index + 1
		   end
		--print("Done, back to main '" .. UnitName("target") .. "' " .. index);
		end
	end
	--Check for healthstone & soulstone
	--if GetItemCooldown(5512) == 0 and player.health.percent < healthstonepercent and usehealthstone == true then
	--  macro('/use Healthstone')
	--end
	--if usesoulstone and GetSpellCooldown(SB.Soulstone) == 0 then
	--	return cast(SB.Soulstone, 'player')
	--end
end

local function resting() end

-- interface and stuff

local function interface()

  local example = {
    key = 'furrylock',
    title = 'Furrylock - Warlock',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Affliction Warlock Settings', align= 'center' },
      { type = 'text', text = 'Rotation is developed by Ferib, you can find Ferib at https://ferib.dev/gg.' }, 
	  { type = 'text', text = 'alt: Drain Life, shift: Fear, ctrl: Seed of Corruption' },
	  { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
      { key = 'agony_dot', type = 'checkbox', text = 'Agony Dot', desc = 'Use Agony for dots ' },
      { key = 'corruption_dot', type = 'checkbox', text = 'Corruption Dot', desc = 'Use Corruption for dots ' },
	  { key = 'soulstone', type = 'checkbox', text = 'Auto Soulstone', desc = 'Automaticly use Soulstone' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %', min = 5, max = 85, step = 5 },
      { type = 'rule' },   
    }
  }

  configWindow = dark_addon.interface.builder.buildGUI(example)

  dark_addon.interface.buttons.add_toggle({
    name = 'dot_focus',
    label = 'Dot focus',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('circle'),
      color = dark_addon.interface.color.purple,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_purple, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('circle'),
      color = dark_addon.interface.color.grey,
      color2 = dark_addon.interface.color.dark_grey
    }
  })
  
    dark_addon.interface.buttons.add_toggle({
    name = 'dot_all',
    label = 'Dot all nearby enemy\'s',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('braille'),
      color = dark_addon.interface.color.purple,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_purple, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('braille'),
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
      color2 = dark_addon.interface.color.dark_blue
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
  spec = dark_addon.rotation.classes.warlock.affliction,
  name = 'FerryAffliction',
  label = 'Bundled Affliction by Rotations',
  combat = combat,
  resting = resting,
  gcd = gcd,
  interface = interface
})

