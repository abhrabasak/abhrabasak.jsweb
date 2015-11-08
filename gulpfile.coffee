gulp = require 'gulp'
panini = require 'panini'
connect = require 'gulp-connect'

paniniConfig =
  layouts: 'source/layouts/'
  partials: 'source/partials/**/*.html'
  data: 'source/data/**/*.{json,yml}'
  helpers: 'source/helpers/**/*.js'

gulp.task 'build', ->
  gulp.src('source/templates/**/*.html')
    .pipe(panini(paniniConfig))
    .pipe(gulp.dest('build'))
    .pipe(connect.reload())

gulp.task 'connect', ->
  connect.server
    root: 'build'
    livereload: true

gulp.task 'watch', ->
  gulp.watch ['source/**/*.html'], ['build']

gulp.task 'default', ['build', 'connect', 'watch']
