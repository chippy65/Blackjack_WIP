class CardtableController < ApplicationController

  def fresh

    # Delete any records that are in the table. Even if we have deleted them
    # after each game, the player may start a new game without finishing a
    # previous game normally, i.e. by repeatedly selecting "Start New..."
    Cardtable.delete_all

    # Create a new cardtable and initialise
    @cardtable = Cardtable.new
    @cardtable.startup(current_player)

    # Save this instance so we can get it and use it again
    @cardtable.save

    # Show the state of the table before we start the game
    respond_to do |format|
      format.html
      format.xml { render :xml => @cardtable }
    end
  end

  def buttonClick

    # There should only be one record in the database as there's only one
    # cardtable session in progress at any one time
    @cardtable = Cardtable.first

    # Find out which button was hit and perform the appropriate action
    if params[:submit] == "Deal"
      @cardtable.deal
    elsif params[:submit] == "Hit"
      @cardtable.hit
    elsif params[:submit] == "Stand"
      @cardtable.setBet(200)
    elsif params[:submit] == "Double"
      @cardtable.setBet(300)
    elsif params[:submit] == "Shuffle"
      @cardtable.shuffle
    end

    # Save this instance so we can get it and use it again
    @cardtable.save

    respond_to do |format|
      format.html
      format.xml { render :xml => @cardtable }
    end
  end
end
