// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BukuTamu {
    address public panitia;
    uint256 public jeda_waktu;

    struct Catatan {
        address pengirim;
        string pesan;
        uint256 waktu;
    }

    Catatan[] public daftar_hadir;
    mapping(address => uint256) public kunjungan_terakhir;

    event CatatanBaru(address indexed pengirim, string pesan, uint256 waktu);
    event JedaWaktuDiubah(uint256 durasiBaru);

    constructor(uint256 _jedaWaktu) {
        panitia = msg.sender;
        jeda_waktu = _jedaWaktu;
    }

    function isiBukuTamu(string memory _pesan) external {
        uint256 terakhir = kunjungan_terakhir[msg.sender];
        require(
            terakhir == 0 || block.timestamp >= terakhir + jeda_waktu,
            "BukuTamu: Belum melewati jeda waktu"
        );

        Catatan memory catatanBaru = Catatan({
            pengirim: msg.sender,
            pesan: _pesan,
            waktu: block.timestamp
        });

        daftar_hadir.push(catatanBaru);
        kunjungan_terakhir[msg.sender] = block.timestamp;

        emit CatatanBaru(msg.sender, _pesan, block.timestamp);
    }

    function setJedaWaktu(uint256 _durasi) external {
        require(msg.sender == panitia, "BukuTamu: Hanya panitia yang bisa mengubah jeda waktu");
        jeda_waktu = _durasi;
        emit JedaWaktuDiubah(_durasi);
    }

    function getSemuaCatatan() external view returns (Catatan[] memory) {
        return daftar_hadir;
    }

    function totalCatatan() external view returns (uint256) {
        return daftar_hadir.length;
    }
}
