class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :postmark_id
      t.string :type
      t.string :tag
      t.string :message_id
      t.integer :type_code
      t.string :to_email
      t.date :bounced_at
      t.string :details
      t.boolean :dump_available
      t.boolean :inactive
      t.boolean :can_activate
      t.string :subject

      t.timestamps
    end
  end
end
