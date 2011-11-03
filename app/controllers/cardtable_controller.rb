class CardtableController < ApplicationController
  def fresh
    Cardtable.startup

    respond_to do |format|
      format.html
      format.xml
    end
  end
end
