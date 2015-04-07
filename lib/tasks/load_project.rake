

desc 'creates a poject object from the project directory'

  task :project_load, [:project_name] => :environment do |task, args|
    project_file_path = Rails.root.join('project', args[:project_name], 'project.rb')

    load project_file_path
    project = Project.find_or_create_by title: Specific_project[:title]
    project.update({
      summary: Specific_project[:summary],
      organizations: Specific_project[:organizations] ,
      team: Specific_project[:team],
      forum: Specific_project[:forum],
      pages: []
    })

    puts "Project: Created '#{project.title}'"

    # Load pages from content/*:
    content_path = Rails.root.join('project', args[:project_name], 'content')
    puts "Loading pages from #{content_path}:"
    Dir.foreach(content_path).each do |file|
      path = Rails.root.join content_path, file
      next if File.directory? path

      ext = file[(0...file.index('.'))]
      page_key = file.split('.').first
      name = page_key.capitalize
      content = File.read path

      puts "  Loading page: \"#{name}\" (#{content.size}b)"
      if page_key == 'home'
        project.home_page_content = content

      else
        project.pages << {
          key: page_key,
          name: name,
          content: content
        }
      end
    end

    styles_path = Rails.root.join('project', args[:project_name], 'styles.css')
    if File.exist? styles_path
      styles = File.read styles_path
      puts "Loading #{styles.size}b of custom CSS"
      project.styles = styles
    end

    project.save

    Rake::Task['project_setup'].invoke(args[:project_name])

    puts "Done loading \"#{project.title}\" with #{project.workflows.count} workflow(s), #{project.subject_sets.count} subject sets."
    # binding.pry
  end
