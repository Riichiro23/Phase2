class SearchController < ApplicationController

  def search
    @model = params["search"]["model"] # フォームで入力された検索値を受け取る
    @value = params["search"]["value"] # フォームで選択されたmodelを受け取る
    @how = params["search"]["how"]  # フォームで選択された検索方法を受け取る
    @datas = search_for(@how, @model, @value)  # 上記の3つの情報を受け取ってsearch_forアクションへ引き渡す
  end


 # 検索フォーム(_header.html.erb)で、選択した条件(モデル = book・user)(検索方法 = march, forward, backforward, partical)
 # によって場合分けしてアクションを実行
  private

 # 完全一致
  def match(model, value)  # フォームで選択した「model」(user , book)と、「value」(検索窓に入力した値)を引数に渡す
    if model == 'user'  # フォームで'user'モデルが選択された場合は、 # Userモデルによって,フォームに入力された値が存在するかどうかnameカラムで参照する
      User.where(name: value)
    elsif model == 'book'
      Book.where(title: value)
    end
  end

  # 前方一致
  def forward(model, value)
    if model == 'User'
      User.where("name LIKE ?", "#{value}%")
    elsif model == 'book'
      Book.where("title LIKE ?", "#{value}%")
    end
  end

  # 後方一致
  def backward(model, value)
    if model == 'user'
      User.where("name LIKE ?", "%#{value}")
    elsif model == 'book'
      Book.where("title LIKE ?", "%#{value}")
    end
  end

  # 部分一致
  def partical(model, value)
    if model == 'user'
      User.where("name LIKE ?", "%#{value}%")
    elsif model == 'book'
      Book.where("title LIKE ?", "%#{value}%")
    end
  end

#検索方法のhowの中身がどれなのかwhenの条件分岐の中から探す処理
  def search_for(how, model, value) #searchアクションで定義した情報が引数に入っている
    case how
    when 'match'  # 入力フォームで完全一致(match)を選択したら
      match(model, value)    # matchアクションを実行
    when 'forward'
      forward(model, value)
    when 'backward'
      backward(model, value)
    when 'partical'
      partical(model, value)
    end
  end
end
