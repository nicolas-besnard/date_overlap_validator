require 'active_record'
ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Migration.create_table :events do |t|
  t.datetime :starts_at
  t.datetime :ends_at
end

ActiveRecord::Migration.create_table :custom_field_events do |t|
  t.datetime :custom_starts_at
  t.datetime :custom_ends_at
end

ActiveRecord::Base.raise_in_transactional_callbacks = true

class Event < ActiveRecord::Base
end

class CustomFieldEvent < ActiveRecord::Base
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'date_overlap_validator'
