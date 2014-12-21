require "ppcommand/version"
require "ppcommand/main"

module PPCommand
  def self.execute
    PPCommand::Main.new.execute(ARGV)
  end
end
