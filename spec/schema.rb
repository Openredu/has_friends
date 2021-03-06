ActiveRecord::Schema.define(:version => 0) do
  begin
    drop_table :users
    drop_table :friendships
  rescue
  end

  create_table :users do |t|
    t.string :login
    t.integer :friends_count, :default => 0, :null => false
  end

  create_table :friendships do |t|
    t.references :user, :friend
    t.string :status
    t.datetime :requested_at, :null => false
    t.datetime :accepted_at, :null => true, :default => nil
  end

  create_table :things do |t|
    t.references :friendship
  end
end
