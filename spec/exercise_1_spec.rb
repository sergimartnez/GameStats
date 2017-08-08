require_relative "../exercise_1"
require "spec_helper"

describe "Exercise1" do
  it "Create a Basketball player and check its calculated rating points" do
    player = BasketballPlayer.new("Test", "Test", 4, "Test team", "G", "10", "2", "7")
    expect(player.get_player_points).to eq(33)
  end
  it "Create a Handball player and check its calculated rating points" do
    player = HandballPlayer.new("player 2", "nick2", "8", "Team A", "F", "15", "20")
    expect(player.get_player_points).to eq(15)
  end
  it "Test that a basketball player line is correct" do
    game = BasketballGame.new
    expect(game.line_with_errors?(["player 1","nick1","4","Team A","G","10","2","7"])).to eq(false)
  end
  it "Test that a basketball player line is wrong" do
    game = BasketballGame.new
    expect(game.line_with_errors?(["player 1","nick1","4","Team A","G","abc","2","7"])).to eq(true)
  end
  it "Test that a handball player line is correct" do
    game = HandballGame.new
    expect(game.line_with_errors?(["layer 1","nick1","4","Team A","G","0","20"])).to eq(false)
  end
  it "Test that a handball player line is wrong" do
    game = HandballGame.new
    expect(game.line_with_errors?(["layer 1","nick1","4","Team A","H","0","20"])).to eq(true)
  end
end