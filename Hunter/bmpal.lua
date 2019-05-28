local dark_addon = dark_interface
local SB = dark_addon.rotation.spellbooks.hunter
local lftime = 0

--Local Spells not in default spellbook
SB.Bite = 17253
SB.Smack = 49962
SB.PetFrenzy = 272790
SB.AncestralCall = 274738
SB.Fireblood = 265221
SB.SpittingCobra = 194407
SB.LightsJudgement = 255647
SB.BloodFury = 20572
SB.Berserking = 26297
SB.LightsJudgement = 247427

local function combat()
  local usetraps = dark_addon.settings.fetch("bmpal_settings_traps", false)
  local usemisdirect = dark_addon.settings.fetch("bmpal_settings_misdirect", false)
  local race = UnitRace("player")

  if target.alive and target.enemy and not player.channeling() then
    auto_shot()
    if usetraps and modifier.shift and castable(SB.FreezingTrap) and spell(SB.FreezingTrap).cooldown == 0 then
      return cast(SB.FreezingTrap, "ground")
    end
    if usetraps and modifier.alt and castable(SB.TarTrap) and spell(SB.TarTrap).cooldown == 0 then
      return cast(SB.TarTrap, "ground")
    end
    if
      toggle("interrupts") and target.interrupt(50) and castable(SB.CounterShot) and spell(SB.CounterShot).cooldown == 0
     then
      return cast(SB.CounterShot, "target")
    end
    if toggle("cooldowns", false) and castable(SB.AspectOfTheWild) and spell(SB.AspectOfTheWild).cooldown == 0 then
      return cast(SB.AspectOfTheWild)
    end
    if
      toggle("cooldowns", false) and castable(SB.BeastialWrath) and spell(SB.BeastialWrath).cooldown == 0 and
        (-spell(SB.AspectOfTheWild) > 20 or target.time_to_die < 15)
     then
      return cast(SB.BeastialWrath)
    end
    if toggle("racial", false) and castable(SB.BeastialWrath) and spell(SB.BeastialWrath).cooldown > 30 then
      if race == "Orc" and castable(SB.BloodFury) then
        cast(SB.BloodFury)
      end
      if race == "Troll" and castable(SB.Berserking) then
        cast(SB.Berserking)
      end
      if race == "Mag'har Orc" and castable(SB.AncestralCall) then
        cast(SB.AncestralCall)
      end
      if race == "LightforgedDraenei" and castable(SB.LightsJudgement) then
        cast(SB.LightsJudgement)
      end
    end
    if pet.exists and not pet.alive then
      return cast(SB.RevivePet)
    end
    if pet.alive and pet.health.percent <= 70 and castable(SB.MendPet) and spell(SB.MendPet).cooldown == 0 then
      return cast(SB.MendPet)
    end
    if
      spell(SB.BarbedShot).charges >= 1 and pet.buff(SB.PetFrenzy).remains <= 1.75 and castable(SB.BarbedShot) and
        spell(SB.BarbedShot).cooldown == 0
     then
      return cast(SB.BarbedShot, "target")
    end
    if talent(7, 3) and castable(SB.SpittingCobra) and spell(SB.SpittingCobra).cooldown == 0 then
      return cast(SB.SpittingCobra)
    end
    if talent(4, 3) and castable(SB.AMurderOfCrows) and spell(SB.AMurderOfCrows).cooldown == 0 then
      return cast(SB.AMurderOfCrows, "target")
    end
    if
      talent(6, 3) and castable(SB.Stampede) and spell(SB.Stampede).cooldown == 0 and buff(SB.AspectOfTheWild).up and
        (buff(SB.BeastialWrath).up or target.time_to_die < 15)
     then
      return cast(SB.Stampede)
    end
    if
      toggle("multitarget", false) and enemies.around(40) > 2 and castable(SB.MultiShot) and
        spell(SB.MultiShot).cooldown == 0
     then
      return cast(SB.MultiShot, "target")
    end
    if toggle("multitarget", false) and talent(6, 2) and enemies.around(40) > 2 and spell(SB.Barrage).cooldown == 0 then
      return cast(SB.Barrage)
    end
    if talent(2, 3) and castable(SB.ChimaeraShot) and -power.focus < 90 and spell(SB.ChimaeraShot).cooldown == 0 then
      return cast(SB.ChimaeraShot, "target")
    end
    if -power.focus >= 30 and castable(SB.KillCommand) and spell(SB.KillCommand).cooldown == 0 then
      return cast(SB.KillCommand, "target")
    end
    if talent(1, 3) and castable(SB.DireBeast) and spell(SB.DireBeast).cooldown == 0 then
      return cast(SB.DireBeast, "target")
    end
    if
      -power.focus >= 80 and castable(SB.CobraShot) and spell(SB.CobraShot).cooldown == 0 and
        spell(SB.KillCommand).cooldown >= 2.5
     then
      return cast(SB.CobraShot, "target")
    end
    if
      (player.health.percent <= 50 or pet.health.percent <= 20) and castable(SB.Exhilaration) and
        spell(SB.Exhilaration).cooldown == 0
     then
      return cast(SB.Exhilaration)
    end
    if player.health.percent < 50 and castable(SB.AspectOfTheTurtle) and not spell(SB.Exhilaration).cooldown == 0 then
      return cast(SB.AspectOfTheTurtle)
    end
  end
