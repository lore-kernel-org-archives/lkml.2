Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1ITLcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 07:32:07 -0400
Received: from mail-gw0-f52.google.com ([74.125.83.52]:62417 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1ITLcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 07:32:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAHR1FHGAf-UFU2GTK_ZcdxFe2Ngxpf9RtnXeRUOtQ1Fz4mqE3A@mail.gmail.com>
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com>
 <CAHR1FHH9bJScYkD7_gDaSd1JZ7eMai+x_-gzUtRZ5jmLSft_WA@mail.gmail.com>
 <1316489711.61388.YahooMailNeo@web130108.mail.mud.yahoo.com> <CAHR1FHGAf-UFU2GTK_ZcdxFe2Ngxpf9RtnXeRUOtQ1Fz4mqE3A@mail.gmail.com>
From: Pranjal Verma <tekytechllinux@gmail.com>
Date: Tue, 20 Sep 2011 17:01:23 +0530
Message-ID: <CAHR1FHFvxiZutYpXz8wa6sN9G+7q=AtTMxZbUwdO6c7L2r4D8g@mail.gmail.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.
To: Alex Davis <alex14641@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for all this HTML shit. I have successfully configured my mail
for plain text now.

>On Tue, Sep 20, 2011 at 4:47 PM, Pranjal Verma <tekytechllinux@gmail.com> wrote:
>> Please send output from lspci -vv. Also what window environment are you
>> using ( KDE, Gnome, etc).
> I am using KDE and the output of lspci -vv is:
> linux-n0zw:/ # lspci -vv
> 00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
> Controller Hub (rev 0c)
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: [e0] Vendor Specific Information: Len=0a <?>
>         Kernel driver in use: agpgart-intel
>
> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (primary) (rev 0c) (prog-if 00 [VGA
> controller])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 40
>         Region 0: Memory at f6e00000 (64-bit, non-prefetchable) [size=1M]
>         Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
>         Region 4: I/O ports at efe8 [size=8]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                 Address: fee0300c  Data: 4169
>         Capabilities: [d0] Power Management version 3
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>                 Bridge: PM- B3+
>         Kernel driver in use: i915
>
> 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated
> Graphics Controller (secondary) (rev 0c)
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Region 0: Memory at f6f00000 (64-bit, non-prefetchable) [size=1M]
>         Capabilities: [d0] Power Management version 3
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>                 Bridge: PM- B3+
>
> 00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #4 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 20
>         Region 4: I/O ports at 6f20 [size=32]
>         Kernel driver in use: uhci_hcd
>
> 00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #5 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 21
>         Region 4: I/O ports at 6f00 [size=32]
>         Kernel driver in use: uhci_hcd
>
> 00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
> Controller #2 (rev 02) (prog-if 20 [EHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 22
>         Region 0: Memory at fed1c400 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Kernel driver in use: ehci_hcd
>
> 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
> Controller (rev 02)
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 41
>         Region 0: Memory at f6dfc000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0300c  Data: 4179
>         Capabilities: [70] Express (v1) Root Complex Integrated Endpoint,
> MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
>                         ExtTag- RBE- FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown,
> Latency L0 <64ns, L1 <1us
>                         ClockPM- Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-
> DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>                 VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=80
>                         Status: NegoPending- InProgress-
>         Capabilities: [130 v1] Root Complex Link
>                 Desc:   PortNumber=0f ComponentID=02 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB-
> LinkType=MemMapped LinkValid+
>                         Addr:   00000000fed18000
>         Kernel driver in use: HDA Intel
>
> 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
> 1 (rev 02) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: c0000000-c01fffff
>         Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal+
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <1us, L1 <4us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
> Surprise+
>                         Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
> HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
> Interlock-
>                         Changed: MRL- PresDet- LinkState-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal+ PMEIntEna-
> CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 0209
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed+ WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                         Status: NegoPending- InProgress-
>         Capabilities: [180 v1] Root Complex Link
>                 Desc:   PortNumber=01 ComponentID=02 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB-
> LinkType=MemMapped LinkValid+
>                         Addr:   00000000fed18001
>
> 00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
> 2 (rev 02) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
>         I/O behind bridge: 00003000-00003fff
>         Memory behind bridge: f6c00000-f6cfffff
>         Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <256ns, L1 <4us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive+ BWMgmt- ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
> Surprise+
>                         Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
> HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
> Interlock-
>                         Changed: MRL- PresDet- LinkState-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 0209
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed+ WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>         Capabilities: [180 v1] Root Complex Link
>                 Desc:   PortNumber=02 ComponentID=02 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB-
> LinkType=MemMapped LinkValid+
>                         Addr:   00000000fed18001
>
> 00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
> 4 (rev 02) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=0d, subordinate=0e, sec-latency=0
>         I/O behind bridge: 0000d000-0000dfff
>         Memory behind bridge: f6a00000-f6bfffff
>         Prefetchable memory behind bridge: 00000000f0000000-00000000f01fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <1us, L1 <4us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
> Surprise+
>                         Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
> HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
> Interlock-
>                         Changed: MRL- PresDet- LinkState-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 0209
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed+ WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                         Status: NegoPending- InProgress-
>         Capabilities: [180 v1] Root Complex Link
>                 Desc:   PortNumber=04 ComponentID=02 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB-
> LinkType=MemMapped LinkValid+
>                         Addr:   00000000fed18001
>
> 00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port
> 6 (rev 02) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
>         I/O behind bridge: 00004000-00004fff
>         Memory behind bridge: f6900000-f69fffff
>         Prefetchable memory behind bridge: 00000000c0600000-00000000c07fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
>                         ExtTag- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <256ns, L1 <4us
>                         ClockPM- Surprise- LLActRep+ BwNot-
>                 LnkCtl: ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive+ BWMgmt- ABWMgmt-
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
> Surprise+
>                         Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt-
> HPIrq- LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
> Interlock-
>                         Changed: MRL- PresDet- LinkState-
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                 RootCap: CRSVisible-
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>         Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
>                 Address: 00000000  Data: 0000
>         Capabilities: [90] Subsystem: Dell Device 0209
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [100 v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed+ WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>         Capabilities: [180 v1] Root Complex Link
>                 Desc:   PortNumber=06 ComponentID=02 EltType=Config
>                 Link0:  Desc:   TargetPort=00 TargetComponent=02 AssocRCRB-
> LinkType=MemMapped LinkValid+
>                         Addr:   00000000fed18001
>
> 00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #1 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 20
>         Region 4: I/O ports at 6f80 [size=32]
>         Kernel driver in use: uhci_hcd
>
> 00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #2 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 21
>         Region 4: I/O ports at 6f60 [size=32]
>         Kernel driver in use: uhci_hcd
>
> 00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
> Controller #3 (rev 02) (prog-if 00 [UHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 22
>         Region 4: I/O ports at 6f40 [size=32]
>         Kernel driver in use: uhci_hcd
>
> 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
> Controller #1 (rev 02) (prog-if 20 [EHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at fed1c000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Kernel driver in use: ehci_hcd
>
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f2)
> (prog-if 01 [Subtractive decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
>         Memory behind bridge: f6800000-f68fffff
>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: [50] Subsystem: Dell Device 0209
>
> 00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
> Controller (rev 02)
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
>
> 00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE
> Controller (rev 02) (prog-if 8a [Master SecP PriP])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16
>         Region 0: I/O ports at 01f0 [size=8]
>         Region 1: I/O ports at 03f4 [size=1]
>         Region 2: I/O ports at 0170 [size=8]
>         Region 3: I/O ports at 0374 [size=1]
>         Region 4: I/O ports at 6fa0 [size=16]
>         Kernel driver in use: ata_piix
>
> 00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA
> IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 17
>         Region 0: I/O ports at 6eb0 [size=8]
>         Region 1: I/O ports at 6eb8 [size=4]
>         Region 2: I/O ports at 6ec0 [size=8]
>         Region 3: I/O ports at 6ec8 [size=4]
>         Region 4: I/O ports at 6ee0 [size=16]
>         Region 5: I/O ports at eff0 [size=16]
>         Capabilities: [70] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: ata_piix
>
> 00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev
> 02)
>         Subsystem: Dell Device 0209
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin B routed to IRQ 17
>         Region 0: Memory at f6dfbf00 (32-bit, non-prefetchable) [size=256]
>         Region 4: I/O ports at 10c0 [size=32]
>         Kernel driver in use: i801_smbus
>
> 03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev
> 05) (prog-if 10 [OHCI])
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 19
>         Region 0: Memory at f68ff800 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
>         Kernel driver in use: firewire_ohci
>
> 03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host
> Adapter (rev 22) (prog-if 01)
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 18
>         Region 0: Memory at f68ff400 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
>         Kernel driver in use: sdhci-pci
>
> 03:01.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter
> (rev 12)
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 4
>         Region 0: Memory at f68ff600 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
>
> 03:01.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)
>         Subsystem: Dell Device 0209
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64, Cache Line Size: 64 bytes
>         Interrupt: pin B routed to IRQ 18
>         Region 0: Memory at f68ff700 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
>         Kernel driver in use: r852
>
> 09:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5906M Fast
> Ethernet PCI Express (rev 02)
>         Subsystem: Dell XPS M1330
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 43
>         Region 0: Memory at f69f0000 (64-bit, non-prefetchable) [size=64K]
>         Expansion ROM at <ignored> [disabled]
>         Capabilities: [48] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [50] Vital Product Data
>                 End
>         Capabilities: [58] Vendor Specific Information: Len=78 <?>
>         Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0300c  Data: 4189
>         Capabilities: [d0] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us,
> L1 unlimited
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <4us, L1 <64us
>                         ClockPM+ Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L0s Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> ChkEn-
>         Capabilities: [13c v1] Virtual Channel
>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>                 Ctrl:   ArbSelect=Fixed
>                 Status: InProgress-
>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
> WRR256-
>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>                         Status: NegoPending- InProgress-
>         Capabilities: [160 v1] Device Serial Number 00-21-9b-ff-fe-e3-92-42
>         Kernel driver in use: tg3
>
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN
> [Kedron] Network Connection (rev 61)
>         Subsystem: Intel Corporation Device 1120
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 42
>         Region 0: Memory at f6cfe000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                 Address: 00000000fee0300c  Data: 4181
>         Capabilities: [e0] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <512ns, L1 unlimited
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <128ns, L1 <64us
>                         ClockPM+ Surprise- LLActRep- BwNot-
>                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [100 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                 AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
> ChkEn-
>         Capabilities: [140 v1] Device Serial Number 00-21-5c-ff-ff-95-34-35
>         Kernel driver in use: iwlagn
>
