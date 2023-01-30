-- Author      : DeRed
-- Create Date : 11/29/2022 12:39:38 AM

local SearchInProgress = false
local itemName = " "
local rarityFlags = {}
local dropDown
local dropDownOptions = {
	{
		["text"] = "Vendored Item",
		["checked"] = true
	},
	{		
		["text"] = "Deleted Item",
		["checked"] = false
	}
}
local function getSelectedOptionText()
	for optionID,attributes in ipairs(dropDownOptions) do
		if attributes["checked"] then
			return attributes["text"]
		end
	end
	--print("DEBUG getSelectedOptionText(): ".."no dropdown option is selected")
	return "Category:"
end
local function getSelectedOptionID()
	for optionID,attributes in ipairs(dropDownOptions) do
		if attributes["checked"] then
			return optionID
		end
	end
	--print("DEBUG getSelectedOptionID(): ".."no dropdown option is selected")
end

function EtherealSearchOnLoad()

	 -- Create the dropdown, and configure its appearance
	 dropDown = CreateFrame("FRAME", "EtherealSearchDropdownFrame", EtherealSearchFrame1, "UIDropDownMenuTemplate")
	 dropDown:SetPoint("TOPLEFT", "ScanButton" ,"TOPRIGHT", 0, 0)
	 dropDown:SetPoint("BOTTOMLEFT", "ScanButton" ,"BOTTOMRIGHT", 0, 0)
	 UIDropDownMenu_SetWidth(dropDown, 100)
	 UIDropDownMenu_SetText(dropDown, getSelectedOptionText())
 
	 -- Create and bind the initialization function to the dropdown menu
	 UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
		  local info = UIDropDownMenu_CreateInfo()
			for optionID,attributes in ipairs(dropDownOptions) do
			  	info.text = attributes["text"]
				info.checked = attributes["checked"]
				info.func = function(b)
				-- MY HEAD HURTS o_o
					UIDropDownMenu_SetSelectedValue(self, b.value, b.value)
					UIDropDownMenu_SetText(self, b.value)
					--print("DEBUG: New option selected "..UIDropDownMenu_GetSelectedID(dropDown))
					for optionID,attributes in ipairs(dropDownOptions) do
						if optionID == UIDropDownMenu_GetSelectedID(dropDown) then
							attributes["checked"] = true
						else
							attributes["checked"] = false
						end
					end
				end
				UIDropDownMenu_AddButton(info,1)
			end	
	 end)
 end


function EtherealSearchFrame1_OnEvent(self,event,...)

	if ( event == "GOSSIP_SHOW" ) then
	
		if SearchInProgress then 
			GossipParse(GetGossipOptions()) 
			return
		end

		for i = 1, select("#", GetGossipOptions()),2 do
				local v = select(i, GetGossipOptions())
				if v:find("Vendor Item Recovery") then 
					EtherealSearchFrame1:Show()
					return
				end
		end
		
	elseif ( event == "GOSSIP_CLOSED" ) then
			SearchInProgress = false
			ScanButton:SetText("Scan")
			EtherealSearchDropdownFrameButton:Enable()
			EtherealSearchFrame1:Hide()
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
			EtherealSearchDropdownFrameButton:Disable()
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
           
            if (getSelectedOptionID() == 1 and v:find("Vendor Item Recovery")) or (getSelectedOptionID() == 2 and v:find("Deleted Item Recovery")) then    
			--print(getSelectedOptionID())             
                SelectGossipOption(id)	  

            elseif searchItem(string.lower(v),string.lower(itemName)) then
                
                SelectGossipOption(id)
				if FlagAutoConfirm:GetChecked() then 
					StaticPopup1Button1:Click()
				end
				return
                
            elseif v:find("Next Page")then          
                SelectGossipOption(id)
			end
            id = id +1
        end
end


function searchItem(string,name)
	name = trim(name)
	local startPosition
	local endPosition 
	local nameClean 

	if rarityFlags["COMMON"] then
		if not FlagExact:GetChecked() and string.find(string,"ffffffff",1, true) and string.find(string,name,1, true) then
			return true 
		end
		startPosition = string.find(string,"ffffffff"..name,1, true)
		if startPosition then
			if not FlagExact:GetChecked() then return true end
			endPosition = string.find(string,"(",startPosition, true) - 1
			nameClean = strsub(string, startPosition+8,endPosition)
			if trim(nameClean) == name then 
				return true 
			end
		end
	end
	if rarityFlags["UNCOMMON"] then
		if not FlagExact:GetChecked() and string.find(string,"ff1eff0c",1, true) and string.find(string,name,1, true) then
			return true 
		end
		startPosition = string.find(string,"ff1eff0c"..name,1, true)
		if startPosition then
			if not FlagExact:GetChecked() then return true end
			endPosition = string.find(string,"(",startPosition, true) - 1
			nameClean = strsub(string, startPosition+8,endPosition) 
			if trim(nameClean) == name then 
				return true 
			end
		end
	end
	if rarityFlags["RARE"] then
		if not FlagExact:GetChecked() and string.find(string,"ff0070ff",1, true) and string.find(string,name,1, true) then
			return true 
		end
		startPosition = string.find(string,"ff0070ff"..name,1, true)
		if startPosition then
			if not FlagExact:GetChecked() then return true end
			endPosition = string.find(string,"(",startPosition, true) - 1
			nameClean = strsub(string, startPosition+8,endPosition) 
			if trim(nameClean) == name then 
				return true 
			end
		end

	end
	if rarityFlags["EPIC"] then
		if not FlagExact:GetChecked() and string.find(string,"ffa335ee",1, true) and string.find(string,name,1, true) then
			return true 
		end
		startPosition = string.find(string,"ffa335ee"..name,1, true)
		if startPosition then
			if not FlagExact:GetChecked() then return true end
			endPosition = string.find(string,"(",startPosition, true) - 1
			nameClean = strsub(string, startPosition+8,endPosition) 
			if trim(nameClean) == name then 
				return true 
			end
		end
	end

end






hooksecurefunc("ChatEdit_InsertLink", function(link)
		if ItemNameField:IsVisible() and ItemNameField:HasFocus() then
		local name,_ = GetItemInfo(link)
		
			ItemNameField:Insert(name)
			return true
		end
end)


-- ARTIFACT FFE6CC80