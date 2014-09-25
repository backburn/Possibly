-- PossiblyEngine Rotations - https://possiblyengine.com/
-- Released under modified BSD, see attached LICENSE.

PossiblyEngine.tooltip = {
  frame = CreateFrame('GameTooltip', 'PE_ScanningTooltip', UIParent, 'GameTooltipTemplate')
}

PossiblyEngine.tooltip.scan = function(target, pattern, scanType)

  if scanType == nil or scanType == 'buff' then
    -- buffs
    for i = 1, 40 do
      PossiblyEngine.tooltip.frame:SetOwner(UIParent, 'ANCHOR_NONE')
      PossiblyEngine.tooltip.frame:SetUnitBuff(target, i)
      local tooltipText = _G["PE_ScanningTooltipTextLeft2"]:GetText()
      if tooltipText then
        if type(pattern) == 'string' then
          local match = tooltipText:lower():match(pattern)
          if match then return true end
        elseif type(pattern) == 'table' then
          for _, curPattern in pairs(pattern) do
            local match = tooltipText:lower():match(curPattern)
            if match then return true end
          end
        end
      end
    end
  elseif scanType == 'debuff' then
    -- debuffs
    for i = 1, 40 do
      PossiblyEngine.tooltip.frame:SetOwner(UIParent, 'ANCHOR_NONE')
      PossiblyEngine.tooltip.frame:SetUnitDebuff(target, i)
      local tooltipText = _G["PE_ScanningTooltipTextLeft2"]:GetText()
      if tooltipText then
        if type(pattern) == 'string' then
          local match = tooltipText:lower():match(pattern)
          if match then return true end
        elseif type(pattern) == 'table' then
          for _, curPattern in pairs(pattern) do
            local match = tooltipText:lower():match(curPattern)
            if match then return true end
          end
        end
      end
    end
  end
  return false
end