package Orders; {
  use DBI;
  use JSON;
  use Data::Dumper;
  use AnyEvent::HTTP;
  use DB;

  sub addOrder {

      my ($number,$body) = @_;
     
      my $params =  decode_json($body);

      my $sth = $DB::dbh->prepare("SELECT client_id FROM clients WHERE name = ?");
      $sth->bind_param(1, $params->{name});
      $sth->execute();  

      my $row = $sth->fetchrow_arrayref();

      if( $row ){
        $params->{client_id} = @$row[0];
        $params->{   number} = $number;

        my $sth = $DB::dbh->prepare("INSERT INTO orders (perf_id,price,amount,client_id,number) VALUES (?,?,?,?,?)");
        $sth->bind_param(1, $params->{  perf_id});
        $sth->bind_param(2, $params->{    price});
        $sth->bind_param(3, $params->{   amount});
        $sth->bind_param(4, $params->{client_id});
        $sth->bind_param(5, $params->{   number});
        $sth->execute();  

        $params->{order_id} = $DB::dbh->sqlite_last_insert_rowid;

        my $params_s = encode_json($params);

        http_post 'http://localhost:8080/journal', $params_s, sub {};

        return '{"success":true}';
      } else {
        return '{"success":false,"message":"No client found!"}';
      }
  }

  sub getAllasHTMLTable {

      my $sth = $DB::dbh->prepare("SELECT perf_id,price,amount,client_id,number FROM orders");
      $sth->execute();

      my $html = '<table><tr>
        <td>perf_id</td>
        <td>price</td>
        <td>amount</td>
        <td>client_id</td>
        <td>number</td>
      </tr>';

      my $row;
      while ($row = $sth->fetchrow_arrayref()) {
         $html .= "<tr>
          <td>@$row[0]</td>
          <td>@$row[1]</td>
          <td>@$row[2]</td>
          <td>@$row[3]</td>
          <td>@$row[4]</td>
        </tr>";
      }

      $html .= '</table>';

    return $html ;

  }

}
1;