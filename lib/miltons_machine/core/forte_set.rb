require 'set'

module MiltonsMachine
  module Core
    #
    # == Class: Forte Set
    #
    # An extention to the basic Array class of Ruby to allow for modulus 12 operations and transformations related to
    # musical set theoretics.
    #
    # @example  create and transpose a set
    #
    #   major_set = MiltonsMachine::Core::ForteSet.new([0, 4, 7])
    #   major_set.transpose_mod12!(3)
    #   puts major_set     <-- should print out [3, 7, 10]
    #
    # TODO Add method to allow for subset search with an array of forte sets

    class ForteSet < Array

      # Returns a copy of the set at a new transposition
      #
      # @param [Integer] number_to_transpose number of half steps between 0 - 11
      # @return [ForteSet] a copy of the set transposed to the new Tn
      #

      def transpose_mod12( number_to_transpose = 0 )
        return_set = clone
        return_set.collect! { |pc| pc = MiltonsMachine::Core::ForteSet.transpose_pc(pc, number_to_transpose) }
      end

      # Transposes the set in place and returns a reference to the set at the new transposition
      #
      # @param [Integer] number_to_transpose number of half steps between 0 - 11
      # @return [ForteSet] a reference to the transposed set
      #

      def transpose_mod12!( number_to_transpose = 0 )
        replace( transpose_mod12(number_to_transpose) )
      end

      # Return the inversion of this set
      #
      # @return [ForteSet] a copy of the set inverted
      #

      def invert_mod12
        return_set = clone
        return_set.collect! { |pc| pc = MiltonsMachine::Core::ForteSet.invert_pc(pc) }
      end

      # Invert the set in place and return a reference
      #
      # @return [ForteSet] a reference to the inverted set
      #

      def invert_mod12!
        replace( invert_mod12 )
      end

      # Return the complement of this set
      #
      # @return [ForteSet] the complement set
      #

      def complement_mod12
        ForteSet.new(12) { |i| i }  - self
      end

      # Replace with the complement of this set
      #
      # @return [ForteSet] a reference to the complemented set
      #

      def complement_mod12!
        replace( complement_mod12 )
      end

      # Return a copy of the set with all elements transposed so that the first element is set to zero.
      #
      # @return [ForteSet] the zero transposed set
      #

      def zero_mod12
        number_to_transpose = 0
        self[0] == 0 ? number_to_transpose = 0 : number_to_transpose = 12 - self[0]
        transpose_mod12(number_to_transpose)
      end

      # Zero the set in place, so that all element transposed so that the first element is set to zero. Return a
      # reference to the result.
      #
      # @return [ForteSet] a reference to the zero transposed set
      #

      def zero_mod12!
        replace( zero_mod12 )
      end

      # Returns the most compact order of a set
      #
      # @return [ForteSet] a copy of the set normalized
      #

      def normalize_mod12
        winner = clone
        winner.sort!
        working_set = winner.clone

        # Pick the best winner out of the lot of permutations
        0.upto(length - 2) { winner = winner.compare_compact_sets( working_set.rotate!(1) ) }
        winner
      end

      # Normalizes the set in place and returns a reference to the set
      #
      # @return [ForteSet] a reference to the normalized set
      #

      def normalize_mod12!
        replace( normalize_mod12 )
      end

      # Normalize and zero down the set, returning a copy
      #
      # @return [ForteSet] a copy of the set reduced
      #

      def reduce_mod12
        return_set = normalize_mod12
        return_set.zero_mod12!
      end

      # Normalize and zero down the set in place, returning a reference to the set
      #
      # @return [ForteSet] a reference to the reduced set
      #

      def reduce_mod12!
        replace( reduce_mod12 )
      end

      # Return the prime version of the set
      #
      # @return [ForteSet] the prime version of the set or its inversion
      #

      def prime_mod12
        prime_form    = normalize_mod12.zero_mod12
        inverted_form = invert_mod12.normalize_mod12.zero_mod12
        prime_form.compare_compact_sets(inverted_form)
      end

      # Set the prime version of the set in place and return a reference
      #
      # @return [ForteSet] a reference to this set now changed to prime version
      #

      def prime_mod12!
        replace( prime_mod12 )
      end

      # Compare two sets and return the most compact version
      #
      # @param [ForteSet] compare_set the set to compare it to
      # @return [ForteSet] the most compact form of the two
      #

      def compare_compact_sets( compare_set )
        winner      = clone                                       # Assume the set is the winner going in.
        working_set = compare_set.clone
        winner.reverse!
        working_set.reverse!

        # Work backwards checking largest interval edge
        working_set.each_index do |working_last_index|
          compare_interval1 = (winner[working_last_index] - winner.at(-1)) % 12
          compare_interval2 = (working_set[working_last_index] - working_set.at(-1)) % 12

          if compare_interval2 == compare_interval1
            next                                                  # equal, so loop back for next outer interval
          elsif compare_interval2 < compare_interval1             # new winner else assume #1 is good enough.
            winner = working_set.clone
          end
          break
        end
        winner.reverse!
      end

      # Converts the set from alpha representation to pc numbers and return a copy
      #
      # @return [ForteSet] a copy of the set converted to pc representation as numbers
      #

      def convert_set_from_alpha
        return_set = clone
        return_set.collect! { |pc| pc = MiltonsMachine::Core::ForteSet.pc_from_alpha(pc) }
      end

      # Converts the set in place from alpha representation to pc numbers and return a reference
      #
      # @return [ForteSet] a reference to the set converted to pc representation as numbers
      #

      def convert_set_from_alpha!
        replace( convert_set_from_alpha )
      end

      #  Converts the set from numeric representation to alphanumeric and return a copy
      #
      # @return [ForteSet] a copy of the set converted to character representation
      #

      def convert_set_to_alpha
        return_set = clone
        return_set.collect! { |pc| pc = MiltonsMachine::Core::ForteSet.pc_to_alpha(pc) }
      end

      # Converts the set in place from numeric representation to alphanumeric and return a reference
      #
      # @return [ForteSet] a reference to the set converted to character representation
      #

      def convert_set_to_alpha!
        replace( convert_set_to_alpha )
      end

      # Converts the set in place from numeric representation to a representation from the chromatic scale
      #
      # @return [ForteSet] a copy of the set converted to chromatic representation
      #

      def convert_set_to_chromatic
        return_set = clone
        return_set.collect! { |pc| pc = MiltonsMachine::Core::ForteSet.pc_to_chromatic(pc) }
      end

      # Given a set and an array of subsets to search for, this method will return true or false on each one found
      #
      # @param [Array] set the set to search
      # @param [Array] search_sets the subsets to search for
      # @return [Array] the search sets with truth table for each one
      #
      def self.search_for_subsets(source_set, search_sets)
        sonority = Set.new(source_set)
        set_to_search = Set.new
        results = []
        search_sets.each do |search_set|
          set_to_search.replace(search_set)
          set_to_search.subset?(sonority) ?  results << true : results << false
        end
        [search_sets.clone, results]
      end

      # Convert Integer representation of a pitch to a String representation from the chromatic scale
      #
      # for example: 3 would return "D#/Eb"
      #
      # @param [Integer] pitch_class the pitch to convert
      # @return [String] the alpha representation of the pitch from the chromatic scale
      #

      def self.pc_to_chromatic( pitch_class )
        case pitch_class
          when 0  then 'C'
          when 1  then 'C#/Db'
          when 2  then 'D'
          when 3  then 'D#/Eb'
          when 4  then 'E'
          when 5  then 'F'
          when 6  then 'F#/Gb'
          when 7  then 'G'
          when 8  then 'G#/Ab'
          when 9  then  'A'
          when 10 then 'A#/Bb'
          when 11 then 'B'
          else 'unknown'
        end
      end


      # Given a musical pitch, and how many 1/2 steps you want to transpose it, returns a new pitch at the new
      # transposition
      #
      # @param [Integer] pitch_class the pitch to transpose (0-11)
      # @param [Integer] number_to_transpose the Tn we wish to transpose it to
      # @return [Integer] a copy of the pitch at the new Tn
      #

      def self.transpose_pc( pitch_class, number_to_transpose = 0 )
        (pitch_class + number_to_transpose)  % 12
      end

      # Given a musical pitch, return the inversion of the pitch
      #
      # @param [Integer] pitch_class the pitch to invert ()0-11)
      # @return [Integer] a copy of the pitch at the new inversion
      #

      def self.invert_pc( pitch_class )
        (12 - pitch_class)  % 12
      end

      # Convert String representation of a pitch to an Integer representation
      #
      # @param [String] pitch_class the pitch to convert
      # @return [Integer]  Integer representation of the pitch
      #

      def self.pc_from_alpha( pitch_class )
        case pitch_class.to_s
          when 'A', 'a' then 10
          when 'B', 'b' then 11
          when 'C', 'c' then 12
          else pitch_class.to_i
        end
      end

      # Convert Integer representation of a pitch to a String representation
      #
      # @param [Integer] pitch_class the pitch to convert
      # @return [String] a string representation
      #

      def self.pc_to_alpha( pitch_class )
        case pitch_class.to_i
          when 10 then 'A'
          when 11 then 'B'
          when 12 then 'C'
          else pitch_class.to_s
        end
      end

    end

  end
end
