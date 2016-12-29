# NesquikCSV

Fork of the Fastest-CSV gem to support different encodings. Uses native C code to parse CSV lines in MRI Ruby.

Supports standard CSV according to RFC4180. Not the so-called "csv" from Excel.

The interface is a subset of the CSV interface in Ruby 1.9.3. The options parameter is not supported.

## Installation

Add this line to your application's Gemfile:

    gem 'nesquikcsv'

And then execute:

    bundle

Or install it yourself as:

    gem install nesquikcsv

## Usage

Parse single line

    # If no encoding is specified UTF-8 is assumed
    NesquikCSV.parse_line "one,two,three" 
     => ["one", "two", "three"]
    NesquikCSV.parse_line "uno,dós,trés", "ASCII-8BIT"
     => ["uno", "d\xC3\xB3s", "tr\xC3\xA9s"]

Parse string in array of arrays

    # Defaults to UTF-8
    rows = NesquikCSV.parse(csv_data)
    # Explicitly
    rows = NesquikCSV.parse(csv_data, "UTF-8")
