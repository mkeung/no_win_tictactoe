class TicTacToe
	@@user_wins = 0
	@@comp_wins = 0
	@@total_games = 0
	@@user_start = 1 # swap by * -1

	attr_reader :game_ended

	def initialize
		@game_board = [1,2,3,4,5,6,7,8,9]
		@available = [true,true,true,true,true,true,true,true,true]
		@user_board = [0,0,0,0,0,0,0,0,0]
		@comp_board = [0,0,0,0,0,0,0,0,0]
		@game_ended = false
		@turns_taken = 0
		@users_move_order = []
	end

	def display
		puts "#{@game_board[0]}|#{@game_board[1]}|#{@game_board[2]}"
		puts "#{@game_board[3]}|#{@game_board[4]}|#{@game_board[5]}"
		puts "#{@game_board[6]}|#{@game_board[7]}|#{@game_board[8]}"
	end

	def user_start
		@@user_start
	end

	def user_select #user is X's
		invalid_selection = true

		# make sure selection input is within the valid range
		while invalid_selection do
			puts "enter a number from the displayed spots"
			display
			selection = gets.chomp.to_i

			if (selection < 1) || (selection > 9)
				puts "I don't understand your entry"
			else
				# adjust for difference in display and array index
				selection_index = selection-1

				# make sure it's not taken
				if @available[selection_index]
					invalid_selection = false
				else
					puts "that's taken!"
				end
			end
		end

		# update game with selection if the above checks are ok
		save_move(selection_index, @user_board, "X")
		@users_move_order << selection_index

		# check if user won
		if victory?(@user_board)
			user_victory
		end

		# check if tie
		game_tie?
	end

	def comp_select

		selection_index = nil

		# Logic:
		# -- universal, priority
		# if can win, win
		selection_index = comp_check_victory(@comp_board)
		# if other player is about to win, stop it
		if selection_index.nil?
			selection_index = comp_check_victory(@user_board)
		end

		# -- offensive play (go 1st)
		if (@@user_start == -1) && selection_index.nil?
		end
		# go corner
		# if they go to non corner, go to adjacent corner that is not touching their move and you win when you go mid after
		#
		# if they go corner, go to your adjacent corner, then final corner

		# -- defensive play (go 2nd)
		if (@@user_start == 1) && selection_index.nil?
			# go middle 1st if it's available
			if @available[4]
				selection_index = 4
			# go corner 1st if middle was taken
			elsif @turns_taken == 1
				selection_index = go_corner

			# if they go non corner, pick something that touches their move
			# note: account for a non corner on 1st move
			elsif non_corner?(@users_move_order.last(2).first) && @turns_taken == 3
				selection_index = touch_non_corner(@users_move_order.last(2).first)
			elsif non_corner?(@users_move_order.last)
				selection_index = touch_non_corner(@users_move_order.last)

			# if they go corner, pick a corner unless control middle
			elsif (@comp_board[4] == 0) && corner?(@users_move_order.last)
				selection_index = go_corner

			# else go non corner
			else
				selection_index = go_non_corner
			end
		end

		# otherwise just select a random available spot
		if selection_index.nil?
			invalid_selection = true
			while invalid_selection do
				selection_index = rand(9)

				if @available[selection_index]
					invalid_selection = false
				end
			end
		end

		#update game with selection if the above checks are ok
		save_move(selection_index, @comp_board, "O")

		#check if comp won
		if victory?(@comp_board)
			comp_victory
		end

		# check if tie
		game_tie?
	end

	def game_stats
		puts "-----------------------------------"
		puts "You've won #{@@user_wins} times"
		puts "I've won #{@@comp_wins} times"
		puts "We've played #{@@total_games} times"
		puts "-----------------------------------"
		#@@user_start *= -1
	end

	private
		def save_move(move_index, player_board, marker)
			@game_board[move_index] = marker
			@available[move_index] = false
			player_board[move_index] = 1
			@turns_taken += 1
		end

		def victory?(player_board)
			# horizontal check
			if player_board[0]+player_board[1]+player_board[2] == 3
				return true
			elsif player_board[3]+player_board[4]+player_board[5] == 3
				return true
			elsif player_board[6]+player_board[7]+player_board[8] == 3
				return true
			# vertical check
			elsif player_board[0]+player_board[3]+player_board[6] == 3
				return true
			elsif player_board[1]+player_board[4]+player_board[7] == 3
				return true
			elsif player_board[2]+player_board[5]+player_board[8] == 3
				return true
			# diagonal check
			elsif player_board[0]+player_board[4]+player_board[8] == 3
				return true
			elsif player_board[2]+player_board[4]+player_board[6] == 3
				return true

			else
				return false
			end
		end

		def game_tie?
			if (@turns_taken == 9) && @game_ended
				# someone won on last turn
				return false
			elsif @turns_taken == 9
				puts "-----------------------------------"
				puts "Tie game. Nobody wins."
				@game_ended = true
				@@total_games += 1
				return true
			else
				return false
			end
		end

		def user_victory
			puts "-----------------------------------"
			puts "wow...you somehow won...IMPOSSIBLE!"
			@@user_wins += 1
			@@total_games += 1
			@game_ended = true
		end

		def comp_victory
			puts "-----------------------------------"
			puts "*yawn*...give up yet?"
			@@comp_wins += 1
			@@total_games += 1
			@game_ended = true
		end

		def comp_check_victory(player_board)
			# horizontal check
			if player_board[0]+player_board[1]+player_board[2] == 2
				return 0 if @available[0]
				return 1 if @available[1]
				return 2 if @available[2]
			end
			if player_board[3]+player_board[4]+player_board[5] == 2
				return 3 if @available[3]
				return 4 if @available[4]
				return 5 if @available[5]
			end
			if player_board[6]+player_board[7]+player_board[8] == 2
				return 6 if @available[6]
				return 7 if @available[7]
				return 8 if @available[8]
			end

			# vertical check
			if player_board[0]+player_board[3]+player_board[6] == 2
				return 0 if @available[0]
				return 3 if @available[3]
				return 6 if @available[6]
			end
			if player_board[1]+player_board[4]+player_board[7] == 2
				return 1 if @available[1]
				return 4 if @available[4]
				return 7 if @available[7]
			end
			if player_board[2]+player_board[5]+player_board[8] == 2
				return 2 if @available[2]
				return 5 if @available[5]
				return 8 if @available[8]
			end

			# diagonal check
			if player_board[0]+player_board[4]+player_board[8] == 2
				return 0 if @available[0]
				return 4 if @available[4]
				return 8 if @available[8]
			end
			if player_board[2]+player_board[4]+player_board[6] == 2
				return 2 if @available[2]
				return 4 if @available[4]
				return 6 if @available[6]
			end

			return nil
		end

		def corner?(move_position)
			corner_spots = [0, 2, 6, 8]
			return corner_spots.include?(move_position)
		end

		def go_corner
			corner = [0, 2, 6, 8].shuffle
			corner.each do |x|
				return x if @available[x]
			end
			return nil
		end

		def non_corner?(move_position)
			non_corner_spots = [1, 3, 5, 7]
			return non_corner_spots.include?(move_position)
		end

		def go_non_corner
			non_corner = [1, 3, 5, 7].shuffle
			non_corner.each do |x|
				return x if @available[x]
			end
			return nil
		end

		def touch_non_corner(move_position)
			moves = []

			case move_position
			when 1
				moves << 0 if @available[0]
				moves << 2 if @available[2]
			when 3
				moves << 0 if @available[0]
				moves << 6 if @available[6]
			when 5
				moves << 2 if @available[2]
				moves << 8 if @available[8]
			when 7
				moves << 6 if @available[6]
				moves << 8 if @available[8]
			end

			if moves.empty?
				return nil
			else
				return moves.shuffle.first
			end
		end


end

# ============================================================================

# ask the user if they want to play again
def playagain?
	puts "Play again? (Y or N)"

	# will break upon return
	while true do
		response = gets.chomp.downcase

		if (response == "y") || (response == "yes")
			puts "Prepare yourself!"
			return true
		elsif (response == "n") || (response == "no")
			puts "Goodbye, it was wise to give up"
			return false
		else
			puts "I didn't recognize your input, please put Y or N"
		end
	end

end

# start initial game
puts "Enjoy these lovely games of Tic Tac Toe...that you cannot win"
puts "You are X's, I am O's"
play = true

# play while user wishes to continue playing
while play == true  do
	game = TicTacToe.new

	if game.user_start == 1
		while game.game_ended == false do
			game.user_select
			game.comp_select unless game.game_ended
		end
	else
		while game.game_ended == false do
			game.comp_select
			game.user_select unless game.game_ended
		end
	end

	game.display
	game.game_stats
	play = playagain?
end