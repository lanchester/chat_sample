class @ChatClass
  @is_focus = true

  constructor: (url, useWebsocket) ->
    # これがソケットのディスパッチャー
    @dispatcher = new WebSocketRails(url, useWebsocket)
    @channel = @dispatcher.subscribe(group_id)
    console.log(url)
    # イベントを監視
    @bindEvents()

  bindEvents: () =>
    # 送信ボタンが押されたらサーバへメッセージを送信
    $('#send').on 'click', @sendMessage
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
    group_id = $('#group_id').text()
    @dispatcher.trigger 'new_message', { name: user_name , body: msg_body , group_id: group_id}
    $('#msgbody').val('')
    console.log msg_body

  receiveMessage: (message) =>
    console.log message
    # 受け取ったデータをappend
    $('#chat').append "#{message.name}「#{message.body}」<br/>"
    if !ChatClass.is_focus
      notification = new Notification "#{message.name} : #{message.body}"
      setTimeout ->
        notification.close()
      , 3000

$ ->
  window.chatClass = new ChatClass($('#chat').data('uri'), true)

  $(window).on 'focus', ->
    ChatClass.is_focus = true
  .on 'blur', ->
    ChatClass.is_focus = false



  # $("#send").on 'click', ->
    # Notification.requestPermission (permission) ->
    # notify = new Notification('通知')