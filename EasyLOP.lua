EasyLOP = LibStub("AceAddon-3.0"):NewAddon("EasyLOP", "AceConsole-3.0", "AceEvent-3.0")

local defaults = {
  profile = {
    optionA = true,
    optionB = false,
    suboptions = {
      subOptionA = false,
      subOptionB = true,
    },
  }
}


function EasyLOP:OnInitialize()
    --AceDB LoadIn
    self.db = LibStub("AceDB-3.0"):New("EasyLOPDB", dafaults)
    
    --Set Default Values

    
end

function EasyLOP:OnEnable()

end

