class Cardtable < ActiveRecord::Base

  belongs_to :game
  belongs_to :player_record, :class_name => "User", :foreign_key => 'player_id'
  belongs_to :dealer_record, :class_name => "User", :foreign_key => 'dealer_id'

  serialize :player
  serialize :dealer
  serialize :deck


  def startup(theplayer)
    # Setup its dealer, player and game associations

    # Find the dealer record and associate it with this cardtable object
    self.dealer_record = User.find(26)
    # Update the number of game sessions for the dealer
    self.dealer_record.num_sessions += 1
    self.dealer_record.save

    # Associate the cardtable player with the logged in user
    self.player_record = theplayer
    # Update the user information regarding sessions
    self.player_record.num_sessions += 1
    self.player_record.save

    # Create and save a new game object/record
    @game = self.create_game
    # Associate the game_id with that saved game object/record
    self.game = @game
    # Initialize the game stats for this game
    self.game.user = self.player_record
    self.game.amount = 200
    self.game.session_num = self.player_record.num_sessions
    # Save the game here for testing purposes
    self.game.save

    # Create a new shuffled desk of cards
    self.deck = Deck.new

    # Create a new dealer object
    self.dealer = Player.new

    # Create a new player object
    self.player = Player.new

    # Set the bet to be 0 initially
    self.bet = 0

    # Dummy test stuff

    # Dummy deal
    self.deal
  end

  def setBet(amount)
    # Set the bet on the cardtable
    self.bet = amount
  end

  def deal
    # This is the beginning of a new game
    # Deal 2 cards to both the dealer and the player
    self.deck.deal(self.player)
    self.deck.deal(self.player)

    self.deck.deal(self.dealer)
    self.deck.deal(self.dealer)
    # The second card dealt to the dealer is face down
    self.dealer.hand[1].faceup = false

    # Update the number of games played by the player and dealer
    self.player_record.games_played += 1
    self.dealer_record.games_played += 1

    # Assume that

  end

  def shuffle
    # Shuffle the deck
    self.deck.shuffle
  end

  def endGame
    # Collect all the dealer cards and players cards and put them
    # to the end of the deck

    # Update the stats for the dealer

    # Update the stats for the player

  end

end

class Player

  attr_accessor :hand, :isawinner

  def initialize
    # Initially, each player has an empty hand of cards and they are assumed
    # to be the loser of the game. This is in case the player kills the game
    # before the end and that player is assumed to have lost.
    self.hand = Array.new
    self.isawinner = false
  end
end

class Card
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SCORES = %w(2 3 4 5 6 7 8 9 10 10 10 10 11)
  SUITS = %w(Spades Clubs Hearts Diamonds)

  attr_accessor :rank, :score, :suit, :image, :faceup

  def initialize(index)
    # Init the rank, suit, score and image of each card based on the
    # argument passed in
    self.rank = RANKS[index % 13]
    self.score = SCORES[index % 13]
    self.suit = SUITS[index % 4]
    self.image = "/images/" + self.rank + self.suit + ".png"

    # By default, each card is assumed to be dealt face up. When we start
    # playing, only the second card of the dealer will be dealt face down.
    # When it is the dealer's turn to play, this card will be set to be face up
    self.faceup = true
  end

end

class Deck
 
  attr_accessor :cards, :nextcard

  def initialize
    # Create an array of 52 shuffled cards to be the deck
    self.cards = (0..51).to_a.shuffle.collect { |index| Card.new(index) }

    # Set the first card to be dealt as the card at index 0 in the deck
    self.nextcard = 0
  end

  def deal(player)
    # Add the next card in the deck to the player's hand
    player.hand << self.cards[self.nextcard]

    # And then increment the position in the deck of the next card to be dealt
    self.nextcard = (self.nextcard + 1) % 52
  end

  def shuffle
    # Shuffle the cards in the deck and set the next card to be dealt
    # as the card at index 0
    self.cards = self.cards.shuffle
    self.nextcard = 0
  end

end
