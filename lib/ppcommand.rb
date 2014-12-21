require 'ppcommand/version'
require 'ppcommand/cli'

module PPCommand
  def self.execute
    PPCommand::CLI.execute(ARGV)
  end
end
