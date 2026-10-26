# Ebraheem Farag Personal Website

Debraheem.github.io

The only editable master CV is `CV/Ebraheem_CV/eb_cv_current.tex`, with its
compiled PDF alongside it. Edit that source for future CV updates and use it as
the starting point for new applications. Existing application CVs are snapshots.

Publications, software, dated citation metrics, and talks share the existing
`data/site_cv.yaml` source with the website; the `generated_*.tex` lists are
regenerated from it. Software has its own section and does not contribute to
the first-author or peer-reviewed paper counts.

Paper-link preference: use a verified ADS abstract page for every paper,
including accepted papers indexed as preprints. Use arXiv only when no ADS
record is available; avoid publisher/IOP URLs as primary paper links. Keep DOIs
as source metadata when available. Apply this to both the website and CV.

Run `make update-cv` (or `make build`) to regenerate the lists, compile the CV,
update the website download `Ebraheem_Farag_CV.pdf`, and assemble `dist/`.
GitHub Pages builds from the same tracked CV source.

Keep private applications, drafts, and notes under `do_not_commit/`; that entire
directory is ignored by Git and is excluded from the assembled website. Local
notes can also use `local_notes/`, `.local-notes/`, `*.local.md`, `*.local.txt`,
or `*_worklog.md`; those patterns are ignored too. Local agent instructions,
agent state, editor backups, and LaTeX build artifacts are also ignored.
