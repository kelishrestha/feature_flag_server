# frozen_string_literal: true

# Assign unique uid
module RandomAlphaNumeric
  def assign_unique_id(field: :uid)
    raise ActiveModel::MissingAttributeError unless has_attribute?(field)
    return if send(field)

    loop do
      random_id = SecureRandom.hex(12)
      break write_attribute(field, random_id) unless self.class.exists?(field => random_id)
    end
  end
end
