# ppcommand

Parse and pretty print YAML/JSON/XML/CSV/HTML.

## Installation

```
  $ gem install ppcommand
```

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

JSON

```
  $ pp 'http://gdata.youtube.com/feeds/api/standardfeeds/most_popular?v=2&alt=json'
  {"version"=>"1.0",
   "encoding"=>"UTF-8",
   "feed"=>
    {"xmlns"=>"http://www.w3.org/2005/Atom",
     "xmlns$gd"=>"http://schemas.google.com/g/2005",
     "xmlns$openSearch"=>"http://a9.com/-/spec/opensearch/1.1/",
     "xmlns$yt"=>"http://gdata.youtube.com/schemas/2007",
     "xmlns$media"=>"http://search.yahoo.com/mrss/",
     "gd$etag"=>"",
     "id"=>{"$t"=>"tag:youtube.com,2008:standardfeed:global:most_popular"},
     "updated"=>{"$t"=>"2015-01-01T00:00:00.000Z"},
     "category"=>
      [{"scheme"=>"http://schemas.google.com/g/2005#kind",
        "term"=>"http://gdata.youtube.com/schemas/2007#video"}],
     "title"=>{"$t"=>"Most Popular"},
     "logo"=>{"$t"=>"http://www.gstatic.com/youtube/img/logo.png"},
     "link"=>
      [{"rel"=>"alternate",
        "type"=>"text/html",
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
