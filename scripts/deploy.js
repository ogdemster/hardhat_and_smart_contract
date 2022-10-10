const { eth } = require("hardhat");
require("dotenv").config({ path: ".env" });

async function main() {
  //getContractFactory ile contractımızı değişkene atıyoruz.
  const myNftContract = await ethers.getContractFactory("MyNftContract");

  // deploy the myNftContract
  const dmyNftContract = await myNftContract.deploy(
    "ipfs//QmYY6urunuftAikZqaAir6xGFhQV1WcRZonKH8p6G6D2iS/"
  );

  //wait for dmyNftContract deployed
  await dmyNftContract.deployed();

  // show contract address
  console.log("Contract address is:", dmyNftContract.address);

  console.log("Wait for verify");
  await waitForVerify(100000);

  await hre.run("verify:verify", {
    address: dmyNftContract.address,
    constructorArguments: [
      "ipfs//QmYY6urunuftAikZqaAir6xGFhQV1WcRZonKH8p6G6D2iS/",
    ],
  });
}

function waitForVerify(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
