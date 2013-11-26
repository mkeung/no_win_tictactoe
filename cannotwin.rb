class TicTacToe
	@@user_wins = 0
	@@comp_wins = 0
	@@total_games = 0

	attr_reader :gameended

	def initialize
		@gameboard = [1,2,3,4,5,6,7,8,9]
		@available = [true,true,true,true,true,true,true,true,true]
		@userboard = [0,0,0,0,0,0,0,0,0]
		@compboard = [0,0,0,0,0,0,0,0,0]
		@gameended = false
	end

	def display_gameboard
		puts "#{@gameboard[0]}|#{@gameboard[1]}|#{@gameboard[2]}"
		puts "#{@gameboard[3]}|#{@gameboard[4]}|#{@gameboard[5]}"
		puts "#{@gameboard[6]}|#{@gameboard[7]}|#{@gameboard[8]}"
	end

	def user_select #user is X's
		puts "select from available spots (numbered)"
		display_gameboard
		selection = gets.chomp.to_i
		selection_index = @gameboard.index(selection)

		# make sure selection is available, if not get it again
		# make sure selection input is valid, if not get it again

		#update game with selection if the above checks are ok
		@gameboard[selection_index] = "X"
		@userboard[selection_index] = 1

		#check if user won
		if user_victory?
			user_victory
		end
	end

	def game_stats
		puts "You've won #{@@user_wins} times"
		puts "I've won #{@@comp_wins} times"
		puts "We've played #{@@total_games} times"
	end

	private
		def user_victory?
			# horizontal check
			if @userboard[0]+@userboard[1]+@userboard[2] == 3
				return true
			elsif @userboard[3]+@userboard[4]+@userboard[5] == 3
				return true
			elsif @userboard[6]+@userboard[7]+@userboard[8] == 3
				return true
			# vertical check
			elsif @userboard[0]+@userboard[3]+@userboard[6] == 3
				return true
			elsif @userboard[1]+@userboard[4]+@userboard[7] == 3
				return true
			elsif @userboard[2]+@userboard[5]+@userboard[8] == 3
				return true
			# diagonal check
			elsif @userboard[0]+@userboard[4]+@userboard[8] == 3
				return true
			elsif @userboard[6]+@userboard[4]+@userboard[2] == 3
				return true

			else
				return false
			end
		end

		def comp_victory?
			# horizontal check
			if @compboard[0]+@compboard[1]+@compboard[2] == 3
				return true
			elsif @compboard[3]+@compboard[4]+@compboard[5] == 3
				return true
			elsif @compboard[6]+@compboard[7]+@compboard[8] == 3
				return true
			# vertical check
			elsif @compboard[0]+@compboard[3]+@compboard[6] == 3
				return true
			elsif @compboard[1]+@compboard[4]+@compboard[7] == 3
				return true
			elsif @compboard[2]+@compboard[5]+@compboard[8] == 3
				return true
			# diagonal check
			elsif @compboard[0]+@compboard[4]+@compboard[8] == 3
				return true
			elsif @compboard[6]+@compboard[4]+@compboard[2] == 3
				return true

			else
				return false
			end
		end

		def user_victory
			puts "wow...you somehow won...IMPOSSIBLE!"
			@@user_wins += 1
			@@total_games += 1
			@gameended = true
		end

		def comp_victory
			puts "*yawn*...give up yet?"
			@@comp_wins += 1
			@@total_games += 1
			@gameended = true
		end
end

# ask the user if they want to play again
def playagain?
	puts "Play again? (Y or N)"
	answered_correctly = false

	while answered_correctly == false do

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

	while game.gameended == false do
		game.user_select
	end

	game.game_stats
	play = playagain?
end