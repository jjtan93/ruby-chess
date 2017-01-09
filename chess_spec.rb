require 'chess'

describe Chess do
  describe "#initialize_board" do
    context "when the chess board is initialized" do
      c = Chess.new
      
      # Board tests
      it "board's length is 8" do
        expect(c.board.length).to eql(8)
      end
      
      it "board[0]'s length is 8" do
        expect(c.board[0].length).to eql(8)
      end
    end
  end
  
  describe "#initialize_chess_pieces" do
    context "when the chess pieces are initialized" do
      c = Chess.new
      
      # Chesspiece initialization tests
      it "pawns[7]'s player_ID is 1 (White)" do
        expect(c.pawns[7].player_ID).to eql(1)
      end
      
      it "pawns[8]'s player_ID is 2 (Black)" do
        expect(c.pawns[8].player_ID).to eql(2)
      end
      
      it "bishops[2]'s player_ID is 2" do
        expect(c.bishops[2].player_ID).to eql(2)
      end
      
      it "bishops[2]'s type is 4" do
        expect(c.bishops[2].type).to eql(4)
      end
    end
  end
  
  describe "#set_initial_locations" do
    context "when the initial positions of the chess pieces are set" do
      c = Chess.new
      
      # Initial location placement tests
      it "board[1][3]'s occupant player_ID is 2 (Black)" do
        expect(c.board[1][3].occupant.player_ID).to eql(2)
      end
      
      it "board[1][3]'s occupant type is 1 (Pawn)" do
        expect(c.board[1][3].occupant.type).to eql(1)
      end
      
      it "board[6][7]'s occupant player_ID is 1 (White)" do
        expect(c.board[6][7].occupant.player_ID).to eql(1)
      end
      
      it "board[6][7]'s occupant type is 1 (Pawn)" do
        expect(c.board[6][7].occupant.type).to eql(1)
      end
      
      it "board[7][0]'s occupant player_ID is 1 (White)" do
        expect(c.board[7][0].occupant.player_ID).to eql(1)
      end
      
      it "board[7][0]'s occupant type is 2 (Rook)" do
        expect(c.board[7][0].occupant.type).to eql(2)
      end
      
      it "board[7][1]'s occupant player_ID is 1 (White)" do
        expect(c.board[7][1].occupant.player_ID).to eql(1)
      end
      
      it "board[7][1]'s occupant type is 3 (Knight)" do
        expect(c.board[7][1].occupant.type).to eql(3)
      end
      
      it "board[7][4]'s occupant player_ID is 1 (White)" do
        expect(c.board[7][4].occupant.player_ID).to eql(1)
      end
      
      it "board[7][4]'s occupant type is 5 (King)" do
        expect(c.board[7][4].occupant.type).to eql(5)
      end
      
      it "board[0][4]'s occupant player_ID is 2 (Black)" do
        expect(c.board[0][4].occupant.player_ID).to eql(2)
      end
      
      it "board[0][4]'s occupant type is 5 (King)" do
        expect(c.board[0][4].occupant.type).to eql(5)
      end
      
      it "board[7][3]'s occupant player_ID is 1 (White)" do
        expect(c.board[7][3].occupant.player_ID).to eql(1)
      end
      
      it "board[7][3]'s occupant type is 6 (Queen)" do
        expect(c.board[7][3].occupant.type).to eql(6)
      end
      
      it "board[0][3]'s occupant player_ID is 2 (Black)" do
        expect(c.board[0][3].occupant.player_ID).to eql(2)
      end
      
      it "board[0][3]'s occupant type is 6 (Queen)" do
        expect(c.board[0][3].occupant.type).to eql(6)
      end
      
      it "Black queen's row is 0" do
        expect(c.queens[1].row).to eql(0)
      end
      
      it "Black queen's col is 3" do
        expect(c.queens[1].col).to eql(3)
      end 
    end
  end
  
  describe "#calculate_pawn_moves" do
    context "when the method is called" do
      c = Chess.new
      
      c.board[1][4].occupant = nil
      c.board[5][4].occupant = c.pawns[12]
      c.pawns[12].row = 5
      c.pawns[12].col = 4
      c.calculate_possible_moves
      
      answer = [[5, 3], [4, 3], [5, 4]]

      it "pawns[3]'s possible_moves list contains all possible valid moves" do
        expect(c.pawns[3].possible_moves).to eql(answer)
      end
    end
  end
  
  describe "#calculate_rook_moves" do
    context "when the method is called" do
      c = Chess.new
      
      c.board[7][7].occupant = nil
      c.board[3][4].occupant = c.rooks[1]
      c.rooks[1].row = 3
      c.rooks[1].col = 4
      c.calculate_possible_moves
      
      answer = [[2, 4], [1, 4], [4, 4], [5, 4], [3, 5], [3, 6], [3, 7], [3, 3], [3, 2], [3, 1], [3, 0]]

      it "rook[1]'s possible_moves list contains all possible valid moves" do
        expect(c.rooks[1].possible_moves).to eql(answer)
      end
    end
  end
  
  describe "#calculate_knight_moves" do
    context "when the method is called" do
      c = Chess.new
      
      c.board[0][6].occupant = nil
      c.board[4][4].occupant = c.knights[3]
      c.knights[3].row = 4
      c.knights[3].col = 4
      c.calculate_possible_moves
      
      answer = [[2, 5], [2, 3], [3, 6], [5, 6], [6, 5], [6, 3], [3, 2], [5, 2]]
      
      it "knights[3]'s possible_moves list contains all possible valid moves" do
        expect(c.knights[3].possible_moves).to eql(answer)
      end
    end
  end
  
  describe "#calculate_bishop_moves" do
    context "when the method is called" do
      c = Chess.new
      
      c.board[0][2].occupant = nil
      c.board[3][4].occupant = c.bishops[3]
      c.bishops[3].row = 3
      c.bishops[3].col = 4
      c.calculate_possible_moves
      
      answer = [[2, 5], [4, 5], [5, 6], [6, 7], [4, 3], [5, 2], [6, 1], [2, 3]]
      
      it "bishops[3]'s possible_moves list contains all possible valid moves" do
        expect(c.bishops[3].possible_moves).to eql(answer)
      end
    end
  end
  
  describe "#calculate_king_moves" do
    context "when the method is called" do
      c = Chess.new
      
      c.board[7][4].occupant = nil
      c.board[2][4].occupant = c.kings[0]
      c.kings[0].row = 2
      c.kings[0].col = 4
      c.calculate_possible_moves
      
      answer = [[1, 4], [1, 5], [2, 5], [3, 5], [3, 4], [3, 3], [2, 3], [1, 3]]
      
      it "c.kings[0]'s possible_moves list contains all possible valid moves" do
        expect(c.kings[0].possible_moves).to eql(answer)
      end
    end
  end
  
  describe "#calculate_queen_moves" do
    context "when the method is called" do
      c = Chess.new
      
      c.board[0][3].occupant = nil
      c.board[4][3].occupant = c.queens[1]
      c.queens[1].row = 4
      c.queens[1].col = 3
      c.calculate_possible_moves
      
      answer = [[3, 3], [2, 3], [5, 3], [6, 3], [4, 4], [4, 5], [4, 6], [4, 7], [4, 2], [4, 1], [4, 0], [3, 4], [2, 5], [5, 4], [6, 5], [5, 2], [6, 1], [3, 2], [2, 1]]
      
      it "c.queens[1]'s possible_moves list contains all possible valid moves" do
        expect(c.queens[1].possible_moves).to eql(answer)
      end
    end
  end
  
  describe "#move_piece" do
    context "when rooks[1] at [7][7] is moved to [1][7] which is occupied by pawns[15]" do
      c = Chess.new
      
      source = [7, 7]
      destination = [1, 7]
      c.move_piece(source, destination)
      
      it "[7][7] is empty" do
        expect(c.board[7][7].occupant).to eql(nil)
      end
      
      it "[1][7]'s occupant is rooks[1]" do
        expect(c.board[1][7].occupant).to eql(c.rooks[1])
      end
      
      it "pawns[15] is dead" do
        expect(c.pawns[15].alive).to eql(false)
      end
    end
  end
  
  describe "#undo_last_move" do
    context "when rooks[1] at [7][7] is moved to [1][7] and the move is undone" do
      c = Chess.new
      
      source = [7, 7]
      destination = [1, 7]
      c.move_piece(source, destination)
      c.undo_last_move
      
      it "[7][7]'s occupant is rooks[1]" do
        expect(c.board[7][7].occupant).to eql(c.rooks[1])
      end
      
      it "[1][7]'s occupant is pawns[15]" do
        expect(c.board[1][7].occupant).to eql(c.pawns[15])
      end
    end
  end
  
  describe "#valid_moves_available?" do
    context "when kings[1] is in a position where there are no valid moves to be made" do
      c = Chess.new
      
      c.board[0][4].occupant = nil
      c.board[4][4].occupant = c.kings[1]
      c.kings[1].row = 4
      c.kings[1].col = 4
      
      c.board[7][0].occupant = nil
      c.board[4][7].occupant = c.rooks[0]
      c.rooks[0].row = 4
      c.rooks[0].col = 7
      
      c.board[7][7].occupant = nil
      c.board[3][7].occupant = c.rooks[1]
      c.rooks[1].row = 3
      c.rooks[1].col = 7
      
      c.calculate_possible_moves
      
      #c.display_board
      
      it "valid_moves_available?(2)'s result is false" do
        expect(c.valid_moves_available?(2)).to eql(false)
      end
    end
    
    context "when kings[0] is in a position where there is a single valid move to be made" do
      it "valid_moves_available?(2)'s result is true when the threatening piece can be blocked" do
        c = Chess.new
      
        # TODO this <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        c.board[0][4].occupant = nil
        c.board[4][4].occupant = c.kings[1]
        c.kings[1].row = 4
        c.kings[1].col = 4

        c.board[7][0].occupant = nil
        c.board[4][7].occupant = c.rooks[0]
        c.rooks[0].row = 4
        c.rooks[0].col = 7

        c.board[7][7].occupant = nil
        c.board[3][7].occupant = c.rooks[1]
        c.rooks[1].row = 3
        c.rooks[1].col = 7

        c.board[0][0].occupant = nil
        c.board[5][6].occupant = c.rooks[2]
        c.rooks[2].row = 5
        c.rooks[2].col = 6

        c.calculate_possible_moves
        
        expect(c.valid_moves_available?(2)).to eql(true)
      end
      
      it "valid_moves_available?(2)'s result is true when the threatening piece can be captured" do
        c = Chess.new
      
        c.board[0][4].occupant = nil
        c.board[4][4].occupant = c.kings[1]
        c.kings[1].row = 4
        c.kings[1].col = 4

        c.board[7][0].occupant = nil
        c.board[4][7].occupant = c.rooks[0]
        c.rooks[0].row = 4
        c.rooks[0].col = 7

        c.board[7][7].occupant = nil
        c.board[3][7].occupant = c.rooks[1]
        c.rooks[1].row = 3
        c.rooks[1].col = 7

        c.board[0][0].occupant = nil
        c.board[5][7].occupant = c.rooks[2]
        c.rooks[2].row = 5
        c.rooks[2].col = 7

        c.calculate_possible_moves
        
        expect(c.valid_moves_available?(2)).to eql(true)
      end
    end
  end
  
end