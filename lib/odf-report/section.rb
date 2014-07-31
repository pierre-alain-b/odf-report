module ODFReport

  class Section
    include Nested

    def initialize(opts)
      @name             = opts[:name]
      @collection_field = opts[:collection_field]
      @collection       = opts[:collection]

      @fields = []
      @texts = []
      @tables = []
      @sections = []

    end

    def replace!(doc, row = nil)

      return unless section = find_section_node(doc)

      template = section.dup


      @collection = get_collection_from_item(row, @collection_field) if row

      @collection.each do |data_item|

        new_section = template.dup

        @tables.each    { |t| t.replace!(new_section, data_item) }

        @sections.each  { |s| s.replace!(new_section, data_item) }

        @texts.each     { |t| t.replace!(new_section, data_item) }

        @fields.each    { |f| f.replace!(new_section, data_item) }

        section.before(new_section)

      end

      section.remove

    end # replace_section

  private

    def find_section_node(doc)

      sections = doc.xpath(".//text:section[@text:name='#{@name}']")

      sections.empty? ? nil : sections.first

    end

  end

end
