module("luci.controller.jmuEportalAuth", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/jmuEportalAuth") then
        return
    end
    if luci.sys.call("command -v jmuEportalAuth >/dev/null") ~= 0 then
        return
    end
    entry({"admin", "services", "jmuEportalAuth"}, cbi("jmuEportalAuth"), _("jmuEportalAuth"), 10).leaf = true
end
