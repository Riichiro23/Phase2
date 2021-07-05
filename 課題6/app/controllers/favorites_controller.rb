class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id]) # 送信されたURLと同じbook_id(外部キー = 投稿情報)を取得（どの投稿にいいねしたのか）
    favorite = @book.favorites.new(user_id: current_user.id)
    favorite.save
    # アクション名と同じjsファイルが読み込まれる
    # 非同期通信のためredirect_toはなし。
    # redirect_to request.referer 
  end

  def destroy
    @book = Book.find(params[:book_id])
    favorite = @book.favorites.find_by(user_id: current_user.id)
    favorite.destroy
    # アクション名と同じjsファイルが読み込まれる
    # 非同期通信のためredirect_toはなし。
    # redirect_to request.referer 
  end
end
