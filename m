Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2I1Hnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:43:45 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48059 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab2I1Hnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:43:42 -0400
Message-ID: <1348818217.6331.0.camel@rajhome2>
Subject: PROBLEM:  Kernel 3.6.0-rc7 freezes up
From: Raj Upadhyaya <raj.upadhyaya@gmail.com>
Reply-To: raj@upadhyaya.com
To: linux-kernel@vger.kernel.org
Date: Fri, 28 Sep 2012 02:43:37 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] PROBLEM:  Kernel 3.6.0-rc7 freezes up    
[2.] I downloaded the kernel from kernel.org and built 3.6.0-rc7.  It freezes up early in the boot.  
I am able to see that the keyboard is active as Num Lock, Caps Lock and Ctrl-Alt-Delete still work.
[3.] kernel
[4.] 3.6.0-rc7
[5.] 
[6.] N/A 
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
[7.2.] Processor information (from /proc/cpuinfo):
I rebooted and chose 3.6.0-rc6 and the following info is produced.
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	: Intel(R) Pentium(R) D CPU 2.80GHz
stepping	: 4
microcode	: 0x4
cpu MHz		: 2400.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pebs bts pni dtes64 monitor ds_cpl est cid cx16 xtpr pdcm lahf_lm
bogomips	: 5601.50
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	: Intel(R) Pentium(R) D CPU 2.80GHz
stepping	: 4
microcode	: 0x4
cpu MHz		: 2400.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pebs bts pni dtes64 monitor ds_cpl est cid cx16 xtpr pdcm lahf_lm
bogomips	: 5601.50
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 48 bits virtual
power management:
[7.3.] Module information (from /proc/modules):
I rebooted and chose 3.6.0-rc6 and the following info is produced.
tcp_lp 12583 0 - Live 0xf88f7000
des_generic 21135 0 - Live 0xf853d000
md4 12523 0 - Live 0xf8533000
nls_utf8 12493 1 - Live 0xf8522000
cifs 276322 2 - Live 0xf87fd000
fscache 48610 1 cifs, Live 0xf855e000
fuse 71577 3 - Live 0xf854b000
bnep 18863 2 - Live 0xf8511000
nf_conntrack_netbios_ns 12585 0 - Live 0xf851a000
nf_conntrack_broadcast 12487 1 nf_conntrack_netbios_ns, Live 0xf8502000
ip6t_REJECT 12826 2 - Live 0xf84fd000
bluetooth 275600 7 bnep, Live 0xf87b8000
nf_conntrack_ipv6 14077 13 - Live 0xf84e4000
nf_defrag_ipv6 13708 1 nf_conntrack_ipv6, Live 0xf84ef000
nf_conntrack_ipv4 14457 12 - Live 0xf84df000
nf_defrag_ipv4 12601 1 nf_conntrack_ipv4, Live 0xf84ea000
xt_state 12514 25 - Live 0xf84da000
rfkill 20451 3 bluetooth, Live 0xf8545000
nf_conntrack 72002 5 nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_conntrack_ipv6,nf_conntrack_ipv4,xt_state, Live 0xf84c7000
ip6table_filter 12711 1 - Live 0xf84f8000
ip6_tables 17744 1 ip6table_filter, Live 0xf8432000
binfmt_misc 17231 1 - Live 0xf88ac000
snd_hda_codec_realtek 63450 1 - Live 0xf84b0000
snd_hda_intel 32538 4 - Live 0xf8508000
snd_hda_codec 109373 2 snd_hda_codec_realtek,snd_hda_intel, Live 0xf8494000
snd_hwdep 13232 1 snd_hda_codec, Live 0xf8424000
snd_seq 54674 0 - Live 0xf8485000
snd_seq_device 13824 1 snd_seq, Live 0xf8341000
snd_pcm 81440 3 snd_hda_intel,snd_hda_codec, Live 0xf840f000
snd_page_alloc 13709 2 snd_hda_intel,snd_pcm, Live 0xf8407000
snd_timer 23742 2 snd_seq,snd_pcm, Live 0xf8371000
joydev 17161 0 - Live 0xf8401000
e100 35903 0 - Live 0xf8367000
iTCO_wdt 13256 0 - Live 0xf81bb000
iTCO_vendor_support 13243 1 iTCO_wdt, Live 0xf837b000
ppdev 17363 0 - Live 0xf8361000
mii 13311 1 e100, Live 0xf8480000
snd 63133 15 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,snd_timer, Live 0xf8350000
serio_raw 13159 0 - Live 0xf8346000
pcspkr 12630 0 - Live 0xf834b000
parport_pc 27403 0 - Live 0xf82f5000
parport 39143 2 ppdev,parport_pc, Live 0xf856e000
lpc_ich 16925 0 - Live 0xf81f6000
soundcore 14123 1 snd, Live 0xf842d000
microcode 18724 0 - Live 0xf81f0000
i2c_i801 17782 0 - Live 0xf81b5000
uinput 17304 0 - Live 0xf89de000
firewire_ohci 35521 0 - Live 0xf81a6000
firewire_core 55924 1 firewire_ohci, Live 0xf81e1000
usb_storage 46945 0 - Live 0xf8199000
crc_itu_t 12523 1 firewire_core, Live 0xf81b0000
i915 470817 3 - Live 0xf8281000
video 18504 1 i915, Live 0xf8181000
i2c_algo_bit 13065 1 i915, Live 0xf7c79000
drm_kms_helper 30925 1 i915, Live 0xf8190000
drm 211791 4 i915,drm_kms_helper, Live 0xf7c37000
i2c_core 28418 5 i2c_i801,i915,i2c_algo_bit,drm_kms_helper,drm, Live 0xf7c71000
[7.4.] Loaded driver and hardware information
(/proc/ioports,
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
0378-037a : parport0
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
0400-04bf : pnp 00:07
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0428-042f : ACPI GPE0_BLK
  0430-0433 : iTCO_wdt
    0430-0433 : iTCO_wdt
  0460-047f : iTCO_wdt
    0460-047f : iTCO_wdt
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
e000-efff : PCI Bus 0000:01
  ec00-ecff : 0000:01:05.0
  ee00-ee3f : 0000:01:08.0
    ee00-ee3f : e100
  ef00-ef7f : 0000:01:01.0
f500-f50f : 0000:00:1f.2
  f500-f50f : ahci
f600-f603 : 0000:00:1f.2
  f600-f603 : ahci
f700-f707 : 0000:00:1f.2
  f700-f707 : ahci
f800-f803 : 0000:00:1f.2
  f800-f803 : ahci
f900-f907 : 0000:00:1f.2
  f900-f907 : ahci
fa00-fa0f : 0000:00:1f.1
  fa00-fa0f : ata_piix
fb00-fb1f : 0000:00:1d.3
  fb00-fb1f : uhci_hcd
fc00-fc1f : 0000:00:1d.2
  fc00-fc1f : uhci_hcd
fd00-fd1f : 0000:00:1d.1
  fd00-fd1f : uhci_hcd
fe00-fe1f : 0000:00:1d.0
  fe00-fe1f : uhci_hcd
ff00-ff07 : 0000:00:02.0


 /proc/iomem)
