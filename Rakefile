require 'fileutils'

workflow_dir = 'workflow'

desc 'Build workflow'
task build: :icon do
  Dir.chdir('itunes-airplay') do
    sh 'rake build'
  end

  FileUtils.copy('itunes-airplay/build/Release/itunes-airplay', 'workflow/bin')

  puts 'Done.'
end

desc 'Generate workflow icon images from iTunes app icon'
task :icon do
  itunes_icon_path = '/Applications/iTunes.app/Contents/Resources/iTunes.icns'
  format = 'png'
  max_width_and_height = 256
  output_basenames = ['icon', 'A8818D44-1EF8-4CDF-9539-E95E50786C3A']

  output_basenames.each do |basename|
    system(
      'sips',
      '-s', 'format', format,
      '--resampleHeightWidthMax', max_width_and_height.to_s,
      '--out', File.join(workflow_dir, "#{basename}.#{format}"),
      itunes_icon_path
    )
  end
end

task default: :build
