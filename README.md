# device_detect

A small Lua library to detect devices.

[![Build Status](https://travis-ci.org/frozenminds/lua_device_detect.svg)](https://travis-ci.org/frozenminds/lua_device_detect)

### Insipiration
This library is inspired by Scott Francis's [mobile_detect](https://github.com/csfrancis/mobile_detect) and Piwik's [device_detector](https://github.com/piwik/device-detector).
The rules are from Piwik as they're impeccable, I've just transformed them from YAML to JSON.

### Installation
```
luarocks install device_detect
```

### Dependencies
* [Lua](http://www.lua.org/) >= 5.1 | [Luajit](http://luajit.org/) >= 2.0.0
* [lua-cjson](http://www.kyne.com.au/~mark/software/lua-cjson.php)
* [Lrexlib-PCRE](http://rrthomas.github.io/lrexlib/)

### Usage
All APIs take a table of HTTP headers as an input parameter.

```
local dd = require("device_detect")

local http_headers = {}

-- smartphone
http_headers['user-agent'] = "Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19"
assert(dd.get_device(http_headers) == "smartphone")

-- tablet
http_headers['user-agent'] = "Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53"
assert(dd.get_device(http_headers) == "tablet")

-- tv
http_headers['user-agent'] = "Mozilla/5.0 (SMART-TV; X11; Linux i686) AppleWebKit/534.7 (KHTML, like Gecko) Version/5.0 Safari/534.7"
assert(dd.get_device(http_headers) == "tv")

```

### Development

Tests can be run using [busted](http://olivinelabs.com/busted/):

```
sudo luarocks install busted
busted tests/device_detect_test.lua
busted tests/device_detect_definitions_test.lua
```
