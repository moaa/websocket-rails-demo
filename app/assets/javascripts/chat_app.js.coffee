class @ChatApp

  messageTemplate: (message, channelName = 'broadcast') ->
    """
    <div>
      <span>
        <label class='label label-#{if channelName == 'broadcast' then 'warning' else 'info'}'>
          [#{channelName}]
        </label> #{message}
      </span>
    </div>
    """
  joinTemplate: (channelName) ->
    """
    <div>
      <span>
        <label class='label label-'>
          [Joined Channel]
        </label> #{channelName}
      </span>
    </div>
    """

  constructor: (@currentChannel = undefined, @username = undefined) ->
    @dispatcher = new WebSocketRails(window.location.host + "/websocket")
    @bindEvents()

  bindEvents: ->
    @dispatcher.bind 'user_info', @setUserInfo
    @dispatcher.bind 'new_message', @receiveGlobalMessage
    $('#send_message').click @sendMessage
    $('.join_chan').click @joinChannel
    
  setUserInfo: (userInfo) =>
    @username = userInfo.user

  receiveGlobalMessage: (message) =>
    $('#chat_history').append @messageTemplate(message.text)

  receiveMessage: (message) =>
    $('#chat_history').append @messageTemplate(message.text, @currentChannel.name)

  sendMessage: (e) =>
    e.preventDefault()
    message = $('#new_message').val()
    if @currentChannel?
      @currentChannel.trigger 'new_message', text: message, username: @username
    else
      @dispatcher.trigger 'new_message', text: message, username: @username
    $('#new_message').val('')

  joinChannel: (e) =>
    e.preventDefault()
    if @currentChannel?
      @currentChannel.trigger 'user_disconnected', username: @username
      @dispatcher.unsubscribe(@currentChannel.name)
      @currentChannel = undefined
    else
     channelName = $(e.target).html()
     @currentChannel = @dispatcher.subscribe(channelName)
     @currentChannel.bind 'new_message', @receiveMessage
     $('#chat_history').append @joinTemplate(channelName)
     
     @currentChannel.bind 'user_disconnected', (data) =>
       $("#chat_history").append @messageTemplate " User #{data.username} disconnected", @currentChannel.name
$(document).ready ->
  window.chatApp = new ChatApp
