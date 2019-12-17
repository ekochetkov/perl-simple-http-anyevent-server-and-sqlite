package Clients; {
  use strict;
  use DBI;
  use DB;
  
  sub getAllasHTMLTable {

      my $sth = $DB::dbh->prepare("SELECT * FROM clients");
      $sth->execute();

      my $html = '<table><tr><td>ID</td><td>Name</td></tr>';

      my $row;
      while ($row = $sth->fetchrow_arrayref()) {
         $html .= "<tr><td>@$row[0]</td><td>@$row[1]</td></tr>";
      }

      $html .= '</table>';

    return $html ;

  }

}
1;