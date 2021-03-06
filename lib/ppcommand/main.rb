# coding: utf-8

require 'awesome_print'
require 'yaml'

module PPCommand
  class Main
    def execute(opts, file)
      source = ''
      if file.nil?
        source = STDIN.read
      elsif file=~ %r{^https?://}
        open(file) do |io|
          source = io.read
          if opts[:type] == "auto"
            t = io.content_type
            if t =~ /json/
              opts[:type] = "json"
            elsif t =~ /yaml/
              opts[:type] = "yaml"
            elsif t =~ /csv/
              opts[:type] = "csv"
            elsif t =~ /html/
              opts[:type] = "html"
            elsif t =~ /xml/
              opts[:type] = "xml"
            end
          end
        end
      else
        source = File.read(file)
      end

      if opts[:type] == "auto"
        if file =~ /\.xml$/i
          opts[:type] = "xml"
        elsif file =~ /\.json$/i
          opts[:type] = "json"
        elsif file =~ /\.(?:csv|txt)$/i
          opts[:type] = "csv"
        elsif file =~ /\.html$/i
          opts[:type] = "html"
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
      when "csv"
        pp_csv(source)
      when "csvtable"
        pp_csvtable(source)
      when "html"
        pp_html(source)
      when "text"
        puts source
      when 'syck'
        pp_syck(source)
      else "yaml"
        pp_yaml(source)
      end
    end

    def pp_xml(source)
      require 'rubygems'
      require 'rexml/document'
      puts pretty_xml(REXML::Document.new(source))
    end

    def pp_xmlsimple(source)
      require 'rubygems'
      require 'xmlsimple'
      ap XmlSimple.xml_in(source)
    end

    def pp_json(source)
      require 'rubygems'
      require 'json'
      ap JSON.parse(source)
    end

    def pp_yaml(source)
      objs = YAML.load_stream(source)
      objs = objs[0] if objs.length == 1
      ap objs
    end

    def pp_syck(source)
      require 'syck'
      YAML::ENGINE.yamler = 'syck'
      objs = YAML.load_stream(StringIO.new(source)).documents
      objs = objs[0] if objs.length == 1
      ap objs
    end

    def pp_csv(source)
      require 'csv'
      ap CSV.parse(source)
    end

    def pp_csvtable(source)
      require 'csv'
      data = CSV.parse(source)
      keys = data.shift
      result = []
      data.each do |values|
        entry = []
        i = nil
        keys.each_with_index do |k, i|
          entry << [i, k, values[i]]
        end
        if keys.length < values.length
          values[i + 1 .. -1].each_with_index do |v, j|
            entry << [i + j + 1, nil, v]
          end
        end
        result << entry
      end
      ap result
      # data.map {|values| Hash[* [keys,values].transpose.flatten] }
    end

    def pp_html(source)
      begin
        require 'nokogiri'
      rescue Exception => e
        STDERR.puts "'nokogiri' is required to parse HTML."
        STDERR.puts "$ gem install nokorigi"
        return
      end
      doc = Nokogiri.HTML(source)
      # doc.serialize(:encoding => 'UTF-8', :save_with =>  Nokogiri::XML::Node::SaveOptions::FORMAT | Nokogiri::XML::Node::SaveOptions::AS_XML)
      ap doc
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
end
