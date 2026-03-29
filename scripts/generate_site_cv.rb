#!/usr/bin/env ruby

require "cgi"
require "json"
require "pathname"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").expand_path
DATA = YAML.load_file(ROOT.join("data/site_cv.yaml"))
SELF_REGEX = /\bFarag\b/.freeze

def html_escape(text)
  CGI.escapeHTML(text.to_s)
end

def tex_escape(text)
  mapping = {
    "\\" => "\\textbackslash{}",
    "{" => "\\{",
    "}" => "\\}",
    "$" => "\\$",
    "&" => "\\&",
    "#" => "\\#",
    "%" => "\\%",
    "_" => "\\_",
    "~" => "\\textasciitilde{}",
    "^" => "\\textasciicircum{}"
  }

  text.to_s.gsub(/[\\{}$&#_%~^]/, mapping)
end

def highlight_html(name)
  escaped = html_escape(name)
  name.match?(SELF_REGEX) ? "<strong>#{escaped}</strong>" : escaped
end

def highlight_tex(name)
  escaped = tex_escape(name)
  name.match?(SELF_REGEX) ? "\\textbf{#{escaped}}" : escaped
end

def join_authors(authors, separator:, last_separator:)
  return "" if authors.nil? || authors.empty?

  if authors.last == "et al."
    body = authors[0...-1]
    rendered = body.map { |author| yield(author) }
    return rendered.join(separator) + ", et al."
  end

  rendered = authors.map { |author| yield(author) }
  return rendered.first if rendered.length == 1
  return rendered.join(last_separator) if rendered.length == 2

  rendered[0...-1].join(separator) + last_separator + rendered[-1]
end

def authors_html(authors)
  join_authors(authors, separator: ", ", last_separator: ", &amp; ") { |author| highlight_html(author) }
end

def authors_tex(authors)
  join_authors(authors, separator: ", ", last_separator: ", \\& ") { |author| highlight_tex(author) }
end

def title_tex(publication)
  publication["title_tex"] || tex_escape(publication["title"])
end

def publication_status_label(publication)
  case publication["status"]
  when "accepted"
    "Accepted"
  when "under_review"
    "Under review"
  else
    nil
  end
end

def publication_website_venue(publication)
  return publication["website_venue"] if publication["website_venue"]

  case publication["status"]
  when "accepted"
    "#{publication.fetch('journal_long')}, accepted (#{publication.fetch('year')})"
  when "preprint"
    "#{publication.fetch('note')} (#{publication.fetch('year')})"
  else
    "#{publication.fetch('journal_long')} #{publication.fetch('volume')}, #{publication.fetch('page')} (#{publication.fetch('year')})"
  end
end

def publication_cv_details(publication)
  return publication["cv_details"] if publication["cv_details"]

  base = "#{publication.fetch('year')}, #{publication.fetch('journal_short')}"
  if publication["status"] == "accepted"
    base
  elsif publication["status"] == "preprint"
    "#{base}, #{publication.fetch('note')}"
  else
    "#{base}, #{publication.fetch('volume')}, #{publication.fetch('page')}"
  end
end

def publication_item_tex(publication)
  title = if publication["link"] && !publication["link"].empty?
            "\\href{#{publication['link']}}{\"#{title_tex(publication)}\"}"
          else
            "{\"#{title_tex(publication)}\"}"
          end

  status = publication_status_label(publication)
  title += " \\textbf{(#{status})}" if status

  details = if publication["cv_details"]
              publication["cv_details"]
            else
              tex_escape(publication_cv_details(publication))
            end

  "\\item #{title}\n\\\\ #{authors_tex(publication.fetch('authors'))} #{details}\n"
end

def talk_item_tex(talk)
  title = if talk["link"] && !talk["link"].empty?
            "\\href{#{talk['link']}}{#{tex_escape(talk['title'])}}"
          else
            tex_escape(talk["title"])
          end

  lines = ["\\item #{title} \\hfill {\\em #{tex_escape(talk.fetch('kind'))}}"]

  if talk["citation_authors"]
    lines << "\\\\ #{authors_tex(talk.fetch('citation_authors'))} #{tex_escape(talk.fetch('citation_details'))}"
    if talk["kind"].start_with?("Invited")
      lines << "\\\\ #{tex_escape(talk.fetch('location'))}"
    end
  else
    lines << "\\\\ #{tex_escape(talk.fetch('location'))}, #{talk.fetch('year')}"
  end

  lines.join("\n") + "\n"
end

def build_publications_tex(data)
  groups = data.fetch("publications").fetch("groups")
  all_items = groups.flat_map { |group| group.fetch("items") }
  first_count = all_items.count { |item| item["author_position"] == "first" }
  second_count = all_items.count { |item| item["author_position"] == "second" }
  metrics = data.fetch("publications").fetch("metrics")

  lines = []
  lines << "\\begin{rSection}{Publications} %\\itemsep -3pt"
  lines << "Summary: #{all_items.length} Total, #{first_count} first Author, #{second_count} second author: \\\\"
  lines << "#{metrics['google_scholar']['citations']} citations, h-index: #{metrics['google_scholar']['h_index']} (\\href{#{metrics['google_scholar']['url']}}{Google Scholar}), #{metrics['ads']['citations']} citations h-index: #{metrics['ads']['h_index']} (\\href{#{metrics['ads']['url']}}{ADS}) \\\\"
  lines << "\\textbf{Peer Reviewed Publications}\\\\"

  groups.select { |group| group["classification"] == "peer_reviewed" }.each do |group|
    lines << "#{group.fetch('cv_label')}:"
    lines << "\\begin{revnumerate}"
    group.fetch("items").each do |publication|
      lines << publication_item_tex(publication).rstrip
      lines << ""
    end
    lines << "\\end{revnumerate}"
    lines << ""
  end

  lines << "\\textbf{Non-Peer reviewed Publications}"
  lines << "\\begin{revnumerate}"
  groups.select { |group| group["classification"] == "non_peer_reviewed" }.flat_map { |group| group.fetch("items") }.each do |publication|
    lines << publication_item_tex(publication).rstrip
    lines << ""
  end
  lines << "\\end{revnumerate}"
  lines << "\\end{rSection}"
  lines << ""
  lines.join("\n")
end

def build_talks_tex(data)
  lines = []
  lines << "\\begin{rSection}{Presentations \\& Invited Talks}"
  lines << "\\begin{revnumerate}"
  lines << ""
  data.fetch("talks").each do |talk|
    lines << talk_item_tex(talk).rstrip
    lines << ""
  end
  lines << "\\end{revnumerate}"
  lines << "\\end{rSection}"
  lines << ""
  lines.join("\n")
end

def build_site_data(data)
  publication_groups = data.fetch("publications").fetch("groups").map do |group|
    {
      "title" => group.fetch("website_title"),
      "meta" => "#{group.fetch('items').length} papers",
      "items" => group.fetch("items").map do |publication|
        {
          "badge" => publication.fetch("year").to_s,
          "title" => publication.fetch("title"),
          "url" => publication.fetch("link"),
          "authorsHtml" => authors_html(publication.fetch("authors")),
          "venue" => publication_website_venue(publication)
        }
      end
    }
  end

  talks = data.fetch("talks").map do |talk|
    item = {
      "badge" => talk.fetch("year").to_s,
      "title" => talk.fetch("title"),
      "url" => talk.fetch("link"),
      "location" => "#{talk.fetch('kind')} • #{talk.fetch('location')}"
    }
    if talk["citation_authors"]
      item["citationHtml"] = "#{authors_html(talk.fetch('citation_authors'))} #{html_escape(talk.fetch('citation_details'))}"
    end
    item
  end

  {
    "statementParagraphsHtml" => data.fetch("site").fetch("statement_paragraphs_html"),
    "interests" => data.fetch("site").fetch("interests"),
    "studentsMentored" => data.fetch("site").fetch("students_mentored"),
    "publicationGroups" => publication_groups,
    "talks" => talks
  }
end

def write_file(path, contents)
  path.dirname.mkpath
  path.write(contents)
end

site_data_js = <<~JS
  // Generated from data/site_cv.yaml by scripts/generate_site_cv.rb. Do not edit manually.
  window.siteData = #{JSON.pretty_generate(build_site_data(DATA))};
JS

write_file(ROOT.join("site-data.js"), site_data_js)
write_file(ROOT.join("CV/Ebraheem_CV/generated_publications.tex"), build_publications_tex(DATA))
write_file(ROOT.join("CV/Ebraheem_CV/generated_presentations.tex"), build_talks_tex(DATA))
