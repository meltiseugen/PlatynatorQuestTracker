---@class addonTablePlatynator
local addonTable = select(2, ...)

addonTable.Display.EliteMarkerMixin = {}

function addonTable.Display.EliteMarkerMixin:PostInit()
  local markerDetails = addonTable.Assets.Markers[self.details.asset]
  local special = addonTable.Assets.SpecialEliteMarkers[self.details.asset]
  if markerDetails.mode == addonTable.Assets.Mode.Special and special then
    self.eliteTexture = addonTable.Assets.Markers[special.elite].file
    self.rareEliteTexture = addonTable.Assets.Markers[special.rareElite].file
  else
    self.eliteTexture = markerDetails.file
    self.rareEliteTexture = markerDetails.file
  end
end

function addonTable.Display.EliteMarkerMixin:SetUnit(unit)
  self.unit = unit
  self:UnregisterAllEvents()
  if self.unit then
    self:RegisterUnitEvent("UNIT_CLASSIFICATION_CHANGED", self.unit)
    self:Update()
  else
    self.marker:Hide()
  end
end

function addonTable.Display.EliteMarkerMixin:Strip()
  self:UnregisterAllEvents()
  self.eliteTexture = nil
  self.rareEliteTexture = nil
  self.PostInit = nil
end

function addonTable.Display.EliteMarkerMixin:Update()
  if not self.unit then
    self.marker:Hide()
    return
  end

  if self.details.openWorldOnly and addonTable.Display.Utilities.IsInRelevantInstance() then
    self.marker:Hide()
    return
  end

  local classification = UnitClassification(self.unit)
  if classification == "elite" or classification == "worldboss" then
    self.marker:Show()
    self.marker:SetTexture(self.eliteTexture)
  elseif classification == "rareelite" then
    self.marker:Show()
    self.marker:SetTexture(self.rareEliteTexture)
  else
    self.marker:Hide()
  end
end

function addonTable.Display.EliteMarkerMixin:OnEvent(eventName, ...)
  self:Update()
end
