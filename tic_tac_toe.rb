
class Board
  attr_accessor :positions

  def initialize
    setup
    @WINNING_POSITIONS =
      [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
  end

  def play
    show_opening_credits
    exit_game = false
    until exit_game
      show_new_game_message
      show_positions
      until check_board
        print "#{@player}: "
        while input = gets.chomp.downcase
          if input == "help"
            show_help_message
          elsif input_ok?(input)
            choose_position(input)
            show_positions
            @turns_played += 1
            switch_player
            break
          end
          print "#{@player}: "
        end
      end
      print "Play a new game? (y/n): "
      while input = gets.chomp.downcase
        if input == "y" || input == "yes"
          reset
          break
        elsif input == "n" || input == "no"
          slowly
          slowly "Thank you for playing."
          slowly
          exit_game = true
          break
        else
          puts "Please type yes or no."
          print "Play a new game? (y/n): "
        end
      end
    end
  end

  private

  def setup
    @turns_played = 0
    @player = "x"
    @positions = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
  end

  def reset
    setup
  end

  def slowly (string = "")
    sleep_time = 0.02
    string.each_char do |char|
      putc char
      sleep(sleep_time)
      $stdout.flush
    end
    sleep(sleep_time)
    puts
  end

  def show_opening_credits
    slowly
    slowly "——————————"
    slowly "TIC-TAC-TOE"
    slowly "——————————————————"
    slowly "Programmed by Nikolas Broman."
    slowly "——————————————————————————————"
  end

  def show_new_game_message
    slowly
    slowly "The board is empty."
    slowly "Player \"#{@player}\" begins."
  end

  def show_help_message
    slowly
    slowly "The goal of tic-tac-toe is to get three in a row,"
    slowly "either horizontally, vertically or diagonally."
    slowly
    slowly "Here is the board again,"
    slowly "with numerical positions (1-9) visible:"
    show_positions_with_numbers
    slowly "Type a number (1-9) and press enter."
  end

  def choose_position(input)
    @positions[input.to_i - 1] = @player
  end

  def switch_player
    @player == "x" ? @player = "o" : @player = "x"
  end

  def show_positions(positions = @positions)
    puts
    puts positions[0..2].join(" ")
    puts positions[3..5].join(" ")
    puts positions[6..8].join(" ")
    puts
  end

  def show_positions_with_numbers
    positions_with_numbers = @positions.map.with_index do |pos, index| 
      if pos == "-"
        index + 1
      else
        pos
      end
    end
    show_positions(positions_with_numbers)
  end

  def input_ok?(input)
    if input =~ /^[1-9]$/
      if @positions[input.to_i - 1] == "-"
        true
      else
        puts "Position #{input} is already taken by \"#{@positions[input.to_i - 1]}\"."
      end
    else
      puts "Please input a numerical position (1-9), or type 'help' for more help."
    end
  end

  def check_board
    if @turns_played < 5
      return false
    else
      @WINNING_POSITIONS.each do |wp|
        unless @positions[wp[0]] == "-"
          if @positions[wp[0]] == @positions[wp[1]] && @positions[wp[1]] == @positions[wp[2]]
            declare_victory
            return true
          end
        end
      end
      if @turns_played >= 9
        puts "Neither player wins. It's a tie."
        puts
        return true
      end
    end
  end

  def declare_victory
    switch_player #to switch back, because switch_player was called before checking for victory
    puts "Player \"#{@player}\" wins!"
    puts
  end
end


board = Board.new
board.play