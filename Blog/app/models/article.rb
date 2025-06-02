class Article < ApplicationRecord
  belongs_to :user

  before_create :set_defaults

  mount_uploader :image, ImageUploader

  def set_defaults
    self.published = true if published.nil?
    self.image = "" if image.nil?
    self.reports_count = 0 if reports_count.nil?
  end
end
