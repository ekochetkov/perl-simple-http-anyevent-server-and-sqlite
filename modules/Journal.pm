package Journal; {
  use strict;
  use DBI;
  use JSON;
  use DB;
  
  sub addEvent {

      my ($body) = @_;
     
      my $params =  decode_json($body);

        my $sth = $DB::dbh->prepare("INSERT INTO journal (dt,perf_id,price,amount,client_id,number,order_id) VALUES (datetime('now'),?,?,?,?,?,?)");
        $sth->bind_param(1, $params->{  perf_id});
        $sth->bind_param(2, $params->{    price});
        $sth->bind_param(3, $params->{   amount});
        $sth->bind_param(4, $params->{client_id});
        $sth->bind_param(5, $params->{   number});
        $sth->bind_param(6, $params->{ order_id});
        $sth->execute();

        return '{"success":true}';
      }

  sub getAllasHTMLTable {

      my $sth = $DB::dbh->prepare("SELECT dt,perf_id,price,amount,client_id,number,order_id FROM journal");
      $sth->execute();

      my $html = '<table><tr>
        <td>dt</td>
        <td>perf_id</td>
        <td>price</td>
        <td>amount</td>
        <td>client_id</td>
        <td>number</td>
        <td>order_id</td>
      </tr>';

      my $row;
      while ($row = $sth->fetchrow_arrayref()) {
         $html .= "<tr>
          <td>@$row[0]</td>
          <td>@$row[1]</td>
          <td>@$row[2]</td>
          <td>@$row[3]</td>
          <td>@$row[4]</td>
          <td>@$row[5]</td>
          <td>@$row[6]</td>
        </tr>";
      }

      $html .= '</table>';

    return $html ;

  }

}
1;