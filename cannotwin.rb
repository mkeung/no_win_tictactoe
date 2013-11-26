class TicTacToe
	@@user_wins = 0
	@@comp_wins = 0
	@@total_games = 0

	attr_reader :game_ended

	def initialize
		@game_board = [1,2,3,4,5,6,7,8,9]
		@available = [true,true,true,true,true,true,true,true,true]
		@user_board = [0,0,0,0,0,0,0,0,0]
		@comp_board = [0,0,0,0,0,0,0,0,0]
		@game_ended = false
		@turns_taken = 0
	end

	def display
		puts "#{@game_board[0]}|#{@game_board[1]}|#{@game_board[2]}"
		puts "#{@game_board[3]}|#{@game_board[4]}|#{@game_board[5]}"
		puts "#{@game_board[6]}|#{@game_board[7]}|#{@game_board[8]}"
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
				selection_index = @game_board.index(selection)

				#make sure it's not taken
				if @available[selection_index]
					invalid_selection = false
				else
					puts "that's taken!"
				end
			end
		end

		# update game with selection if the above checks are ok
		@game_board[selection_index] = "X"
		@available[selection_index] = false
		@user_board[selection_index] = 1
		@turns_taken += 1

		# check if user won
		if user_victory?
			user_victory
		end

		# check if tie
		game_tie?
	end

	def comp_select

		# just select a random available spot for now
		invalid_selection = true
		while invalid_selection do
			selection_index = rand(9)

			if @available[selection_index]
				invalid_selection = false
			end
		end

		#update game with selection if the above checks are ok
		@game_board[selection_index] = "O"
		@available[selection_index] = false
		@comp_board[selection_index] = 1
		@turns_taken += 1

		#check if comp won
		if comp_victory?
			comp_victory
		end

		# check if tie
		game_tie?
	end

	def game_stats
		puts "You've won #{@@user_wins} times"
		puts "I've won #{@@comp_wins} times"
		puts "We've played #{@@total_games} times"
	end

	private
		def user_victory?
			# horizontal check
			if @user_board[0]+@user_board[1]+@user_board[2] == 3
				return true
			elsif @user_board[3]+@user_board[4]+@user_board[5] == 3
				return true
			elsif @user_board[6]+@user_board[7]+@user_board[8] == 3
				return true
			# vertical check
			elsif @user_board[0]+@user_board[3]+@user_board[6] == 3
				return true
			elsif @user_board[1]+@user_board[4]+@user_board[7] == 3
				return true
			elsif @user_board[2]+@user_board[5]+@user_board[8] == 3
				return true
			# diagonal check
			elsif @user_board[0]+@user_board[4]+@user_board[8] == 3
				return true
			elsif @user_board[6]+@user_board[4]+@user_board[2] == 3
				return true

			else
				return false
			end
		end

		def comp_victory?
			# horizontal check
			if @comp_board[0]+@comp_board[1]+@comp_board[2] == 3
				return true
			elsif @comp_board[3]+@comp_board[4]+@comp_board[5] == 3
				return true
			elsif @comp_board[6]+@comp_board[7]+@comp_board[8] == 3
				return true
			# vertical check
			elsif @comp_board[0]+@comp_board[3]+@comp_board[6] == 3
				return true
			elsif @comp_board[1]+@comp_board[4]+@comp_board[7] == 3
				return true
			elsif @comp_board[2]+@comp_board[5]+@comp_board[8] == 3
				return true
			# diagonal check
			elsif @comp_board[0]+@comp_board[4]+@comp_board[8] == 3
				return true
			elsif @comp_board[6]+@comp_board[4]+@comp_board[2] == 3
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
				puts "Tie game. Nobody wins."
				@game_ended = true
				@@total_games += 1
				return true
			else
				return false
			end
		end

		def user_victory
			puts "wow...you somehow won...IMPOSSIBLE!"
			@@user_wins += 1
			@@total_games += 1
			@game_ended = true
		end

		def comp_victory
			puts "*yawn*...give up yet?"
			@@comp_wins += 1
			@@total_games += 1
			@game_ended = true
		end
end

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

	while game.game_ended == false do
		game.user_select
		game.comp_select unless game.game_ended
	end
	game.display
	game.game_stats
	play = playagain?
end