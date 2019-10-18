# chef-ruby-lvm-attrib

[![Gem Version](https://badge.fury.io/rb/chef-ruby-lvm-attrib.svg)](https://badge.fury.io/rb/chef-ruby-lvm-attrib)

This is a list of attributes for lvm objects. They are generated from the source code and broken down by version. See ADDING ATTRIBUTES below to contribute.

At their core these files exist to determine which arguments to pass lvs/vgs/pvs and the subsequent type conversions.

Currently this is split from the main ruby-lvm gem since these files require updating to follow LVM2 releases.

## Usage

```ruby
  require 'lvm/attributes'

  attributes = Attributes.load("2.0.36", "vgs.yaml")
```

## Requirements

- None

## Installation

```bash
sudo gem install chef-ruby-lvm-attrib
```

## Updating for new LVM releases

To add attributes:

Use `update-lvm.sh` script to add new version. Find the interested LVM2 tag from [LVM2 Repository](https://sourceware.org/git/?p=lvm2.git).

- Fork this repository
- `git clone your-forked-repo`
- `cd your-forked-repo`
- `./update-lvm.sh v2_02_155`

The script will add `lib/lvm/attributes/LVM_VERSION` where `LVM_VERSION` being something like `2.02.86(2)` or `2.02.98(2)`.

If the script will not error, it will create new branch and commit `Added LVM_VERSION attributes`.

In case of error, see missing attribute type note below.

If all is well, publish the changes and make Pull Request from GitHub web:

- `git push origin mybranch`
- Submit PR to this repository.

### Missing Attribute Type:

If you get an error like the below:

```
Oops, missing type conversion data of column 'discards' use by 'SEGS' which says its going to return a 'discards'
Figure out the missing type and rerun.
```

- Look in `path/to/lvm-source/lib/report/columns.h` for the column name in the 7th field.
- If the 3rd field is NUM, type will be Integer. If 3rd field is STR, type will be String.
- Add the information to `bin/generate_field_data` in the TYPE_CONVERSION_MAP and try running again

## License

(The MIT License)

Copyright (c) 2008 Matthew Kent, Bravenet Web Services Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
