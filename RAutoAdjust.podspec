Pod::Spec.new do |s|
  s.name         = 'RAutoAdjust'
  s.version      = '1.0.0'
  s.authors      = { 'Ricky Tan' => 'ricky.tan.xin@gmail.com' }
  s.homepage     = 'https://github.com/rickytan/RAutoAdjust'
  s.platform     = :ios
  s.summary      = 'A drop-in replacement for UITextField and UITextView which will adjust it's position automatically when keyboard popout'
  s.source       = { :git => 'https://github.com/rickytan/RAutoAdjust.git', :tag => s.version.to_s }
  s.license      = 'MIT'
  s.frameworks   = 'UIKit'
  s.source_files = 'Classes/**/*'
  s.requires_arc = true
  s.ios.deployment_target = '5.0'
  s.social_media_url = 'http://rickytan.cn'
end