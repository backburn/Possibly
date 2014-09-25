-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

local band = bit.band

local HostileEvents = {
        ['SWING_DAMAGE'] = true,
        ['SWING_MISSED'] = true,
        ['RANGE_DAMAGE'] = true,
        ['RANGE_MISSED'] = true,
        ['SPELL_DAMAGE'] = true,
        ['SPELL_PERIODIC_DAMAGE'] = true,
        ['SPELL_MISSED'] = true
}

PossiblyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)

  local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _ = ...

  if sourceName and destName and sourceName ~= '' and destName ~= '' then

    if HostileEvents[event] then

      if band(destFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 and band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then

        PossiblyEngine.module.combatTracker.tagUnit(sourceGUID, sourceName, timeStamp)
        local damage = select(15, ...)
        --PossiblyEngine.module.combatTracker.damageUnit(destGUID, damage)

      elseif band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 0 and band(destFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0 then

        PossiblyEngine.module.combatTracker.tagUnit(destGUID, destName, timeStamp)
        local damage = select(15, ...)
        PossiblyEngine.module.combatTracker.damageUnit(destGUID, damage)

      end

    end

  elseif (event == 'UNIT_DIED' or event == 'UNIT_DESTROYED' or event == 'UNIT_DISSIPATES') then

    PossiblyEngine.module.combatTracker.killUnit(destGUID)

  end

end)

PossiblyEngine.listener.register("UPDATE_MOUSEOVER_UNIT", function(...)
  local guid = UnitGUID('mouseover')
  if PossiblyEngine.module.combatTracker.enemy[guid] then
    PossiblyEngine.module.combatTracker.aquireHealth(guid, true)
    PossiblyEngine.module.combatTracker.aquireHealth(guid)
  end
end)
