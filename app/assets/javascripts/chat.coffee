class @ChatClass
  @is_focus = true

  constructor: (url, useWebsocket) ->
    room_id = $('#room_id').text()
    # これがソケットのディスパッチャー
    @dispatcher = new WebSocketRails(url, useWebsocket)
    @channel = @dispatcher.subscribe(room_id)
    console.log('@channel', @channel)
    console.log(url)
    console.log(room_id)
    # イベントを監視
    @bindEvents()

  bindEvents: () =>
    # 送信ボタンが押されたらサーバへメッセージを送信
    $('#chat_form').on 'submit', @sendMessage
    # サーバーからnew_messageを受け取ったらreceiveMessageを実行
    @dispatcher.bind 'new_message', @receiveMessage
    @channel.bind 'new_message', @receiveMessage

  sendMessage: (event) =>
    # Notificationの許可
    Notification.requestPermission()
    # サーバ側にsend_messageのイベントを送信
    # オブジェクトでデータを指定
    user_name = $('#username').text()
    msg_body = $('#msgbody').val()
    room_id = $('#room_id').text()
    @dispatcher.trigger 'new_message', { name: user_name , body: msg_body , room_id: room_id}
    $('#msgbody').val('')
    console.log msg_body
    false

  receiveMessage: (message) =>
    console.log('receiveMessage')
    console.log message
    # 受け取ったデータをappend
    message = $("<li>「#{message.body}」<time>#{message.time}</time></li>")
    $('#messages').append message

    if !ChatClass.is_focus
      notification = new Notification "#{message.name} : #{message.body}"
      setTimeout ->
        notification.close()
      , 3000

color_cords = ['#ff7f7f','#ff7fbf','#ff7fff','#bf7fff','#7f7fff','#7fbfff','#7fffff','#7fffbf','#7fff7f','#bfff7f','#ffff7f','#ffbf7f']

$(document).on 'ready page:load', ->
  $('#chat_rooms li').removeClass('animate')

  room_id = $('#room_id').text()

  if room_id
    window.chatClass = new ChatClass($('#chat').data('uri'), true)
    console.log('ChatClass.constructor')

    $(window).on 'focus', ->
      ChatClass.is_focus = true
    .on 'blur', ->
      ChatClass.is_focus = false
  # else




  # $("#send").on 'click', ->
    # Notification.requestPermission (permission) ->
    # notify = new Notification('通知')