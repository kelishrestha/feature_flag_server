class CreateApiKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :api_keys do |t|
      t.jsonb :app_info
      t.string :token

      t.timestamps
    end
    add_index :api_keys, :token
  end
end
