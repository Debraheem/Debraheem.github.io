# Ebraheem Farag Personal Website

Static personal website and CV build for GitHub Pages.

## Local update workflow

1. Edit shared content in [`data/site_cv.yaml`](./data/site_cv.yaml).
2. Run:

```bash
make
```

This regenerates the website data, recompiles the CV, refreshes `Ebraheem_Farag_CV.pdf`, and builds a deployable `dist/` folder.

## GitHub Pages deployment

This repo includes a GitHub Actions workflow at [`.github/workflows/pages.yml`](./.github/workflows/pages.yml).

After pushing to GitHub:

1. Create a new GitHub repository.
2. Add it as the remote:

```bash
git remote add origin <your-github-repo-url>
```

3. Push the `main` branch:

```bash
git push -u origin main
```

4. In the GitHub repository settings, enable Pages and set the source to `GitHub Actions`.

Each push to `main` will rebuild the CV and deploy the website.