I rebooted and chose 3.6.0-rc6 and the following info is produced.
00000000-0000ffff : reserved
00010000-000987ff : System RAM
00098800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cc000-000d07ff : Adapter ROM
000d0800-000d3fff : pnp 00:0a
000e0000-000effff : pnp 00:0a
000f0000-000fffff : reserved
000f0000-000fffff : System ROM
00100000-7f6dffff : System RAM
00400000-0094f12c : Kernel code
0094f12d-00bf413f : Kernel data
00c97000-00d8bfff : Kernel bss
7f6e0000-7f6e2fff : ACPI Non-volatile Storage
7f6e3000-7f6effff : ACPI Tables
7f6f0000-7f6fffff : reserved
7f700000-7fffffff : RAM buffer
e0000000-efffffff : 0000:00:02.0
f0000000-f3ffffff : PCI MMCONFIG 0000 [bus 00-3f]
f0000000-f3ffffff : reserved
f0000000-f3ffffff : pnp 00:09
fde00000-fdefffff : PCI Bus 0000:01
fdefe000-fdefefff : 0000:01:08.0
fdefe000-fdefefff : e100
fdeff000-fdeff7ff : 0000:01:01.0
fdeff000-fdeff7ff : firewire_ohci
fdf00000-fdf7ffff : 0000:00:02.0
fdf80000-fdfbffff : 0000:00:02.0
fdff8000-fdffbfff : 0000:00:1b.0
fdff8000-fdffbfff : ICH HD audio
fdffe000-fdffe3ff : 0000:00:1f.2
fdffe000-fdffe3ff : ahci
fdfff000-fdfff3ff : 0000:00:1d.7
fdfff000-fdfff3ff : ehci_hcd
fec00000-ffffffff : reserved
fec00000-fec003ff : IOAPIC 0
fed1f410-fed1f414 : iTCO_wdt
fed1f410-fed1f414 : iTCO_wdt
fee00000-fee00fff : Local APIC
fee00000-fee00fff : pnp 00:0a
ffb00000-ffb7ffff : pnp 00:0a
fff00000-ffffffff : pnp 00:0a

