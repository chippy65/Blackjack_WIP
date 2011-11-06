class CardtableController < ApplicationController

  def fresh
    @cardtable = Cardtable.new
    @cardtable.startup(current_player)

    respond_to do |format|
      format.html
      format.xml
    end
  end
end
