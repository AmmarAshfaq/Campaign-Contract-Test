const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');


const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8');
// we only look here for contract properties not other
const output = solc.compile(source, 1).contracts;
console.log(output)
// create the folder if doesn't exist
fs.ensureDirSync(buildPath);

for (let contract in output) {
    // console.log(contract)
    // fs.outputJSONSync(
    //     path.resolve(buildPath,contract+'.json'),
    //     output[contract]
    // )
    fs.outputJSONSync(
        path.resolve(buildPath, contract.replace(':','') + '.json'),
        output[contract]
    )
}