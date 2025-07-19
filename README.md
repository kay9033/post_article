# 記事投稿アプリケーション

Ruby on Rails と Docker を使用した記事投稿・閲覧 Web アプリケーションです。

## 概要

ユーザー登録・ログイン後、記事を投稿・編集・削除・閲覧できる Web アプリケーションです。記事の公開は即時であり、全ユーザーが他ユーザーの記事も閲覧できます。

## 主要機能

| 機能名                 | 内容                            |
| ---------------------- | ------------------------------- |
| ユーザー登録・ログイン | Devise を用いたユーザー認証機能 |
| 記事一覧表示           | 全記事を一覧で表示              |
| 記事詳細表示           | 特定の記事の内容を表示          |
| 記事投稿               | 認証済みユーザーによる記事作成  |
| 記事編集               | 自身の投稿記事のみ編集可能      |
| 記事削除               | 自身の投稿記事のみ削除可能      |

## 技術スタック

- **Ruby**: 3.3.4
- **Rails**: 7.2.2.1
- **データベース**: MySQL 8.0
- **認証**: Devise
- **コンテナ**: Docker & Docker Compose
- **フロントエンド**: HTML/CSS/JavaScript (Turbo, Stimulus)
- **キャッシュ**: Redis

## API 仕様（ユーザー側）

| メソッド  | パス               | 認証 | 機能説明                                 |
| --------- | ------------------ | ---- | ---------------------------------------- |
| GET       | /articles          | 不要 | 記事一覧を表示                           |
| GET       | /articles/:id      | 不要 | 記事の詳細を表示                         |
| GET       | /articles/new      | 必要 | 記事投稿フォームを表示                   |
| POST      | /articles          | 必要 | 記事を新規作成                           |
| GET       | /articles/:id/edit | 必要 | 記事編集フォームを表示（投稿者本人のみ） |
| PATCH/PUT | /articles/:id      | 必要 | 記事を更新（投稿者本人のみ）             |
| DELETE    | /articles/:id      | 必要 | 記事を削除（投稿者本人のみ）             |

## データベース設計

### ユーザー（users）

| カラム名                | 型       | 備考        |
| ----------------------- | -------- | ----------- |
| id                      | bigint   | 主キー      |
| email                   | string   | Devise 標準 |
| encrypted_password      | string   | Devise 標準 |
| created_at / updated_at | datetime | Rails 標準  |

### 記事（articles）

| カラム名                | 型       | 備考                           |
| ----------------------- | -------- | ------------------------------ |
| id                      | bigint   | 主キー                         |
| title                   | string   | タイトル、必須（255 文字以内） |
| body                    | text     | 本文、必須                     |
| user_id                 | bigint   | 投稿者（外部キー）             |
| created_at / updated_at | datetime | Rails 標準                     |

## セットアップ手順

### 前提条件

- Docker Desktop がインストールされていること
- Git がインストールされていること

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd post_article
```

### 2. アプリケーションの起動

```bash
# Dockerコンテナの起動
docker compose up -d

# データベースの作成
docker compose exec web rails db:create

# マイグレーションの実行
docker compose exec web rails db:migrate

# サンプルデータの投入（オプション）
docker compose exec web rails db:seed
```

### 3. アプリケーションへのアクセス

ブラウザで以下の URL にアクセス：

```
http://localhost:3000
```

## サンプルアカウント

サンプルデータを投入した場合、以下のアカウントでログインできます：

**アカウント 1:**

- Email: `user1@example.com`
- Password: `password`

**アカウント 2:**

- Email: `user2@example.com`
- Password: `password`

## データベース接続情報（開発用）

**DBeaver 等のデータベース管理ツールで接続する場合：**

- Host: `localhost`
- Port: `3307`
- Database: `post_article_development`
- Username: `root`
- Password: `password`

## 開発コマンド

```bash
# コンテナの起動
docker compose up -d

# コンテナの停止
docker compose down

# Railsコンソール
docker compose exec web rails console

# ログの確認
docker compose logs web

# テストの実行
docker compose exec web rspec

# Bundleインストール
docker compose run web bundle install

# 新しいgem追加後
docker compose run web bundle install
docker compose restart web
```

## 権限設計

| アクション        | 全ユーザー | 認証済ユーザー | 投稿者本人 |
| ----------------- | ---------- | -------------- | ---------- |
| 記事一覧/詳細閲覧 | ✅         | ✅             | ✅         |
| 記事投稿          | ❌         | ✅             | ✅         |
| 記事編集/削除     | ❌         | ❌             | ✅         |

## バリデーション

- **Article モデル**
  - `title`：必須、255 文字以内
  - `body`：必須

## ディレクトリ構成

```
post_article/
├── app/
│   ├── controllers/        # コントローラー
│   ├── models/             # モデル
│   ├── views/              # ビュー
│   └── assets/             # CSS/JavaScript
├── config/                 # 設定ファイル
├── db/                     # データベース関連
├── docker-compose.yml      # Docker設定
├── Dockerfile             # Dockerイメージ設定
└── Gemfile                # Ruby gem設定
```

## トラブルシューティング

### ポート競合エラー

ローカルの MySQL が 3306 ポートを使用している場合、Docker コンテナは 3307 ポートを使用しています。

### データベース接続エラー

```bash
# データベースコンテナの再起動
docker compose restart db

# ログの確認
docker compose logs db
```

### アプリケーションが起動しない

```bash
# すべてのコンテナを再作成
docker compose down
docker compose up --build -d
```

## ライセンス

このプロジェクトは MIT ライセンスの下で公開されています。

## 作成者

記事投稿アプリケーション開発チーム
