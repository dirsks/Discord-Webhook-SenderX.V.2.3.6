--[[
local function decodeBase64(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = data:gsub('[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if x == '=' then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
		return r
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if #x ~= 8 then return '' end
		local c = 0
		for i = 1,8 do c = c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local base64 = "W0Jhc2U2NCBjb250ZW50IGNvbWUgZ2VyYWRvIGFxdWkgXQptb2QgcnE9cmVxdWVzdCBvciBodHRwX3JlcXVlc3Qgb3Igc3luJiZzeW4ucmVxdWVzdAppZiBub3QgcnEgdGhlbiB3YXJuKCDigJggWW91ciBleGVjdXRvciBkb2VzIG5vdCBzdXBwb3J0IEhUVFAgcmVxdWVzdHMuIikgcmV0dXJuCmZ1bmN0aW9uIE5vdGlmeSh0aXRsZSwgdGV4dCkKICAgIHBjYWxsKGZ1bmN0aW9uKCkKICAgICAgICBnYW1lOkdldFNlcnZpY2UoIlN0YXJ0ZXJHdWkiKTpTZXRDb3JlKCJTZW5kTm90aWZpY2F0aW9uIiwgewogICAgICAgICAgICBUaXRsZSA9IHRpdGxlLAogICAgICAgICAgICBUZXh0ID0gdGV4dCwKICAgICAgICAgICAgRHVyYXRpb24gPSA1CiAgICAgICAgfSkKICAgIGVuZCkKZW5kCmlmIG5vdCBfRy53ZWIgb3Igbm90IF9HLndlYi5XZWJob29rIG9yIF9HLndlYi5XZWJob29rID09ICIiIHRoZW4KICAgIE5vdGlmeSgiV2ViaG9vayBub3Qgc2V0IiwgIllvdSBtdXN0IGRlZmluZSBfRy53ZWIuV2ViaG9vay4iKQogICAgcmV0dXJuCmVuZAppZiBfRy53ZWIuTWVzc2FnZSBhbmQgX0cud2ViLk1lc3NhZ2UgIT0gIiIgdGhlbgogICAgbG9jYWwgcGF5bG9hZCA9IHsKICAgICAgICBjb250ZW50ID0gX0cud2ViLk1lc3NhZ2UKICAgIH0KICAgIGxvY2FsIHN1Y2Nlc3MsIGVyciA9IHBjYWxsKGZ1bmN0aW9uKCkKICAgICAgICBycSh7CiAgICAgICAgICAgIFVybCA9IF9HLndlYi5XZWJob29rLAogICAgICAgICAgICBNZXRob2QgPSAiUE9TVCIsCiAgICAgICAgICAgIEhlYWRlcnMgPSB7WyJDb250ZW50LVR5cGUiXSA9ICJhcHBsaWNhdGlvbi9qc29uIn0sCiAgICAgICAgICAgIEJvZHkgPSBnYW1lOkdldFNlcnZpY2UoIkh0dHBTZXJ2aWNlIik6SlNPTkVuY29kZShwYXlsb2FkKQogICAgICAgIH0pCiAgICBlbmQpCiAgICBpZiBzdWNjZXNzIHRoZW4KICAgICAgICBOb3RpZnkoIk1lc3NhZ2UgU2VudCIsICJzZW5kTWVzc2FnZSgpIikKICAgIGVsc2UKICAgICAgICBOb3RpZnkoIlJlcXVlc3QgRmFpbGVkIiwgdG9zdHJpbmcoZXJyKSkKICAgIGVuZCBlbmQKaWYgX0cud2ViLmVtYmVkIGFuZCB0eXBlb2YoX0cud2ViLmVtYmVkKSA9PSAidGFibGUiIHRoZW4KICAgIGxvY2FsIGUgPSBfRy53ZWIuZW1iZWQKICAgIGxvY2FsIGRhdGEgPSB7CiAgICAgICAgZW1iZWRzID0gewogICAgICAgICAgICB7CiAgICAgICAgICAgICAgICB0aXRsZSA9IGUudGl0bGUgb3IgIiIsCiAgICAgICAgICAgICAgICBkZXNjcmlwdGlvbiA9IGUuZGVzY3JpcHRpb24gb3IgIiIsCiAgICAgICAgICAgICAgICBjb2xvciA9IGUuY29sb3Igb3IgMzQ0NzAwMywKICAgICAgICAgICAgICAgIGZpZWxkcyA9IGUuZmllbGRzIG9yIHt9LAogICAgICAgICAgICAgICAgZm9vdGVyID0gewogICAgICAgICAgICAgICAgICAgIHRleHQgPSAoZSYmZS5mb290ZXIpIGFuZCBlLmZvb3Rlci50ZXh0IG9yICIiCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICB9CiAgICBsb2NhbCBzdWNjZXNzLCBlcnIgPSBwY2FsbChmdW5jdGlvbigpCiAgICAgICAgcnEoewogICAgICAgICAgICBVcmwgPSBfRy53ZWIuV2ViaG9vaywKICAgICAgICAgICAgTWV0aG9kID0gIlBPU1QiLAogICAgICAgICAgICBIZWFkZXJzID0ge1siQ29udGVudC1UeXBlIl0gPSAiYXBwbGljYXRpb24vanNvbiIgfSwKICAgICAgICAgICAgQm9keSA9IGdhbWU6R2V0U2VydmljZSgiSHR0cFNlcnZpY2UiKTpKU09ORW5jb2RlKGRhdGEpCiAgICAgICAgfSkKICAgIGVuZCkKICAgIGlmIHN1Y2Nlc3MgdGhlbgogICAgICAgIE5vdGlmeSgiRW1iZWQgU2VudCIsICJzZW5kRW1iZWQoKSIpCiAgICBlbHNlCiAgICAgICAgTm90aWZ5KCJSZXF1ZXN0IEZhaWxlZCIsIHRvc3RyaW5nKGVycikpCiAgICBlbmQgZW5kCmVuZA=="

local decoded = decodedBase64(base64)
loadstring(decoded)()
]]
local v1 = game
local v2 = v1["\x47\x65\x74\x53\x65\x72\x76\x69\x63\x65"]
local A = v2(v1, "\x50\x6c\x61\x79\x65\x72\x73")
local B = v2(v1, "\x53\x74\x61\x72\x74\x65\x72\x47\x75\x69")
local C = v2(v1, ("\72\116\116\112\83\101\114\118\105\99\101"):gsub(".", function(c) return string.char(c:byte()) end))

local D = 138986560996119
local Enc = function(str)
	return (str:gsub(".", function(c)
		return "\\"..c:byte()
	end))
end

local Func = loadstring([[
return function()
	if not game then return end
	local _ENV = _ENV
	local h = {
		["Content-Type"] = "application/json"
	}
	local data = {
		["content"] = _G.web.Message
	}
	local json = ]] .. "game:GetService('" .. ("HttpService") .. "'):JSONEncode(data)" .. [[

	request({
		Url = _G.web.Webhook,
		Method = "POST",
		Headers = h,
		Body = json
	})

	if _G.web and _G.web.Notify ~= false or _G.web.Notify ~= nil then
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Message Sent",
				Text = "SendMessage()",
				Icon = "rbxassetid://".. D,
				Duration = 6
			})
		end)
	end
end
]])()

