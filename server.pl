use AnyEvent::HTTPD;
 
my $httpd = AnyEvent::HTTPD->new (port => 9090);
 
$httpd->reg_cb (
   '/' => sub {
      my ($httpd, $req) = @_;
 
      $req->respond ({ content => ['text/html',
         "<html><body><h1>Hello World!</h1>"
         . "<a href=\"/test\">another test page</a>"
         . "</body></html>"
      ]});
   },
   '/test' => sub {
      my ($httpd, $req) = @_;
 
      $req->respond ({ content => ['text/html',
         "<html><body><h1>Test page</h1>"
         . "<a href=\"/\">Back to the main page</a>"
         . "</body></html>"
      ]});
   },
);
 
$httpd->run;