end

local function resting()
  local lfg = GetLFGProposal()
  local hasData = GetLFGQueueStats(LE_LFG_CATEGORY_LFD)
  local hasData2 = GetLFGQueueStats(LE_LFG_CATEGORY_LFR)
  local hasData3 = GetLFGQueueStats(LE_LFG_CATEGORY_RF)
  local hasData4 = GetLFGQueueStats(LE_LFG_CATEGORY_SCENARIO)
  local hasData5 = GetLFGQueueStats(LE_LFG_CATEGORY_FLEXRAID)
  local hasData6 = GetLFGQueueStats(LE_LFG_CATEGORY_WORLDPVP)
  local bgstatus = GetBattlefieldStatus(1)
  local autojoin = dark_addon.settings.fetch("bmpal_settings_autojoin", true)
  local usemisdirect = dark_addon.settings.fetch("bmpal_settings_misdirect")
  local petselection = dark_addon.settings.fetch("bmpal_settings_petselector")

  if not pet.exists then
    if petselection == "key_1" then
      return cast(SB.CallPet1)
    elseif petselection == "key_2" then
      return cast(SB.CallPet2)
    elseif petselection == "key_3" then
      return cast(SB.CallPet3)
    elseif petselection == "key_4" then
      return cast(SB.CallPet4)
    elseif petselection == "key_5" then
      return cast(SB.CallPet5)
    end
  end
  if pet.exists and not pet.alive and castable(SB.RevivePet) and spell(SB.RevivePet).cooldown == 0 then
    return cast(SB.RevivePet)
  end
  if pet.alive and pet.health.percent <= 70 and spell(SB.MendPet).cooldown == 0 then
    return cast(SB.MendPet)
  end
end

function interface()
  local settings = {
    key = "bmpal_settings",
    title = "Beastmaster Hunter by Pal Team",
    width = 300,
    height = 380,
    fontheight = 10,
    resize = true,
    show = false,
    template = {
      {type = "header", text = "Pal Settings"},
      {type = "rule"},
      {type = "text", text = "Rotation: bmpal    Author: mPixels    Version: 81514"},
      {type = "text", text = "Class: Hunter    Spec: Beastmastery    Build: 1323211"},
      {type = "rule"},
      {type = "header", text = "General Settings"},
      {
        key = "autojoin",
        type = "checkbox",
        text = "Auto Join",
        desc = "Automatically accept Dungeon/Battleground Invites",
        default = true
      },
      {type = "rule"},
      {
        key = "traps",
        type = "checkbox",
        text = "Traps",
        desc = "Auto use Traps",
        default = false
      },
      {type = "rule"},
      {type = "header", text = "Pet Management"},
      {
        key = "petselector",
        type = "dropdown",
        text = "Pet Selector",
        desc = "select your active pet",
        default = "key_3",
        list = {
          {key = "key_1", text = "Pet 1"},
          {key = "key_2", text = "Pet 2"},
          {key = "key_3", text = "Pet 3"},
          {key = "key_4", text = "Pet 4"},
          {key = "key_5", text = "Pet 5"}
        }
      }
    }
  }
  configWindow = dark_addon.interface.builder.buildGUI(settings)

  dark_addon.interface.buttons.add_toggle(
    {
      name = "racial",
      label = "Use Racial",
      on = {
        label = "Racial",
        color = dark_addon.interface.color.orange,
        color2 = dark_addon.interface.color.ratio(dark_addon.interface.color.dark_orange, 0.7)
      },
      off = {
        label = "Racial",
        color = dark_addon.interface.color.grey,
        color2 = dark_addon.interface.color.dark_grey
      }
    }
  )

  dark_addon.interface.buttons.add_toggle(
    {
      name = "settings",
      label = "Rotation Settings",
      font = "dark_addon_icon",
      on = {
        label = dark_addon.interface.icon("cog"),
        color = dark_addon.interface.color.cyan,
        color2 = dark_addon.interface.color.dark_cyan
      },
      off = {
        label = dark_addon.interface.icon("cog"),
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
    }
  )
end

dark_addon.rotation.register(
  {
    spec = dark_addon.rotation.classes.hunter.beastmastery,
    name = "bmpal",
    label = "Beastmastery Hunter by Pal Team",
    combat = combat,
    resting = resting,
    interface = interface
  }
)
