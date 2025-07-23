class Article < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true

  scope :recent, -> { order(created_at: :desc) }

  # Ransack設定 - 検索可能な属性を明示的に指定
  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "title", "updated_at", "user_id"]
  end

  # Ransack設定 - 検索可能な関連を明示的に指定
  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end
