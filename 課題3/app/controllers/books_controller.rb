class BooksController < ApplicationController
before_action :ensure_current_user, {only: [:edit, :update]}

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @user = @book.user
    @book_comment = BookComment.new  
  end

  def index
    @book = Book.new
    @books = Book.all
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
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def ensure_current_user
    @book = Book.find(params[:id])
    if current_user.id != @book.user.id  # @book.user.id {「投稿した本」に対応する「投稿したユーザー」の「id」（投稿されている本と、その投稿をしたユーザーをひもづける) と、 current_user.id (今ログインしている人の「id」)が一致していなければ}
      flash[:notice]="権限がありません"
      redirect_to books_path
    end
  end

end
