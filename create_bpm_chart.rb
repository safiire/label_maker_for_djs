#!/usr/bin/env ruby

####
##  Get the start and end BPM from the user
if ARGV.size ==  2
  Start, End = ARGV.map(&:to_i)
else
  STDERR.puts("Usage: #{$0} <start bpm> <end bpm>")
  exit(1)
end
OutputFile = "#{Start}-#{End}_chart.html"

Template = <<-STR
<!doctype html>
<html lang="en">
  <head>
    <style type="text/css">
      body{
        font-family: "Arial Black";
        font-size: 9pt;
      }
      table {
        border: 1px solid black;
        border-collapse: collapse;
      }
      td {
        width: 3.5em;
        height: 3em;
        text-align: center;
      }
    </style>
    <meta charset="utf-8">
    <title>BPM Chart</title>
    <link rel="stylesheet" href="css/styles.css?v=1.0">
  </head>
  <body>
    <table border="1">
      <caption>BPM %d - %d</caption>
      %s
    </table>
  </body>
</html>

STR


####
##  Create a table row
def create_row(ary, row_type = :tr, col_type = :td)
  inner = ary.inject('') do |output, value|
    output += "<#{col_type}>#{value}</#{col_type}>"
  end
  "<#{row_type}>#{inner}</#{row_type}>\n"
end


####
##  What is the percent difference
def bpm_percent(a, b)
  min, max = [a, b].min, [a, b].max
  sign = ['&nbsp;', '&nbsp;', '-'][(a <=> b) + 1]
  ratio = ((max / min.to_f) - 1.0) * 100
  "%s%.2f" % [sign, ratio]
end

print "Rendering BPM Chart #{Start} - #{End} to #{OutputFile}"

##  Make the header
html_rows = [create_row((Start..End).to_a, :th, :td)]

Start.upto(End) do |y_bpm|
  row_values = [y_bpm]

  Start.upto(End) do |x_bpm|
    row_values << bpm_percent(y_bpm, x_bpm)
    print '.'
  end
  html_rows << create_row(row_values)
end

File.open("#{Start}-#{End}_chart.html", 'w') do |fp|
  fp.puts(Template % [Start, End, html_rows.join])
end

puts ' Done'

