class AddCalendarTokenToUsers < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    add_column :users, :ics_token, :string

    add_concurrent_index :users, :ics_token
  end

  def down
    remove_concurrent_index :users, :ics_token if index_exists? :users, :ics_token

    remove_column :users, :ics_token
  end
end
