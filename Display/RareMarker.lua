---@class addonTablePlatynator
local addonTable = select(2, ...)

addonTable.Display.RareMarkerMixin = {}

function addonTable.Display.RareMarkerMixin:SetUnit(unit)
  self.unit = unit
  self:UnregisterAllEvents()
  if self.unit then
    self:RegisterUnitEvent("UNIT_CLASSIFICATION_CHANGED", self.unit)
    self:Update()
  else
    self:Strip()
  end
end

function addonTable.Display.RareMarkerMixin:Update()
  if not self.unit then
    self.marker:Hide()
    return
  end

  local classification = UnitClassification(self.unit)
  local show = classification == "rare" or (self.details.includeElites and classification == "rareelite")
  self.marker:SetShown(show)
end

function addonTable.Display.RareMarkerMixin:Strip()
  self:UnregisterAllEvents()
end

function addonTable.Display.RareMarkerMixin:OnEvent(eventName, ...)
  self:Update()
end
