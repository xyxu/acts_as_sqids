# acts_as_sqids

[![Gem Version][gem-image]][gem-link]
[![Download][download-image]][download-link]
[![Build Status][build-image]][build-link]
[![Coverage Status][cov-image]][cov-link]
[![Code Climate][gpa-image]][gpa-link]

Use [Sqids](https://github.com/sqids/sqids-ruby) (a.k.a. Youtube-Like ID) in ActiveRecord seamlessly.

## Installation

Add the acts_as_sqids gem to your Gemfile.

```ruby
gem "acts_as_sqids"
```

And run `bundle install`.

## Usage

Activate the function in any model of `ActiveRecord::Base`.

```ruby
class Foo < ActiveRecord::Base
  acts_as_sqids
end

foo = Foo.create
# => #<Foo:0x007feb5978a7c0 id: 3>

foo.to_param
# => "ePQgabdg"

Foo.find(3)
# => #<Foo:0x007feb5978a7c0 id: 3>

Foo.find("ePQgabdg")
# => #<Foo:0x007feb5978a7c0 id: 3>

Foo.with_sqids("ePQgabdg").first
# => #<Foo:0x007feb5978a7c0 id: 3>
```

### Use in Rails

Only one thing you need to hash ids is put `acts_as_sqids` in `ApplicationRecord`, then you will see hash ids in routes URL and they are handled correctly as long as you use `find` to find records.

## Options

### length

You can customize the length of hash ids per model. The default length is 8.

```ruby
class Foo < ActiveRecord::Base
  acts_as_sqids length: 2
end

Foo.create.to_param
# => "Rx"
```

### secret

You can customize the secret of hash ids per model. The default secret is the class name. The name of base class is used for STI.

```ruby
class Foo1 < ActiveRecord::Base
  acts_as_sqids secret: 'my secret'
end

class Foo2 < ActiveRecord::Base
  acts_as_sqids secret: 'my secret'
end

Foo1.create.to_param
# => "RxQce3a2"

Foo2.create.to_param
# => "RxQce3a2"
```

### alphabet

Specify which characters you use to generate sqids.

```rb
class Foo < ActiveRecord::Base
  acts_as_sqids alphabet: '0123456789uvwxyz'
end

Foo.create(id: 1).to_param
# => "4xw8zwyv"
```

## Test

Execute the command below to run rspec and rubocop.

```
bundle exec rake
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.




[gem-image]:   https://badge.fury.io/rb/acts_as_sqids.svg
[gem-link]:    http://badge.fury.io/rb/acts_as_sqids
[download-image]:https://img.shields.io/gem/dt/acts_as_sqids.svg
[download-link]:https://rubygems.org/gems/acts_as_sqids
[build-image]: https://github.com/xyxu/acts_as_sqids/actions/workflows/test.yml/badge.svg
[build-link]:  https://github.com/xyxu/acts_as_sqids/actions/workflows/test.yml
[cov-image]:   https://coveralls.io/repos/xyxu/acts_as_sqids/badge.png
[cov-link]:    https://coveralls.io/r/xyxu/acts_as_sqids
[gpa-image]:   https://codeclimate.com/github/xyxu/acts_as_sqids.png
[gpa-link]:    https://codeclimate.com/github/xyxu/acts_as_sqids

