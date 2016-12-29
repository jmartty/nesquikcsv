#
# Tests copied from faster_csv by James Edward Gray II
#

require 'test/unit'
require 'nesquikcsv'

class TestNesquikCSVInterface < Test::Unit::TestCase

  def setup
    @path = File.join(File.dirname(__FILE__), "temp_test_data.csv")
    
    File.open(@path, "w") do |file|
      file << "1,2,3\r\n"
      file << "4,5\r\n"
    end

    @expected = [%w{1 2 3}, %w{4 5}]
  end
  
  def teardown
    File.unlink(@path)
  end
  
  ### Test Read Interface ###
  
  def test_foreach
    NesquikCSV.foreach(@path) do |row|
      assert_equal(@expected.shift, row)
    end
  end
  
  def test_open_and_close
    csv = NesquikCSV.open(@path, "r+")
    assert_not_nil(csv)
    assert_instance_of(NesquikCSV, csv)
    assert_equal(false, csv.closed?)
    csv.close
    assert(csv.closed?)
    
    ret = NesquikCSV.open(@path) do |csv|
      assert_instance_of(NesquikCSV, csv)
      "Return value."
    end
    assert(csv.closed?)
    assert_equal("Return value.", ret)
  end
  
  def test_parse
    data = File.read(@path)
    assert_equal( @expected,
                  NesquikCSV.parse(data) )

    NesquikCSV.parse(data) do |row|
      assert_equal(@expected.shift, row)
    end
  end
  
  #def test_parse_line
  #  row = FasterCSV.parse_line("1;2;3", :col_sep => ";")
  #  assert_not_nil(row)
  #  assert_instance_of(Array, row)
  #  assert_equal(%w{1 2 3}, row)
  #  
  #  # shortcut interface
  #  row = "1;2;3".parse_csv(:col_sep => ";")
  #  assert_not_nil(row)
  #  assert_instance_of(Array, row)
  #  assert_equal(%w{1 2 3}, row)
  #end
  
  def test_parse_line_with_empty_lines
    assert_equal(nil,       NesquikCSV.parse_line("", "UTF-8"))  # to signal eof
    #assert_equal(Array.new, NesquikCSV.parse_line("\n1,2,3"))
    assert_equal([nil], NesquikCSV.parse_line("\n1,2,3", "UTF-8"))
  end
  
  def test_read_and_readlines
    assert_equal( @expected,
                  NesquikCSV.read(@path) )
    assert_equal( @expected,
                  NesquikCSV.readlines(@path))
    
    
    data = NesquikCSV.open(@path) do |csv|
      csv.read
    end
    assert_equal(@expected, data)
    data = NesquikCSV.open(@path) do |csv|
      csv.readlines
    end
    assert_equal(@expected, data)
  end
  
  #def test_table
  #  table = NesquikCSV.table(@path)
  #  assert_instance_of(NesquikCSV::Table, table)
  #  assert_equal([[:"1", :"2", :"3"], [4, 5, nil]], table.to_a)
  #end
  
  def test_shift  # aliased as gets() and readline()
    NesquikCSV.open(@path, "r+") do |csv|
      assert_equal(@expected.shift, csv.shift)
      assert_equal(@expected.shift, csv.shift)
      assert_equal(nil, csv.shift)
    end
  end

  def test_long_line # ruby's regex parser may have problems with long rows
    File.unlink(@path)

    long_field_length = 2800
    File.open(@path, "w") do |file|
      file << "1,2,#{'3' * long_field_length}\r\n"
    end
    @expected = [%w{1 2} + ['3' * long_field_length]]
    test_shift
  end
  
  def test_enumerable
    NesquikCSV.open(@path) do |csv|
      assert(csv.include?(["1", "2", "3"]))
      csv.rewind
      assert_equal([["1", "2", "3"], ["4", "5"]], csv.to_a)
    end
  end
  
end
