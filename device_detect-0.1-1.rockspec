package = "device_detect"
version = "0.1-1"
source = {
  url = "https://github.com/frozenminds/lua_device_detect/archive/master.zip",
  tag="0.1"
}
description = {
  summary = "Device detection library",
  homepage = "https://github.com/frozenminds/lua_device_detect",
  license = "LGPL",
  maintainer = "Constantin Bejenaru <boby@frozenminds.com>"
}
dependencies = {
  "lua >= 5.1",
  "lua-cjson",
  "lrexlib-pcre"
}
build = {
  type = "builtin",
  install = {
    conf = {
      ["definitions/device.json"] = "src/definitions/device.json",
    }
  },
  modules = {
    device_detect_definitions = "src/device_detect_definitions.lua",
    device_detect = "src/device_detect.lua",
  },
}
