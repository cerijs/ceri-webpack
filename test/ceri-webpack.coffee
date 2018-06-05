{test} = require "snapy"

plg = require "!./src/ceri-webpack"

test (snap) =>
  ## test plugin delivery
  # should have code and styl file 
  snap(
    promise: 
      plg(config:polyfill:false,plugins:["./test/_plugin"])
      .then (val) => 
        return val.files.map (file) => file.options
      .catch (e) => console.log e
  )
test (snap) =>
  ## test polyfill delivery
  # polyfill should be present 
  snap(
    promise: 
      plg(config:plugins:["./test/_plugin"])
      .then (val) => 
        o = val.files[2].options
        o.contents = if o.contents.length > 10000 then "present" else "absent"
        return val.files.map (file) => file.options
      .catch (e) => console.log e
  )

test (snap) =>
  ## webpack test
  conf =  
    entry: "./test/_entry.js"
    plugins: [await plg(config:plugins:["./test/_plugin"])]
    module:
      rules: [
        test: /.styl$/, use: ["style-loader","css-loader","stylus-loader"]
      ]
  snap webpack: conf