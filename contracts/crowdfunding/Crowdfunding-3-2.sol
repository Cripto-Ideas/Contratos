// SPDX-License-Identifier: GPL-3.0
// ref: se tomo de base 1-Storage.sol (ej. de Remix)

pragma solidity >=0.7.0 <0.9.0;

contract Crowdfunding3 {

    // Etapa 3: Dirección de pago (ref:2_Owner.sol, ej Remix)
    address private owner;
    address payable private dirDePago;
        
    // Etapa 7: Eventos (owner, example)
    event OwnerSet(address indexed newOwner); // event for EVM logging
    // Etapa 7: Eventos de donacion y pago de fondos
    event DonacionDeFondos(address origen, string donante, uint monto);
    event PagoDeFondos(address beneficiario);

    //Etapa 8: Modificadores
    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    // Modificadores del estado del proyecto
    modifier enEstado(Estado _estado) {
        require(estado == _estado);
        _;
    }
        
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        dirDePago = payable(msg.sender);
        emit OwnerSet( owner);
    }
    
    // Etapa 1: Info del proyecto
    string private proyecto = "Indefinido";
    string private artista  = "Desconocido";       // nombre del artista o emprendedor
    uint private aRecaudar  = 3000000000000000000; // monto TOTAL a recaudar (3 eth por default)

    //Etapa 5: Estado
    enum Estado {
        Abierto,
        Supendido,
        Cerrado,
        Expirado
    }       
    Estado private estado = Estado.Abierto;


    // Etapa 6: Array de donaciones
    string[] private donantes;
    uint[] private donaciones;

    function setInfoProy(string memory nombre_proyecto, string memory nombre_artista, uint monto_a_recaudar) public isOwner {
        proyecto  = nombre_proyecto;
        artista   = nombre_artista;
        aRecaudar = monto_a_recaudar;
    }

    function getInfoProy() public view returns (string memory, string memory, uint, address, Estado){
        return (proyecto, artista, aRecaudar, dirDePago, estado);
    }

    // Etapa 2: Donacion
    address private origen; // direccion del ultimo donante
    string private donante; // nombre del ultimo donante/aportante/mecenas
    uint private monto;     // ultimo monto donado

    function donar(string memory nombre_donante) public payable enEstado(Estado.Abierto) {
        origen  = msg.sender;
        donante = nombre_donante;
        monto   = msg.value;

        // Etapa 6: Array de donaciones
        donantes.push(nombre_donante);
        donaciones.push(monto);
        
        emit DonacionDeFondos(origen, donante, monto);

        // Etapa 4: pagar al artista
        if (address(this).balance >= aRecaudar) {
            pagar();

        }
    }

    function getUltimaDonacion() public view returns (address, string memory, uint){
        return (origen, donante, monto);
    }

    function balance() public view returns (uint){
        return address(this).balance;
    }

    // Etapa 4: pagar al artista
    function pagar() private {
        dirDePago.transfer(address(this).balance);
        // habria que hacer otras cosas como emitir un evento y dejar el proyecto en estado cerrado.

        estado = Estado.Cerrado;        
        emit PagoDeFondos(dirDePago);
    }
    
    function getDonantes() public view returns (string[] memory){
        return donantes;
    }
    
    function getDonaciones() public view returns (uint[] memory){
        return donaciones;
    }

    
}