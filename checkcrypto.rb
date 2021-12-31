# Pass currencies to check as argument as "BTC:1;ETH:1" etc
# Set your coinmarket cap api key as environment variable COINMARKETCAP_API_KEY
# Set your desired currency as environment variable DESIRED_CURRENCY (default USD)
# e.g.
# DESIRED_CURRENCY=GBP COINMARKETCAP_API_KEY="key-here" ruby checkcrypto.rb "BTC:1;ETH:2"

# sandbox values for testing
#url = "https://sandbox-api.coinmarketcap.com"
#key = "b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c"

# production
url = "pro-api.coinmarketcap.com"
key = ENV["COINMARKETCAP_API_KEY"]
desired_currency = ENV["DESIRED_CURRENCY"] ||  "USD"
# AlfredApp can't handle the width when data is set into columns,
# so just put everything together with a single space
thin_width_display = ENV.key?("THIN_WIDTH_DISPLAY")

endpoint = "#{url}/v1/cryptocurrency/quotes/latest"

require "rest-client"
require 'json'
def format_currency(value)
  value
    .round(2) # want at most 2 decimal places
    .to_s
    .yield_self {_1[-2] == "." ? _1 + "0" : _1} # add trailing 0
    .yield_self {_1.length >= 7 ? _1.insert(-7, ",") : _1} # add thousands comma
    .prepend "$"
end

portfolio = ARGV[0] # "symbol:amount;symbol:amount;..."
  .split(";") # Split into [ "symbol:amount", ... ]
  .map {_1.split(":")} # Split into [ ["symbol", "amount"], ... ]
  .to_h # Convert to { "symbol" => "amount" }
  .transform_values(&:to_f) # Convert to { "symbol" => amount, ... }

begin
response = RestClient.get endpoint,
  "X-CMC_PRO_API_KEY" => key,
  params: {"symbol" => portfolio.keys.join(","), "convert" => desired_currency}
rescue Exception => e
  puts "Error From API"
  puts e
  exit(1)
end
data = JSON.parse(response.body)["data"]

total_value = portfolio.inject(0) do |total_value, (symbol, amount)|
  quote = data.dig(symbol, "quote", desired_currency, "price")
  value = amount * quote

  if thin_width_display then
    [symbol, "amount:", amount, "quote:", format_currency(quote), "value:", format_currency(value)]
  else
    [symbol.ljust(5), "amount:", amount.to_s.rjust(13, " "), "quote:", format_currency(quote).rjust(10, " "), "value:", format_currency(value).rjust(10, " ")]
  end.join(" ").tap {puts _1}

  total_value += value
end

puts "Portfolio Value: #{format_currency(total_value)}"
