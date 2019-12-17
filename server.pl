use AnyEvent::HTTPD;
use Data::Dumper;
use File::Slurp;

use lib 'modules';
use DB;
use Clients;
use Orders;
use Journal;


my $httpd = AnyEvent::HTTPD->new (port => 8080);

DB::init 'data.db';

sub Render {

   my ($view, $content) = @_;

   my $layout = read_file($view);

   $layout =~ s/_content/$content/; 

   if( $view eq 'views/layout.html'){
      return $layout;
   }

   return Render('views/layout.html', $layout);

}

$httpd->reg_cb (

   '/' => sub {
      
      my ($httpd, $req) = @_;

      my $content = Render('views/_main.html',  '');

      $req->respond({ content => [ 'text/html', $content]});

      $httpd->stop_request;
   },

   '/clients' => sub { 
      my ($httpd, $req) = @_;

      my $data    = Clients::getAllasHTMLTable();
      my $content = Render('views/_clients.html',  $data);

      $req->respond ({ content => [ 'text/html', $content ]});
      $httpd->stop_request;
   },

   '/orders' => sub { 
      my ($httpd, $req) = @_;

      my $data    = Orders::getAllasHTMLTable();
      my $content = Render('views/_orders.html',  $data);
      
      $req->respond ({ content => [ 'text/html', $content ]});
      $httpd->stop_request;
   },

   '/journal' => sub { 
      my ($httpd, $req) = @_;
      
      Journal::addEvent $req->content;

      $req->respond ({ content => [ 'application/json', '{"success":true}' ]});
      $httpd->stop_request;
   },

   '/journals' => sub { 
      my ($httpd, $req) = @_;

      my $data    = Journal::getAllasHTMLTable();
      my $content = Render('views/_journal.html',  $data);
      
      $req->respond ({ content => [ 'text/html', $content ]});
      $httpd->stop_request;
   },

   request => sub {

      my ($httpd, $req) = @_;

      my $url = $req->url;

      print 'Req.url ' . $req->url . "\n";
 
      if (($req->method eq 'POST') && ($url->path =~ /orders\/(\d+)$/)) {
         $req->respond ({ content => [ 'application/json', Orders::addOrder($1, $req->content) ]});
         $httpd->stop_request;
      }      
   }
);
 
$httpd->run;
