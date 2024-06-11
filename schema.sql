-- TRANSFERS
CREATE TABLE IF NOT EXISTS Transfers  (
    "id" String,
    address FixedString(40),
    `from` String,
    `to` String,
    value String,
    transaction String,
    block_number    UInt32(),
    timestamp       DateTime64(3, 'UTC'),
)
ENGINE = MergeTree PRIMARY KEY ("id")
ORDER BY (id,timestamp, block_number);

-- Indexes for block_number
ALTER TABLE Transfers ADD INDEX transfers_block_number_index block_number TYPE minmax;

-- MV for contract --
CREATE MATERIALIZED VIEW mv_transfers_contract
ENGINE = MergeTree()
ORDER BY (address, `from`,`to`)
POPULATE
AS SELECT * FROM Transfers;

-- MV for from --
CREATE MATERIALIZED VIEW mv_transfers_from
ENGINE = MergeTree()
ORDER BY (`from`, address)
POPULATE
AS SELECT * FROM Transfers;

-- MV for from --
CREATE MATERIALIZED VIEW mv_transfers_to
ENGINE = MergeTree()
ORDER BY (`to`, address)
POPULATE
AS SELECT * FROM Transfers;




-- BALANCE_CHANGES --
CREATE TABLE IF NOT EXISTS balance_changes  (
    "id"            String,
    block_num    UInt32(),
    timestamp       DateTime64(3, 'UTC'),
    contract        FixedString(40),
    owner           FixedString(40),
    amount          UInt256,
    old_balance     UInt256,
    new_balance     UInt256,
    transaction_id  FixedString(64),
    change_type     Int32
)
ENGINE = MergeTree PRIMARY KEY ("id")
ORDER BY (id,timestamp, block_num);

-- Indexes for block_number --
ALTER TABLE balance_changes ADD INDEX balance_changes_block_number_index block_num TYPE minmax;

-- MV for contract --
CREATE MATERIALIZED VIEW mv_balance_changes_contract
ENGINE = MergeTree()
ORDER BY (contract, owner)
POPULATE
AS SELECT * FROM balance_changes;

-- MV for owner --
CREATE MATERIALIZED VIEW mv_balance_changes_owner
ENGINE = MergeTree()
ORDER BY (owner, contract)
POPULATE
AS SELECT * FROM balance_changes;




-- SUPPLY --
CREATE TABLE IF NOT EXISTS TotalSupply  (
    address FixedString(40),
    supply UInt256,
    block_number    UInt32(),
    timestamp       DateTime64(3, 'UTC'),
    version         UInt32()
)
ENGINE = ReplacingMergeTree(version)
ORDER BY (address,supply);

-- Indexes for block_number and chain --
ALTER TABLE TotalSupply ADD INDEX TotalSupply_block_number_index block_number TYPE minmax;

-- MV for contract --
CREATE MATERIALIZED VIEW mv_TotalSupply_contract
ENGINE = MergeTree()
ORDER BY (address)
POPULATE
AS SELECT * FROM TotalSupply;




-- CONTRACTS --
CREATE TABLE IF NOT EXISTS Contracts  (
    address FixedString(40),
    name String,
    symbol String,
    decimals UInt64,
    block_number    UInt32(),
    timestamp       DateTime64(3, 'UTC'),
)
ENGINE = MergeTree PRIMARY KEY ("address")
ORDER BY (address, timestamp, block_number,);

-- Indexes for block_number and chain --
ALTER TABLE Contracts ADD INDEX Contracts_block_number_index block_number TYPE minmax;
