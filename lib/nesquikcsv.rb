# This loads either csv_parser.so, csv_parser.bundle or
# csv_parser.jar, depending on your Ruby platform and OS
require 'csv_parser'
require 'stringio'

# Fast CSV parser using native code
class NesquikCSV
  include Enumerable
  
  # Pass each line of the specified +path+ as array to the provided +block+
  def self.foreach(path, &block)
    open(path) do |reader|
      reader.each(&block)
    end
  end

  # Opens a csv file. Pass a FastestCSV instance to the provided block,
  # or return it when no block is provided
  def self.open(path, mode = "rb")
    csv = new(File.open(path, mode))
    if block_given?
      begin
        yield csv
      ensure
        csv.close
      end
    else
      csv
    end
  end

  # Read all lines from the specified +path+ into an array of arrays
  def self.read(path)
    open(path, "rb") { |csv| csv.read }
  end

  # Alias for read
  def self.readlines(path)
    read(path)
  end

  # Read all lines from the specified String into an array of arrays
  def self.parse(data, encoding="UTF-8", &block)
    csv = new(StringIO.new(data), encoding)
    if block.nil?
      begin
        csv.read
      ensure
        csv.close
      end
    else
      csv.each(&block)
    end
  end
  
  def self.parse_line(line, encoding="UTF-8")
    CsvParser.parse_line(line, encoding)
  end

  # Create new NesquikCSV wrapping the specified IO object
  def initialize(io, encoding="UTF-8")
    @io = io
    @encoding = encoding
  end
  
  # Read from the wrapped IO passing each line as array to the specified block
  def each
    if block_given?
      while row = shift(@encoding)
        yield row
      end
    else
      to_enum # return enumerator
    end
  end
  
  # Read all remaining lines from the wrapped IO into an array of arrays
  def read
    table = Array.new
    each {|row| table << row}
    table
  end
  alias_method :readlines, :read
  
  # Rewind the underlying IO object and reset line counter
  def rewind
    @io.rewind
  end

  # Read next line from the wrapped IO and return as array or nil at EOF
  def shift(encoding='UTF-8')
    if line = get_line_with_quotes
      CsvParser.parse_line(line, encoding)
    else
      nil
    end
  end
  alias_method :gets,     :shift
  alias_method :readline, :shift
  
  # Close the wrapped IO
  def close
    @io.close
  end
  
  def closed?
    @io.closed?
  end

  def get_line_with_quotes
    line = @io.gets
    if !line.nil?
      while line.count('"').odd?
        next_line = @io.gets
        break if next_line.nil?
        line << next_line
      end
    end
    line
  end


end