#!/usr/bin/perl

use CGI;
use Imager::QRCode;

my $q = CGI->new;
my $text = $q->param('text');
my $img = $q->param('img');
if ((defined $text) && (defined $img)) {
    my $qrcode = Imager::QRCode->new(
        size          => 18,
        margin        => 1,
        version       => 2,
        level         => 'H',
        casesensitive => 1,
        lightcolor    => Imager::Color->new(255, 255, 255),
        darkcolor     => Imager::Color->new(0, 0, 0),
    );
    my $img = $qrcode->plot($text);
    print $q->header('image/gif');
    $img->write(fh => \*STDOUT, type => 'gif')
        or die $img->errstr;
} else {
    print $q->header('text/html');
    $text = '' if !defined $text;

    print <<END_HTML;
<!DOCTYPE html>
<meta charset="utf-8">
<title>QR</title>
<h1>QR</h1>
<form>
    <div>
        <label>
            QR:<textarea name="text" rows="10" cols="50">$text</textarea>
        </label>
        <input type="submit">
    </div>
</form>
END_HTML

  if ((defined $text) && (!defined $img)) {
    print "<br><hr>";
    my @lines = split (/\r/, $text);
    foreach my $line (@lines) {
      $line =~ s/\n//g;
      $line =~ s/\r//g;

      print "<br><br><h2>$line</h2><img src=\"index.cgi?text=$line&img=1\" width=\"100\" height=\"100\" alt=\"qr\">";
#    print `qrencode --level=H -t svg '$line'`;

      print "<hr>";
    }
  }
}
