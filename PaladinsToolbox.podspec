Pod::Spec.new do |spec|
	spec.name	= 'PaladinsToolbox'
	spec.version	= '1.0.1'
	spec.authors	= {
		'John Stanford' => 'jes13524@gmail.com'
	}
	spec.license	= {
		:type => 'MIT',
		:file => 'LICENSE'
	}
	spec.homepage	= 'https://github.com/PaladinCrow/PaladinsToolbox.git'
	spec.source	= {
		:git => 'https://github.com/PaladinCrow/PaladinsToolbox.git',
		:branch => 'main',
		:tag => spec.version.to_s
	}
	spec.summary	= 'Simple toolbox for swift apps'
	spec.source_files = '**/*.swift', '*.swift'
	spec.swift_versions = '5.0'
	spec.ios.deployment_target = '14.4'
end
