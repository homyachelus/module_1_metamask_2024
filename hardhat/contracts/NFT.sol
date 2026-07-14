// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";     // право на использование ERC1155
import "./Token.sol";

contract NFT is ERC1155 {

    address owner;                  // владелец контракта
    uint256 start_system;           // время старта системы
    Token public profi;             // токен профи

    // передача параметров
    constructor (string memory uri, address token) ERC1155(uri) {
        owner = msg.sender;                                     // обозначение владельца
        start_system = block.timestamp;                         // обозначение времени запуска системы
        profi = Token(token);
    }



    // структура одиночных nft 
    struct single_nft_struct {
        bool status;            // статус продажи продан/не продан
        address _owner;         // владелец нфт
        string name;            // название
        string description;     // описание
        string image;           // картинка
        uint256 price;          // цена
        uint256 released;       // количество выпущенных нфт
        uint256 available;      // количество продающихся нфт
        uint256 date;           // дата создания нфт
    }

    // хранение одиночных нфт
    mapping (uint256 => single_nft_struct) public single_nft;

    // функция создания одиночных нфт
    function create_single_nft(
        uint256 single_id, 
        bool _status,
        string memory _name,
        string memory _description,
        string memory _image,
        uint256 _price,
        uint256 _released,
        uint256 _available,
        uint256 _date) public{

        require(msg.sender == owner, unicode"создать одиночный нфт может только владелец");
        
        single_nft[single_id] = single_nft_struct({
            status: _status,
            _owner: msg.sender,
            name: _name,
            description: _description,
            image: _image,
            price: _price,
            released: _released,
            available: _available,
            date: _date
        });

        _mint(owner, single_id, _released, "");
    }

    //купить нфт
    function pay_single_nft(address seller, uint256 id_nft, uint256 amount) public {
        single_nft_struct storage nft = single_nft[id_nft];

        require(amount <= nft.available, unicode"нет столько нфт в продаже");
        require((nft.price * amount) <= profi.balanceOf(msg.sender), unicode"недостаточно средств для покупки");

        uint256 total_price = nft.price * amount;
        if (user_discount[msg.sender] > 0) {
            total_price = (total_price * (100 - user_discount[msg.sender])) / 100;
        }

        profi.transferFrom(msg.sender, seller, total_price);            // функция из erc20
        safeTransferFrom(seller, msg.sender, id_nft, amount,'');        // функция из erc1155
        nft.available -= amount;
    }

    // выставить на продажу/убрать с продажи
    function put_sale(uint256 id_nft) public {
        single_nft_struct storage nft = single_nft[id_nft];
        
        if(nft.status == true) nft.status = false;
        else {
            require(bytes(collection_nft[id_nft].name).length == 0, unicode"нфт есть в коллекции");
            nft.status = true;
        }
    }

    // изменить цену нфт
    function change_price(uint256 _price, uint256 id_nft) public {
        single_nft_struct storage nft = single_nft[id_nft];
        nft.price = _price;
    }

    // передать безвозмездно нфт
    function nft_transfer_free(uint256 id_nft, address to, uint256 amount) public {
        single_nft_struct storage nft = single_nft[id_nft];
        _safeTransferFrom(msg.sender, to, id_nft, amount, '');
        nft._owner = to;
    }
    


    // структура коллекций nft 
    struct collection_nft_struct {
        string name;                    // название
        string description;             // описание
        uint256[] nft_id;               // айди нфт входящих в коллекцию
    }

    // хранение коллекций нфт
    mapping (uint256 => collection_nft_struct) public collection_nft;

    // создание коллекций нфт
    function create_collection_nft(
        uint256 collection_id,
        string memory _name,
        string memory _description,
        uint256[] memory _nft_id) public {

        require(msg.sender == owner, unicode"создать коллекцию нфт может только владелец");
        
        collection_nft[collection_id] = collection_nft_struct({
            name: _name,
            description: _description,
            nft_id: _nft_id
        });
    }

    function getCollectionNfts(uint256 _collectionId) public view returns (uint256[] memory) {
        return collection_nft[_collectionId].nft_id;
    }



    // структура аукциона
    struct auction_struct {
        uint256 start_auc;                  // стартовое время
        uint256 stop_auc;                   // время окончания
        uint256 start_price;                // начальная цена
        uint256 max_price;                  // максимальная ставка
        uint256 id_collection;              // айди коллекции
        address top_bidder;                 // пользователь кто поставил большую ставку
    }

    // хранение аукционов
    mapping (uint256 => auction_struct) public auction;

    // функция запуска аукциона
    function start_auction(
        uint256 _id_collection, 
        uint256 id_auction, 
        uint256 start_auc_minutes, 
        uint256 stop_auc_minutes, 
        uint256 _start_price, 
        uint256 _max_price) public {
            
        require(msg.sender == owner, unicode"начать аукцион может только владелец");
        require(bytes(collection_nft[_id_collection].name).length > 0, unicode"такой коллекции не существует");
        
        uint256 _start_auc = (start_auc_minutes * 60) + start_system;
        uint256 _stop_auc = (stop_auc_minutes * 60) + start_system;

        auction[id_auction] = auction_struct({
            start_auc: _start_auc, 
            stop_auc: _stop_auc, 
            start_price: _start_price, 
            max_price: _max_price,
            id_collection: _id_collection,
            top_bidder: address(0)
        });
    }

    // хранение ставок пользователей
    mapping (address => uint256) public bids;

    // сделать и увеличить ставку
    function do_bid(uint256 amount, uint256 id_collection) public{
        auction_struct storage auct = auction[id_collection];

        require(profi.balanceOf(msg.sender) >= amount, unicode"недостаточно средств для ставки");
        require(amount >= auct.start_price, unicode"ставка меньше цены");

        if (bids[msg.sender] == 0) {
            if (amount > auct.max_price) {
                profi.transferFrom(msg.sender, owner, auct.max_price);

                //передача прав пользователю на нфт
                uint256 id_col = auct.id_collection;
                collection_nft_struct storage col = collection_nft[id_col];

                for (uint256 i=0; i < col.nft_id.length; i++) {
                    uint256 id_nft = col.nft_id[i];
                    single_nft_struct storage nft = single_nft[id_nft];
                    _safeTransferFrom(owner, msg.sender, id_nft, 1, ""); 
                    nft._owner = msg.sender;
                }

                auct.stop_auc = block.timestamp;
            }
            else {
                profi.transferFrom(msg.sender, owner, amount);
                bids[msg.sender] += amount;
            }   
        }
        else {
            if (amount > auct.max_price) {
                profi.transferFrom(msg.sender, owner, auct.max_price - bids[msg.sender]);

                //передача прав пользователю на нфт
                uint256 id_col = auct.id_collection;
                collection_nft_struct storage col = collection_nft[id_col];

                for (uint256 i=0; i < col.nft_id.length; i++) {
                    uint256 id_nft = col.nft_id[i];
                    single_nft_struct storage nft = single_nft[id_nft];
                    _safeTransferFrom(owner, msg.sender, id_nft, 1, ""); 
                    nft._owner = msg.sender;
                }
                auct.stop_auc = block.timestamp;
            }
            else {
                profi.transferFrom(msg.sender, owner, amount);
                bids[msg.sender] += amount;
            } 
        }
        auct.start_price += amount;
        auct.top_bidder = msg.sender;
    }

    // закончить аукцион
    function stop_auct(uint256 id_collection) public {
        auction_struct storage auct = auction[id_collection];
        uint256 id_col = auct.id_collection;
        collection_nft_struct storage col = collection_nft[id_col];

        for (uint256 i=0; i < col.nft_id.length; i++) {
            uint256 id_nft = col.nft_id[i];
            single_nft_struct storage nft = single_nft[id_nft];
            _safeTransferFrom(owner, auct.top_bidder, id_nft, 1, ""); 
            nft._owner = auct.top_bidder;
        }
        auct.stop_auc = block.timestamp;
    }



    // хранение реферальных кодов пользователей
    mapping (string => address) public referal_code;
    // хранение пользователей вводивших скидку
    mapping (address => bool) public enter_code;
    // хранение процентов скидки у пользователей
    mapping (address => uint256) public user_discount;

    // функция добавления кода
    function add_ref_code(string memory code) public {
        referal_code[code] = msg.sender;
    }

    // функция ввода кода
    function enter_ref_code(string memory code) public {
        address code_owner = referal_code[code];
        require(code_owner != msg.sender, unicode"нельзя вводить свой код");
        require(enter_code[msg.sender] == false, unicode"вы уже вводили код");
        require(referal_code[code] != address(0), unicode"такого кода не существует");

        profi.transferFrom(owner, msg.sender, 100 * 10**6);
        if (user_discount[code_owner] < 3) user_discount[code_owner]++;

        enter_code[msg.sender] = true;
    }
}