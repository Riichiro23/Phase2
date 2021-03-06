class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show   # books#showページ内のコメント投稿フォームををBookCommentモデルで作成
    @book = Book.find(params[:id]) # favorites/_favorite.html.erb(いいねボタンの部分テンプレート)に渡す変数  and  # books/_comment.html.erb(コメント投稿フォームの部分テンプレート)に渡す変数
    @book_comment = BookComment.new # books/_comment.html.erb(コメント投稿フォームの部分テンプレート)に渡す変数  
  end

  def index
    @books = Book.all  # favorites/_favorite.html.erb(いいねボタンの部分テンプレート)に渡す変数
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
