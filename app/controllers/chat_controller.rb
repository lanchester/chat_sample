# coding: utf-8

class ChatController < WebsocketRails::BaseController
  # initialize_session はwebsocket接続時に実行される処理
  def initialize_session
    logger.debug("==========================================================================================initialize chat controller==========================================================================================")
    @redis = Redis.new(host: 'localhost', port: 6379)
    controller_store[:redis] = @redis
  end

  def connect_user
    logger.debug("========================================================================connected user==========================================================================================")
    logger.debug("************************************************************#{request.fullpath}************************************************************")
    rid = session[:room_id]
    talks = controller_store[:redis].lrange rid, 0,100
    logger.debug("************************************************************#{session.keys}************************************************************")
    talks.each do |message|
      msg = ActiveSupport::HashWithIndifferentAccess.new(eval(message))
      # broadcast_message :new_message, msg
      send_message :new_message, msg
    end
  end

  def new_message
    logger.debug("============================================================================================================Call new_message : #{message}==========================================================================================")
    logger.debug("============================================================================================================Call new_message : #{message[:room_id]}==========================================================================================")
    room_id = message[:room_id]
    message[:time] = Time.now.strftime("%Y/%m/%d %H:%M").to_s
    #controller_store[:redis].del gid   消す時はこれ。（ただのメモ）
    controller_store[:redis].rpush room_id, message
    # broadcast_message :new_message, message
    WebsocketRails["#{room_id}"].trigger(:new_message, message)
  end
end