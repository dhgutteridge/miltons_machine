require 'set'

module MiltonsMachine
  module Core

    #
    # == Class: Generator
    #
    # This class expands on the Array class to includes various methods to facilitate the permutation and
    # the supply of materials for musical composition.  No monkey patching.
    #
    # @example Permutate set pairs:
    #
    #   working_sets = [[0, 1, 2], [2, 1, 0],
    #                   [3, 4, 5], [5, 4, 3]]
    #
    #   final_results =  MiltonsMachine::Tools::Generator.permutate_set_pairs( working_sets )
    #
    #   final_results.each do |resulting_pair|
    #     puts " #{resulting_pair}"
    #   end
    #
    #   would print out:
    #
    #   [[0, 1, 2], [3, 4, 5]]
    #   [[0, 1, 2], [5, 4, 3]]
    #   [[2, 1, 0], [3, 4, 5]]
    #   [[2, 1, 0], [5, 4, 3]]
    #   [[3, 4, 5], [0, 1, 2]]
    #   [[3, 4, 5], [2, 1, 0]]
    #   [[5, 4, 3], [0, 1, 2]]
    #   [[5, 4, 3], [2, 1, 0]]
    #

    class Generator < Array

      # Constructor
      #
      # @return [Object] a new Generator Object
      #

      def initialize
        # stubbed for now
      end

      # Given an array of sets as a parameter, this method will permutate combinations
      # and return the results as pairs.  Duplicates between each pair are not returned.
      # (for example [0, 1, 2], [2, 1, 0] are the same and will not be considered a solution)
      #
      # @param [Array] working_sets an array of sets to permutate
      # @return [Array] an array of pairings, less duplicates.
      #

      def self.permutate_set_pairs( working_sets )
        compare_set1  = Set.new
        compare_set2  = Set.new
        final_results = []

        working_sets.repeated_permutation(2) do |resulting_pair|
          # filter out duplicate prime and retrogrades
          unless compare_set1.replace(resulting_pair[0]) == compare_set2.replace(resulting_pair[1])
              final_results << resulting_pair
          end
        end

        final_results
      end

    end
  end
end
