-- =============================================================================
-- update.lua — pull this machine's MEDINA files from the pinned repo.
--
-- One-time setup on each computer: set ROLE below, then run `update`.
-- Every later run re-downloads config.lua plus the scripts that role uses,
-- always from this repo — so local fixes (e.g. the Plutonium 241 fluid name)
-- can never be regressed by re-running the upstream installer.
-- =============================================================================

local ROLE = "broker"  -- "broker" | "dust" | "hw" | "fluid"

local RAW = "https://raw.githubusercontent.com/philipxjm/gtnh-medina/main/"

local FILES = {
  broker = {
    "config.lua", "broker-mk3.lua", "scheduler.lua", "loader.lua",
    "logger.lua", "list_components.lua", "detect_module.lua",
  },
  dust  = { "config.lua", "dust_telem.lua" },
  hw    = { "hw_telem.lua" },
  fluid = { "config.lua", "fluid_telem.lua" },
}

local list = FILES[ROLE]
if not list then error("Unknown ROLE: " .. tostring(ROLE)) end

-- job_node_config.lua is never overwritten: it holds this machine's hardware
-- addresses, which live only here.
local shell = require("shell")
for _, f in ipairs(list) do
  print("updating " .. f)
  local ok = shell.execute("wget -f " .. RAW .. f .. " /home/" .. f)
  if not ok then print("  FAILED: " .. f) end
end
print("done — restart the node's script to pick up changes.")
