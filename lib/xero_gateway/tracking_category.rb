module XeroGateway
  class TrackingCategory
    attr_accessor :name, :options
    
    def initialize(params = {})
      @options = []
      params.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    
    def option
       options[0] if options.size == 1
    end
        
    def to_xml(b = Builder::XmlMarkup.new)
      b.TrackingCategory {
        b.Name self.name
        b.Options {
          if self.options.is_a?(Array)
            self.options.each do |option|
              b.Option {
                b.Name option
              }
            end
          else
            b.Option {
              b.Name self.options.to_s
            }            
          end
        }
      }
    end
    
    def self.from_xml(tracking_category_element)
      tracking_category = TrackingCategory.new
      tracking_category_element.children.each do |element|
        case(element.name)
          when "Name" then tracking_category.name = element.text
          when "Options" then element.children.each {|option| tracking_category.options << option.children.first.text}
        end
      end
      tracking_category              
    end  
    
    def ==(other)
      [:name, :options].each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end      
  end
end
