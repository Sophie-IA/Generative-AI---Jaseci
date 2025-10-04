impl TicTacToe.start {
    if not [root --> (`?board)] {
        next = root ++> board();
    } else {
        next = [root --> (`?board)];
    }
    visit next;
}

impl TicTacToe.process_move {
    if [-->] {
        visit [-->];
    } else {
        # Validate move
        row = self.row - 1;  # Convert to 0-based indexing
        col = self.col - 1;
        is_valid = (0 <= row < 3 and 0 <= col < 3 and here.grid[row][col] == ' ');

        if not is_valid {
            feedback = give_feedback(here.grid, here.current_player, (self.row, self.col), False, "ongoing");
            print(feedback);
            here ++> board(here.grid, here.current_player, here.move_count);
            return;
        }

        # Place move
        here.grid[row][col] = here.current_player;
        here.move_count += 1;

        # Check for win
        win = False;
        # Rows
        for i in range(3) {
            if here.grid[i][0] == here.current_player and here.grid[i][1] == here.current_player and here.grid[i][2] == here.current_player {
                win = True;
            }
        }
        # Columns
        for j in range(3) {
            if here.grid[0][j] == here.current_player and here.grid[1][j] == here.current_player and here.grid[2][j] == here.current_player {
                win = True;
            }
        }
        # Diagonals
        if here.grid[0][0] == here.current_player and here.grid[1][1] == here.current_player and here.grid[2][2] == here.current_player {
            win = True;
        }
        if here.grid[0][2] == here.current_player and here.grid[1][1] == here.current_player and here.grid[2][0] == here.current_player {
            win = True;
        }

        # Check for draw
        draw = (here.move_count == 9 and not win);

        # Generate feedback
        game_status = "win" if win else "draw" if draw else "ongoing";
        feedback = give_feedback(here.grid, here.current_player, (self.row, self.col), True, game_status);
        print(feedback);

        # Print board
        print("Current board:");
        for i in range(3) {
            print(here.grid[i][0] + "|" + here.grid[i][1] + "|" + here.grid[i][2]);
            if i < 2 {
                print("-+-+-");
            }
        }

        # End game or continue
        if win {
            print("Player " + here.current_player + " wins!");
            disengage;
        } elif draw {
            print("It's a draw!");
            disengage;
        } else {
            # Switch player
            next_player = 'O' if here.current_player == 'X' else 'X';
            here ++> board(here.grid, next_player, here.move_count);
        }
    }
}