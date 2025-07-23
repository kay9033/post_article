class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy

  # Ban関連のスコープ
  scope :banned, -> { where(banned: true) }
  scope :active, -> { where(banned: false) }

  # Ban関連のメソッド
  def ban!(reason = nil)
    update!(banned: true, banned_at: Time.current, ban_reason: reason)
  end

  def unban!
    update!(banned: false, banned_at: nil, ban_reason: nil)
  end

  def banned?
    banned
  end

  def active_for_authentication?
    super && !banned?
  end

  def inactive_message
    banned? ? :banned : super
  end

  # Ransack設定 - 検索可能な属性を明示的に指定（セキュリティ重要）
  def self.ransackable_attributes(auth_object = nil)
    ["banned", "banned_at", "created_at", "email", "id", "updated_at"]
  end

  # Ransack設定 - 検索可能な関連を明示的に指定
  def self.ransackable_associations(auth_object = nil)
    ["articles"]
  end
end
