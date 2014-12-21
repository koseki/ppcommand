# coding: utf-8

require 'optparse'
require 'ppcommand/main'
require 'open-uri'

module PPCommand

  class CLI
    def self.execute(argv)
      opts = {:type => "auto"}
      opp = OptionParser.new

      opp.banner = "pp [options] [file|URI]"
      opp.on_tail("-h", "--help", "show this help.") do
        puts opp
        exit
      end
      opp.on_tail("-v", "--version", "show version.") do
        puts "ppcommand #{ PPCommand::VERSION }"
        exit
      end

      opp.on("-c", "--csv", "parse CSV and pp."){|x| opts[:type] = "csv"}
      opp.on("-C", "--csvtable", "parse CSV, add labels and pp."){|x| opts[:type] = "csvtable"}
      opp.on("-H", "--html", "parse HTML and pp."){|x| opts[:type] = "html"}
      opp.on("-j", "--json", "parse JSON and pp."){|x| opts[:type] = "json"}
      opp.on("-x", "--xml", "parse XML using REXML and pp."){|x| opts[:type] = "xml"}
      opp.on("-X", "--xmlsimple", "parse XML using XMLSimple and pp."){|x| opts[:type] = "xmlsimple"}
      opp.on("-y", "--yaml", "parse YAML and pp."){|x| opts[:type] = "yaml"}

      opp.on("-t", "--text", "do not parse. print plain text."){|x| opts[:type] = "text"}

      opp.parse!(argv)

      file = argv.shift

      PPCommand::Main.new.execute(opts, file)
    end
  end
end
