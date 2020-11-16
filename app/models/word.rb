class Word
  include ActiveModel::Validations

  validates :name, presence: {message: 'Please enter a word before searching'}
  validates :name, format: { with: /\A[A-Za-z]*\z/, message: 'Please enter a word without numbers, special characters, or spaces' }
  attr_reader :name
  attr_accessor :definition

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end

end
