Build = require('../src').Build
assert = require 'should'
fs = require 'fs'
tmp = require 'tmp'

describe 'Build', ->
  describe '#writeJson', ->
    it 'should indent by two and add LF at end', (done) ->
      json =
        something: 'text'
        array: [1, 2]
      text = """
        {
          "something": "text",
          "array": [
            1,
            2
          ]
        }

      """
      tmp.file (err, file, fd) ->
        throw err if err
        Build.writeJson file, json
        read = fs.readFileSync(file).toString()
        read.should.equal text
        done()
