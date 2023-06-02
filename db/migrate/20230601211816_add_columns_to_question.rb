class AddColumnsToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :success, :boolean
    add_column :questions, :answer, :string
    add_column :questions, :question, :string
  end
end
