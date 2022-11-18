local SellThatCrap = {}

function SellThatCrap:SellJunk()
    for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemLink = C_Container.GetContainerItemLink(bag, slot)
            if itemLink then
                if C_Item.GetItemQualityByID(itemLink) == 0 then
                    print("Selling ", itemLink)
                    C_Container.UseContainerItem(bag, slot)
                end
            end
        end
    end
end

local function SellThatCrap_OnEvent(self, event, ...)
    if (event == "MERCHANT_SHOW") then
        SellThatCrap.SellJunk(self)
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", SellThatCrap_OnEvent)
