local _M = {}
_M.module_name = "device_detect"

--- User agent HTTP headers
-- A list of allowed HTTP user agents
local _uaHttpHeaders = {
    "user-agent",
    "x-operamini-phone-ua",
    "x-device-user-agent",
    "x-original-user-agent",
    "x-skyfire-phone",
    "x-bolt-phone-ua",
    "device-stock-ua",
    "x-ucbrowser-device-ua"
}

--- Definitions table
local _definitions = {}

--- Definitions module
local def = require("device_detect_definitions")

--- Lrexlib module
-- Lua PCRE regex support
local rex = require("rex_pcre")

--- Initialize module
local function _initialize()
    _definitions.device = def.device()
    local typeDevice = type(_definitions.device)
    assert(typeDevice == "table", "_initialize() function expects definitions.device() to return table, " .. typeDevice .. " returned")
end

--- Get user agent header from a table of HTTP headers
-- Some devices don't use the default "user-agent" header
-- @param http_headers Device's HTTP headers
-- @return Returns nil if no user agent header present
-- @return Returns the user agent HTTP header name
local function get_user_agent(http_headers)
    if http_headers == nil then return nil end

    for _, v in ipairs(_uaHttpHeaders) do
        if http_headers[v] ~= nil then return http_headers[v] end
    end
    return nil
end

--- Build complete regular expression pattern
-- @return Complete pattern
local function build_patter(regex)
    return "(?:^|[^A-Z_-])(?:" .. string.gsub(regex, "/", "\\/") .. ")"
end

--- Get device by HTTP headers
-- @see _definitions
-- @param http_headers Device's HTTP headers
-- @return Returns nil if device could not be detected
-- @return Returns the device name as string
local function get_device_by_user_agent(http_headers)
    local _return = nil

    local user_agent = get_user_agent(http_headers)
    if user_agent == nil then return _return end

    -- compilation flags
    -- @see http://rrthomas.github.io/lrexlib/manual.html#cf
    local cf = "i"

    for brand, regexBrand in pairs(_definitions.device) do
        local typeBrand = type(regexBrand.regex)
        assert(typeBrand == "string", "get_device_by_user_agent() function expects _definitions['" .. brand .. "']['regex'] of type string, " .. typeBrand .. " given")

        if rex.find(user_agent, build_patter(regexBrand.regex), 1, cf) ~= nil then
            if regexBrand.device ~= nil then _return = regexBrand.device end

            if regexBrand.models ~= nil and type(regexBrand.models) == "table" then
                for _, regexModel in pairs(regexBrand.models) do
                    local typeModel = type(regexModel.regex)
                    assert(typeModel == "string", "get_device_by_user_agent() function expects _definitions['" .. brand .. "']['models']['regex'] of type string, " .. typeModel .. " given")

                    if rex.find(user_agent, build_patter(regexModel.regex), 1, cf) ~= nil then
                        if regexModel.device ~= nil then _return = regexModel.device break
                        end
                    end
                end
            end
        end

        if _return ~= nil then
            return _return
        end
    end

    return _return
end

--- Get device by HTTP headers
-- @param http_headers Device's HTTP headers
-- @return Returns nil if device could not be detected
-- @return Returns the device name as string
function _M.get_device(http_headers)
    return get_device_by_user_agent(http_headers)
end

_initialize()

return _M
