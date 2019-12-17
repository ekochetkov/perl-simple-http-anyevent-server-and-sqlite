package DB; {
  use DBI;
  use Data::Dumper;

  sub init {

      my ($db) = @_;

      $dbh = DBI->connect(          
         "dbi:SQLite:dbname=$db", 
         "",                          
         "",                          
         { RaiseError => 1 },         
      ) or die $DBI::errstr;

  }

}
1;