require_relative 'date_generator'
require_relative 'rotator'
require_relative 'enigma'

class Crack
  attr_reader :message_filename, :target_filename, :date, :message, :decrypted_message, :key
  def initialize(message_filename, target_filename, date)
    @message_filename  = message_filename
    @target_filename   = target_filename
    @date              = date
    @message           = File.open(message_filename, "r"){ |file| file.read }.chomp.to_s
    @decrypted_message = ""
  end

  def crack
    @key = 0
    until @decrypted_message[-4..-1] == "nd.."
      rotator            = Rotator.new(@key.to_i, date.to_i)
      enigma             = Enigma.new(message, rotator)
      @decrypted_message = enigma.decrypt
      @key += 1
    end

    @decrypted_message 
  end

  def write_file
    File.open(target_filename, "w"){ |file| file.puts decrypted_message}
  end

  def success_message
    "Created '#{target_filename}' with the key #{key-1} and date #{date}"
  end
end

if __FILE__ == $0
  crack = Crack.new(ARGV[0], ARGV[1], ARGV[2])
  crack.crack
  crack.write_file
  puts crack.success_message
end
