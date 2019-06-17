require 'sinatra'

get '/' do
  erb :index, locals: { result: nil, input: nil }
end

post '/' do
  output = convert_service_to_category(params['input'])
  
  erb :index, locals: { result: output, input: params['input'] }
end

CATEGORY_COLUMNS = File.read('categories_columns.csv').split("\t").each_with_index.map { |item, index| [item, index] }.to_h.freeze
SERVICE_COLUMNS = File.read('services_columns.csv').split("\t").each_with_index.map { |item, index| [item, index] }.to_h.freeze

CAT_TO_SERVICE_COL = {
  'Task Filters' => 'Task Name Filters',
  'hreflang' => 'HREFLANG Tag',
  'Alternate Category' => 'Alternate Service',
}.freeze

def convert_service_to_category(input)
  split = input.split("\t")

  output = CATEGORY_COLUMNS.map do |cat_column, _index|
    service_column = CAT_TO_SERVICE_COL[cat_column] || cat_column
    index = SERVICE_COLUMNS[service_column]
    if index.nil?
      puts "Warning: column '#{cat_column}' not found"
    end
    index ? split[index] : nil
  end

  # Manual steps where the column names weren't the same
  output[CATEGORY_COLUMNS['Category Grouping']] = nil # not used anymore!

  output.join("\t")
end
