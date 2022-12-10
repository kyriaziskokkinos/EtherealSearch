-- Author      : DeRed
-- Create Date : 11/29/2022 12:39:38 AM

local SearchInProgress = false
local found = false
local itemName = " "
local rarityFlags = {}
function Frame1_OnEvent(self,event,...)

	if ( event == "GOSSIP_SHOW" ) then
	
		if SearchInProgress then 
			GossipParse(GetGossipOptions()) 
			return
		end

		for i = 1, select("#", GetGossipOptions()),2 do
				local v = select(i, GetGossipOptions())
				if v:find("Vendor Item Recovery") then 
					Frame1:Show()
					return
				end
		end
		
	elseif ( event == "GOSSIP_CLOSED" ) then
			SearchInProgress = false
			ScanButton:SetText("Scan")
			Frame1:Hide()
	end

end

function ScanButton_OnClick()
	if not SearchInProgress then
		itemName = ItemNameField:GetText()
		rarityFlags["COMMON"] = FlagCommon:GetChecked()
		rarityFlags["UNCOMMON"] = FlagUncommon:GetChecked()
		rarityFlags["RARE"] = FlagRare:GetChecked()
		rarityFlags["EPIC"] = FlagEpic:GetChecked()

		if rarityFlags["COMMON"] or rarityFlags["UNCOMMON"] or  rarityFlags["RARE"] or  rarityFlags["EPIC"] then
			SearchInProgress = true
			ScanButton:SetText("Stop")
			GossipParse(GetGossipOptions())	
		else 
			print("Please Select a rarity to scan for.")
		end 
	else
		SearchInProgress = false
		ScanButton:SetText("Scan")
	end
end




function GossipParse(...)
			
        local id = 1
        for i = 1, select("#", ...),2 do
            local v = select(i, ...)
            
            if v:find("Vendor Item Recovery") then 
                
                SelectGossipOption(id)
				  
            elseif searchItem(string.lower(v),string.lower(itemName)) then
                found = true
                SelectGossipOption(id)
				return
                
            elseif v:find("Next Page")then          
                SelectGossipOption(id)
			end
            id = id +1
        end
end

function searchItem(string,name)
local s,e
	if rarityFlags["COMMON"] then
		if string.find(string,"ffffffff"..name,1, true) then 
		return true 
		end
	end
	if rarityFlags["UNCOMMON"] then
		if string.find(string,"ff1rff0c"..name,1, true) then 
		return true 
		end
	end
	if rarityFlags["RARE"] then
		if string.find(string,"ff0070ff"..name,1, true) then 
		return true 
		end
	end
	if rarityFlags["EPIC"] then
		if string.find(string,"ffa335ee"..name,1, true) then 
		return true 
		end
	end

	return false
end


hooksecurefunc("ChatEdit_InsertLink", function(link)
		if ItemNameField:IsVisible() and ItemNameField:HasFocus() then
		local name,_ = GetItemInfo(link)
		
			ItemNameField:Insert(name)
			return true
		end
end)