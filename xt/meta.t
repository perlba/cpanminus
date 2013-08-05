use strict;
use Test::More;
use JSON;
use Config;
use xt::Run;

sub load_json {
    open my $in, "<", $_[0] or die "$_[0]: $!";
    JSON::decode_json(join "", <$in>);
}

my $local_lib = "$ENV{PERL_CPANM_HOME}/perl5";

{
    run_L "MIYAGAWA/Hash-MultiValue-0.10.tar.gz";

    my $dist = (last_build_log =~ /Configuring (Hash-\S+)/)[0];

    my $file = "$local_lib/lib/perl5/$Config{archname}/.meta/$dist/install.json";

    my $data = load_json $file;
    is $data->{name}, "Hash::MultiValue";
    is_deeply $data->{provides}{"Hash::MultiValue"}, { file => "lib/Hash/MultiValue.pm", version => "0.10" };
}

{
    run_L "MLEHMANN/common-sense-3.72.tar.gz";
    my $file = "$local_lib/lib/perl5/$Config{archname}/.meta/common-sense-3.72/install.json";

    my $data = load_json $file;
    is $data->{name}, "common::sense";
    is_deeply $data->{provides}{"common::sense"}, { file => "sense.pm.PL", version => "3.72" };
}

{
    run_L 'Module::CPANfile@0.9035';
    my $file = "$local_lib/lib/perl5/$Config{archname}/.meta/Module-CPANfile-0.9035/install.json";
    my $data = load_json $file;
    ok exists $data->{provides}{"Module::CPANfile"};
    ok !exists $data->{provides}{"xt::Utils"};
}

{
    run_L 'Text::Xslate@2.0009';
    my $file = "$local_lib/lib/perl5/$Config{archname}/.meta/Text-Xslate-2.0009/install.json";
    my $data = load_json $file;
    is $data->{provides}{"Text::Xslate"}{version}, '2.0009';
}

done_testing;

