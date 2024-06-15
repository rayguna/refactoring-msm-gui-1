# refactoring-msm-gui-1

Target: https://msm-gui.matchthetarget.com/

Lesson: https://learn.firstdraft.com/lessons/151-refactoring-msm-gui-1

Video: https://share.descript.com/view/c9aAdymOLGC

Grading: https://grades.firstdraft.com/resources/3a0972b1-4374-47fa-83b1-1319150e1313

<hr>

Start out by populating the table data with the command `rake sample_Data` in the terminal; otherwise, you will see no data being displayed.

**Goal:** To simplify the query commands that tend to be verbose via queries encapsulation, e.g.:

Simplify this:
```
<% the_id = @the_movie.director_id >

<% matching_directors = Director.where({ :id => the_id }) %>
    
<% the_director = matching_directors.at(0) %>

<%= the_director.name %>
```

Into this:

```
<% the_director = @the_movie.director %>

<%= the_director.name %>
```

or
```
<%= @the_movie.director.name %>
```

1. You can achieve refactoring using classes, e.g.:

```
class Person
  attr_accessor(:first_name)
  attr_accessor(:last_name)

  def full_name
    assembled_name = self.first_name + " " + self.last_name

    return assembled_name
  end

  def full_name_caps
    return self.full_name.upcase
  end
end

rb = Person.new
rb.first_name = "Raghu"
rb.last_name = "Betina"

pp rb.full_name_caps
```

2. A class that is equipped with the appropriate methods can be used over and over again for various sub-cases, thus simplifying the problem. 

3. (Amazing!) In rails, we can define an child class that inherits all properties of ApplicationRecord and add custom methods to it. This can be done by placing the class within the models/ folder.

```
# app/models/movie.rb

class Movie < ApplicationRecord
  def director
    return "Hello!"
  end
end
```

I. Refactor a one-to-many relationship

1. To transform the object directly to have the suitable property, so you don't have to repeat the effort multiple times for similar purposes:

```
# app/models/movie.rb

class Movie < ApplicationRecord
  def director
    my_director_id = self.director_id

    matching_directors = Director.where({ :id => my_director_id })
    
    the_director = matching_directors.at(0)

    return the_director
  end
end
```

2. Accordingly, you can shorten the html script as follows:

```
#views/movie_template/show.html.erb

  <dt>
    Director 
  </dt>
  <dd>
    <!--<% the_id = @the_movie.director_id %>

    <% matching_directors = Director.where({ :id => the_id }) %>
        
    <% the_director = matching_directors.at(0) %>-->

    <% if the_director != nil %>
      <!--<%= the_director.name %>-->
      <%=@the_movie.director.name%>
    <% else %>
      Uh oh! We weren't able to find a director for this movie.
    <% end %>
  </dd>
```

The above refactoring applies for a one-to-many relationship.

II. Refactor a manyto-many relationship

1. Here is the original code that we wish to refactor:

```
# app/views/director_templates/show.html.erb

<% the_id = @the_director.id %>

<% matching_movies = Movie.where({ :director_id => the_id }) %>

<% films = matching_movies.order({ :year => :asc }) %>

<% films.each do |a_movie| %>
```

2. We will simplify the above code by creating the following class:

```
# app/models/director.rb

class Director < ApplicationRecord
  def filmography
    my_id = self.id

    matching_movies = Movie.where({ :director_id => my_id })

    return matching_movies
  end
end
```

3. Accordingly, you can shorten the html script as follows:

```
#views/director_templates/show.html.erb

<% films = @the_director.filmography.order({ :year => :asc }) %>

<% films.each do |a_movie| %>
```

You can further shorten the above code by method chaining as follows:

```
#views/director_templates/show.html.erb

<% @the_director.filmography.order(:year).each do |a_movie| %>
```

4. Here is the modified html script:

```
#views/director_templates/show.html.erb

  <!--<% the_id = @the_director.id %>

  <% matching_movies = Movie.where({ :director_id => the_id }) %>

  <% films = matching_movies.order({ :year => :asc }) %>-->

  <% films = @the_director.filmography.order({ :year => :asc }) %>

  <% films.each do |a_movie| %>
```
