ActiveAdmin.register Article do
  permit_params :title, :body, :user_id

  # インデックスページの設定
  index do
    selectable_column
    id_column
    column :title do |article|
      link_to truncate(article.title, length: 50), admin_article_path(article)
    end
    column :user do |article|
      link_to article.user.email, admin_user_path(article.user)
    end
    column :body do |article|
      truncate(article.body, length: 100)
    end
    column :created_at
    actions
  end

  # フィルター設定
  filter :title
  filter :user, as: :select, collection: -> { User.all.map { |u| [u.email, u.id] } }
  filter :created_at

  # 詳細ページの設定
  show do
    attributes_table do
      row :id
      row :title
      row :user do |article|
        link_to article.user.email, admin_user_path(article.user)
      end
      row :body do |article|
        simple_format(article.body)
      end
      row :created_at
      row :updated_at
    end

    panel "ユーザー情報" do
      attributes_table_for article.user do
        row :email
        row :banned do |user|
          status_tag(user.banned? ? 'BANNED' : 'ACTIVE', 
                     class: user.banned? ? 'error' : 'ok')
        end
        row :created_at
        row "記事数" do |user|
          user.articles.count
        end
        row "操作" do |user|
          if user.banned?
            link_to 'Ban解除', unban_admin_user_path(user), method: :patch,
                    class: 'button', confirm: 'Ban解除しますか？'
          else
            link_to 'ユーザーをBan', new_ban_admin_user_path(user), class: 'button'
          end
        end
      end
    end
  end

  # 編集フォーム設定
  form do |f|
    f.inputs do
      f.input :title
      f.input :body, as: :text, rows: 10
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
    end
    f.actions
  end

  # 削除時の確認メッセージをカスタマイズ
  controller do
    def destroy
      @article = Article.find(params[:id])
      @article.destroy
      redirect_to admin_articles_path, notice: "記事「#{@article.title}」を削除しました。"
    end
  end

  # バッチアクション
  batch_action :destroy, confirm: "選択した記事を削除しますか？" do |ids|
    articles = Article.where(id: ids)
    count = articles.count
    articles.destroy_all
    redirect_to collection_path, notice: "#{count}件の記事を削除しました。"
  end
end
