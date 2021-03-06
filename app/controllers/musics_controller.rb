class MusicsController < ApplicationController
  before_action :set_music, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
     if user_signed_in?
      @musics = current_user.musics.order("created_at DESC").paginate(:page => params[:page], :per_page => 6)
     else 
      redirect_to new_user_session_path
   end
  end

  def show; end

  def new
    @music = current_user.musics.build
  end

  def edit; end

  def search
    if params[:search].present?
      @musics = Music.search(params[:search])
    else
      @musics = Music.all
    end
  end
  

  def create
    @music = current_user.musics.build(music_params)

    respond_to do |format|
      if @music.save
        format.html { redirect_to @music, notice: 'Music was successfully created.' }
        format.json { render :show, status: :created, location: @music }
      else
        format.html { render :new }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to @music, notice: 'Music was successfully updated.' }
        format.json { render :show, status: :ok, location: @music }
      else
        format.html { render :edit }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @music.destroy
    respond_to do |format|
      format.html { redirect_to musics_url, notice: 'Music was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_music
      @music = Music.find(params[:id])
    end
    
    def music_params
      params.require(:music).permit(:artist, :title, :year, :label, :genere, :format, :grade, :rate, :image, :notes)
    end
end
