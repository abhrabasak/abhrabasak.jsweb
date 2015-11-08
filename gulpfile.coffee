gulp = require 'gulp'
panini = require 'panini'
connect = require 'gulp-connect'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'

config =
  panini: # https://github.com/zurb/panini
    layouts: 'source/layouts/'
    partials: 'source/partials/**/*.html'
    data: 'source/data/**/*.{json,yml}'
    helpers: 'source/helpers/**/*.js'
  sass: # https://github.com/sass/node-sass#options
    includePaths: ['source/bower/foundation/scss']
    outputStyle: 'expanded'
    sourceComments: true
  coffee:
    bare: true

gulp.task 'build', ->
  gulp.src 'source/templates/**/*.html'
    .pipe panini config.panini
    .pipe gulp.dest 'build'
    .pipe connect.reload()

gulp.task 'sass', ->
  gulp.src ['source/assets/styles/*.scss']
    .pipe sass config.sass
    .pipe gulp.dest 'build/assets/styles'

gulp.task 'scripts', ->
  gulp.src ['source/bower/foundation/js/vendor/modernizr.js', 'source/bower/foundation/js/vendor/jquery.js']
    .pipe concat 'app.js'
    .pipe gulp.dest 'build/assets/scripts/'

gulp.task 'coffee', ->
  gulp.src ['source/assets/scripts/*.coffee']
    .pipe coffee()
    .pipe gulp.dest 'build/assets/scripts'

gulp.task 'connect', ->
  connect.server
    root: 'build'
    livereload: true

gulp.task 'watch', ->
  gulp.watch ['source/**/*.html'], ['build']
  gulp.watch ['source/assets/styles/*.scss'], ['sass']
  gulp.watch ['source/assets/scripts/*.coffee'], ['coffee']

gulp.task 'default', ['build', 'sass', 'scripts', 'coffee', 'connect', 'watch']
