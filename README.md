# Israel Campiotti — Portfolio

Personal portfolio site built with [Jekyll](https://jekyllrb.com/) and the [Minima](https://github.com/jekyll/minima) theme. It is published as a [GitHub Pages](https://pages.github.com/) user site at [israelcamp.github.io](https://israelcamp.github.io).

## Prerequisites

- [Ruby](https://www.ruby-lang.org/) (3.x recommended)
- [Bundler](https://bundler.io/) (`gem install bundler`)

## Run locally

Clone the repository and install dependencies:

```bash
git clone git@github.com:israelcamp/israelcamp.github.io.git
cd israelcamp.github.io
bundle install
```

Start the development server:

```bash
bundle exec jekyll serve --trace
```

The site is served at [http://localhost:4000](http://localhost:4000). Jekyll watches for file changes and rebuilds automatically.

To stop the server, press `Ctrl+C`.

### Useful flags

| Flag | Description |
|------|-------------|
| `--livereload` | Reload the browser when files change |
| `--draft` | Include posts with `published: false` |
| `--future` | Include posts dated in the future |

### Troubleshooting

- **Config changes ignored** — `_config.yml` is only read at startup. Restart the server after editing it.
- **Dependency issues** — Run `bundle install` again after pulling changes that update `Gemfile` or `Gemfile.lock`.
- **Port already in use** — Use a different port: `bundle exec jekyll serve --port 4001`

## Project structure

Content is organized as Jekyll collections and standard posts:

| Path | Description |
|------|-------------|
| `_experiences/` | Work experience entries |
| `_papers/` | Publications |
| `_projects/` | Side projects |
| `_awards/` | Awards and recognitions |
| `_posts/` | Blog posts |
| `_layouts/`, `_includes/` | HTML templates and partials |
| `_plugins/` | Custom Jekyll plugins (e.g. `wrapText` Liquid filter) |
| `assets/` | CSS and static assets |
| `_config.yml` | Site settings, collections, and plugins |

To add content, create a new Markdown file in the relevant collection folder with YAML front matter (see existing files for examples).

## Deploy

This repo is the GitHub Pages source for `israelcamp.github.io`. Deployment is automatic:

1. Commit your changes on the `main` branch.
2. Push to `origin`:

   ```bash
   git push origin main
   ```

3. GitHub builds and publishes the site. Changes are usually live within a few minutes at [https://israelcamp.github.io](https://israelcamp.github.io).

You can check build status under **Settings → Pages** in the GitHub repository.

### Preview before pushing (optional)

Build the static site locally without serving:

```bash
bundle exec jekyll build
```

Output is written to `_site/`. Open `_site/index.html` in a browser or serve the folder with any static file server to preview the production build.
