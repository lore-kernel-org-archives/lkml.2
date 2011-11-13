Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1KMSr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:47:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65216 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1KMSr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:47:56 -0500
MIME-Version: 1.0
In-Reply-To: <2407026.akcTO2Ggic@gemini-64>
References: <2407026.akcTO2Ggic@gemini-64>
Date: Sun, 13 Nov 2011 18:47:53 +0000
Message-ID: <CAPM=9tzJMaxs1d-kKj-oc1K-izwRT78dcfjrxA=BAsxpvMioqw@mail.gmail.com>
Subject: Re: PROBLEM: Radeon display connector : No monitor connected or
 invalid EDID
From: Dave Airlie <airlied@gmail.com>
To: Treeve Jelbert <treeve@scarlet.be>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc Alex.

> Since installing kernel-3.1.1 the screen goes blank during the boot and I am
> unable to do anything, not even ssh into the box.
> â€‹
> linux-3.1.0 worked ok. There are no other changes to the system. Both were
> built using the same config file.
> â€‹
> When I reboot into 3.1.0 and check the log messages, I see
> â€‹
> Nov 13 14:31:22 Edge-64 kernel: [    0.055378] CPU0: AMD A6-3400M APU with
> Radeon(tm) HD Graphics stepping 00
> â€‹
> # grep '\[drm\]' messages |cut -d:  -f4-
>  [    0.645028] [drm] Initialized drm 1.1.0 20060810
>  [ 14.128321] [drm] radeon defaulting to kernel modesetting.
>  [ 14.128391] [drm] radeon kernel modesetting enabled.
>  [ 14.129217] [drm] initializing kernel modesetting (SUMO 0x1002:0x9647
> 0x17AA:0x21EA).
>  [ 14.129410] [drm] register mmio base: 0xF0B00000
>  [ 14.129476] [drm] register mmio size: 262144
>  [ 14.130388] [drm] Detected VRAM RAM=512M, BAR=256M
>  [ 14.130459] [drm] RAM width 32bits DDR
>  [ 14.130848] [drm] radeon: 512M of VRAM memory ready
>  [ 14.130912] [drm] radeon: 512M of GTT memory ready.
>  [ 14.131021] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>  [ 14.131085] [drm] Driver supports precise vblank timestamp query.
>  [ 14.131281] [drm] radeon: irq initialized.
>  [ 14.131347] [drm] GART: num cpu pages 131072, num gpu pages 131072
>  [ 14.132538] [drm] Loading SUMO Microcode
>  [ 14.547990] [drm] ring test succeeded in 1 usecs
>  [ 14.548128] [drm] radeon: ib pool ready.
>  [ 14.548249] [drm] ib test succeeded in 0 usecs
>  [ 14.551990] [drm] Radeon Display Connectors
>  [ 14.552056] [drm] Connector 0:
>  [ 14.552119] [drm]   VGA
>  [ 14.552179] [drm]   HPD2
>  [ 14.552242] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
> 0x644c 0x644c
>  [ 14.552336] [drm]   Encoders:
>  [ 14.552397] [drm]     CRT1: INTERNAL_UNIPHY2
>  [ 14.552473] [drm]     CRT1: NUTMEG
>  [ 14.552535] [drm] Connector 1:
>  [ 14.552596] [drm]   LVDS
>  [ 14.552657] [drm]   HPD1
>  [ 14.552718] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
> 0x643c 0x643c
>  [ 14.552809] [drm]   Encoders:
>  [ 14.552870] [drm]     LCD1: INTERNAL_UNIPHY2
>  [ 14.552932] [drm]     LCD1: TRAVIS
>  [ 14.552994] [drm] Connector 2:
>  [ 14.553055] [drm]   HDMI-A
>  [ 14.553115] [drm]   HPD3
>  [ 14.553176] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
> 0x645c 0x645c
>  [ 14.553266] [drm]   Encoders:
>  [ 14.553327] [drm]     DFP1: INTERNAL_UNIPHY
>  [ 14.952397] [drm] Radeon display connector VGA-1: No monitor connected or
> invalid EDID
>  [ 15.352332] [drm] Radeon display connector LVDS-1: No monitor connected or
> invalid EDID
>  [ 15.752357] [drm] Radeon display connector HDMI-A-1: No monitor connected
> or invalid EDID
>  [ 15.779878] [drm] Internal thermal controller without fan control
>  [ 15.780236] [drm] radeon: power management initialized
>  [ 16.014394] [drm] fb mappable at 0xE0141000
>  [ 16.014506] [drm] vram apper at 0xE0000000
>  [ 16.014568] [drm] size 4325376
>  [ 16.014629] [drm] fb depth is 24
>  [ 16.014690] [drm]    pitch is 5632
>  [ 16.111788] [drm] Initialized radeon 2.11.0 20080528 for 0000:00:01.0 on
> minor 0
> â€‹
> at this point the log ends.
> â€‹
> â€‹
> I also see
> â€‹
> [ 13.411889] thinkpad_acpi: Lenovo ThinkPad E525, model 12002JG
> [ 14.129616] ATOM BIOS: Lenovo
> â€‹
> Those messages did not appear in 3.1.0
> I am not sure of the meaning of ATOM, but I have an AMD system, not Intel.
> â€‹
> â€‹
> Keywords:graphics drm radeon Lenovo
> â€‹
> The following data is from the running linux-3.1.0
> $ lspci -vvv
> â€‹
> â€‹
> 00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 12h Processor Root
> Complex
>        Subsystem: Lenovo Device 21ea
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 64
> â€‹
> 00:01.0 VGA compatible controller: ATI Technologies Inc Device 9647 (prog-if
> 00 [VGA controller])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 11
>        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
>        Region 1: I/O ports at 4000 [size=256]
>        Region 2: Memory at f0b00000 (32-bit, non-prefetchable) [size=256K]
>        Expansion ROM at <unassigned> [disabled]
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI
> 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <4us, L1
> unlimited
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0
> <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl:         ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive-
> BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-,
> Selectable De-emphasis: -6dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel modules: radeon
> â€‹
> 00:01.1 Audio device: ATI Technologies Inc Device 1714
>        Subsystem: Lenovo Device 21ea
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin B routed to IRQ 46
>        Region 0: Memory at f0b44000 (32-bit, non-prefetchable) [size=16K]
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI
> 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <4us, L1
> unlimited
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #0, Speed unknown, Width x0, ASPM
> unknown, Latency L0
> <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl:         ASPM Disabled; Disabled- Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed unknown, Width x0, TrErr- Train-
> SlotClk- DLActive-
> BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-,
> Selectable De-emphasis: -6dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4181
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel driver in use: snd_hda_intel
> â€‹
> 00:04.0 PCI bridge: Advanced Micro Devices [AMD] Family 12h Processor Root
> Port (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>        I/O behind bridge: 00003000-00003fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: 00000000f0000000-00000000f00fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0
> <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep+ BwNot+
>                LnkCtl:         ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
>                SltCap:         AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
> HotPlug- Surprise-
>                        Slot #4, PowerLimit 75.000W; Interlock- NoCompl+
>                SltCtl:         Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq-
> LinkChg-
>                        Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                SltSta:         Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet+ LinkState+
>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
>                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-
> ARIFwd-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis+,
> Selectable De-emphasis: -6dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4141
>        Capabilities: [b0] Subsystem: Lenovo Device 21ea
>        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel driver in use: pcieport
> â€‹
> 00:11.0 SATA controller: Advanced Micro Devices [AMD] Hudson SATA Controller
> [AHCI mode] (prog-if 01 [AHCI 1.0])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64
>        Interrupt: pin A routed to IRQ 45
>        Region 0: I/O ports at 4118 [size=8]
>        Region 1: I/O ports at 4124 [size=4]
>        Region 2: I/O ports at 4110 [size=8]
>        Region 3: I/O ports at 4120 [size=4]
>        Region 4: I/O ports at 4100 [size=16]
>        Region 5: Memory at f0b4b000 (32-bit, non-prefetchable) [size=2K]
>        Capabilities: [50] MSI: Enable+ Count=1/16 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4171
>        Capabilities: [70] SATA HBA v1.0 InCfgSpace
>        Kernel driver in use: ahci
> â€‹
> 00:12.0 USB controller: Advanced Micro Devices [AMD] Hudson USB OHCI
> Controller (rev 11) (prog-if 10 [OHCI])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 18
>        Region 0: Memory at f0b4a000 (32-bit, non-prefetchable) [size=4K]
>        Kernel driver in use: ohci_hcd
>        Kernel modules: ohci-hcd
> â€‹
> 00:12.2 USB controller: Advanced Micro Devices [AMD] Hudson USB EHCI
> Controller (rev 11) (prog-if 20 [EHCI])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at f0b4bb00 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [c0] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>                Bridge: PM- B3+
>        Capabilities: [e4] Debug port: BAR=1 offset=00e0
>        Kernel driver in use: ehci_hcd
> â€‹
> 00:13.0 USB controller: Advanced Micro Devices [AMD] Hudson USB OHCI
> Controller (rev 11) (prog-if 10 [OHCI])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 18
>        Region 0: Memory at f0b49000 (32-bit, non-prefetchable) [size=4K]
>        Kernel driver in use: ohci_hcd
>        Kernel modules: ohci-hcd
> â€‹
> 00:13.2 USB controller: Advanced Micro Devices [AMD] Hudson USB EHCI
> Controller (rev 11) (prog-if 20 [EHCI])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at f0b4ba00 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [c0] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>                Bridge: PM- B3+
>        Capabilities: [e4] Debug port: BAR=1 offset=00e0
>        Kernel driver in use: ehci_hcd
> â€‹
> 00:14.0 SMBus: Advanced Micro Devices [AMD] Hudson SMBus Controller (rev 13)
>        Subsystem: Lenovo Device 21ea
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:14.2 Audio device: Advanced Micro Devices [AMD] Hudson Azalia Controller
> (rev 01)
>        Subsystem: Lenovo Device 21ea
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at f0b40000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: snd_hda_intel
> â€‹
> 00:14.3 ISA bridge: Advanced Micro Devices [AMD] Hudson LPC Bridge (rev 11)
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
> â€‹
> 00:14.4 PCI bridge: Advanced Micro Devices [AMD] Hudson PCI Bridge (rev 40)
> (prog-if 01 [Subtractive decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64
>        Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: fff00000-000fffff
>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort-
> <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> â€‹
> 00:14.7 SD Host controller: Advanced Micro Devices [AMD] Hudson SD Flash
> Controller (prog-if 01)
>        Subsystem: Lenovo Device 21ea
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 71, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at f0b4b900 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Kernel driver in use: sdhci-pci
>        Kernel modules: sdhci-pci
> â€‹
> 00:15.0 PCI bridge: Advanced Micro Devices [AMD] Device 43a0 (prog-if 00
> [Normal decode])
>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fff00000-000fffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #247, Speed 5GT/s, Width x1, ASPM L0s L1,
> Latency L0
> <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep+ BwNot+
>                LnkCtl:         ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed unknown, Width x16, TrErr- Train-
> SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
>                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-
> ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
> Selectable De-emphasis: -3.5dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4149
>        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 0000
>        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel driver in use: pcieport
> â€‹
> 00:15.1 PCI bridge: Advanced Micro Devices [AMD] Device 43a1 (prog-if 00
> [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: f0a00000-f0afffff
>        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #1, Speed 5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <64ns,
> L1 <1us
>                        ClockPM- Surprise- LLActRep+ BwNot+
>                LnkCtl:         ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
>                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-
> ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
> Selectable De-emphasis: -3.5dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4151
>        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 0000
>        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel driver in use: pcieport
> â€‹
> 00:15.2 PCI bridge: Advanced Micro Devices [AMD] Device 43a2 (prog-if 00
> [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>        I/O behind bridge: 00002000-00002fff
>        Memory behind bridge: f0900000-f09fffff
>        Prefetchable memory behind bridge: 00000000f0c00000-00000000f0dfffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #2, Speed 5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <64ns,
> L1 <1us
>                        ClockPM- Surprise- LLActRep+ BwNot+
>                LnkCtl:         ASPM L1 Enabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive+
> BWMgmt- ABWMgmt-
>                SltCap:         AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
> HotPlug+ Surprise-
>                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
>                SltCtl:         Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq-
> LinkChg-
>                        Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                SltSta:         Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet+ Interlock-
>                        Changed: MRL- PresDet- LinkState+
>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
>                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-
> ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
> Selectable De-emphasis: -3.5dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4159
>        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 0000
>        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel driver in use: pcieport
> â€‹
> 00:15.3 PCI bridge: Advanced Micro Devices [AMD] Device 43a3 (prog-if 00
> [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Bus: primary=00, secondary=06, subordinate=07, sec-latency=0
>        I/O behind bridge: 00001000-00001fff
>        Memory behind bridge: f0500000-f08fffff
>        Prefetchable memory behind bridge: 00000000f0100000-00000000f04fffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [50] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                        ExtTag+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr- TransPend-
>                LnkCap:         Port #247, Speed 5GT/s, Width x1, ASPM L0s L1,
> Latency L0
> <64ns, L1 <1us
>                        ClockPM- Surprise- LLActRep+ BwNot+
>                LnkCtl:         ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
> Retrain- CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed unknown, Width x16, TrErr- Train-
> SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
>                SltCap:         AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
> HotPlug+ Surprise-
>                        Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
>                SltCtl:         Enable: AttnBtn- PwrFlt- MRL- PresDet-
> CmdCplt- HPIrq-
> LinkChg-
>                        Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                SltSta:         Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet- Interlock-
>                        Changed: MRL- PresDet- LinkState-
>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
>                DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-
> ARIFwd-
>                LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
> Selectable De-emphasis: -3.5dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -3.5dB
>        Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4161
>        Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 0000
>        Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
>        Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> Len=010
> <?>
>        Kernel driver in use: pcieport
> â€‹
> 00:16.0 USB controller: Advanced Micro Devices [AMD] Hudson USB OHCI
> Controller (rev 11) (prog-if 10 [OHCI])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 18
>        Region 0: Memory at f0b48000 (32-bit, non-prefetchable) [size=4K]
>        Kernel driver in use: ohci_hcd
>        Kernel modules: ohci-hcd
> â€‹
> 00:16.2 USB controller: Advanced Micro Devices [AMD] Hudson USB EHCI
> Controller (rev 11) (prog-if 20 [EHCI])
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 32 bytes
>        Interrupt: pin B routed to IRQ 17
>        Region 0: Memory at f0b4b800 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [c0] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>                Bridge: PM- B3+
>        Capabilities: [e4] Debug port: BAR=1 offset=00e0
>        Kernel driver in use: ehci_hcd
> â€‹
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 0 (rev 43)
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 1
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 2
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 3
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Capabilities: [f0] Secure device <?>
>        Kernel driver in use: k10temp
> â€‹
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 4
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 6
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 5
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor
> Function 7
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> â€‹
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
> Express Gigabit Ethernet controller (rev 06)
>        Subsystem: Lenovo Device 21ea
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 47
>        Region 0: I/O ports at 3000 [size=256]
>        Region 2: Memory at f0004000 (64-bit, prefetchable) [size=4K]
>        Region 4: Memory at f0000000 (64-bit, prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4189
>        Capabilities: [70] Express (v2) Endpoint, MSI 01
>                DevCap:         MaxPayload 256 bytes, PhantFunc 0, Latency L0s
> <512ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                DevSta:         CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr+ TransPend-
>                LnkCap:         Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0
> <512ns, L1 <64us
>                        ClockPM+ Surprise- LLActRep- BwNot-
>                LnkCtl:         ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk-
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-,
> Selectable De-emphasis: -6dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
>                Vector table: BAR=4 offset=00000000
>                PBA: BAR=4 offset=00000800
>        Capabilities: [d0] Vital Product Data
>                Unknown small resource type 00, will not decode more.
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF-
> MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt:         DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                AERCap:         First Error Pointer: 14, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status:         InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status:         NegoPending- InProgress-
>        Capabilities: [160 v1] Device Serial Number 3a-0b-00-00-68-4c-e0-00
>        Kernel driver in use: r8169
>        Kernel modules: r8169
> â€‹
> 04:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 04) (prog-if 01)
>        Subsystem: Lenovo Device 21ea
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 17
>        Region 0: Memory at f0a00200 (32-bit, non-prefetchable) [size=256]
>        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [78] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
>        Capabilities: [80] Express (v1) Endpoint, MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1
> unlimited
>                        ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta:         CorrErr+ UncorrErr- FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap:         Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <4us,
> L1 unlimited
>                        ClockPM+ Surprise- LLActRep- BwNot-
>                LnkCtl:         ASPM L1 Enabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
>        Capabilities: [100 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status:         InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status:         NegoPending- InProgress-
>        Capabilities: [800 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt:         DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                AERCap:         First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Kernel driver in use: sdhci-pci
>        Kernel modules: sdhci-pci
> â€‹
> 05:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
> 802.11b/g/n WiFi Adapter (rev 01)
>        Subsystem: Realtek Semiconductor Co., Ltd. Device 8195
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 18
>        Region 0: I/O ports at 2000 [size=256]
>        Region 2: Memory at f0900000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [70] Express (v2) Endpoint, MSI 00
>                DevCap:         MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <512ns, L1 <64us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                DevCtl:         Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta:         CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPend-
>                LnkCap:         Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0
> <512ns, L1 <64us
>                        ClockPM+ Surprise- LLActRep- BwNot-
>                LnkCtl:         ASPM L0s L1 Enabled; RCB 64 bytes Disabled-
> Retrain- CommClk+
>                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
>                LnkSta:         Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
>                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> SpeedDis-,
> Selectable De-emphasis: -6dB
>                        Transmit Margin: Normal Operating Range,
> EnterModifiedCompliance-
> ComplianceSOS-
>                        Compliance De-emphasis: -6dB
>                LnkSta2: Current De-emphasis Level: -6dB
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt:         DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr-
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> NonFatalErr+
>                AERCap:         First Error Pointer: 00, GenCap+ CGenEn-
> ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status:         InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status:         NegoPending- InProgress-
>        Capabilities: [160 v1] Device Serial Number 01-91-81-fe-ff-4c-e0-00
>        Kernel driver in use: rtl8192ce
>        Kernel modules: rtl8192ce
> â€‹
> â€‹
> â€‹
> â€‹
> â€‹
> $ lsmod
> Module                  Size  Used by
> rtl8192ce              69655  0
> rtl8192c_common        54535  1 rtl8192ce
> cfbcopyarea             3217  0
> ohci_hcd               20690  0
> sdhci_pci               8440  0
> rtlwifi                87860  1 rtl8192ce
> sdhci                  21347  1 sdhci_pci
> cfbimgblt               1969  0
> mmc_core               67307  1 sdhci
> r8169                  43238  0
> cfbfillrect             3581  0
> processor              22993  4
> mii                     3707  1 r8169
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
