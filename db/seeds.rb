# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# サンプルユーザーの作成
user1 = User.find_or_create_by!(email: "user1@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

user2 = User.find_or_create_by!(email: "user2@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

# サンプル記事の作成
Article.find_or_create_by!(title: "Railsアプリケーションの始め方", user: user1) do |article|
  article.body = <<~BODY
    Ruby on Railsは、Webアプリケーションを迅速に開発するためのフレームワークです。

    ## Railsの特徴

    1. **Convention over Configuration**: 設定よりも規約を重視
    2. **DRY (Don't Repeat Yourself)**: 同じことを繰り返さない
    3. **MVC アーキテクチャ**: Model-View-Controller パターンを採用

    ## 基本的な開発フロー

    1. アプリケーションの作成
    2. モデルの設計
    3. コントローラーの実装
    4. ビューの作成
    5. ルーティングの設定

    Railsを使用することで、効率的にWebアプリケーションを開発できます。
  BODY
end

Article.find_or_create_by!(title: "Dockerを使った開発環境構築", user: user2) do |article|
  article.body = <<~BODY
    Dockerを使用することで、一貫した開発環境を構築できます。

    ## Dockerのメリット

    - 環境の一貫性
    - 簡単なセットアップ
    - ポータビリティ

    ## docker-compose.ymlの基本設定

    ```yaml
    version: '3'
    services:
      web:
        build: .
        ports:
          - "3000:3000"
        depends_on:
          - db
      db:
        image: mysql:8.0
        environment:
          MYSQL_ROOT_PASSWORD: password
    ```

    この設定により、WebサーバーとデータベースをDocker上で起動できます。
  BODY
end

Article.find_or_create_by!(title: "Webアプリケーションのセキュリティ", user: user1) do |article|
  article.body = <<~BODY
    Webアプリケーションを開発する際は、セキュリティを考慮することが重要です。

    ## 主要なセキュリティ対策

    ### 1. 認証・認可
    - 適切なユーザー認証システムの実装
    - 権限に基づくアクセス制御

    ### 2. データの保護
    - パスワードのハッシュ化
    - 機密データの暗号化

    ### 3. 入力値検証
    - SQLインジェクション対策
    - XSS（Cross-Site Scripting）対策

    ### 4. HTTPS通信
    - データ通信の暗号化
    - SSL/TLS証明書の適切な設定

    定期的なセキュリティ監査も重要です。
  BODY
end

puts "サンプルデータの作成が完了しました！"
puts "ユーザー: #{User.count}人"
puts "記事: #{Article.count}件"

# 管理者ユーザーの作成
if Rails.env.development?
  admin_user = AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
  puts "管理者ユーザー: #{admin_user.email}"
end
