class Divingsite < ApplicationRecord
  belongs_to :country
  has_many :reviews, dependent: :destroy
  has_many :reviews
  acts_as_votable
  has_attached_file :divesiteimage, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :divesiteimage, content_type: /\Aimage\/.*\z/


  def self.search(search)
    where("name LIKE ?", "%#{search}%")
  end

  def rating_average
    review_ratings = []
    if self.reviews.count == 0
      return 0
    else
    self.reviews.each do |review|
      review_ratings << review.rating
    end
  end
    review_ratings.inject(0.0) { |sum, el| sum + el } / review_ratings.size
  end

  def self.top
    Divingsite.all.max_by do |divingsite|
      divingsite.rating_average
    end
  end

  def self.topfive
    Divingsite.all.max_by(5) do |divingsite|
      divingsite.rating_average
    end
  end


end
