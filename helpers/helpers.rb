class Content < Middleman::Util::EnhancedHash
  def <=>(other)
    ret = self.title.casecmp(other.title)
    ret.zero? ? self.title <=> other.title : ret
  end
end

module Helpers
  def side_menu(current_path)
    Dir.glob('source/*/').select { |dir_path|
      dir_name = File.basename dir_path
      File.exist?("#{dir_path}index.html.md") && !exclusion.include?(dir_name)
    }.map { |dir_path|
      dir_name = File.basename dir_path
      Content.new(
        url: "/#{dir_name}",
        title: get_title("#{dir_path}index.html.md"),
        children: dir_name == File.dirname(current_path) ? contents_list(current_path) : nil
      )
    }.sort
  end

  def contents_list(current_path)
    current_dir = "source/#{File.dirname(current_path)}/"
    Dir.glob("#{current_dir}_*.md").map { |md_path|
      md_name = File.basename(md_path).scan(/^_(.+)\.md/)[0][0]
      Content.new(
        url: "##{md_name}",
        name: md_name,
        title: get_title(md_path)
      )
    }.sort
  end

  def page_title(current_path)
    get_title("source/#{current_path}.md") + (File.dirname(current_path) == '.' ? '' : " - #{data.site.title}")
  end

  private

  def get_title(path)
    File.open(path) do |file|
      file.gets.chomp
    end
  end

  def exclusion
    @exclusion ||= data.menu.additional
      .select { |content| content.url.start_with?('/') }
      .map { |content| content.url[1..-1] }
  end
end
