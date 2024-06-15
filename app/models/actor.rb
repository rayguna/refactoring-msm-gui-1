# == Schema Information
#
# Table name: actors
#
#  id         :integer          not null, primary key
#  bio        :text
#  dob        :date
#  image      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Actor < ApplicationRecord
  attr_accessor(:movie_id)

  def characters
    a_id = self.id

    matching_characters = Character.where({ :actor_id => a_id })

    return matching_characters
  end
end
