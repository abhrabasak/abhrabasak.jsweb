gulp = require 'gulp'
panini = require 'panini'
connect = require 'gulp-connect'
sass = require 'gulp-sass'

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

nodeSassConfig =
  includePaths: ['source/bower/foundation/scss']
  outputStyle: 'expanded'

gulp.task 'sass', ->
  gulp.src(['source/assets/styles/*.scss'])
    .pipe(sass(nodeSassConfig))
    .pipe(gulp.dest('build/assets/styles'))

gulp.task 'connect', ->
  connect.server
    root: 'build'
    livereload: true

gulp.task 'watch', ->
  gulp.watch ['source/**/*.html'], ['build']

gulp.task 'default', ['build', 'sass', 'connect', 'watch']
