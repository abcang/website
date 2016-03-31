module Helpers
  def side_menu(current_path, exclusion)
    Dir.glob("source/*/").select { |dir_path|
      dir_name = File.basename dir_path
      File.exist?("#{dir_path}index.html.md") && !exclusion.include?(dir_name)
    }.map { |dir_path|
      dir_name = File.basename dir_path
      item = {}
      item[:url] = "/#{dir_name}"
      item[:title] = get_title("#{dir_path}index.html.md")
      item[:children] = contents_list(current_path) if dir_name == File.dirname(current_path)
      item
    }.sort {|a, b| title_cmp(a, b) }
  end

  def contents_list(current_path)
    current_dir = "source/#{File.dirname(current_path)}/"
    Dir.glob("#{current_dir}_*.md").map { |md_path|
      md_name = File.basename(md_path)
      {
        url: "##{md_name}",
        name: md_name,
        title: get_title(md_path)
      }
    }.sort {|a, b| title_cmp(a, b) }
  end

  def get_title(path)
    File.open(path) do |file|
      file.gets.chomp
    end
  end

  def page_title(current_path)
    get_title("source/#{current_path}.md") + (File.dirname(current_path) == '.' ? '' : " - #{data.site.title}")
  end

  def title_cmp(a, b)
    ret = a[:title].casecmp(b[:title])
    ret == 0 ? a <=> b : ret
  end
end
