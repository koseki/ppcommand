# Ppcommand

Parse and pretty print YAML/JSON/XML/CSV/HTML.

## Installation

Add this line to your application's Gemfile:

    gem 'ppcommand'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ppcommand

## Usage

```
  $ pp --help
  pp [options] [file|URI]
      -c, --csv                        parse CSV and pp.
      -C, --csvtable                   parse CSV, add labels and pp.
      -H, --html                       parse HTML and pp.
      -j, --json                       parse JSON and pp.
      -x, --xml                        parse XML using REXML and pp.
      -X, --xmlsimple                  parse XML using XMLSimple and pp.
      -y, --yaml                       parse YAML and pp.
      -t, --text                       do not parse. print plain text.
      -h, --help                       show this help.
      -v, --version                    show version.
```

## Example

YAML

```
  $ pp ./config/database.yml
  {"development"=>
    {"encoding"=>"utf8",
     "username"=>"root",
     "adapter"=>"mysql",
     "host"=>"localhost",
     "password"=>nil,
     "database"=>"appname_test",
     "pool"=>5},
  :
```

JSON (from remote)

```
  $ pp http://api.twitter.com/1/statuses/public_timeline.json
  [{"user"=>
     {"name"=>"septiasabatina",
      "profile_sidebar_fill_color"=>"FFFFFF",
      "profile_sidebar_border_color"=>"FFFFFF",
      "profile_background_tile"=>true,
      "profile_link_color"=>"000000",
      "url"=>"http://example.com",
      "contributors_enabled"=>false,
      "favourites_count"=>0,
      "id"=>123456789,
      "description"=>"",
      "utc_offset"=>0,
      "lang"=>"en",
  :
```

HTML (required nokogiri)

```
  $ pp http://www.google.com/
  #(Document:0x96c0ee {
    name = "document",
    children = [
      #(DTD:0x96bb9e { name = "html" }),
      #(Element:0x96b5cc {
        name = "html",
        children = [
          #(Element:0x96adb6 {
            name = "head",
  :
```

Get URL contents as text, skip 3 lines, convert encoding to UTF-8, parse CSV and pp with labels. When using --csvtable(-C), the first line treated as label.

```
  $ pp -t http://example.com/items.csv | head -n +3 | nkf -w | pp -C
  [[[0, "name", "apple"],
    [1, "price", "100"],
    [2, "amount", "99"],
    [3, "label1", "aaa"],
    [4, "label2", "bbb"],
    [5, "label3", "ccc"]],
   [[0, "name", "orange"],
    [1, "price", "123"],
    [2, "amount", "10"],
    [3, "label1", "xxx"],
    [4, "label2", "yyy"],
    [5, "label3", "zzz"]]]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ppcommand/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
