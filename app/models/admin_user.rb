class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  # Ransack設定 - 検索可能な属性を明示的に指定
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "remember_created_at", "reset_password_sent_at", "updated_at"]
  end

  # Ransack設定 - 検索可能な関連を明示的に指定
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
