local SellThatCrap = {}
local crapList = {}

function SellThatCrap:onList(itemLink)
    if C_Item.GetItemQualityByID(itemLink) == 0 then
        return true
    end
    local name = C_Item.GetItemNameByID(itemLink)
    for k, v in ipairs(crapList) do
        local n = C_Item.GetItemNameByID(v)
        if n == name then
            return true
        end
    end
    return false;
end

function SellThatCrap:isCrap(bag, slot)
    local itemLink = C_Container.GetContainerItemLink(bag, slot)
    return itemLink and SellThatCrap:onList(itemLink)
end

function SellThatCrap:SellJunk()
    for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            if SellThatCrap:isCrap(bag, slot) then
                local itemLink = C_Container.GetContainerItemLink(bag, slot)
                print("Selling ", itemLink)
                C_Container.UseContainerItem(bag, slot)
            end
        end
    end
end

local function SellThatCrap_OnEvent(self, event, ...)
    if (event == "MERCHANT_SHOW") then
        SellThatCrap.SellJunk(self)
    end
end

function commands(msg, editbox)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if cmd == "add" and args ~= "" then
        local found = false
        for k, v in ipairs(crapList) do
            if v == args then
                found = true
                break
            end
        end
        if not found then
            table.insert(crapList, args)
            print("Added " .. args .. " to CrapList")
        end
    elseif cmd == "show" then
        print("#" .. table.maxn(crapList) .. " on the List:")
        for k, v in ipairs(crapList) do
            print(k, v)
        end
    elseif cmd == "rm" and args ~= "" then
        for k, v in ipairs(crapList) do
            if v == args then
                table.remove(crapList, k)
                print("Removed " .. args .. " from CrapList")
            end
        end
    elseif cmd == "clear" then
        print("Clearing crap off of list")
        crapList = {}
    else
        -- If not handled above, display some sort of help message
        print("Syntax for /crap:");
        print("/crap add item - Add item to crapList");
        print("/crap rm  item - Remove item from crapList");
        print("/crap show     - List all crap in crapList");
        print("/crap clear    - Remove everything from crapList");
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", SellThatCrap_OnEvent)

SLASH_CRAP1 = "/crap"
SlashCmdList["CRAP"] = commands
