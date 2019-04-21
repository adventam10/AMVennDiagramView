Pod::Spec.new do |s|
    s.name         = "AMVennDiagramView"
    s.version      = "2.0"
    s.summary      = "AMVennDiagramView is a view can display the diagram like Venn diagram."
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage     = "https://github.com/adventam10/AMVennDiagramView"
    s.author       = { "am10" => "adventam10@gmail.com" }
    s.source       = { :git => "https://github.com/adventam10/AMVennDiagramView.git", :tag => "#{s.version}" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.source_files = 'AMVennDiagram/*.{swift}'
    s.swift_version = "5.0"
end
