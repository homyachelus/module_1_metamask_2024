import hre from "hardhat";

async function main() {
    const {ethers} = hre;

    const contract1 = await ethers.getContractFactory("Token");
    const contract2 = await ethers.getContractFactory("NFT");

    // деплоим токены профи
    const profi = await contract1.deploy();
    // деплоим контаркт нфт
    const nft = await contract2.deploy("http://127.0.0.1:8545", profi.getAddress());

    // создаем первый одиночный нфт
    await nft.create_single_nft(
        1,
        true,
        "Герда в профиль",
        "Скучающая хаски по имени Герда",
        "husky_nft1.png",
        2000,
        7,
        7,
        Math.floor(Date.now() / 1000)
    )
    console.log(await nft.single_nft(1));

    // создаем второй одиночный нфт
    await nft.create_single_nft(
        2,
        true,
        "Герда на фрилансе",
        "Герда релизнула новый проект",
        "husky_nft2.png",
        5000,
        5,
        5,
        Math.floor(Date.now() / 1000)
    )
    console.log(await nft.single_nft(2));

    // создаем третий одиночный нфт
    await nft.create_single_nft(
        3,
        true,
        "Новогодняя Герда",
        "Герда ждет боя курантов",
        "husky_nft3.png",
        3500,
        2,
        2,
        Math.floor(Date.now() / 1000)
    )
    console.log(await nft.single_nft(3));

    // создаем четвертый одиночный нфт
    await nft.create_single_nft(
        4,
        true,
        "Герда в отпуске",
        "Приехала отдохнуть после тяжелого проекта",
        "husky_nft4.png",
        4000,
        6,
        6,
        Math.floor(Date.now() / 1000)
    )
    console.log(await nft.single_nft(4));


    // первая коллекция

    // создаем нфт для первой коллекции:
    await nft.create_single_nft(
        5,
        true,
        "Комочек",
        "Комочек слился с космосом",
        "cat_nft1.png",
        1000,
        1,
        1,
        Math.floor(Date.now() / 1000)
    )

    await nft.create_single_nft(
        6,
        true,
        "Вкусняшка",
        "Вкусняшка впервые пробует японскую кухню",
        "cat_nft2.png",
        1000,
        1,
        1,
        Math.floor(Date.now() / 1000)
    )

    await nft.create_single_nft(
        7,
        true,
        "Пузырик",
        "Пузырик похитил котика с Земли",
        "cat_nft3.png",
        1000,
        1,
        1,
        Math.floor(Date.now() / 1000)
    )

    // создаем коллекцию
    await nft.create_collection_nft(
        1,
        "Космические котики",
        "Они путешествуют по вселенной",
        [5,6,7]
    )
    console.log(await nft.collection_nft(1));
    console.log(await nft.getCollectionNfts(1));

    // вторая коллекция

    // создаем нфт для второй коллекции:
    await nft.create_single_nft(
        8,
        true,
        "Баскетболист",
        "Он идет играть в баскетбол",
        "walker_nft1.png",
        1000,
        1,
        1,
        Math.floor(Date.now() / 1000)
    )

    await nft.create_single_nft(
        9,
        true,
        "Волшебник",
        "Он идет колдовать",
        "walker_nft2.png",
        1000,
        1,
        1,
        Math.floor(Date.now() / 1000)
    )

    // создаем коллекцию
    await nft.create_collection_nft(
        2,
        "Пешеходы",
        "Куда они идут?",
        [8,9]
    )
    console.log(await nft.collection_nft(2));
    console.log(await nft.getCollectionNfts(2));
}

main().catch((error) => {
    console.log(error);
    process.exit(1);
});