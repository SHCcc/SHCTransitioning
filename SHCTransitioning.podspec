
Pod::Spec.new do |s|

s.name         = "SHCTransitioning"
s.version      = "0.0.1"
s.summary      = '转场动画'
s.description  = '提供一个swift4.0的缩放转场动画'
s.homepage     = "https://github.com/SHCcc/SHCTransitioning"
s.license      = 'MIT'
s.ios.deployment_target = '8.0'
s.author             = { "SHCcc" => "578013836@qq.com" }
s.source       = { :git => "https://github.com/SHCcc/SHCTransitioning.git", :tag => s.version.to_s }

s.source_files  = ["SHCTransitioning/*/**", "SHCTransitioning/**"]
s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
