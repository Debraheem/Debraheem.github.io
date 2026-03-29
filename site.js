const siteData = window.siteData || {};

function renderStatement() {
  const container = document.getElementById("statement-content");
  const paragraphs = siteData.statementParagraphsHtml;
  if (!container || !Array.isArray(paragraphs)) return;

  container.innerHTML = paragraphs.map((paragraph) => `<p>${paragraph}</p>`).join("");
}

function renderSimpleList(containerId, items) {
  const container = document.getElementById(containerId);
  if (!container || !Array.isArray(items)) return;

  container.innerHTML = items.map((item) => `<li>${item}</li>`).join("");
}

function renderPublicationGroups() {
  const container = document.getElementById("publication-groups");
  const publicationGroups = siteData.publicationGroups;
  if (!container) return;
  if (!Array.isArray(publicationGroups)) return;

  container.innerHTML = publicationGroups
    .map(
      (group) => `
        <section class="publication-group">
          <h3>${group.title}</h3>
          <p class="publication-meta">${group.meta}</p>
          <ul class="publication-list">
            ${group.items
              .map(
                (item) => `
                  <li class="publication-item">
                    <div class="publication-top">
                      <h4 class="publication-title">
                        <a href="${item.url}">${item.title}</a>
                      </h4>
                      <span class="publication-badge">${item.badge}</span>
                    </div>
                    <p class="authors">${item.authorsHtml}</p>
                    <p class="venue">${item.venue}</p>
                  </li>
                `
              )
              .join("")}
          </ul>
        </section>
      `
    )
    .join("");
}

function renderTalks() {
  const container = document.getElementById("talks-list");
  const talks = siteData.talks;
  if (!container) return;
  if (!Array.isArray(talks)) return;

  container.innerHTML = talks
    .map(
      (talk) => `
        <article class="talk-card">
          <div class="talk-top">
            <h3 class="talk-title"><a href="${talk.url}">${talk.title}</a></h3>
            <span class="talk-badge">${talk.badge}</span>
          </div>
          <p class="talk-location">${talk.location}</p>
          ${talk.citationHtml ? `<p class="talk-citation">${talk.citationHtml}</p>` : ""}
        </article>
      `
    )
    .join("");
}

renderStatement();
renderSimpleList("interests-list", siteData.interests);
renderSimpleList("students-list", siteData.studentsMentored);
renderPublicationGroups();
renderTalks();
