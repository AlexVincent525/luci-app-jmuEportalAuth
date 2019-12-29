require("luci.sys")

function is_online()
    if luci.sys.call("ping -c1 -w1 %s >/dev/null 2>&1" %{"114.114.114.114"}) == 0 then
        return "<strong style='padding:0 3px;border-radius:5px;background-color:green;color:white'>Online</strong>"
    else
        return "<strong style='padding:0 3px;border-radius:5px;background-color:red;color:white'>Offline</strong>"
    end
end

m = Map("jmuEportalAuth", translate("jmuEportalAuth"), translate("Configure eportal authentication for JMU " .. is_online()))

o = m:section(TypedSection, "jmuEportalAuth", "")
local section_name = ""
o.anonymous = true

o:tab("basic", translate("Basic Settings"))
o:tab("action", translate("Actions"))

button_restart = o:taboption("action", Button, "Restart", translate("Restart Auth"))
button_restart.inputtitle = translate("Restart")
button_restart.inputstyle = "apply"
button_start = o:taboption("action", Button, "Start", translate("Start Auth"))
button_start.inputtitle = translate("Start")
button_start.inputstyle = "save"
button_stop = o:taboption("action", Button, "Stop", translate("Stop Auth"))
button_stop.inputtitle = translate("Stop")
button_stop.inputstyle = "reset"

function button_restart:write(self, section, value)
	luci.sys.call("/etc/init.d/jmuEportalAuth restart >/dev/null")
end

function button_start:write(self, section, value)
	luci.sys.call("/etc/init.d/jmuEportalAuth start >/dev/null")
end

function button_stop:write(self, section, value)
	luci.sys.call("/etc/init.d/jmuEportalAuth stop >/dev/null")
end

enable = o:taboption("basic", Flag, "enable", translate("Enable"), translate("After clicked <button style=\"color:#fff;background:linear-gradient(to bottom,#0069d6,#0049d6) no-repeat;text-shadow:0 -1px 0 rgba(0,0,0,0.25)\" class=\"cbi-button cbi-button-apply\" type=\"button\">Save & Apply</button>, click <button class='cbi-button cbi-button-apply' onclick=\"this.blur(); var section_name=document.getElementsByTagName('label')[1].getAttribute('for').split('.')[2]; return cbi_t_switch('jmuEportalAuth.'+section_name, 'action')\">Actions</button> to restart service manually."))
cronset = o:taboption("basic", Flag, "cronset", translate("Morning Re-Auth"), translate("Re-auth when it's 6:10 A.M. everyday."))
name = o:taboption("basic", Value, "username", translate("Username"), translate("WorkID/StuID"))
pass = o:taboption("basic", Value, "password", translate("Password"), translate("Password for jmu pass."))
pass.password = true

services = o:taboption("basic", ListValue, "services", translate("Services"), translate("Bind network operator at <a target='_blank' href='http://user.jmu.edu.cn'>user.jmu.edu.cn</a> before using it."))
services:value(0, translate("Education Network"))
services:value(1, translate("China Telecom"))
services:value(2, translate("China Unicom"))
services:value(3, translate("China Mobile"))
services.datatype = "uinteger"

section_name="cfg019cda"

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("echo 'enable: "..tostring(m:get(section_name,"enable")).."' > /tmp/eportal-set.log")
    io.popen("/etc/init.d/jmuEportalAuth restart")
end

return m
