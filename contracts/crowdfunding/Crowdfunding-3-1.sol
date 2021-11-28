// SPDX-License-Identifier: GPL-3.0
// ref: se tomo de base 1-Storage.sol (ej. de Remix)

pragma solidity >=0.7.0 <0.9.0;

contract Crowdfunding3 {

    string private proyecto;
    string private artista;
    uint private aRecaudar; // monto a recaudar

    function setInfoProy(string memory nombre_proyecto, string memory nombre_artista, uint monto_a_recaudar) public {
        proyecto = nombre_proyecto;
        artista  = nombre_artista;
        aRecaudar = monto_a_recaudar;
    }

    function getInfoProy() public view returns (string memory, string memory, uint){
        return (proyecto, artista, aRecaudar);
    }
}