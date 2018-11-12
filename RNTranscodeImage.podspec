require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNTranscodeImage"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  RNTranscodeImage
                   DESC
  s.homepage     = "https://github.com/alpha0010/react-native-transcode-image"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author       = { "author" => "alpha0010@users.noreply.github.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNTranscodeImage.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  #s.dependency "others"
end

