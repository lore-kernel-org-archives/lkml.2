Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1EDSBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:01:40 -0400
Received: from perninha.conectiva.com.br ([187.115.55.249]:58096 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:01:39 -0400
Subject: DRIVERS MMC card freezes at Jmicron controllers.
From: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Conectiva
Date: Wed, 04 May 2011 14:59:04 -0300
Message-ID: <1304531944.6868.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3-1.1mdv2010.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.
I wrote an email minutes ago and I think it could be delivered missing
half of the content for mistake using email editor. Sorry for that

We have users, reporting problems with MMC cards and JMicron controller
devices. We have here to test more than one Pc (with Jmicron) with the
same problem. It freezes completely after the insert of stick. Using
2.6.33 to 2.6.39 RC6 the error is the same. I tried many alternatives,
but with no success. If there is a idea that could make a fix on it
please copy me on thread.

lspci:
02:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host
Controller (rev 80) (prog-if 01)
        Subsystem: Holco Enterprise Co, Ltd/Shuttle Computer Device
2000                                
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Interrupt: pin B routed to IRQ
18                                                                    
        Region 0: Memory at febff800 (32-bit, non-prefetchable)
[size=256]                                   
        Capabilities: [a4] Power Management version
3                                                        
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)                   
                Status: D0 PME-Enable- DSel=0 DScale=0
PME-                                                  
        Capabilities: [80] Express (v1) Endpoint, MSI
00                                                     
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us                        
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+
FLReset-                                      
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-                           
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr-
NoSnoop-                                         
                        MaxPayload 128 bytes, MaxReadReq 128
bytes                                           
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
TransPend-                          
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 unlimited    
                        ClockPM- Surprise- LLActRep-
BwNot-                                                  
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+                              
                        ExtSynch- ClockPM- AutWidDis- BWInt-
AutBWInt-                                       
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-           
        Capabilities: [94] MSI: Mask- 64bit- Count=1/1
Enable-                                               
                Address: fffffffc  Data:
0000                                                                
        Kernel modules: sdhci-pci

Before death it outputs on log
mmc0:new MMC card at...
mmcblk0:mmc0 ...
ldm_validade_partition_table() Disk read failed
mmcblk0: retrying using single block read
error -110 transfering data, sector 0, card status nr8, 0xb00

I'll still trying something, but if anybody knows about it warn me.
Thanks
Alexandre

