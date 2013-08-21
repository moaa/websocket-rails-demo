class ChatController < WebsocketRails::BaseController

	def user_connected

	end

	def incoming_message
		screen_name = connection_store[:screen_name]
		broadcast_message :new_message, {:user => screen_name, :text => message[:text]}
	end

	def set_name
		connection_store[:screen_name] = message[:name]
	end
end
