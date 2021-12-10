// SPDX-License-Identifier: CC-BY-SA-4.0
// ref: Antonopoulus Faucet example

// Version del compilador Solidity para el que este programa fue escrito
pragma solidity ^0.6.4;

contract Owned {
    address payable owner;

    // Contract constructor: set owner
    constructor() public {
        owner = msg.sender;
    }

    event ChangeOwner(address indexed newOwner);
    event Destroy(address indexed owner);

    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Solo el propietario (owner) puede llamar esta funcion");
        _;
    }
 
    // Change owner
    function change(address newOwner) public onlyOwner {
        owner = payable(newOwner);
        emit ChangeOwner(msg.sender);
    }
     
    // Contract destructor
    function destroy() public onlyOwner {
        selfdestruct(owner);
        emit Destroy(msg.sender);
    }
}

contract SmartWallet is Owned {
    uint limitePublico = 0.1 ether;
    uint limitePropio  = 10 ether;
    uint limiteAuto    = 100 ether; // si el saldo supera este limite se transfiere todo al owner

    event Deposito(address indexed origen, uint cant);
    event Retiro(address indexed destino, uint cant);

    function config(uint _pub, uint _prop, uint _auto) public onlyOwner {
        limitePublico  = _pub;
        limitePropio   = _prop;
        limiteAuto     = _auto;
    }
    
    // Funcion STANDARD para aceptar cualquier deposito.
    receive() external payable {
        emit Deposito(msg.sender, msg.value);
    }

    // Funcion NO STANDARD para aceptar cualquier deposito.
    function depositar() external payable {
        emit Deposito(msg.sender, msg.value);
    }

    // Informa el balance del contrato (para acceso de debug)
    function balance() public view returns (uint){
        return address(this).balance;
    }

    // Le da Ether almacenado en el contrato a cualquiera que lo pida.
    function retirar(uint cant) public {

        // Controlar que este habiita el retiro publico (si el limite es mayor que cero).
        require(
            limitePublico > 0,
            "No se permiten retiros publicos"
        );

        // Limitar la cantidad de retiro publico.
        require(
            (cant <= limitePublico) || (msg.sender == owner), 
            "No se permiten retiros mayores al limite publico"
        );

        // Limitar la cantidad de retiro propio.
        require(
            cant <= limitePropio,
            "No se permiten retiros mayores al limite propio"
        );

        // Controlar que haya fondos (para clarificar el error).
        require(
            address(this).balance >= cant,
            "No hay suficientes fondos para un retiro de ese monto"
        );

        // Enviar la cantidad requerida a la direccion del solicitante.
        msg.sender.transfer(cant);

        emit Retiro(msg.sender, cant);
    }
}