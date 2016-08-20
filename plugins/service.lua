local function gsub_custom_welcome(msg, custom)
	local name = msg.added.first_name:mEscape()
	local id = msg.added.id
	local username
	local title = msg.chat.title:mEscape()
	if msg.added.username then
		username = '@'..msg.added.username:mEscape()
	else
		username = '(no username)'
	end
	custom = custom:gsub('$name', name):gsub('$username', username):gsub('$id', id):gsub('$title', title)
	return custom
end

local function get_welcome(msg, ln)
	if is_locked(msg, 'Welcome') then
		return false
	end
	local type = db:hget('chat:'..msg.chat.id..':welcome', 'type')
	local content = db:hget('chat:'..msg.chat.id..':welcome', 'content')
	if type == 'media' then
		local file_id = content
		api.sendDocumentId(msg.chat.id, file_id)
		return false
	elseif type == 'custom' then
		return gsub_custom_welcome(msg, content)
	elseif type == 'composed' then
		if not(content == 'no') then
			local abt = cross.getAbout(msg.chat.id, ln)
			local rls = cross.getRules(msg.chat.id, ln)
			local mods = cross.getModlist(msg.chat.id, ln):mEscape()
			local mods = lang[ln].service.welcome_modlist..mods
			local text = make_text(lang[ln].service.welcome, msg.added.first_name:mEscape_hard(), msg.chat.title:mEscape_hard())
			if content == 'a' then
				text = text..'\n\n'..abt
			elseif content == 'r' then
				text = text..'\n\n'..rls
			elseif content == 'm' then
				text = text..mods
			elseif content == 'ra' then
				text = text..'\n\n'..abt..'\n\n'..rls
			elseif content == 'am' then
				text = text..'\n\n'..abt..mods
			elseif content == 'rm' then
				text = text..'\n\n'..rls..mods
			elseif content == 'ram' then
				text = text..'\n\n'..abt..'\n\n'..rls..mods
			end
			print(text)
			return text
		else
			return make_text(lang[ln].service.welcome, msg.added.first_name:mEscape_hard(), msg.chat.title:mEscape_hard())
		end
	end
end

local action = function(msg, blocks, ln)
	
	--avoid trolls
	if not msg.service then return end
	
	--if the bot join the chat
	if blocks[1] == 'botadded' then
		
		print('Bot added to '..msg.chat.title..' ['..msg.chat.id..']')
		
		if db:hget('bot:general', 'adminmode') == 'on' and not is_admin(msg) then
			api.sendMessage(msg.chat.id, 'Solamente puede agregarme mi administrador')
			api.kickChatMember(msg.chat.id, bot.id)
			return
		end
		
		--check if the owner has a username, and save it. If not, use the name
		local name = msg.adder.first_name
		if msg.adder.username then
			name = name..' (@'..msg.adder.username..')'
		end
		
		save_log('added', msg.chat.title, msg.chat.id, name, msg.adder.id)
		api.sendLog(vtext(msg.chat)..vtext(msg.adder))
		
		cross.initGroup(msg.chat.id, msg.adder.id, name)
		
        local out = make_text(lang[ln].service.new_group, msg.from.first_name:mEscape())
		api.sendMessage(msg.chat.id, out, true)
	end
	
	--if someone join the chat
	if blocks[1] == 'added' then
		
		if msg.chat.type == 'group' and is_banned(msg.chat.id, msg.added.id) then
			api.kickChatMember(msg.chat.id, msg.added.id)
			return
		end
		
		if user_in_gbans(msg) then
			api.kickChatMember(msg.chat.id, msg.added.id)
		    	return
		end
		
		cross.remBanList(msg.chat.id, msg.added.id) --remove him from the banlist
		db:hdel('warn:'..msg.chat.id, msg.added.id) --remove the warns
		db:del('chat:'..msg.chat.id..':'..msg.added.id..':mediawarn') --remove the warn for media
		
		local text = get_welcome(msg, ln)
		if text then
			api.sendMessage(msg.chat.id, text, true)
		end
		--if not text: welcome is locked
	end
	
	--if the bot is removed from the chat
	if blocks[1] == 'botremoved' then
		
		print('Bot left '..msg.chat.title..' ['..msg.chat.id..']')
		
		--clean the modlist and the owner. If the bot is added again, the owner will be who added the bot and the modlist will be empty (except for the new owner)
		clean_owner_modlist(msg.chat.id)
		
		--remove group id
		db:srem('bot:groupsid', msg.chat.id)
		
		--save stats
        local num = db:hincrby('bot:general', 'groups', -1)
        print('Stats saved', 'Groups: '..num)
	end

end

return {
	action = action,
	triggers = {
		'^###(botadded)',
		'^###(added)',
		'^###(botremoved)'
	}
}
