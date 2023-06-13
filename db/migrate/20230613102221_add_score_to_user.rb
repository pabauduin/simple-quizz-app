class AddScoreToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :score, :string
  end
end
