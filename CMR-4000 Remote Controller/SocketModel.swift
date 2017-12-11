//
//  Model.swift
//  SwiftSocket
//
//  Created by Ben Choi on 7/5/17.
//  Copyright © 2017 Ben Choi. All rights reserved.
//

import Foundation

struct SocketModel {
    
    var client: UDPClient?
    var port: Int? = 7777
    var host: String? = "192.168.10.225"
    
    mutating func setClient(address: String, port: Int)
    {
        if (host != nil && port != nil) {
            client = UDPClient(address: address, port: Int32(port))
        }
    }
    
    func getClient() -> UDPClient? {
        return client
    }
    
    //Make packets to shoot to the device
    mutating func make_MICOMPkt(check_mode: Int, FrontButtonNumberUni: UnicodeScalar, data_len: Int) -> [Character] {
        
        let zeroUni = Character(UnicodeScalar(0))
        var data = [Character(FrontButtonNumberUni), zeroUni, zeroUni]
        var idx = 0
        var micom_Pkt = [Character]()
        var Chksum = 0
        
        if let start_pattern_uni = UnicodeScalar(7)
        {   micom_Pkt.append( Character(start_pattern_uni) )  }
        
        var micom_Pkt_1_value = data_len + 2
        
        if let micom_Pkt_1_uni = UnicodeScalar(micom_Pkt_1_value)
        {   micom_Pkt.append(Character (micom_Pkt_1_uni) )    }
        
        if let check_mode_uni = UnicodeScalar(check_mode)
        {   micom_Pkt.append( Character(check_mode_uni) ) }
        
        if let micom_Pkt2_uni = UnicodeScalar(String(micom_Pkt[2]))
        { Chksum += Int(micom_Pkt2_uni.value) }
        
        for num in 3...( data_len + 3 - 1 ) {
            
            micom_Pkt.append(data[num-3])
            
            if let micom_Pkt_idx_uni = UnicodeScalar(String(micom_Pkt[num]))
            {   Chksum += Int(micom_Pkt_idx_uni.value)  }
            
            idx = num
        }
        
        if let Chksum_uni = UnicodeScalar(Chksum)
        {   micom_Pkt[idx] = Character(Chksum_uni)  }
        
        return micom_Pkt
        
    }
}
