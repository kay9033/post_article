ActiveAdmin.register User do
  permit_params :email, :banned, :ban_reason

  # インデックスページの設定
  index do
    selectable_column
    id_column
    column :email
    column :banned do |user|
      status_tag(user.banned? ? 'BANNED' : 'ACTIVE', 
                 class: user.banned? ? 'error' : 'ok')
    end
    column :banned_at
    column :articles_count do |user|
      user.articles.count
    end
    column :created_at
    actions do |user|
      if user.banned?
        link_to 'Ban解除', unban_admin_user_path(user), method: :patch, 
                class: 'button', confirm: 'Ban解除しますか？'
      else
        link_to 'Ban', new_ban_admin_user_path(user), class: 'button'
      end
    end
  end

  # フィルター設定
  filter :email
  filter :banned
  filter :banned_at
  filter :created_at

  # 詳細ページの設定
  show do
    attributes_table do
      row :id
      row :email
      row :banned do |user|
        status_tag(user.banned? ? 'BANNED' : 'ACTIVE', 
                   class: user.banned? ? 'error' : 'ok')
      end
      row :banned_at
      row :ban_reason
      row :created_at
      row :updated_at
    end

    panel "記事一覧" do
      table_for user.articles.recent do
        column :id
        column :title do |article|
          link_to article.title, admin_article_path(article)
        end
        column :created_at
        column :updated_at
        column "操作" do |article|
          link_to '削除', admin_article_path(article), method: :delete,
                  confirm: '記事を削除しますか？', class: 'button'
        end
      end
    end
  end

  # スコープ設定
  scope :all, default: true
  scope :active
  scope :banned

  # カスタムアクション
  member_action :new_ban, method: :get do
    @user = resource
    render 'new_ban'
  end

  member_action :ban, method: :patch do
    @user = resource
    reason = params[:ban_reason]
    if @user.ban!(reason)
      redirect_to admin_user_path(@user), notice: "#{@user.email}をBANしました。"
    else
      redirect_to admin_user_path(@user), alert: "BANに失敗しました。"
    end
  end

  member_action :unban, method: :patch do
    @user = resource
    if @user.unban!
      redirect_to admin_user_path(@user), notice: "#{@user.email}のBANを解除しました。"
    else
      redirect_to admin_user_path(@user), alert: "BAN解除に失敗しました。"
    end
  end
end
