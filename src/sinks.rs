use substreams::errors::Error;
use substreams_database_change::pb::database::DatabaseChanges;


#[substreams::handlers::map]
fn db_out(transfers: DatabaseChanges,supply: DatabaseChanges,contracts: DatabaseChanges,balances: DatabaseChanges) -> Result<DatabaseChanges, Error> {

    let mut array = transfers.clone();
    array.table_changes.extend(supply.table_changes);
    array.table_changes.extend(contracts.table_changes);
    array.table_changes.extend(balances.table_changes);

    Ok(array)
}


