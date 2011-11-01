class User < ActiveRecord::Base
  acts_as_authentic

  def init
    self.games_played, self.games_lost, self.games_won = 0, 0, 0
    self.balance, self.cashflow = 1000, 1000
    self.num_sessions, self.games_per_session_avg = 1, 0
  end
end
