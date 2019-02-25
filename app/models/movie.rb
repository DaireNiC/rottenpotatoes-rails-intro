class Movie < ActiveRecord::Base
    
    def self.ratings()
        # get all unique values for rating of movies and return enum
        return  self.all.map{|m| m.rating}.uniq
    end  

end
