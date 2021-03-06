# How to install R Suite

R Suite is an R package so it is platform independent. We **strongly
recommend** using R Suite CLI to install R Suite package. But there
are other options that could fit your needs better.

## **Got stuck?**

If you are stuck feel free to contact us:

* through R Suite website (https://rsuite.io#contact) or 
* using Gitter [R Suite room](https://gitter.im/WLOGSolutions/RSuite "R Suite room")
* directly by sending an email with your problem description to [rsuite@wlogsolutions.com](mailto:rsuite@wlogsolutions.com).

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->

## **Table of Contents** ##

- [Requirements](#requirements)
- [Installation with help of R Suite CLI [Recommended]](#installation-with-help-of-r-suite-cli-recommended)
- [Basic installation](#basic-installation)
- [Development version installation](#development-version-installation)
- [Updating R Suite](#updating-r-suite)

<!-- markdown-toc end -->


# Requirements

R Suite depends on number of other R packages. On Linux systems they require
libxml2-devel, libssl-devel, libcurl-devel and zlib-devel system packages.

On RedHat like systems (RedHat/Fedora/CentOS) you can install them 
with following command:

```bash
$ sudo yum install -y openssl-devel libxml2-devel libcurl-devel zlib-devel
```

On Debian like systems (Debian/Ubuntu) you can install them executing:

```bash
$ sudo apt-get install -y libssl-dev libxml2-dev libcurl4-openssl-dev zlib1g-dev
```

**Important:** If you are installing using R Suite CLI (see below) the
required dependencies are installed automatically.

On Windows it is necessary to have Rtools installed. Rtools contains number of utilities for building R packages 
(e.g. zip - required to build binary packages on windows).

# Installation with help of R Suite CLI [Recommended]

![Installing R Suite with R Suite CLI](https://github.com/WLOGSolutions/RSuite/blob/master/docs/media/rsuite_install_with_cli.png "Installing R Suite with R Suite CLI")

If you have R Suite CLI installed (check [R Suite CLI installation
reference](https://rsuite.io/RSuite_Tutorial.php?article=rsuite_cli_installation.md
"R Suite CLI installation reference.")) already you can use it to
install latest compatible version of R Suite. Just execute the following
command in your shell:

```bash
$ rsuite install
```

If any problems occur try to run this command in verbose mode. It will probably
give you hints on why the problem occurred:

```bash
$ rsuite install -v
```

# Basic installation

You can simply install R Suite in your R environment from [CRAN](https://cran.r-project.org/package=RSuite)
executing the following command:

```bash
> install.packages('RSuite')
```

It will install the latest released version of R Suite in the first folder mentioned in 
.libPaths() which is usually your user R packages folder.

# Development version installation

R Suite sources are publicly available. You can install the development version of 
R Suite from GitHub by executing the following code in your R environment:

```bash
> devtools::install_github('WLOGSolutions/RSuite/packages/RSuite')
```

# Updating R Suite

You can check which version of R Suite is currently installed in your R environment
with the following code:

```bash
> packageVersion("RSuite")
```

You can check what is the latest released version of R Suite using the following code:

```bash
> RSuite::rsuite_check_version()
```

You can upgrade R Suite any time by executing the following code:

```bash
> RSuite::rsuite_update()
```

It will check if the currently installed version of R Suite is up to date and if it's
not, the latest released version will be installed from the WLOG repository.

**ATTENTION:** R Suite CLI requires compatible version of R Suite to work properly.
Version of R Suite and R Suite CLI has form \<Maj\>.\<Min\>-\<Rel\>. Compatibility is 
detected comparing if \<Maj\>.\<Min\> matches for R Suite and R Suite CLI. Then upgrading
to the latest released version of R Suite compatibility with R Suite CLI can be broken.
In that case you will need to upgrade R Suite CLI also.
