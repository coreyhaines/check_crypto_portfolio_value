# Check Your Crypto Portfolio value

This is a quick little script I wrote to give me the total value of my crypto portfolio, as I got tired of doing it manually.

This uses the [CoinMarketCap API](https://coinmarketcap.com/api/) API to get the current pricing information.

## Installing

This uses the [rest-client](https://github.com/rest-client/rest-client) gem, so you need to install it. I have a `Gemfile`, so you can either install manually or with bundler:

> gem install rest-client

or

> bundle install

## Running

The coinmarketcap api key is set using an environment variable, `COINMARKETCAP_API_KEY`, and the coins to check are passed as an argument: `SYMBOL1:AMOUNT1;SYMBOL2:AMOUNT2`.

Example
```
COINMARKETCAP_API_KEY="b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c" ruby checkcrypto.rb "BTC:1;ETH:1"
```

and you get an output

```
BTC count: 1 quote: $39,322.42 value: $39,322.42
ETH count: 1 quote: $1,684.36 value: $1,684.36
Portfolio Value: $41,006.78
```

## Thin Display Style

I built an Alfred Workflow to run this, so I can trigger it without going to the command line. It shows it in Large Type, which is cool. But, when I display it with the column layout, it is too wide. So, I made a way to just squish everything together with a single space, instead of aligned columns.

If you want that, then set a `THIN_WIDTH_DISPLAY` environment variable. It doesn't matter what it is set to, as I just check the existence.

## Only One Commit?

This was originally built on February 6th, and I've added a few things since then. But, for some strange reason, I'm amending the commit when I make changes, then force-pushing it up. So, that's why it looks like there is only one commit. LOL! I do what I want!