local Func2 = loadstring([[
return function()
	if not game then return end
	local embed = _G.web.embed
	local headers = {
		["Content-Type"] = "application/json"
	}
	local payload = {
		["embeds"] = {
			{
				["title"] = embed.title or "",
				["description"] = embed.description or "",
				["color"] = embed.color or 2123412,
				["fields"] = embed.fields or {},
				["footer"] = {
					["text"] = embed.footer and embed.footer.text or ""
				}
			}
		}
	}
	local body = game:GetService("HttpService"):JSONEncode(payload)

	request({
		Url = _G.web.Webhook,
		Method = "POST",
		Headers = headers,
		Body = body
	})

	if _G.web and _G.web.Notify ~= false or _G.web.Notify ~= nil then
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Embed Sent",
				Text = "SendMessageEMBED()",
				Icon = "rbxassetid://".. D,
				Duration = 6
			})
		end)
	end
end
]])()

if not _G.web or not _G.web.Webhook or _G.web.Webhook == "" then
	B:SetCore("\x53\x65\x6e\x64\x4e\x6f\x74\x69\x66\x69\x63\x61\x74\x69\x6f\x6e", {
		Title = Enc("Error"),
		Text = Enc("Webhook isn’t set."),
		Icon = "rbxassetid://".. D,
		Duration = 5
	})
	return
end

if _G.web.Message and _G.web.Message ~= "" then
	Func()
end

if _G.web.embed and typeof(_G.web.embed) == "table" then
	Func2()
end
