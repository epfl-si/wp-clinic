# WP-Clinic

<p align="center">
  <img src="./ChatGPT-Image-2026-04-16.png" width="300px" alt="WP-Clinic logo generated with ChatGPT" />
</p>
<!--
Create a minimalistic logo for a project called WP-Clinic. It should have an
hospital building with the OwrdPress logo on it, and some doctors walking in the
front in while blouses.
https://chatgpt.com/s/m_69e087b1c23c8191b235840dbcd6ae84
-->

## About

This is a dedicated pod that can be used to route an EPFL WordPress site on it
for debugging purposes. It includes SRE tools and makes the content writable,
allowing the use `error_log` and `var_dump`.

> [!IMPORTANT]  
> This repository should not be used on its own. Instead, clone the [wp-dev] repository and run `make wp-clinic`.

## Usage

This "pod" should be deployed as code. Once you have the EPFL WordPress
development kit ready (i.e. the [wp-dev] repository that have cloned [wp-ops]
and everything), you can run
```sh
wpsible -t wp.clinic
```
Tags such as `wp.clinic.rebuild` and `wp.clinic.restart` can be handy.

> [!NOTE]  
> Be sure to have a (OpenShift) route ready. This can be done as code with
> the [wpsible] extra-vars:  
> `-e "wp_clinic_url=https://wpn-test.epfl.ch/somesite"`.

## Tooling

The [Dockerfile](./Dockerfile) provides a set of tools useful for diagnosing and
analyzing issues within the pod and the underlying infrastructure. It includes
standard utilities such as [bash], [curl], [jq], and [vim].

In addition, [arnaud-lb/php-memory-profiler] is installed with [PIE] (The PHP
Installer for Extensions).


[--links--]: #
[wp-dev]: https://github.com/epfl-si/wp-dev
[wp-ops]: https://github.com/epfl-si/wp-ops
[wpsible]: https://github.com/epfl-si/wp-ops/blob/master/ansible/wpsible
[bash]: https://www.gnu.org/software/bash/manual/bash.html
[curl]: https://curl.se/
[jq]: https://jqlang.org/
[vim]: https://www.vim.org/
[arnaud-lb/php-memory-profiler]: https://github.com/arnaud-lb/php-memory-profiler
[PIE]: https://github.com/php/pie
