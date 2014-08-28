class CreateSentEmails < ActiveRecord::Migration
  def change
    create_table :sent_emails do |t|
      t.string :message_id
      t.string :to
      t.references :user, index: true

      t.timestamps
    end
  end
end
