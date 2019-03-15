require("luci.sys")

m = Map("jmuEportalAuth", translate("jmuEportalAuth"), translate("Configure eportal authentication for JMU."))

o = m:section(TypedSection, "jmuEportalAuth", "")
o.addremove = false
o.anonymous = true

enable = o:option(Flag, "enable", translate("Enable"))
cronset = o:option(Flag, "cronset", translate("Morning Re-Auth"), translate("Re-auth when it's 6AM everyday."))
name = o:option(Value, "username", translate("Username"), translate("WorkID/StuID"))
pass = o:option(Value, "password", translate("Password"), translate("Password for jmu pass."))
pass.password = true

services = o:option(ListValue, "services", translate("Services"), translate("Bind network operator at <a target='_blank' href='http://user.jmu.edu.cn'>user.jmu.edu.cn</a> before using it."))
services:value(0, translate("Education Network"))
services:value(1, translate("China Telecom"))
services:value(2, translate("China Unicom"))
services:value(3, translate("China Mobile"))
services.datatype = "uinteger"

local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/jmuEportalAuth restart")
end

return m
