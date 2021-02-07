# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint           not null, primary key
#  app_info   :jsonb
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_api_keys_on_token  (token)
#
class ApiKey < ApplicationRecord
  include RandomAlphaNumeric

  before_create -> { assign_unique_id(field: :token) }

  def self.valid_token?(token)
    ApiKey.exists?(token: token)
  end
end
