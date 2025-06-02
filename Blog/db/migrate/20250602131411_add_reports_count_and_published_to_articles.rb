class AddReportsCountAndPublishedToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :reports_count, :integer
    add_column :articles, :published, :boolean
  end
end
