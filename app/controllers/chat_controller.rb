# coding: utf-8

class ChatController < WebsocketRails::BaseController
  # initialize_session はwebsocket接続時に実行される処理
  def initialize_session
    logger.debug("initialize chat controller")
    @redis = Redis.new(host: 'localhost', port: 6379)
    controller_store[:redis] = @redis
  end

  def connect_user
    logger.debug("connected user")
    gid = session[:group_id]
    talks = controller_store[:redis].lrange gid, 0,100
    talks.each do |message|
      msg = ActiveSupport::HashWithIndifferentAccess.new(eval(message))
      send_message :new_message, msg
    end
  end

  def new_message
    logger.debug("Call new_message : #{message}")
    gid = message[:gid]
    message[:time] = Time.now.strftime("%H時%M分").to_s
    #controller_store[:redis].del gid   消す時はこれ。（ただのメモ）
    controller_store[:redis].rpush gid, message
    broadcast_message :new_message, message
    # WebsocketRails["#{gid}"].trigger(:new_message, message)
  end
end