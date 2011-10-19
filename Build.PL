
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Dancer::Test" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "An interface to a search engine index of pages crawled by WWW::3172::Crawler",
  "dist_author" => [
    "Mike Doherty <doherty\@cpan.org>"
  ],
  "dist_name" => "WWW-3172-SearchEngine",
  "dist_version" => "0.001",
  "license" => "perl",
  "module_name" => "WWW::3172::SearchEngine",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Dancer" => 0,
    "Dancer::Plugin::Database" => 0,
    "HTML::Entities" => 0,
    "Lingua::Stem::Snowball" => 0,
    "Lingua::StopWords" => 0,
    "List::MoreUtils" => 0,
    "Text::Unidecode" => 0,
    "WWW::Form" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [
    "bin/app.pl"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
