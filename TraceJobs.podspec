#
# Be sure to run `pod lib lint TraceJobs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TraceJobs"
  s.version          = "0.1.0"
  s.summary          = "Trace Jobs is a job queueing library that allows you the create jobs and submit them to a job queue. This allows you to create reusable blocks of code."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  ## Trace Jobs
  Trace Jobs is a job queueing library that allows you the create jobs and submit them to a job queue.
  This allows you to create reusable blocks of code.
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/TraceJobs"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Brian Bal" => "briantbal@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/TraceJobs.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.platform     = :osx, '10.11'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  #s.resource_bundles = {
  #  'TraceJobs' => ['Pod/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
