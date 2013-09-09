class ChatController < WebsocketRails::BaseController

	def user_connected
		p 'user connected'
	end

	def incoming_message
		screen_name = connection_store[:screen_name]
		broadcast_message :new_message, {:user => current_user.screen_name, :text => message[:text]}
	end

	def user_disconnected
		p 'user disconnected'
	end
end
