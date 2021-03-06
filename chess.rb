require 'yaml'

# Data structure representing a single square on the chess board
class BoardSquare
  attr_accessor :row, :col, :occupant
  
  def initialize
    @row = -1
    @col = -1
    @occupant = nil
  end
end

# Data structure representing a single chess piece
# player_ID : White = 1, Black = 2
# type: 1 = pawn, 2 = rook, 3 = knight, 4 = bishop, 5 = king, 6 = queen
class ChessPiece
  attr_accessor :type, :player_ID, :number, :row, :col, :possible_moves, :alive
  
  def initialize
    @type = -1
    @player_ID = -1
    @row = -1
    @col = -1
    @possible_moves = []
    @alive = true
  end
end

# Class representing a fully playable chess game
class Chess
  attr_accessor :board, :pawns, :rooks, :knights, :bishops, :kings, :queens, :p1_possible_movelist, :p2_possible_movelist, :p1_possible_movelist_src, :p2_possible_movelist_src, :p1_threats, :p2_threats
  
  def initialize
    @current_player = 1
    @board = []
    @pawns = []
    @rooks = []
    @knights = []
    @bishops = []
    @kings = []
    @queens = []
    @p1_possible_movelist = []
    @p2_possible_movelist = []
    @p1_possible_movelist_src = []
    @p2_possible_movelist_src = []
    @p1_threats = []
    @p2_threats = []
    
    @source = []
    @destination = []
    @piece_moved = nil
    @piece_captured = nil
    
    initialize_board
    initialize_chess_pieces
    set_initial_locations
    calculate_possible_moves
  end
  
  # Initializes the game board
  def initialize_board
    8.times do
      temp = []
      8.times do
        temp += Array(BoardSquare.new)
      end
      
      @board << Array(temp)
    end
  end
  
  # Initializes all the chess pieces
  def initialize_chess_pieces
    temp = []
    num_times = -1
    half = -1
    (1..6).each do |i|
      if(i == 1)
        num_times = 16
        half = 8
      elsif(i > 1 && i < 5)
        num_times = 4 
        half = 2
      elsif(i == 5 || i == 6)
        num_times = 2 
        half = 1
      end
      
      initialize_piece_array(i, num_times, half)
    end
  end
  
  # Helper method used to initialize all the chess pieces
  def initialize_piece_array(type, num_times, half)
    
    num_times.times do |i|
      tempPiece = ChessPiece.new
    
      tempPiece.type = type
      
      # The 1st half of the array consists of white pieces, black for the 2nd half 
      if(i < half)
        tempPiece.player_ID = 1
      elsif(i >= half)
        tempPiece.player_ID = 2 
      end
      
      case type
        when 1
          @pawns += Array(tempPiece)
        when 2
          @rooks += Array(tempPiece)
        when 3
          @knights += Array(tempPiece)
        when 4
          @bishops += Array(tempPiece)
        when 5
          @kings += Array(tempPiece)
        when 6
          @queens += Array(tempPiece)
      end
      
    end
  end
  
  # Places each chess piece in its respective starting position at the beginning of the game
  def set_initial_locations
    # Pawns
    @pawns.each_with_index do |pawn, index|
      row = -1
      col = -1
      
      # White then black
      if(index < 8)
        row = 6
        col = index
      elsif(index >= 8)
        row = 1 
        col = index - 8
      end
      
      @board[row][col].occupant = @pawns[index]
      @pawns[index].row = row
      @pawns[index].col = col
    end
    
    # Rooks, knights, bishops, kings, queens
    (2..6).each do |i|
      initial_location_helper(i)
    end
  end
  
  # Helper method used to set the initial locations of the chess pieces
  def initial_location_helper(type)
    temp_arr = []
    row = -1
    col = -1
    col_1 = -1
    col_2 = -1
    
    case type
      when 2
        temp_arr = @rooks
        col_1 = 0
        col_2 = 7
      when 3
        temp_arr = @knights
        col_1 = 1
        col_2 = 6
      when 4
        temp_arr = @bishops
        col_1 = 2
        col_2 = 5
      when 5
        temp_arr = @kings
        col_1 = 4
      when 6
        temp_arr = @queens
        col_1 = 3
    end
    
    temp_arr.each_with_index do |piece, index|
      
      # White then black
      if(index == 0)
        row = 7
        col = col_1
      elsif(index == 1)
        row = 7 
        col = col_2
        if(type == 5 || type == 6)
          row = 0 
          col = col_1
        end
      elsif(index == 2)
        row = 0 
        col = col_1
      elsif(index == 3)
        row = 0 
        col = col_2
      end
      
      @board[row][col].occupant = temp_arr[index]
      temp_arr[index].row = row
      temp_arr[index].col = col
    end
    
  end
  
  # Calculates all possible moves for all chess pieces on the board
  def calculate_possible_moves
    arrays = [@pawns, @rooks, @knights, @bishops, @kings, @queens]
    
    # Clear the possible_moves array each time
    arrays.each do |array|
      array.each do |element|
        element.possible_moves = []
      end
    end
    
    @p1_possible_movelist = []
    @p2_possible_movelist = []
    @p1_possible_movelist_src = []
    @p2_possible_movelist_src = []
    @p1_threats = []
    @p2_threats = []
    
    calculate_pawn_moves
    calculate_rook_moves(2)
    calculate_knight_moves
    calculate_bishop_moves(4)
    calculate_king_moves
    calculate_queen_moves
  end
  
  # Calculates all possible moves for all the pawns on the chess board
  def calculate_pawn_moves
    @pawns.each_with_index do |pawn, index|
      # Does not calculate moves if the piece has been captured
      next if(!pawn.alive)
      
      row = pawn.row
      col = pawn.col
      
      # White
      if(index < 8)
        # Forward
        calculate_pawn_helper(index, row, col, -1, 0, false) if(row > 0 && @board[row - 1][col].occupant == nil)
        # 2x Forward
        calculate_pawn_helper(index, row, col, -2, 0, false) if(row == 6 && @board[row - 1][col].occupant == nil && @board[row - 2][col].occupant == nil)
        # Capture left
        calculate_pawn_helper(index, row, col, -1, -1, true) if(row > 0 && col > 0 && @board[row - 1][col - 1].occupant != nil && @board[row - 1][col - 1].occupant.player_ID == 2)
        # Capture right
        calculate_pawn_helper(index, row, col, -1, 1, true) if(row > 0 && col < 7 && @board[row - 1][col + 1].occupant != nil && @board[row - 1][col + 1].occupant.player_ID == 2)
      # Black
      elsif(index >= 8)
        # Forward
        calculate_pawn_helper(index, row, col, 1, 0, false) if(row < 7 && @board[row + 1][col].occupant == nil)
        # 2x Forward
        calculate_pawn_helper(index, row, col, 2, 0, false) if(row == 1 && @board[row + 1][col].occupant == nil && @board[row + 2][col].occupant == nil)
        # Capture left
        calculate_pawn_helper(index, row, col, 1, -1, true) if(row < 7 && col > 0 && @board[row + 1][col - 1].occupant != nil && @board[row + 1][col - 1].occupant.player_ID == 1)
        # Capture right
        calculate_pawn_helper(index, row, col, 1, 1, true) if(row < 7 && col < 7 && @board[row + 1][col + 1].occupant != nil && @board[row + 1][col + 1].occupant.player_ID == 1)
      end
    end
  end
  
  # Helper method that adds the move coordinates to the possible_moves list of the specified pawn
  def calculate_pawn_helper(index, row, col, row_modifier, col_modifier, capturable_move)
    @pawns[index].possible_moves << [row + row_modifier, col + col_modifier]
    
    case @pawns[index].player_ID
      when 1
        @p1_possible_movelist << [row + row_modifier, col + col_modifier]
        @p1_possible_movelist_src << [row, col]
      when 2
        @p2_possible_movelist << [row + row_modifier, col + col_modifier]
        @p2_possible_movelist_src << [row, col]
    end
    
    # Only add to the threats list if it is a move which can result in the capture of an enemy piece
    if(capturable_move)
      case @pawns[index].player_ID
        when 1
          @p1_threats << [row + row_modifier, col + col_modifier]
        when 2
          @p2_threats << [row + row_modifier, col + col_modifier]
      end
    end
  end
  
  # Calculates all possible moves for all the rooks on the chess board
  # Also used to calculate possible moves for queens
  def calculate_rook_moves(type)
    temp_array = []
    
    # The type argument specifies whether the method should be used to calculate possible moves for rooks/queens 
    case type
      when 2
        temp_array = @rooks
      when 6
        temp_array = @queens
    end
    
    temp_array.each_with_index do |piece, index|
      next if(!piece.alive)
      
      row = piece.row
      col = piece.col
      
      row_orig = piece.row
      col_orig = piece.col
      # Up
      while(row > 0)
        reached_end = generic_direction_helper(type, index, row, col, -1, 0, row_orig, col_orig)
        # Stop once an occupied square has been reached
        break if(reached_end == 1)
        row -= 1
      end
      
      row = piece.row
      # Down
      while(row < 7)
        reached_end = generic_direction_helper(type, index, row, col, 1, 0, row_orig, col_orig)
        break if(reached_end == 1)
        row += 1
      end
      
      row = piece.row
      col = piece.col
      # Right
      while(col < 7)
        reached_end = generic_direction_helper(type, index, row, col, 0, 1, row_orig, col_orig)
        break if(reached_end == 1)
        col += 1
      end
      
      col = piece.col
      # Left
      while(col > 0)
        reached_end = generic_direction_helper(type, index, row, col, 0, -1, row_orig, col_orig)
        break if(reached_end == 1)
        col -= 1
      end
    end
  end
  
  # Calculates all possible moves for all the knights on the chess board
  def calculate_knight_moves
    @knights.each_with_index do |knight, index|
      next if(!knight.alive)
      
      row = knight.row
      col = knight.col
      
      # Upper right
      generic_direction_helper(3, index, row, col, -2, 1, row, col) if(row > 1 && col < 7)
      # Upper left
      generic_direction_helper(3, index, row, col, -2, -1, row, col) if(row > 1 && col > 0)
      # Right upper
      generic_direction_helper(3, index, row, col, -1, 2, row, col) if(row > 0 && col < 6)
      # Right lower
      generic_direction_helper(3, index, row, col, 1, 2, row, col) if(row < 7 && col < 6)
      # Lower right
      generic_direction_helper(3, index, row, col, 2, 1, row, col) if(row < 6 && col < 7)
      # Lower left
      generic_direction_helper(3, index, row, col, 2, -1, row, col) if(row < 6 && col > 0)
      # Left upper
      generic_direction_helper(3, index, row, col, -1, -2, row, col) if(row > 0 && col > 1)
      # Left lower
      generic_direction_helper(3, index, row, col, 1, -2, row, col) if(row < 7 && col > 1)
    end
  end
  
  # Calculates all possible moves for all the bishops on the chess board
  # Also used to calculate possible moves for queens
  def calculate_bishop_moves(type)
    temp_array = []
    
    # The type argument specifies whether the method should be used to calculate possible moves for bishops/queens 
    case type
      when 4
        temp_array = @bishops
      when 6
        temp_array = @queens
    end
    
    temp_array.each_with_index do |piece, index|
      next if(!piece.alive)
      
      row = piece.row
      col = piece.col
      
      row_orig = piece.row
      col_orig = piece.col
      
      # Right upper diagonal
      while(row > 0 && col < 7)
        reached_end = generic_direction_helper(type, index, row, col, -1, 1, row_orig, col_orig)
        break if(reached_end == 1)
        row -= 1
        col += 1
      end
      
      row = piece.row
      col = piece.col
      # Right lower diagonal
      while(row < 7 && col < 7)
        reached_end = generic_direction_helper(type, index, row, col, 1, 1, row_orig, col_orig)
        break if(reached_end == 1)
        row += 1
        col += 1
      end
      
      row = piece.row
      col = piece.col
      # Left lower diagonal
      while(row < 7 && col > 0)
        reached_end = generic_direction_helper(type, index, row, col, 1, -1, row_orig, col_orig)
        break if(reached_end == 1)
        row += 1
        col -= 1
      end
      
      row = piece.row
      col = piece.col
      # Left upper diagonal
      while(row > 0 && col > 0)
        reached_end = generic_direction_helper(type, index, row, col, -1, -1, row_orig, col_orig)
        break if(reached_end == 1)
        row -= 1
        col -= 1
      end
    end
  end
  
  # Helper method used to calculate the possible moves of each specified chess piece
  # Returns 0 if the target square is unoccupied, 1 otherwise
  def generic_direction_helper(type, index, row, col, row_modifier, col_modifier, row_orig, col_orig)
    temp_array = []
    
    case type
      when 2
        temp_array = @rooks
      when 3
        temp_array = @knights
      when 4
        temp_array = @bishops
      when 5
        temp_array = @kings
      when 6
        temp_array = @queens
    end
    
    # When an empty square is encountered
    if(@board[row + row_modifier][col + col_modifier].occupant == nil)
      temp_array[index].possible_moves << [row + row_modifier, col + col_modifier]
      
      if(temp_array[index].player_ID == 1)
        @p1_possible_movelist << [row + row_modifier, col + col_modifier]
        @p1_possible_movelist_src << [row_orig, col_orig]
        @p1_threats << [row + row_modifier, col + col_modifier]
      elsif(temp_array[index].player_ID == 2)
        @p2_possible_movelist << [row + row_modifier, col + col_modifier]
        @p2_possible_movelist_src << [row_orig, col_orig]
        @p2_threats << [row + row_modifier, col + col_modifier]
      end
    # When an occupied square is encountered
    # Adds the given coordinates into the threats list if the square is occupied by a capturable piece
    elsif(@board[row + row_modifier][col + col_modifier].occupant != nil)
      case temp_array[index].player_ID
        when 1
          if(@board[row + row_modifier][col + col_modifier].occupant.player_ID == 2)
            temp_array[index].possible_moves << [row + row_modifier, col + col_modifier]
            @p1_possible_movelist << [row + row_modifier, col + col_modifier]
            @p1_possible_movelist_src << [row_orig, col_orig]
            @p1_threats << [row + row_modifier, col + col_modifier]
          end
        when 2
          if(@board[row + row_modifier][col + col_modifier].occupant.player_ID == 1)
            temp_array[index].possible_moves << [row + row_modifier, col + col_modifier]
            @p2_possible_movelist << [row + row_modifier, col + col_modifier]
            @p2_possible_movelist_src << [row_orig, col_orig]
            @p2_threats << [row + row_modifier, col + col_modifier]
          end
      end
      
      return 1
    end
    
    return 0
  end
  
  # Calculates all possible moves for the kings on the chess board
  def calculate_king_moves
    @kings.each_with_index do |king, index|
      row = king.row
      col = king.col
      
      # Up
      generic_direction_helper(5, index, row, col, -1, 0, row, col) if(row > 0)
      # Upper right diagonal
      generic_direction_helper(5, index, row, col, -1, 1, row, col) if(row > 0 && col < 7)
      # Right
      generic_direction_helper(5, index, row, col, 0, 1, row, col) if(col < 7)
      # Lower right diagonal
      generic_direction_helper(5, index, row, col, 1, 1, row, col) if(row < 7 && col < 7)
      # Down
      generic_direction_helper(5, index, row, col, 1, 0, row, col) if(row < 7)
      # Lower left diagonal
      generic_direction_helper(5, index, row, col, 1, -1, row, col) if(row < 7 && col > 0)
      # Left
      generic_direction_helper(5, index, row, col, 0, -1, row, col) if(col > 0)
      # Upper left diagonal
      generic_direction_helper(5, index, row, col, -1, -1, row, col) if(row > 0 && col > 0)
    end
  end
  
  # Calculates all possible moves for the queens on the chess board
  def calculate_queen_moves
    # The methods for calculating the possible moves for rooks and bishops are reused
    calculate_rook_moves(6)
    calculate_bishop_moves(6)
  end
  
  # Performs a check to see if the specified player's king is under check or checkmate status
  # Returns 0 if king is not threatened, 1 if under check, 2 if checkmated
  def checkmate_status(player_ID)
    status = 0
    possible_moves = []
    
    # Returns 0 immediately if the king is not under check
    return status if(!king_is_threatened?(player_ID))
    
    # At this stage, the king is guaranteed to be at least in check status
    status = 1
    
    # If there are no valid moves available, then the king is checkmated
    status = 2 if(!valid_moves_available?(player_ID))
    
    return status
  end

  # Checks to see if the king of the specified player is currently being threatened
  def king_is_threatened?(player_ID)
    king = nil
    to_check = []
    coordinates = []
    is_threatened = false
    src = []
    
    case player_ID
      when 1
        king = @kings[0]
        to_check = @p2_threats
        src = @p2_possible_movelist_src
      when 2
        king = @kings[1]
        to_check = @p1_threats
        src = @p1_possible_movelist_src
    end
    
    coordinates = [king.row, king.col]
    is_threatened = true if(to_check.include? coordinates)
    
    return is_threatened
  end

  # Checks to see if there are any valid moves available for the specified player
  # Returns true if there are valid moves to be made, false otherwise
  def valid_moves_available?(player_ID)
    king = nil
    movelist = []
    movelist_src = []
    
    case player_ID
      when 1
        king = @kings[0]
        movelist = p1_possible_movelist
        movelist_src = p1_possible_movelist_src
      when 2
        king = @kings[1]
        movelist = p2_possible_movelist
        movelist_src = p2_possible_movelist_src
    end
    
    # Iterate through all possible moves the player can make
    # If any one of the moves does not result in the king being threatened, then it is a check
    # Otherwise, it is a checkmate
    movelist.each_with_index do |move, index|
      source = movelist_src[index]
      move_piece(source, move)
      
      is_threatened = king_is_threatened?(player_ID)
      
      undo_last_move
      
      return true if(!is_threatened)
    end
    
    return false
  end
  
  # Moves the chess piece which is located at the source coordinates to the destination coordinates
  # If a capture is possible, no color check is done as the check is done prior to calling this method
  def move_piece(source, destination)
    piece_to_move = @board[source[0]][source[1]].occupant
    piece_to_capture = @board[destination[0]][destination[1]].occupant
    
    # Move the piece to the new location
    piece_to_move.row = destination[0]
    piece_to_move.col = destination[1]
    @board[source[0]][source[1]].occupant = nil
    @board[destination[0]][destination[1]].occupant = piece_to_move
    
    # If the destination square is occupied, change the status of the occupant to "dead"
    piece_to_capture.alive = false if(piece_to_capture != nil)
    
    # Record the necessary informtion which will be used to undo a move if necessary
    @source = source
    @destination = destination
    @piece_moved = piece_to_move
    @piece_captured = piece_to_capture
    
    calculate_possible_moves
  end

  # Reverts the last move which was made
  def undo_last_move
    # Move the piece back to the original location
    @piece_moved.row = @source[0]
    @piece_moved.col = @source[1]
    @board[@source[0]][@source[1]].occupant = @piece_moved
    
    @board[@destination[0]][@destination[1]].occupant = nil
    
    # Revive the captured piece, if possible
    if(@piece_captured != nil)
      @piece_captured.alive = true
      @board[@destination[0]][@destination[1]].occupant = @piece_captured
    end
    
    calculate_possible_moves
  end
  
  # Saves the current game state
  def save_game
    File.open("save_state.yaml", "w") do |file|
      file.write(self.to_yaml)
    end
    
    puts ">>>>> GAME STATE SAVED! <<<<<"
  end
  
  # Loads a previous saved game state
  def load_game
    unless File.exists?("save_state.yaml")
      File.new("save_state.yaml", "w+")
    end
    loaded_data = YAML.load_file("save_state.yaml")
    
    @current_player = loaded_data.instance_variable_get(:@current_player)
    @board = loaded_data.instance_variable_get(:@board)
    @pawns = loaded_data.instance_variable_get(:@pawns)
    @rooks = loaded_data.instance_variable_get(:@rooks)
    @knights = loaded_data.instance_variable_get(:@knights)
    @bishops = loaded_data.instance_variable_get(:@bishops)
    @kings = loaded_data.instance_variable_get(:@kings)
    @queens = loaded_data.instance_variable_get(:@queens)
    @p1_possible_movelist = loaded_data.instance_variable_get(:@p1_possible_movelist)
    @p2_possible_movelist = loaded_data.instance_variable_get(:@p2_possible_movelist)
    @p1_possible_movelist_src = loaded_data.instance_variable_get(:@p1_possible_movelist_src)
    @p2_possible_movelist_src = loaded_data.instance_variable_get(:@p2_possible_movelist_src)
    @p1_threats = loaded_data.instance_variable_get(:@p1_threats)
    @p2_threats = loaded_data.instance_variable_get(:@p2_threats)
    
    @source = loaded_data.instance_variable_get(:@source)
    @destination = loaded_data.instance_variable_get(:@destination)
    @piece_moved = loaded_data.instance_variable_get(:@piece_moved)
    @piece_captured = loaded_data.instance_variable_get(:@piece_captured)
    
    puts ">>>>> GAME STATE LOADED! <<<<<"
  end
  
  # Prompts the current player for a move
  def prompt(player_ID)
    valid_move = false
    
    # Continue prompting the player for a move until a valid move is given
    while(!valid_move)
      display_board
      color = ""
      case @current_player
        when 1
          color = "WHITE"
        when 2
          color = "BLACK"
      end
      print "Player #{color}'s turn. Please enter a valid move: "
      input = gets.chomp
      
      # Save the game state
      if(input == "save")
        save_game
        next
      end
      
      # Load a saved game state
      if(input == "load")
        load_game
        next
      end
      
      # Parse the input
      source = [input[0].to_i, input[1].to_i]
      destination = [input[2].to_i, input[3].to_i]
      
      range = (0..7).to_a
      # Reject the given input if it is invalid
      if(!range.include?(source[0]) || !range.include?(source[1]) || !range.include?(destination[0]) || !range.include?(destination[1]))
        puts ">>>>> Invalid input given! Please try again."
        next
      end
      
      piece_to_move = @board[source[0]][source[1]].occupant
      
      # Reject the given input if thre is no piece to be moved
      if(@board[source[0]][source[1]].occupant == nil)
        puts ">>>>> Invalid input given! There is no piece at #{source}!"
        next
      end
      
      # Reject the given input if the current player intends to move a piece that does not belong to him/her
      if(piece_to_move.player_ID != @current_player)
        puts ">>>>> Invalid input given! You are attempting to move a piece of the opposing player!"
        next
      end
      
      # Reject the given input if the destination given is not found in the list of possible moves
      if(!piece_to_move.possible_moves.include? destination)
        puts ">>>>> Invalid input given! The piece at #{source} cannot be moved to #{destination}"
        next
      end
      
      # Move the piece after confirming that the coordinates given are valid
      move_piece(source, destination)
      
      # Undo the move if the move results in the player moving his/her king into check
      if(king_is_threatened? @current_player)
        puts ">>>>> Invalid input given! You are not allowed to expose your king to check!"
        undo_last_move
        next
      end
      
      # Mark the move as valid if all validity tests are passed
      valid_move = true
    end
  end
  
  # Runs the entire chess game
  def run
    game_over = false
    player = ""
    
    while(!game_over)
      prompt(@current_player)
      enemy_king_status = 0
      enemy = ""
      
      # Perform a checkmate status check for the enemy king
      # The game ends immediately if the enemy king is checkmated
      case @current_player
        when 1
          enemy_king_status = checkmate_status(2)
          enemy = "BLACK"
          player = "WHITE"
        when 2
          enemy_king_status = checkmate_status(1)
          enemy = "WHITE"
          player = "BLACK"
      end
      
      case enemy_king_status
        when 1
          puts ">>>>> #{enemy}'s king is checked!"
        when 2
          puts ">>>>> #{enemy}'s king is checkmated!"
          break
      end
      
      swap_player_turn
    end
    
    puts ">>> GAME OVER! Player #{player} has won! <<<"
  end
  
  # Swap's the turn priority to the opposing player
  def swap_player_turn
    case @current_player
      when 1
        @current_player = 2
      when 2
        @current_player = 1
    end
  end
  
  # Prints out the current board state onto the console
  def display_board
    # Print x-axis grid markings
    8.times do |i|
      print "   (#{i})  "
    end
    puts ""
    
    # Print top border
    print_border
    
    8.times do |row|
      # Print 1st line
      print_blank_line
      
      # Print 2nd line
      8.times do |col|
        # Blank if no occupant, otherwise fetch the unicode string of the occupant
        occupant = " "
        occupant = get_chesspiece_unicode(@board[row][col].occupant.player_ID, @board[row][col].occupant.type) if(@board[row][col].occupant != nil)
        print "|"
        print "   #{occupant}   "
      end
      print "|"
      
      # Print y-axis grid markings
      puts " (#{row})"
      
      # Print 3rd line
      print_blank_line
      
      # Print bottom border
      print_border();
      
    end
    
  end
  
  # Helper method that returns the unicode string of the specified chess piece
  def get_chesspiece_unicode(color, type)
    case color
      # White
      when 1
        case type
          when 1
            return "\u2659"
          when 2
            return "\u2656"
          when 3
            return "\u2658"
          when 4
            return "\u2657"
          when 5
            return "\u2654"
          when 6
            return "\u2655"
        end
      # Black
      when 2
        case type
          when 1
            return "\u265F"
          when 2
            return "\u265C"
          when 3
            return "\u265E"
          when 4
            return "\u265D"
          when 5
            return "\u265A"
          when 6
            return "\u265B"
        end
    end
  end
  
  # Prints the top/bottom border of the board
  def print_border
    65.times do
      print "*"
    end
    puts ""
  end
    
  # Prints a blank line on the board
  def print_blank_line
    8.times do
      print "|       "
    end
    puts "|"
  end
end

c = Chess.new
#c.run