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

function renderPublicationGroups(containerId, publicationGroups) {
  const container = document.getElementById(containerId);
  if (!container) return;
  if (!Array.isArray(publicationGroups)) return;

  container.innerHTML = publicationGroups
    .map(
      (group) => `
        <section class="publication-group">
          ${group.title ? `<h3>${group.title}</h3>` : ""}
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
    .map((talk) => {
      const [kind, ...locationParts] = talk.location.split(" • ");
      const location = locationParts.join(" • ");

      return `
        <article class="talk-card">
          <p class="talk-year">${talk.badge}</p>
          <div class="talk-content">
            <div class="talk-top">
              <h3 class="talk-title"><a href="${talk.url}">${talk.title}</a></h3>
              <p class="talk-kind">${kind}</p>
            </div>
            <p class="talk-location">${location}</p>
            ${talk.citationHtml ? `<p class="talk-citation">${talk.citationHtml}</p>` : ""}
          </div>
        </article>
      `;
    })
    .join("");
}

function renderSoftware() {
  const container = document.getElementById("software-list");
  const software = siteData.software;
  if (!container || !Array.isArray(software)) return;

  container.innerHTML = software
    .map(
      (project) => `
        <li class="software-item">
          <h3 class="software-title">${project.title}</h3>
          <p class="software-role">${project.role}</p>
          <p class="software-description">${project.description}</p>
          <div class="software-links">
            ${project.links
              .map((link) => `<a href="${link.url}">${link.label}</a>`)
              .join("")}
          </div>
        </li>
      `
    )
    .join("");
}

renderStatement();
renderSimpleList("interests-list", siteData.interests);
renderSimpleList("students-list", siteData.studentsMentored);
renderPublicationGroups("publication-groups", siteData.publicationGroups);
renderSoftware();
renderTalks();
