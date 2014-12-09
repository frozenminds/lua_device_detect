require("luarocks.loader")

describe("device_detect tests", function()
    local def

    setup(function()
        def = require("device_detect_definitions")
    end)

    it("should return device definitions", function()
        assert.are.equals('table', type(def.device()))
    end)

end)
