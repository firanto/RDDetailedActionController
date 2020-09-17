Pod::Spec.new do |s|

    s.name = 'RDDetailedActionController'
    s.version = '0.2.2'
    s.summary = 'Detailed cell item of action sheets. It has icon, title, and subtitle.'
    s.description = <<-DESC
                        Detailed cell item of action sheets. It has icon, title, and subtitle.
                        Similar to action menu we found of Facebook app.
                       DESC

    s.homepage = 'https://github.com/firanto/RDDetailedActionController'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.author = { 'Firstiar Noorwinanto' => 'radical.dreamers@outlook.co.id' }
    s.source = { :git => 'https://github.com/firanto/RDDetailedActionController.git', :tag => s.version }

    s.ios.deployment_target = '8.0'
    s.swift_version = '4.0'

    s.source_files = 'RDDetailedActionController/*.swift'

end
