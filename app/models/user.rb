class User < ActiveRecord::Base
  has_many :sent_emails, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
