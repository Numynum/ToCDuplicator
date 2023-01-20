### This github action is now archived, since its functionality has been integrated into the BigWigs packager.

# duplicateToc.sh

__duplicateToc.sh__ will create .toc files specific to each wow version.
See https://github.com/Stanzilla/WoWUIBugs/issues/68#issuecomment-830351390 for more information

The best way to use this, is as part of your addon builds, between checkout and using a packager (e.g. bigwigs packager)

Example usage:

    steps:
      - uses: actions/checkout@v2

      - name: Replace toc-versions
        uses: Numynum/ToCVersions@master

      - name: Create Version specific ToC files
        uses: Numynum/ToCDuplicator@master

      - name: Create Retail Package
        uses: BigWigsMods/packager@master

An example .toc file could be:

    ## Interface: 1234 # if hardcoded
    ## Interface-Retail: @toc-version-retail@ # if using ToCVersions action
    ## Interface-Classic: @toc-version-classic@
    ## Interface-BCC: @toc-version-bcc@
    ## Title: MyEpicAddon
    ## Notes: Making addons great again!
    ## Author: EpicAddonWriter2000
    ## Version: @project-version@

After each file is created, the `## Interface-XX` line for that file will __NOT__ be removed from the source .toc file, until packagers support it properly.

## Version arguments

By default, this script will attempt to create a file for each version (retail|bcc|classic).
This can be explicitly disabled by passing `0` or `false`, as in the example below.

Leaving out these arguments is the same as passing `true`.

    - name: Create Retail and Classic ToC files
      uses: Numynum/ToCDuplicator@master
      with:
          retail: true
          bcc: false
          classic: true

## Files argument

By default, this script will parse all .toc files in your root directory.
If this isn't enough, you can instead pass a list of files to replace.
Version specific files are never used as a source, but WILL be overwritten if configured.

      - name: Replace toc-versions
        uses: Numynum/ToCVersions@master
        with:
          files: path/to/module/*.toc *.toc
