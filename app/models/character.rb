# == Schema Information
#
# Table name: characters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  actor_id   :integer
#  movie_id   :integer
#
class Character < ApplicationRecord
  def movie
    m_id = self.movie_id 

    matching_movies = Movie.where({ :id => m_id })

    the_movie = matching_movies.at(0)

    return the_movie
  end
end
