class RenameEmailToBouncedEmail < ActiveRecord::Migration
  def change
    rename_table :emails, :bounced_emails
  end
end
