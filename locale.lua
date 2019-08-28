local Regen = select(2, ...)

local function AddLocale(L, name, loc)
    if GetLocale() == name or name == "enUS" then
      for k,v in pairs(loc) do
          if type(v) == "table" then
            ---
          elseif v == true then
            L[k] = k
          else
            L[k] = v
          end
        end
      end
    end
  
local loc_mt = {
    __index = function(t, k)
    error("Locale key " .. tostring(k) .. " is not provided.")
    end
}

local function GetLocalizer(locs)
    locs.AddLocale = AddLocale
    return setmetatable(locs, loc_mt)
end

Regen.L = GetLocalizer({})

