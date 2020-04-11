class CreateCaseloads < ActiveRecord::Migration[5.1]
  def change
    create_table :counties do |t|
      t.string :name
      t.string :state
      t.string :fips
    end

    create_table :caseloads do |t|
      t.date :date
      t.references :county, index: true, foreign_key: true
      t.integer :cases
      t.integer :deaths

      t.timestamps
    end
  end
end
