require 'pp'
require 'yaml'
require 'optparse'

$KCODE = 'utf8'

class PPCommand

  def self.execute
    self.new.execute(ARGV)
  end

  def pp_xml(source)
    require 'rubygems'
    require 'rexml/document'
    puts pretty_xml(REXML::Document.new(source))
  end

  def pp_xmlsimple(source)
    require 'rubygems'
    require 'xmlsimple'
    pp XmlSimple.xml_in(source)
  end
  
  def pp_json(source)
    require 'rubygems'
    require 'json'
    pp JSON.parse(source)
  end

  def pp_yaml(source)
    YAML.each_document(StringIO.new(source)) do |obj|
      pp obj
    end
  end

  def execute(argv)
    opts = {:type => "auto"}
    opp = OptionParser.new

    opp.banner = "pp [options] [file|URI]"
    opp.on("-y", "--yaml", "parse YAML and pp."){|x| opts[:type] = "yaml"}
    opp.on("-j", "--json", "parse JSON and pp."){|x| opts[:type] = "json"}
    opp.on("-x", "--xml", "parse XML using REXML and pp."){|x| opts[:type] = "xml"}
    opp.on("-X", "--xmlsimple", "parse XML using XMLSimple and pp."){|x| opts[:type] = "xmlsimple"}
    opp.on("-t", "--text", "do not parse. print plain text."){|x| opts[:type] = "text"}
    opp.parse!(argv)

    file = argv.shift

    source = ""
    if file.nil?
      source = STDIN.read
    elsif file=~ %r{^https?://}
      require 'open-uri'
      open(file) do |io|
        source = io.read
        if opts[:type] == "auto"
          t = io.content_type
          if t =~ /json/
            opts[:type] = "json"
          elsif t =~ /yaml/
            opts[:type] = "yaml"
          elsif t =~ /xml/
            opts[:type] = "xml"
          end
        end
      end
    else
      source = File.read(file)
    end

    if opts[:type] == "auto"
      if file =~ /\.xml$/
        opts[:type] = "xml"
      elsif file =~ /\.json$/
        opts[:type] = "json"
      else
        opts[:type] = "yaml"
      end
    end
    
    case opts[:type]
    when "xml"
      pp_xml(source)
    when "xmlsimple"
      pp_xmlsimple(source)
    when "json"
      pp_json(source)
    when "text"
      puts source
    else "yaml"
      pp_yaml(source)
    end
  end


  # original from http://snippets.dzone.com/posts/show/4953
  def x_pretty_print(parent_node, itab)
    buffer = ''
    parent_node.elements.each do |node|
    buffer += ' ' * itab + "<#{node.name}#{get_att_list(node, itab)}"
      if node.to_a.length > 0
        buffer += ">"
        if node.text.nil?
          buffer += "\n"
          buffer += x_pretty_print(node,itab+2) 
          buffer += ' ' * itab + "</#{node.name}>\n"
        else
          node_text = node.text.strip
          if node_text != ''
            buffer += node_text 
            buffer += "</#{node.name}>\n"        
          else
            buffer += "\n" + x_pretty_print(node,itab+2) 
            buffer += ' ' * itab + "</#{node.name}>\n"        
          end
        end
      else
        buffer += " />\n"
      end
      
    end
    buffer
  end

  def get_att_list(node, itab = 0)
    att_list = ''
    node.attributes.each { |attribute, val| att_list += "\n" + (" " * itab) + " #{attribute} = \"#{val}\"" }
    att_list
  end
  
  def pretty_xml(doc)
    buffer = ''
    xml_declaration = doc.to_s.match('<\?.*\?>').to_s
    buffer += "#{xml_declaration}\n" if not xml_declaration.nil?
    xml_doctype = doc.to_s.match('<\!.*\">').to_s
    buffer += "#{xml_doctype}\n" if not xml_doctype.nil?
    buffer += "<#{doc.root.name}#{get_att_list(doc.root)}"
    if doc.root.to_a.length > 0
      buffer +=">\n#{x_pretty_print(doc.root,2)}</#{doc.root.name}>"
    else
      buffer += " />\n"
    end
  end

end


