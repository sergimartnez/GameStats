require 'pry'

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

class Game
  attr_accessor :players_count, :team_1_name, :team_2_name, :team_1_players, 
                :team_2_players, :winner, :mvp, :team_1_points, :team_2_points
  def initialize
    @players_count = 0
    @winner=nil
    @mvp=nil
    @mvp_team_1=nil
    @mvp_team_2=nil
    @team_1_name=nil
    @team_2_name=nil
    @team_1_points=nil
    @team_2_points=nil
    @team_1_players=[]
    @team_2_players=[]
  end

  def show_results
    puts "Team #{@team_1_name} has scored #{@team_1_points} points/goals."
    puts "Team #{@team_2_name} has scored #{@team_2_points} points/golas."
    puts "The winner of this Game is #{@winner}"
    puts "The MVP of team #{@team_1_name} is #{@mvp_team_1.name} with #{@mvp_team_1.rating_points} rating points."
    puts "The MVP of team #{@team_2_name} is #{@mvp_team_2.name} with #{@mvp_team_2.rating_points} rating points."
    puts "The MVP of the game is #{@mvp.name} with #{@mvp.rating_points} rating points."
  end

  def add_player player
    if player.team_name == @team_1_name
      @team_1_players.push(player)
    elsif player.team_name == @team_2_name
      @team_2_players.push(player)
    end
    @players_count+=1
  end

  def get_game_mvp
    if @mvp_team_1.rating_points > @mvp_team_2.rating_points
      @mvp=@mvp_team_1
    else
      @mvp=@mvp_team_2
    end

  end

  def get_teams_mvp
    @mvp_team_1 = @team_1_players.max_by do |player|
      player.rating_points
    end
    @mvp_team_2 = @team_2_players.max_by do |player|
      player.rating_points
    end
  end

  def get_winner_team
    if @team_1_points > @team_2_points
      @winner=@team_1_name
      # Add 10 points to MVP from team 1
      @mvp_team_1.rating_points+=10
    else
      @winner=@team_2_name
      # Add 10 points to MVP from team 2
      @mvp_team_2.rating_points+=10
    end
  end

end


class BasketballGame < Game
  # Creating specific Game class for Basketball in case there are any
  # specific method for this sport. Inherits from Game
  def read_player_line line

    player_info = line.gsub("\n",'').split(";")
    return false if line_with_errors?(player_info) == true

    # player name;nickname;number;team name;position;scored points;rebounds;assists
    player = BasketballPlayer.new(player_info[0], player_info[1], player_info[2].to_i, player_info[3],
                                      player_info[4], player_info[5].to_i, player_info[6].to_i, player_info[7].to_i)
    player.get_player_points

    if @team_1_name == nil
      @team_1_name = player.team_name
    elsif @team_2_name == nil && @team_1_name != player.team_name
      @team_2_name = player.team_name
    end
    add_player player

  end

  def line_with_errors? player_info
    return true if player_info.length!=8 || !player_info[5].is_i? || !player_info[6].is_i? || 
                  !player_info[7].is_i? || !["G", "F", "C"].include?(player_info[4])
    false
  end

  def get_team_points
    @team_1_points = @team_1_players.reduce(0) do |points, player|
      points + player.scored_points
    end
    @team_2_points = @team_2_players.reduce(0) do |points, player|
      points + player.scored_points
    end
  end
end

class HandballGame < Game
  # Creating specific Game class for Handball in case there are any
  # specific method for this sport. Inherits from Game
  def read_player_line line
    player_info = line.gsub("\n",'').split(";")
    return false if line_with_errors?(player_info) == true

    # player name;nickname;number;team name;position;goals made;goals received
    player = HandballPlayer.new(player_info[0], player_info[1], player_info[2].to_i, player_info[3],
                                      player_info[4], player_info[5].to_i, player_info[6].to_i)
        
    player.populate_rating_initial_points
    player.get_player_points

    if @team_1_name == nil
      @team_1_name = player.team_name
    elsif @team_2_name == nil && @team_1_name != player.team_name
      @team_2_name = player.team_name
    end
    add_player player

  end

  def line_with_errors? player_info
    return true if player_info.length!=7 || !player_info[5].is_i? || !player_info[6].is_i? || 
                   !["G", "F"].include?(player_info[4])
    false
  end

  def get_team_points
    @team_1_points = @team_1_players.reduce(0) do |points, player|
      points + player.goal_made
    end
    @team_2_points = @team_2_players.reduce(0) do |points, player|
      points + player.goal_made
    end
  end
end

class BasketballPlayer
  attr_accessor :name, :nickname, :number, :team_name, :position, :scored_points, 
                :rebounds, :assists, :rating_points
  def initialize name, nickname, number, team_name, position, scored_points, rebounds, assists
    @name=name
    @nickname=nickname
    @number=number
    @team_name=team_name
    @position=position
    @scored_points=scored_points
    @rebounds=rebounds
    @assists=assists
    @rating_points=nil
  end

  def get_player_points
    if position == "G"
      @rating_points = @scored_points*2 + @rebounds*3 + @assists*1
    elsif position == "F"
      @rating_points = @scored_points*2 + @rebounds*2 + @assists*2
    elsif position == "C"
      @rating_points = @scored_points*2 + @rebounds*1 + @assists*3
    end
  end
end

class HandballPlayer
  attr_accessor :name, :nickname, :number, :team_name, :position, :goal_made, 
                :goal_received, :initial_rating_points, :rating_points
  def initialize name, nickname, number, team_name, position, goal_made, goal_received
    @name=name
    @nickname=nickname
    @number=number
    @team_name=team_name
    @position=position
    @goal_made=goal_made
    @goal_received=goal_received
    @initial_rating_points=nil
    @rating_points=nil
  end

  def populate_rating_initial_points
    if @position == "G"
      @initial_rating_points = 50
    else
      @initial_rating_points = 20
    end
  end

  def get_player_points
    if position == "G"
      @rating_points = @initial_rating_points + @goal_made*5 - @goal_received*2
    elsif position == "F"
      @rating_points = @initial_rating_points + @goal_made*1 - @goal_received*1
    end
  end
end

loop do
  puts "\nPlease input the name of the file with the stats of the Game:"
  file_name = gets.chomp
  if File.exist?("game_files/#{file_name}.txt")
    file = File.open("game_files/#{file_name}.txt", "r")
  else
    puts "\nThe filename that you have provided does not exist. Please try again."
    next
  end
  line_num = 1
  play_again = "y"
  game = nil
  file.each_line do |line|
    if line_num == 1
      # read the name of the Game and create it
      if line.include?("BASKETBALL")
        puts "\nIt is a basketball game!"
        game = BasketballGame.new
      elsif line.include?("HANDBALL")
        puts "\nIt is a handball game!"
        game = HandballGame.new
      else
        puts "This game is not recognized by this tool or the stats file is wrong."
        puts "Do you want to try with a new File Game stats? (y/n)"
        play_again = gets.chomp
        break
      end
    else
      # player line
      if game.read_player_line(line) == false
        puts "The file is wrong."
        puts "Do you want to try with a new File Game stats? (y/n)"
        play_again = gets.chomp
        break
      end
    end
    line_num+=1
  end

  break if play_again != "y"
  game.get_team_points
  game.get_teams_mvp
  game.get_winner_team
  game.get_game_mvp
  game.show_results
  puts "\nDo you want to try with a new Game? (y/n)"
  play_again = gets.chomp
  break if play_again != "y"
end

