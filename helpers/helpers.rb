module Helpers
  def side_menu(current_path, exclusion)
    Dir.glob("source/*/").select { |dir|
      dir_name = dir.match(%r{/(.+)/})[1]
      File.exist?("#{dir}index.html.md") && !exclusion.include?(dir_name)
    }.sort.map { |dir|
      dir_name = dir.match(%r{/(.+)/})[1]
      item = {}
      item[:url] = "/#{dir_name}"
      item[:title] = get_title("#{dir}index.html.md")
      item[:children] = contents_list(current_path) if "#{dir_name}/" == current_path.scan(%r{^.+?/})[0]
      item
    }.sort {|a, b| title_cmp(a, b) }
  end

  def contents_list(current_path)
    current_dir = "source/#{current_path.scan(%r{^.+?/})[0]}"
    Dir.glob("#{current_dir}_*.md").map { |md|
      md_name = md.match(/_(.+)\.md/)[1]
      {
        url: "##{md_name}",
        name: md_name,
        title: get_title(md)
      }
    }.sort {|a, b| title_cmp(a, b) }
  end

  def get_title(path)
    File.open(path) do |file|
      file.gets.chomp
    end
  end

  def page_title(current_path)
    get_title("source/#{current_path}.md") + (current_path.include?('/') ? " - #{data.site.title}" : '')
  end

  def title_cmp(a, b)
    ret = a[:title].casecmp(b[:title])
    ret == 0 ? a <=> b : ret
  end
end
