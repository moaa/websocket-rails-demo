$(document).ready ->
	ws = new WebSocketRails('localhost:3000/websocket')
	ws.on_open = ->
		console.log 'socket opened'
	ws.bind 'new_message', (data) ->
		console.log data
		$('#chat_history').append('<br /><span>'+data['user']+':</label>'+data['text'])


	$('#send_message').on 'click', ->
		ws.trigger 'incoming_message', {text: $('#new_message').val()}
		$('#new_message').val('')

	$('#set_name').on 'click', ->
		ws.trigger 'set_name', {name: $('#screen_name').val()}		