$(document).ready ->
  start_timeline()
  $(window).resize start_timeline

start_timeline = ->
  $("#projects").empty()
  $("#timeline").empty()
  $.getJSON( "data.json", (data) ->
    years = get_time_range(data)
    console.log(years)
    insert_dates(years)
    insert_companies(data["companies"])
    $(data["companies"]).each initialize_projects
  )


get_time_range = (data) ->
  min = Math.min data["companies"].map((company) ->
    company["from"]["year"])...
  max = Math.max data["companies"].map((company) ->
    company["to"]["year"])...
  [min..max]


insert_dates = (years) ->
  $("#timeline").append("<div class='dates'></div>")
  $("#timeline > .dates").append("<div class='dates-row'></div>")
  $("#timeline > .dates > .dates-row").append("<div class='date'>#{year}</div>") for year in years


insert_companies = (companies) ->
  $("#timeline").append("<div class='companies'></div>")
  first_year_div = $("#timeline > .dates > .dates-row > .date").first()
  month_width = first_year_div.outerWidth()/12
  first_year = parseInt(first_year_div.text())
  last_year = parseInt($("#timeline > .dates > .dates-row > .date").last().text())

  $(companies).each (i, company) ->
    # left-offset
    year = company["from"]["year"]
    month = company["from"]["month"]
    left_offset = ((year - first_year) * 12 + month - 1) * month_width

    #right-offset
    year = company["to"]["year"]
    month = company["to"]["month"]
    console.log(last_year - year)
    right_offset = ((last_year - year) * 12 + (12 - month + 1)) * month_width

    companies = $("#timeline > .companies").append("<div
      class='company'
      data-company='company_#{i}'
      style='
        left: #{left_offset}px;
        right: #{right_offset}px;
      '>#{company["name"]}</div>")

    $("#timeline > .companies > .company").last().mouseover ->
      $("#projects > .company_projects").fadeOut(500)
      $("#projects > #company_#{i}.company_projects").delay(500).fadeIn(500)

    companies.append("<div class='company_info'>
      <span class='title'>#{company["title"]}</span>
      <span class='desc'>#{company["desc"]}</span></div>")



initialize_projects = (i, company) ->
  $('#projects').append("<div class='company_projects' id='company_#{i}'><h1>Projects</h1></div>")
  for project in company["projects"]
    $('#projects > .company_projects').last().append("<div class='project'>
       <h2>#{project["name"]}</h2>
       <p>#{project["desc"]}</p>
      </div>")

