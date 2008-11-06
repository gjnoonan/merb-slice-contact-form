namespace :slices do
  namespace :merb_slice_contact_form do
  
    desc "Install MerbSliceContactForm"
    task :install => [:preflight, :setup_directories, :copy_assets, :migrate]
    
    desc "Test for any dependencies"
    task :preflight do # see slicetasks.rb
    end
  
    desc "Setup directories"
    task :setup_directories do
      puts "Creating directories for host application"
      MerbSliceContactForm.mirrored_components.each do |type|
        if File.directory?(MerbSliceContactForm.dir_for(type))
          if !File.directory?(dst_path = MerbSliceContactForm.app_dir_for(type))
            relative_path = dst_path.relative_path_from(Merb.root)
            puts "- creating directory :#{type} #{File.basename(Merb.root) / relative_path}"
            mkdir_p(dst_path)
          end
        end
      end
    end
    
    desc "Copy stub files to host application"
    task :stubs do
      puts "Copying stubs for MerbSliceContactForm - resolves any collisions"
      copied, preserved = MerbSliceContactForm.mirror_stubs!
      puts "- no files to copy" if copied.empty? && preserved.empty?
      copied.each { |f| puts "- copied #{f}" }
      preserved.each { |f| puts "! preserved override as #{f}" }
    end
    
    desc "Copy stub files and views to host application"
    task :patch => [ "stubs", "freeze:views" ]
  
    desc "Copy public assets to host application"
    task :copy_assets do
      puts "Copying assets for MerbSliceContactForm - resolves any collisions"
      copied, preserved = MerbSliceContactForm.mirror_public!
      puts "- no files to copy" if copied.empty? && preserved.empty?
      copied.each { |f| puts "- copied #{f}" }
      preserved.each { |f| puts "! preserved override as #{f}" }
    end
    
    desc "Migrate the database"
    task :migrate do # see slicetasks.rb
    end
    
    desc "Freeze MerbSliceContactForm into your app (only merb-slice-contact-form/app)" 
    task :freeze => [ "freeze:app" ]

    namespace :freeze do
      
      desc "Freezes MerbSliceContactForm by installing the gem into application/gems"
      task :gem do
        ENV["GEM"] ||= "merb-slice-contact-form"
        Rake::Task['slices:install_as_gem'].invoke
      end
      
      desc "Freezes MerbSliceContactForm by copying all files from merb-slice-contact-form/app to your application"
      task :app do
        puts "Copying all merb-slice-contact-form/app files to your application - resolves any collisions"
        copied, preserved = MerbSliceContactForm.mirror_app!
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freeze all views into your application for easy modification" 
      task :views do
        puts "Copying all view templates to your application - resolves any collisions"
        copied, preserved = MerbSliceContactForm.mirror_files_for :view
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freeze all models into your application for easy modification" 
      task :models do
        puts "Copying all models to your application - resolves any collisions"
        copied, preserved = MerbSliceContactForm.mirror_files_for :model
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
      desc "Freezes MerbSliceContactForm as a gem and copies over merb-slice-contact-form/app"
      task :app_with_gem => [:gem, :app]
      
      desc "Freezes MerbSliceContactForm by unpacking all files into your application"
      task :unpack do
        puts "Unpacking MerbSliceContactForm files to your application - resolves any collisions"
        copied, preserved = MerbSliceContactForm.unpack_slice!
        puts "- no files to copy" if copied.empty? && preserved.empty?
        copied.each { |f| puts "- copied #{f}" }
        preserved.each { |f| puts "! preserved override as #{f}" }
      end
      
    end
    
  end
end