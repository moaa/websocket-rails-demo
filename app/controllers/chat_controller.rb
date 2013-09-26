class ChatController < WebsocketRails::BaseController

	def user_connected
		p 'user connected'
		send_message :user_info, {:user => current_user.screen_name}
	end

	def incoming_message
		WebsocketRails.users[current_user.id] = connection
		screen_name = connection_store[:screen_name]
		broadcast_message :new_message, {:user => current_user.screen_name, :text => message[:text]}
	end

	def user_disconnected
		p 'user disconnected'
	end
end
