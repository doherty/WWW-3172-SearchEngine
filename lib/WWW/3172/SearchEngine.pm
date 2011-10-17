package WWW::3172::SearchEngine;
use strict;
use warnings;
use Dancer ':syntax';
use Dancer::Plugin::Database;
# ABSTRACT: An interface to a search engine index of pages crawled by WWW::3172::Crawler
# VERSION

use WWW::Form;
use HTML::Entities qw(encode_entities);
use List::MoreUtils qw(uniq);
use Lingua::Stem::Snowball;
use Lingua::StopWords qw(getStopWords);
use Text::Unidecode qw(unidecode);

my $stopwords = getStopWords('en');
my $stemmer   = Lingua::Stem::Snowball->new(
    lang    => 'en',
    encoding=> 'UTF-8',
);

get '/' => sub {
    my $form = WWW::Form->new(
        { 'q' => { label => 'Search query', type => 'text' } },
        { 'q' => '' },
        ['q']
    );

    template 'index', {
        form => $form->getFormHTML(
            action  => '/s',
            name    => 'search-form',
            submit_label => 'Search',
        ),
    };
};

any ['get', 'post'] => '/s' => sub {
    my $query = params->{q};

    my @words;
    {
        my $punct = quotemeta q{.,[]()<>{}+-=_'"\|};
        my @split = map {
            s{\A[$punct]}{};
            s{[$punct]\Z}{};

            length($_) < 2 || exists $stopwords->{$_}
                ? ()
                : unidecode($_)
        } split /\s+/, $query;
        @words = $stemmer->stem([uniq @split]);
    }
    redirect '/' unless @words;

    my $sql = sprintf(<<'SQL', (('?,' x (scalar(@words) - 1)) . '?' ) );
SELECT url_str FROM url WHERE url_id in (
    SELECT url_id FROM url_words WHERE word_id in (
        SELECT word_id FROM words WHERE word_str in (%s)
    )
)
SQL

    my $sth = database->prepare($sql);
    $sth->execute(@words);

    my @urls;
    while (my $data = $sth->fetchrow_hashref) {
        push @urls, $data->{url_str};
    }

    return template 'results', {
        results => '<p>No results were found for <strong>' . encode_entities($query) . '</strong></p>'
    } unless @urls;

    my $html = '<ul>';
    foreach my $url (@urls) {
        my $safe_url = encode_entities($url);
        $html .= "<li><a href='$safe_url'>$safe_url</a></li>\n";
    }
    $html .= '</ul>';

    template 'results', { results => $html };
};

true;

