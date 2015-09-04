class TopsController < ApplicationController
  # before_action :set_top, only: [:show, :edit, :update, :destroy]

  # GET /tops
  # GET /tops.json
  def index
    @chat_room = ChatRoom.all
    binding.pry
  end

  # GET /tops/1
  # GET /tops/1.json
  def show
  end

  # GET /tops/new
  def new
    @chat_room = ChatRoom.create

    respond_to do |format|
      if @chat_room
        format.html { redirect_to @top, notice: 'Top was successfully created.' }
        format.json { render json: @chat_room.id, flash: @chat_room }
      else
        format.html { render :new }
        format.json { render json: @top.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tops/1/edit
  def edit
  end

  # POST /tops
  # POST /tops.json
  def create
    @chat_room = ChatRoom.create

      binding.pry
    respond_to do |format|
      if @chat_room
        format.html { redirect_to @top, notice: 'Top was successfully created.' }
        format.json { render json: @chat_room.id, flash: @chat_room }
      else
        format.html { render :new }
        format.json { render json: @top.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tops/1
  # PATCH/PUT /tops/1.json
  def update
    respond_to do |format|
      if @top.update(top_params)
        format.html { redirect_to @top, notice: 'Top was successfully updated.' }
        format.json { render :show, status: :ok, location: @top }
      else
        format.html { render :edit }
        format.json { render json: @top.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tops/1
  # DELETE /tops/1.json
  def destroy
    @top.destroy
    respond_to do |format|
      format.html { redirect_to tops_url, notice: 'Top was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_top
      @top = ChatRoom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def top_params
      params[:top]
    end
end
