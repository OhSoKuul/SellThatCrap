local SellThatCrap = {}

function SellThatCrap:onList(itemLink)
    local name = C_Item.GetItemNameByID(itemLink)
    for k, v in ipairs(crapList) do
        local n = C_Item.GetItemNameByID(v)
        if n == name then
            return true
        end
    end
    return false
end

function SellThatCrap:isCrapOrOnList(bag, slot)
    local itemLink = C_Container.GetContainerItemLink(bag, slot)
    local crap = false
    if itemLink ~= nil then
        crap = C_Item.GetItemQualityByID(itemLink) == 0 or SellThatCrap:onList(itemLink)
    end
    if crap then
        print("Selling ", itemLink)
    end
    return crap
end

--########################### Frame Events

function SellThatCrap:MERCHANT_SHOW()
    for bag = BACKPACK_CONTAINER, NUM_TOTAL_EQUIPPED_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            if SellThatCrap:isCrapOrOnList(bag, slot) then
                C_Container.UseContainerItem(bag, slot)
            end
        end
    end
end

function SellThatCrap:VARIABLES_LOADED()
    if crapList == nil then
        crapList = {}
    end

    print("Thanks for using SellThatCrap.")
    print("#" .. table.maxn(crapList) .. " on the List.")
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("VARIABLES_LOADED")

frame:SetScript("OnEvent", function(this, event, ...)
    SellThatCrap[event](SellThatCrap, ...)
end)

--########################### CommandLine args

function SellThatCrap:add(args)
    local found = false
    for k, v in ipairs(crapList) do
        if v == args then
            found = true
            break
        end
    end
    if not found and args ~= nil then
        table.insert(crapList, args)
        print("Added " .. args .. " to CrapList")
    end
end

function SellThatCrap:show(args)
    print("#" .. table.maxn(crapList) .. " on the List:")
    for k, v in ipairs(crapList) do
        print(k, v)
    end
end

function SellThatCrap:rm(args)
    for k, v in ipairs(crapList) do
        if v == args then
            table.remove(crapList, k)
            print("Removed " .. args .. " from CrapList")
        end
    end
end

function SellThatCrap:clear(args)
    print("Clearing crap off of list")
    crapList = {}
end

function commandos(msg, editbox)
    local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
    if SellThatCrap[cmd] == nil then
        print("Syntax for /crap:");
        print("/crap add item - Add item to crapList");
        print("/crap rm  item - Remove item from crapList");
        print("/crap show     - List all crap in crapList");
        print("/crap clear    - Remove everything from crapList");
    else
        SellThatCrap[cmd](SellThatCrap,args)
    end
end

SLASH_CRAP1 = "/crap"
SlashCmdList["CRAP"] = commandos
