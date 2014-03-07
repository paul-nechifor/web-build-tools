fs = require 'fs'
{exec, spawn} = require 'child_process'

browserifyPkg = require 'browserify'
coffeeify = require 'coffeeify'
uglifyJs = require 'uglify-js'
stylusPkg = require 'stylus'
nib = require 'nib'


class Build
  constructor: (@taskOrig, @config, @processOptions, @actions) ->

  run: (names, cb) ->
    names = [names] if typeof names is 'string'
    i = 0
    next = =>
      @actions[names[i]] ->
        i++
        return cb?() if i >= names.length
        next()
    next()

  task: (action, desc, func) ->
    @taskOrig action, desc, (options) =>
      @processOptions options
      func()

  makePublic: (actionDesc) ->
    for action, desc of actionDesc
      do (action) =>
        @task action, desc, => @run action

Build.sh = (commands, cb) ->
  exec commands, (err, stdout, stderr) ->
    throw err if err
    process.stdout.write stdout + stderr
    cb?()

Build.writeJson = (file, json) ->
  text = JSON.stringify json, null, '  '
  fs.writeFileSync file, text + '\n'

Build.cmd = (name, args, cb) ->
  p = spawn name, args
  p.stdout.on 'data', (data) -> process.stdout.write data + ''
  p.stderr.on 'data', (data) -> process.stderr.write data + ''
  p.on 'close', -> cb?()

Build.stylus = (outFile, inFile, opts, cb) ->
  if cb is undefined
    cb = opts
    opts = {}
  input = fs.readFileSync(inFile).toString()
  s = stylusPkg input
  s.set 'compress', opts.debug
  s.use nib
  s.render (err, css) ->
    throw err if err
    fs.writeFileSync outFile, css
    cb?()

Build.browserify = (outFile, inFile, opts, cb) ->
  if cb is undefined
    cb = opts
    opts = {}
  b = browserifyPkg()
  b.add inFile
  b.transform coffeeify
  b.bundle
    debug: true
    transform: coffeeify
  , (err, result) ->
    throw err if err
    if opts.debug
      done = uglifyJs.minify result, fromString: true
      fs.writeFileSync outFile, done.code
    else
      fs.writeFileSync outFile, result
    cb?()

Build.commandify = (jsFilePath, cb) ->
  file = fs.readFileSync jsFilePath
  fs.writeFileSync jsFilePath, '#!/usr/bin/env node\n\n' + file
  Build.cmd 'chmod', ['+x', jsFilePath], cb


exports.Build = Build
