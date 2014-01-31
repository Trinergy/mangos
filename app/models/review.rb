class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :movie

  validates :user,
    presence: true

  validates :movie,
    presence: true

  validates :text,
    presence: true

  validates :rating_out_of_ten,
    numericality: { only_integer: true }
  validates :rating_out_of_ten,
    numericality: { greater_than_or_equal_to: 1 }
  validates :rating_out_of_ten,
    numericality: { less_than_or_equal_to: 10 }

  after_create :recalculate_average_rating_for_movie
  validate :initial_review_from_user

  protected

  def initial_review_from_user
    self.movie.reviews.each do |review|
      if review.user == self.user
        self.errors.add :base, "You've already reviewed this movie"
      end
    end
  end

  def recalculate_average_rating_for_movie
    puts "Business time"
    self.movie.average_rating = self.movie.calculate_average_rating
    self.movie.save
  end
    
end
