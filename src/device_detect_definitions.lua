local _M = {}
_M.module_namee = "device_detect"

--- Directories table
local _dirs = {}

--- Definition tables
local _definitions = {}

--- CJSON module
-- Lua JSON support
local cjson = require("cjson")

--- Get configuration directory
-- @return Configuration directory as string
local function get_config_dir()
    if _dirs.conf ~= nil then
        return _dirs.conf
    end

    local path   = require("luarocks.path")
    local search = require("luarocks.search")
    local fetch  = require("luarocks.fetch")
    local cfg    = require("luarocks.cfg")

    local tree_map = {}
    local results  = {}
    local query    = search.make_query(_M.module_namee, nil)
    local trees    = cfg.rocks_trees

    for _, tree in ipairs(trees) do
        local rocks_dir = path.rocks_dir(tree)
        tree_map[rocks_dir] = tree
        search.manifest_search(results, rocks_dir, query)
    end

    assert(results[_M.module_namee])

    local version = nil
    for k, _ in pairs(results[_M.module_namee]) do version = k end

    local repo = tree_map[results[_M.module_namee][version][1].repo]
    _dirs.conf = path.conf_dir(_M.module_namee, version, repo)

    return _dirs.conf
end

--- Get definitions directory
-- @return Definitions directory as string
local function get_definitions_dir()
    if _dirs.definitions ~= nil then
        return _dirs.definitions
    end

    _dirs.definitions = get_config_dir()..package.config:sub(1,1).."definitions"
    return _dirs.definitions
end

--- Get definitions for devices
-- @return Lua table
local function get_definitions_device()
    if _definitions.device ~= nil then
        return _definitions.device
    end

    local json_file = get_definitions_dir()..package.config:sub(1,1).."device.json"
    local f = assert(io.open(json_file, "r"))
    local t = f:read("*all")
    f:close()

    _definitions.device = cjson.decode(t)
    assert(type(_definitions.device) == 'table', 'get_definitions_device() function expects parsable JSON device definitions')

    return _definitions.device
end

--- Get device definitions
-- @return JSON formatted string
function _M.device()
    return get_definitions_device()
end

return _M
