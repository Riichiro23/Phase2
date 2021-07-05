class BookCommentsController < ApplicationController
	before_action :authenticate_user!


		#  注)コメント投稿フォームはBookモデルのbooks#showページ内に作成 = Bookモデルによって投稿を取得
	def create
		#----------------------------------------------------
    # remote: true（非同期通信）を指定したアクション名と同じアクション名のjsファイルが呼び出される
		# book_comments/create.js.erb(非同期通信を行うためのファイル)に渡すための変数
		# create後のレンダーで、再度、books#showページを表示するために,books#showコントローラーで定義している変数を持ってきている
		@book = Book.find(params[:book_id])  # cretateの時に送信される(/books/:book_id/book_comments)のbook_id（投稿番号）を取得することで、コメントされた投稿を受け取る
		@book_comment = BookComment.new
    #----------------------------------------------------
		book_comment = BookComment.new(book_comment_params)
		book_comment.book_id = @book.id
		book_comment.user_id = current_user.id
		unless book_comment.save
  		#redirect_to book_path(@book.id)
		  render 'books/show'
		end
	end

	def destroy
		#----------------------------------------------------
	  # remote: true（非同期通信）を指定したアクション名と同じアクション名のjsファイルが呼び出される
		# book_comments/destroy.js.erb(非同期通信を行うためのファイル)に渡すための変数
		#destroy後のレンダーで、再度、books#showページを表示するために,books#showコントローラーで定義している変数を持ってきている
		@book = Book.find(params[:book_id])
		@book_comment = BookComment.new   
		#----------------------------------------------------
  	book_comment = @book.book_comments.find(params[:id])
		book_comment.destroy
	#	redirect_to request.referer
	end

	private
	def book_comment_params
		params.require(:book_comment).permit(:comment)
	end
end
