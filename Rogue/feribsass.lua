-- Assa Rogue for 8.3 - 4/2020
-- Level 20 twinks only :p

-- its forked from furrylock, cba changing all vars urg

local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.rogue

local function combat()
  if target.alive and target.enemy then
    
	-- main combat logic
	
	-- Check for healing
	if toggle('use_heal_flask', false) and castable(SB.CrimsonVial) and -player.health <= 80 then
	  return cast(SB.CrimsonVial)
	end
	
	-- Garrote keep up on main
	if castable(SB.Garrote) and -spell(SB.Garrote) == 0 and player.buff(SB.Garrote).down and target.debuff(SB.Garrote).down then
	  return cast(SB.Garrote)
	end
	
	if castable(SB.Rupture) and -spell(SB.Rupture) == 0 and player.power.combopoints.actual > 0 and target.debuff(SB.Rupture).down then
	  return cast(SB.Rupture)
	end 
	
	
	-- check nearby
	if toggle('dot_all', false) then
	   local usegarrote = true --dark_addon.settings.fetch('furrylock_corruption_dot')
	   local userupture = true --dark_addon.settings.fetch('furrylock_agony_dot')
	   local index = 0
	   local NotMain = true
	   local MainTarget = UnitGUID("target")
	   TargetNearestEnemy()
	   while(NotMain)
	   do
		  -- check buffs up
		  local RuptureDur
		  local GarroteDur

		  for i = 1, 40 do
			 name, a, b, c, d, dur = UnitDebuff("target", i, "PLAYER")
			 if (name == "Rupture") then
				RuptureDur = dur   
			 elseif(name == "Garrote") then
				GarroteDur = dur   
			 end
		  end
		  -- update buffs
		  if userupture and (RuptureDur == nil or RuptureDur-5 < GetTime()) and target.alive then
			CastSpellByName("Rupture")
		  end
		  if usegarrote and (GarroteDur == nil or GarroteDur-5 < GetTime()) and target.alive then
			CastSpellByName("Garrote")
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
	
	if castable(SB.SinisterStrike) and -spell(SB.SinisterStrike) == 0
	and ((player.power.energy.actual > 69 and player.power.combopoints.actual < 5 and player.power.combopoints.actual > 0)
	or player.power.combopoints.actual == 0 and target.debuff(SB.Garrote).up) then
      return cast(SB.SinisterStrike)
    end


  end
end

local function gcd()
	local usesoulstone = true --dark_addon.settings.fetch('furrylock_soulstone')
	local usehealthstone = true --dark_addon.settings.fetch('furrylock_healthstone.checked')
	local healthstonepercent = 25 --dark_addon.settings.fetch('furrylock_healthstone.spin')
	
	if player.combat then
		if toggle('dot_all2', false) then
		   local usegarrote = true --dark_addon.settings.fetch('furrylock_corruption_dot')
		   local userupture = true --dark_addon.settings.fetch('furrylock_agony_dot')
		   local index = 0
		   local NotMain = true
		   local MainTarget = UnitGUID("target")
		   TargetNearestEnemy()
		   while(NotMain)
		   do
			  -- check bug Agony & Corruption
			  --local HasAgony = false
			  --local HasCorruption = false
			  local RuptureDur
			  local GarroteDur

			  for i = 1, 40 do
				 name, a, b, c, d, dur = UnitDebuff("target", i, "PLAYER")
				 if (name == "Rupture") then
					--HasRupture = true  
					RuptureDur = dur   
				 elseif(name == "Garrote") then
					--HasCorruption = true  
					GarroteDur = dur   
				 end
			  end
			  -- update buffs
			  if userupture and (RuptureDur == nil or RuptureDur-5 < GetTime()) and target.alive then
				CastSpellByName("Rupture")
			  end
			  if usegarrote and (GarroteDur == nil or GarroteDur-2 < GetTime()) and target.alive then
				CastSpellByName("Garrote")
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
    key = 'Ferib20Rogue',
    title = 'Ferib - Rogue',
    width = 250,
    height = 320,
    resize = true,
    show = false,
    template = {
      { type = 'header', text = 'Assa Rogue Settings', align= 'center' },
      { type = 'text', text = 'Rotation is developed by Ferib, you can find Ferib at https://ferib.dev/' }, 
	  --[[ { type = 'text', text = 'alt: Drain Life, shift: Fear, ctrl: Seed of Corruption' },
	  { type = 'rule' },   
      { type = 'text', text = 'General Settings' },
      { key = 'agony_dot', type = 'checkbox', text = 'Agony Dot', desc = 'Use Agony for dots ' },
      { key = 'corruption_dot', type = 'checkbox', text = 'Corruption Dot', desc = 'Use Corruption for dots ' },
	  { key = 'soulstone', type = 'checkbox', text = 'Auto Soulstone', desc = 'Automaticly use Soulstone' },
      { key = 'healthstone', type = 'checkspin', text = 'Healthstone', desc = 'Auto use Healthstone at health %', min = 5, max = 85, step = 5 },
      { type = 'rule' },    ]]--
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
    name = 'use_heal_flask',
    label = 'Use Crimson Vial',
    font = 'dark_addon_icon',
    on = {
      label = dark_addon.interface.icon('flask'),
      color = dark_addon.interface.color.purple,
      color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_red, 0.7)
    },
    off = {
      label = dark_addon.interface.icon('flask'),
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
  spec = dark_addon.rotation.classes.rogue.assassination,
  name = 'FeribA',
  label = 'Level 20 Assasination Rogue',
  combat = combat,
  resting = resting,
  gcd = gcd,
  interface = interface
})

