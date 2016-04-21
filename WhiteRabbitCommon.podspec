Pod::Spec.new do |s|
  s.name         = "WhiteRabbitCommon"
  s.version      = "0.0.5"
  s.summary      = "Shared resources for White Rabbit apps."
  s.homepage     = "https://github.com/white-rabbit-apps/white-rabbit-common-ios"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Michael Bina" => "michaelbina@whiterabbitapps.net" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/white-rabbit-apps/white-rabbit-common-ios.git", :tag => "#{s.version}" }
  s.source_files = 'WhiteRabbitCommon/*.{h,swift}'
  s.public_header_files   = 'WhiteRabbitCommon/*.h'
  s.resource_bundles = { 'WhiteRabbitCommon' => ['WhiteRabbitCommon/*.xcassets'] }
  s.frameworks   = ['UIKit', 'Foundation']
  s.requires_arc = true
end