[7.5.] PCI information ('lspci -vvv' as root)
I rebooted and chose 3.6.0-rc6 and the following info is produced.
00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub (rev 02)
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=09 <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fdf00000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at ff00 [size=8]
	Region 2: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at fdf80000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 01)
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 41
	Region 0: Memory at fdff8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at fe00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at fd00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at fc00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at fb00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fdfff000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Hewlett-Packard Company Pavilion A1512X

00:1f.0 ISA bridge: Intel Corporation 82801GH (ICH7DH) LPC Interface Bridge (rev 01)
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at fa00 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 RAID bus controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA RAID Controller (rev 01)
	Subsystem: Hewlett-Packard Company Device 2a3b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 40
	Region 0: I/O ports at f900 [size=8]
	Region 1: I/O ports at f800 [size=4]
	Region 2: I/O ports at f700 [size=8]
	Region 3: I/O ports at f600 [size=4]
	Region 4: I/O ports at f500 [size=16]
	Region 5: Memory at fdffe000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4181
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 01)
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 0500 [size=32]
	Kernel driver in use: i801_smbus

01:01.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device 2a3b
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (8000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
	Region 1: I/O ports at ef00 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: firewire_ohci

01:05.0 Communication controller: Agere Systems Lucent V.92 Data/Fax Modem
	Subsystem: Agere Systems Lucent V.92 Data/Fax Modem
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 255
	Region 0: I/O ports at ec00 [size=256]
	Capabilities: [f8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

01:08.0 Ethernet controller: Intel Corporation N10/ICH 7 Family LAN Controller (rev 01)
	Subsystem: Hewlett-Packard Company Pavilion A1512X
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fdefe000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at ee00 [size=64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: e100
[7.6.] SCSI information (from /proc/scsi/scsi)
I rebooted and chose 3.6.0-rc6 and the following info is produced.
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3000JS-60P Rev: 21.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRRW GSA-H20L  Rev: S632
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: USB SD Reader    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: USB CF Reader    Rev: 1.01
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic  Model: USB SM Reader    Rev: 1.02
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi6 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic  Model: USB MS Reader    Rev: 1.03
  Type:   Direct-Access                    ANSI  SCSI revision: 00
[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
I tried rebuilding the kernel without bluetooth and Wimax support, with the same results.


