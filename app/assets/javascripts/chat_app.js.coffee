$(document).ready ->
  ws = new WebSocketRails('localhost:3000/websocket')
  current_channel = undefined
  username = undefined
  ws.on_open = ->
    console.log 'socket opened'
    $('.join_chan').on 'click', (e) ->
      ws.unsubscribe(current_channel.name) if current_channel
      current_channel = ws.subscribe $(this).data('chan')
      current_channel.bind 'incoming_message', (data) -> 
        $('#chat_history').append('<br /><span>['+current_channel.name+'] '+data['user']+':</label> '+data['text'])
      current_channel.bind 'subscriber_join', (data) ->
        $('#chat_history').append('<br />'+data['email']+' has joined '+ current_channel.name)
      console.log 'joining ' + $(this).data('chan')
      ws.subscribe $(this).data('chan')
      $('#chat_history').html('<b>You have joined '+current_channel.name)
  ws.bind 'user_info', (data) -> 
    username = data['user']
  ws.bind 'new_message', (data) ->
    console.log data
    $('#chat_history').append('<br /><span>[broadcast] '+data['user']+':</label> '+data['text'])

  $('#send_message').on 'click', ->
    if current_channel
      current_channel.trigger 'incoming_message', {user: username, text: $('#new_message').val()}
    else
      ws.trigger 'incoming_message', {text: $('#new_message').val()}
    $('#new_message').val('')
