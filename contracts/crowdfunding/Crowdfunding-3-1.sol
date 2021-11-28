// SPDX-License-Identifier: GPL-3.0
// ref: se tomo de base 1-Storage.sol (ej. de Remix)

pragma solidity >=0.7.0 <0.9.0;

contract Crowdfunding3 {

    // Etapa 1: Info del proyecto
    string private proyecto;
    string private artista;  // nombre del artista o emprendedor
    uint private aRecaudar;  // monto TOTAL a recaudar

    function setInfoProy(string memory nombre_proyecto, string memory nombre_artista, uint monto_a_recaudar) public {
        proyecto  = nombre_proyecto;
        artista   = nombre_artista;
        aRecaudar = monto_a_recaudar;
    }

    function getInfoProy() public view returns (string memory, string memory, uint){
        return (proyecto, artista, aRecaudar);
    }

    // Etapa 2: Donacion
    address private origen; // direccion del ultimo donante
    string private donante; // nombre del ultimo donante/aportante/mecenas
    uint private monto;     // ultimo monto donado

    function donar(string memory nombre_donante) public payable {
        origen  = msg.sender;
        donante = nombre_donante;
        monto   = msg.value;
    }

    function getUltimaDonacion() public view returns (address, string memory, uint){
        return (origen, donante, monto);
    }

    function balance() public view returns (uint){
        return address(this).balance;
    }

    
    
}