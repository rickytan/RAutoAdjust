Pod::Spec.new do |s|
  s.frameworks   = 'UIKit'
  s.ios.deployment_target = '5.0'
  s.social_media_url = 'http://rickytan.cn'
  s.name         = "RAutoAdjust"
  s.version      = "1.0.3"
  s.summary      = "a drop-in replacement of UITextField and UITextView which adjust window position to make itself visible when keyboard pop out"
  s.description  = "a drop-in replacement of UITextField and UITextView which can automatically adjust window position to make itself visible when keyboard pop out"
  s.homepage     = "https://github.com/rickytan/RAutoAdjust"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'rickytan' => 'ricky.tan.xin@gmail.com' }
  s.source       = { :git => 'https://github.com/rickytan/RAutoAdjust.git', :tag => s.version.to_s }
  s.platform     = :ios
  s.ios.deployment_target = '4.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true
end