# ceri-webpack

Configure your ceri components in a single place.
Webpack only.

## Features
- configuration based by using [read-conf](https://github.com/paulpflug/read-conf)

### Install

```sh
npm install --save-dev ceri-webpack
```

## webpack.config

```js
module.exports = async function() {
  return {
    plugins: [
      // available options
      // name (String) Default:"ceri.config" Name of the configuration file
      // config (Object) Overwrites configuration file
      await require("ceri-webpack")(options)
    ]
  }
}
```

## ceri.config
Read by [read-conf](https://github.com/paulpflug/read-conf), from `./` or `./build/` by default.
```js
module.exports = {
  // …

  // Ceri plugins to load
  plugins: [], // Array

  // Name of the custom elements polyfill to load
  // types: [String, Boolean]
  polyfill: "document-register-element",

  // …

}
```

## License
Copyright (c) 2017 Paul Pflugradt
Licensed under the MIT license.
