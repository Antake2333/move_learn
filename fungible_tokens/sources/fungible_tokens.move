module fungible_tokens::managed{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // witness
    struct MANAGED has drop {}

    // 初始化函数只执行一次
    fun init(witness: MANAGED, ctx: &mut TxContext){
        let (treasury_cap, metadata) = coin::create_currency<MANAGED>(witness, 2, b"ORCAS", b"OCS", b"", option::none(), ctx);
        // 冻结Metadata
        transfer::public_freeze_object(metadata);
        // 转移所有权到部署人身上
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    // mint方法,必须要treasury_cap才行
    public fun mint(
        treasury_cap: &mut TreasuryCap<MANAGED>, amount: u64, recipient: address, ctx: &mut TxContext
    ) {
        coin::mint_and_transfer(treasury_cap, amount, recipient, ctx)
    }

    public fun burn(treasury_cap: &mut TreasuryCap<MANAGED>, coin: Coin<MANAGED>) {
        coin::burn(treasury_cap, coin);
    }


    #[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(MANAGED {}, ctx)
    }
}