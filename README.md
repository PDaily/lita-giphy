# lita-giphy

**lita-giphy** is a handler for [Lita](https://github.com/jimmycuadra/lita) that adds gif-searching functionality backed by [Giphy](http://giphy.com).

Make gif searching fun again. :tada:

## Installation

Add lita-giphy to your Lita instance's Gemfile:
``` ruby
gem "lita-giphy"
```

## Configuration

### Required attributes
* `api_key` - Your [Giphy API](https://github.com/giphy/GiphyAPI) key. You can either email the devs for a personal API key, or you can use the default public beta key-- `dc6zaTOxFJmzC`.

### Example

``` ruby
Lita.configure do |config|
  config.handlers.giphy.api_key = "dc6zaTOxFJmzC"
end
```

## Usage

```
Lita: giphy swanson dance
```

```
Lita: gif me emo spiderman
```

```
Lita: animate me joffrey slap
```
