require 'miltons_machine'

describe MiltonsMachine::Core::ForteSet do

  context "when performing base set operations" do

    before(:each) do
      subject.replace([0, 3, 5, 6, 9])
    end

    it "should transpose itself and return a copy" do
      return_set = subject.transpose_mod12(4)
      subject.should eq [0, 3, 5, 6, 9]
      return_set.should eq [4, 7, 9, 10, 1]
    end

    it "should transpose itself in place and return a reference" do
      return_set = subject.transpose_mod12!(4)
      subject.should eq [4, 7, 9, 10, 1]
      return_set.should eq subject
      subject[3] = 11
      subject.should eq [4, 7, 9, 11, 1]
      return_set.should eq subject
    end

    it "should invert itself and return a copy" do
      subject.transpose_mod12!(4)
      return_set = subject.invert_mod12
      subject.should eq [4, 7, 9, 10, 1]
      return_set.should eq [8, 5, 3, 2, 11]
    end

    it "should invert itself in place and return a reference" do
      subject.transpose_mod12!(4)
      return_set = subject.invert_mod12!
      subject.should eq [8, 5, 3, 2, 11]
      return_set.should eq subject
      subject[3] = 7
      subject.should eq [8, 5, 3, 7, 11]
      return_set.should eq subject
    end

    it "should return it's complement set" do
      return_set = subject.complement_mod12
      subject.should eq [0, 3, 5, 6, 9]
      return_set.should eq [1, 2, 4, 7, 8, 10, 11]
    end

    it "should replace itself with it's complement set" do
      return_set = subject.complement_mod12!
      subject.should eq [1, 2, 4, 7, 8, 10, 11]
      return_set.should eq subject
      subject[3] = 5
      subject.should eq [1, 2, 4, 5, 8, 10, 11]
      return_set.should eq subject
    end

    it "should return the zero placement of the set" do
      subject.transpose_mod12!(7)
      return_set = subject.zero_mod12
      subject.should eq [7, 10, 0, 1, 4]
      return_set.should eq [0, 3, 5, 6, 9]
    end

    it "should zero itself in place and return a reference" do
      subject.transpose_mod12!(7)
      return_set = subject.zero_mod12!
      subject.should eq [0, 3, 5, 6, 9]
      return_set.should eq subject
      subject[3] = 7
      subject.should eq [0, 3, 5, 7, 9]
      return_set.should eq subject
    end

    it "should return its normalized form" do
      subject.transpose_mod12!(1)
      return_set = subject.normalize_mod12
      subject.should eq [1, 4, 6, 7, 10]
      return_set.should eq [4, 6, 7, 10, 1]
    end

    it "should replace itself with it's normalized form and return a copy" do
      subject.transpose_mod12!(1)
      return_set = subject.normalize_mod12!
      subject.should eq [4, 6, 7, 10, 1]
      return_set.should eq subject
      subject[3] = 9
      subject.should eq [4, 6, 7, 9, 1]
      return_set.should eq subject
    end

    it "should return it's reduced form'" do
      subject.transpose_mod12!(1)
      return_set = subject.reduce_mod12
      subject.should eq [1, 4, 6, 7, 10]
      return_set.should eq [0, 2, 3, 6, 9]
    end

    it "should replace itself with it's reduced form and return a copy" do
      subject.transpose_mod12!(1)
      return_set = subject.reduce_mod12!
      subject.should eq [0, 2, 3, 6, 9]
      return_set.should eq subject
      subject[3] = 7
      subject.should eq [0, 2, 3, 7, 9]
      return_set.should eq subject
    end

    it "should return it's prime form" do
      subject.transpose_mod12!(1)
      return_set = subject.prime_mod12
      subject.should eq [1, 4, 6, 7, 10]
      return_set.should eq [0, 1, 3, 6, 9]
    end

    it "should replace itself with it's prime form and return a reference" do
      subject.transpose_mod12!(1)
      return_set = subject.prime_mod12!
      subject.should eq [0, 1, 3, 6, 9]
      return_set.should eq subject
      subject[3] = 7
      subject.should eq [0, 1, 3, 7, 9]
      return_set.should eq subject
    end

    it "should compare itself with another set and return the more compact form" do
      subject.transpose_mod12!(1)
      return_set = subject.compare_compact_sets([4, 6, 7, 10, 1])
      subject.should eq [1, 4, 6, 7, 10]
      return_set.should eq [4, 6, 7, 10, 1]
    end

    it "should convert itself from alphanumeric form and return a copy" do
      subject.replace(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'a', 'B', 'b', 'C', 'c'])
      return_set = subject.convert_set_from_alpha
      subject.should eq ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'a', 'B', 'b', 'C', 'c']
      return_set.should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12]
    end

    it "should convert itself in place from alphanumeric form and return a reference" do
      subject.replace(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'a', 'B', 'b', 'C', 'c'])
      return_set = subject.convert_set_from_alpha!
      subject.should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12]
      return_set.should eq subject
      5.times { |n| subject[10 + n] = n}
      subject.should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 12]
      return_set.should eq subject
    end

    it "should convert itself from numeric form and return a copy" do
      subject.replace([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12])
      return_set = subject.convert_set_to_alpha
      subject.should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12]
      return_set.should eq ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'A', 'B', 'B', 'C', 'C']
    end

    it "should convert itself in place from numeric form and return a reference" do
      subject.replace([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12])
      return_set = subject.convert_set_to_alpha!
      subject.should eq ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'A', 'B', 'B', 'C', 'C']
      return_set.should eq subject
      5.times { |n| subject[10 + n] = n.to_s}
      subject.should eq ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '1', '2', '3', '4', 'C']
      return_set.should eq subject
    end

    it "should convert itself from numeric form and return a copy as a chromatic representation" do
      subject.replace([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13])
      solution_set = ['C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B', 'unknown',
                      'unknown']
      return_set = subject.convert_set_to_chromatic
      subject.should eq [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
      return_set.should eq solution_set
    end

    it "should allow for multiple subset searches" do
      solution_set = [[[3, 0, 9], [2, 3, 7], [1, 5, 8], [2, 7, 8], [4, 6, 9]], [false, true, false, false, true]]
      source_set = [2, 3, 4, 6, 7, 9]
      search_sets = [[3, 0, 9], [2, 3, 7], [1, 5, 8], [2, 7, 8], [4, 6, 9]]
      result_set = MiltonsMachine::Core::ForteSet.search_for_subsets(source_set, search_sets)
      result_set.should eq solution_set
    end

    # Note: we do not provide an update ! version of convert_set_to_chromatic as there is no way to convert ot back

    it "should allow to convert a pitch class from numeric form to a chromatic representation" do
      solution_set = ['C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B', 'unknown',
                      'unknown']
      result_set = []
      0.upto(13)  do |n|
        result_set <<  MiltonsMachine::Core::ForteSet.pc_to_chromatic(n)
      end
      result_set.should eq solution_set
    end

    it "should transpose an individual pitch class" do
      solution_set = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 1, 2]
      result_set = []
      0.upto(12)  do |n|
        result_set <<  MiltonsMachine::Core::ForteSet.transpose_pc(n, 2)
      end
      result_set.should eq solution_set
    end

    it "should invert an individual pitch class" do
      solution_set = [0, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
      result_set = []
      0.upto(12)  do |n|
        result_set <<  MiltonsMachine::Core::ForteSet.invert_pc(n)
      end
      result_set.should eq solution_set
    end

    it "should translate pc from alpha to numeric" do
       solution_set = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 11, 11, 12, 12]
       test_set = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'a', 'B', 'b', 'C', 'c']
       result_set = []
       test_set.each  do |pc|
         result_set <<  MiltonsMachine::Core::ForteSet.pc_from_alpha(pc)
       end
       result_set.should eq solution_set
    end

    it "should translate pc from numeric to alphanumeric" do
       solution_set = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C']
       test_set = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
       result_set = []
       test_set.each  do |pc|
         result_set <<  MiltonsMachine::Core::ForteSet.pc_to_alpha(pc)
       end
       result_set.should eq solution_set
    end

  end

end