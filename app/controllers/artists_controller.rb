class ArtistsController < ApplicationController

  before_action :authenticate_user!, only: [ :edit, :update, :destroy ]
  
  expose(:artists) { Artist.order('name ASC') }

  expose(:artist, attributes: :artist_params) do
    unless params[:id].nil?
      Artist.find(params[:id])
    else
      Artist.new
    end
  end

  def create
    self.artist = Artist.new(artist_params)

    respond_to do |format|
      if artist.save
        format.html { redirect_to artist, notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: artist }
      else
        format.html { render :new }
        format.json { render json: artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if artist.update(artist_params)
        format.html { redirect_to artist, notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: artist }
      else
        format.html { render :edit }
        format.json { render json: artist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
    def artist_params
      params.require(:artist).permit(:name)
    end
end
