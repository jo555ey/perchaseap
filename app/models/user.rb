class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  has_many :ownerships
  has_many :items, through: :ownerships
  has_many :keeps
  has_many :keep_items, through: :keeps, class_name: 'Item', source: :item
  
  def keep(item)
    self.keeps.find_or_create_by(item_id: item.id)
  end

  def unkeep(item)
    keep = self.keeps.find_by(item_id: item.id)
    keep.destroy if keep
  end

  def keep?(item)
    self.keep_items.include?(item)
  end
  
  has_secure_password
end
