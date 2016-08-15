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
      it "pawns[7]'s playerID is 1 (White)" do
        expect(c.pawns[7].playerID).to eql(1)
      end
      
      it "pawns[8]'s playerID is 2 (Black)" do
        expect(c.pawns[8].playerID).to eql(2)
      end
      
      it "bishops[2]'s playerID is 2" do
        expect(c.bishops[2].playerID).to eql(2)
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
      it "board[1][3]'s occupant playerID is 2 (Black)" do
        expect(c.board[1][3].occupant.playerID).to eql(2)
      end
      
      it "board[1][3]'s occupant type is 1 (Pawn)" do
        expect(c.board[1][3].occupant.type).to eql(1)
      end
      
      it "board[6][7]'s occupant playerID is 1 (White)" do
        expect(c.board[6][7].occupant.playerID).to eql(1)
      end
      
      it "board[6][7]'s occupant type is 1 (Pawn)" do
        expect(c.board[6][7].occupant.type).to eql(1)
      end
      
      it "board[7][0]'s occupant playerID is 1 (White)" do
        expect(c.board[7][0].occupant.playerID).to eql(1)
      end
      
      it "board[7][0]'s occupant type is 2 (Rook)" do
        expect(c.board[7][0].occupant.type).to eql(2)
      end
      
      it "board[7][1]'s occupant playerID is 1 (White)" do
        expect(c.board[7][1].occupant.playerID).to eql(1)
      end
      
      it "board[7][1]'s occupant type is 3 (Knight)" do
        expect(c.board[7][1].occupant.type).to eql(3)
      end
      
      it "board[7][4]'s occupant playerID is 1 (White)" do
        expect(c.board[7][4].occupant.playerID).to eql(1)
      end
      
      it "board[7][4]'s occupant type is 5 (King)" do
        expect(c.board[7][4].occupant.type).to eql(5)
      end
      
      it "board[0][4]'s occupant playerID is 2 (Black)" do
        expect(c.board[0][4].occupant.playerID).to eql(2)
      end
      
      it "board[0][4]'s occupant type is 5 (King)" do
        expect(c.board[0][4].occupant.type).to eql(5)
      end
      
      it "board[7][3]'s occupant playerID is 1 (White)" do
        expect(c.board[7][3].occupant.playerID).to eql(1)
      end
      
      it "board[7][3]'s occupant type is 6 (Queen)" do
        expect(c.board[7][3].occupant.type).to eql(6)
      end
      
      it "board[0][3]'s occupant playerID is 2 (Black)" do
        expect(c.board[0][3].occupant.playerID).to eql(2)
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
  
end