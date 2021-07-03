class BookCommentsController < ApplicationController
  def create
    if book = Book.find(params[:book_id]) # book_id：Bookモデル（投稿）の主キーカラム = どの投稿に対してのコメントなのかを紐付ける(book = コメントに紐づく投稿情報)
       comment = current_user.book_comments.new(book_comment_params)   # ログイン者のコメントを（book_comment_paramsで受け取る）
       comment.book_id = book.id      # 「投稿に紐づくコメント」 が「createしたidの投稿」に対応している時
       comment.save# 投稿に対してのコメントを保存
       redirect_to book_path(book)
       flash[:notice] = "投稿に成功しました"
    else
      render "books/show"
    end
  end

  def destroy
    BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    redirect_to book_path(params[:book_id])
  end
  
  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end