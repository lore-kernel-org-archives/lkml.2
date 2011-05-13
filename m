Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab1EMMrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:47:53 -0400
Received: from shark.2a.pl ([195.117.102.3]:52162 "EHLO shark.2a.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623Ab1EMMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:47:50 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 May 2011 08:47:48 EDT
From: =?iso-8859-2?q?K=F8i=B9tof_=AEelechovski?= <giecrilj@stegny.2a.pl>
To: linux-kernel@vger.kernel.org
Subject: size of /proc/kcore is not the physical RAM size
Date: Fri, 13 May 2011 14:40:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105131440.44747.giecrilj@stegny.2a.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    
	Size of /proc/kcore is not the physical RAM size.
[2.] Full description of the problem/report:
	Size of /proc/kcore is not the physical RAM size.
[3.] Keywords (i.e., modules, networking, kernel):
	kcore, documentation
[4.] Kernel version (from /proc/version):
	Linux version 2.6.37.6-0.5-desktop (geeko@buildhost) (gcc version 4.5.1 20101208 [gcc-4_5-branch revision 167585] (SUSE Linux) ) #1 SMP PREEMPT 2011-04-25 21:48:33 +0200
[5.] Output of Oops.. message (if applicable) with symbolic information resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the problem (if possible)
	ll /proc/kcore
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux ne-1-26 2.6.37.6-0.5-desktop #1 SMP PREEMPT 2011-04-25 21:48:33 +0200 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.5
Gnu make               3.82
binutils               11.4
2.21
util-linux             scripts/ver_linux: line 23: fdformat: nie znaleziono polecenia
mount                  support
module-init-tools      polecenia
Linux C Library        2.11.3
Dynamic linker (ldd)   2.11.3
Procps                 3.2.8
Kbd                    1.15.2
Sh-utils               8.9
Modules Loaded         ip6t_LOG ipt_MASQUERADE xt_pkttype xt_TCPMSS xt_tcpudp ipt_LOG xt_limit iptable_nat nf_nat edd af_packet microcode ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack mperf ip6table_filter ip6_tables x_tables fuse dm_mod snd_intel8x0 sr_mod snd_ac97_codec ac97_bus 8139too firewire_ohci ppdev snd_pcm cdrom firewire_core crc_itu_t 8139cp iTCO_wdt iTCO_vendor_support parport_pc parport snd_timer floppy snd shpchp pcspkr i2c_i801 sg soundcore snd_page_alloc pci_hotplug ext4 jbd2 crc16 i915 drm_kms_helper drm i2c_algo_bit video button pata_acpi fan processor ata_generic thermal thermal_sys

[7.2.] Processor information (from /proc/cpuinfo):

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Celeron(R) CPU 2.53GHz
stepping        : 9
cpu MHz         : 2526.042
cache size      : 256 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc up pebs bts nopl pni dtes64 monitor ds_cpl tm2 cid cx16 xtpr lahf_lm
bogomips        : 5052.08
clflush size    : 64
cache_alignment : 128
address sizes   : 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

ip6t_LOG 9192 11 - Live 0xffffffffa0134000
ipt_MASQUERADE 2624 1 - Live 0xffffffffa012e000
xt_pkttype 1288 7 - Live 0xffffffffa00a4000
xt_TCPMSS 3635 1 - Live 0xffffffffa009e000
xt_tcpudp 3812 7 - Live 0xffffffffa0058000
ipt_LOG 8721 11 - Live 0xffffffffa0096000
xt_limit 2591 22 - Live 0xffffffffa004c000
iptable_nat 5847 1 - Live 0xffffffffa0030000
nf_nat 24179 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffffa003f000
edd 9664 0 - Live 0xffffffffa0011000
af_packet 23463 2 - Live 0xffffffffa04bb000
microcode 26647 0 - Live 0xffffffffa04ae000
ip6t_REJECT 4709 3 - Live 0xffffffffa04a7000
nf_conntrack_ipv6 9399 15 - Live 0xffffffffa049e000
nf_defrag_ipv6 11699 1 nf_conntrack_ipv6, Live 0xffffffffa0495000
ip6table_raw 1627 1 - Live 0xffffffffa048f000
xt_NOTRACK 1224 4 - Live 0xffffffffa0489000
ipt_REJECT 2640 3 - Live 0xffffffffa0483000
iptable_raw 1686 1 - Live 0xffffffffa047d000
iptable_filter 1946 1 - Live 0xffffffffa0477000
ip6table_mangle 2036 0 - Live 0xffffffffa0471000
nf_conntrack_netbios_ns 1822 0 - Live 0xffffffffa046b000
nf_conntrack_ipv4 10168 26 iptable_nat,nf_nat, Live 0xffffffffa0462000
nf_defrag_ipv4 1737 1 nf_conntrack_ipv4, Live 0xffffffffa045c000
ip_tables 22270 3 iptable_nat,iptable_raw,iptable_filter, Live 0xffffffffa0450000
xt_conntrack 2880 38 - Live 0xffffffffa043f000
nf_conntrack 88175 8 ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv6,xt_NOTRACK,nf_conntrack_netbios_ns,nf_conntrack_ipv4,xt_conntrack, Live 0xffffffffa0413000
mperf 1555 0 - Live 0xffffffffa040d000
ip6table_filter 1855 1 - Live 0xffffffffa0407000
ip6_tables 22656 4 ip6t_LOG,ip6table_raw,ip6table_mangle,ip6table_filter, Live 0xffffffffa03fb000
x_tables 28281 19 ip6t_LOG,ipt_MASQUERADE,xt_pkttype,xt_TCPMSS,xt_tcpudp,ipt_LOG,xt_limit,iptable_nat,ip6t_REJECT,ip6table_raw,xt_NOTRACK,ipt_REJECT,iptable_raw,iptable_filter,ip6table_mangle,ip_tables,xt_conntrack,ip6table_filter,ip6_tables, Live 0xffffffffa03ec000
fuse 80767 4 - Live 0xffffffffa03ce000
dm_mod 86272 0 - Live 0xffffffffa03ad000
snd_intel8x0 33045 2 - Live 0xffffffffa039d000
sr_mod 16781 0 - Live 0xffffffffa0392000
snd_ac97_codec 131492 1 snd_intel8x0, Live 0xffffffffa035b000
ac97_bus 1578 1 snd_ac97_codec, Live 0xffffffffa0355000
8139too 30960 0 - Live 0xffffffffa0346000
firewire_ohci 31271 0 - Live 0xffffffffa0329000
ppdev 9183 0 - Live 0xffffffffa0321000
snd_pcm 104468 2 snd_intel8x0,snd_ac97_codec, Live 0xffffffffa02fb000
cdrom 43280 1 sr_mod, Live 0xffffffffa02d7000
firewire_core 65247 1 firewire_ohci, Live 0xffffffffa02be000
crc_itu_t 1779 1 firewire_core, Live 0xffffffffa02b8000
8139cp 23939 0 - Live 0xffffffffa02a0000
iTCO_wdt 12266 0 - Live 0xffffffffa0297000
iTCO_vendor_support 3118 1 iTCO_wdt, Live 0xffffffffa0291000
parport_pc 37259 0 - Live 0xffffffffa027f000
parport 40234 2 ppdev,parport_pc, Live 0xffffffffa026d000
snd_timer 26774 1 snd_pcm, Live 0xffffffffa025f000
floppy 68461 0 - Live 0xffffffffa0245000
snd 84374 8 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer, Live 0xffffffffa0224000
shpchp 31135 0 - Live 0xffffffffa0215000
pcspkr 2190 0 - Live 0xffffffffa020f000
i2c_i801 10920 0 - Live 0xffffffffa0206000
sg 33426 0 - Live 0xffffffffa01e6000
soundcore 8782 1 snd, Live 0xffffffffa01e1000
snd_page_alloc 9569 2 snd_intel8x0,snd_pcm, Live 0xffffffffa00b5000
pci_hotplug 32310 1 shpchp, Live 0xffffffffa01d7000
ext4 398026 2 - Live 0xffffffffa015b000
jbd2 91654 1 ext4, Live 0xffffffffa0142000
crc16 1747 1 ext4, Live 0xffffffffa0007000
i915 461044 2 - Live 0xffffffffa00bb000
drm_kms_helper 36694 1 i915, Live 0xffffffffa00aa000
drm 232428 3 i915,drm_kms_helper, Live 0xffffffffa005b000
i2c_algo_bit 6342 1 i915, Live 0xffffffffa0054000
video 15929 1 i915, Live 0xffffffffa0039000
button 6829 1 i915, Live 0xffffffffa0048000
pata_acpi 4019 0 - Live 0xffffffffa0033000
fan 3215 0 - Live 0xffffffffa002d000
processor 39669 0 - Live 0xffffffffa001b000
ata_generic 3995 0 - Live 0xffffffffa0015000
thermal 14914 0 - Live 0xffffffffa000b000
thermal_sys 17462 4 video,fan,processor,thermal, Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
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
037b-037f : parport0
03c0-03df : vesafb
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
03f7-03f7 : floppy
03f8-03ff : serial
0400-047f : pnp 00:0c
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-0420 : ACPI PM2_CNT_BLK
  0428-042f : ACPI GPE0_BLK
  0430-0433 : iTCO_wdt
  0460-047f : iTCO_wdt
04d0-04d1 : pnp 00:0a
0500-053f : pnp 00:0c
0680-06ff : pnp 00:0c
0a10-0a1f : pnp 00:0a
0cf8-0cff : PCI conf1
b000-bfff : PCI Bus 0000:01
  b000-b07f : 0000:01:04.0
  b400-b4ff : 0000:01:03.0
    b400-b4ff : 8139too
  b800-b8ff : 0000:01:01.0
    b800-b8ff : 8139too
  bc00-bc07 : 0000:01:02.0
c400-c41f : 0000:00:1f.3
  c400-c41f : i801_smbus
c800-c81f : 0000:00:1d.0
  c800-c81f : uhci_hcd
cc00-cc1f : 0000:00:1d.1
  cc00-cc1f : uhci_hcd
d000-d01f : 0000:00:1d.2
  d000-d01f : uhci_hcd
d400-d41f : 0000:00:1d.3
  d400-d41f : uhci_hcd
d800-d80f : 0000:00:1f.2
  d800-d80f : ata_piix
dc00-dc03 : 0000:00:1f.2
  dc00-dc03 : ata_piix
e000-e007 : 0000:00:1f.2
  e000-e007 : ata_piix
e400-e403 : 0000:00:1f.2
  e400-e403 : ata_piix
e800-e807 : 0000:00:1f.2
  e800-e807 : ata_piix
ec00-ec07 : 0000:00:02.0
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffaf : ata_piix

00000000-0000ffff : reserved
00010000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000c0000-000d7fff : pnp 00:0d
000e6000-000fffff : reserved
00100000-3ef2ffff : System RAM
  01000000-0152dcc4 : Kernel code
  0152dcc5-01b28b0f : Kernel data
  01c1a000-01d97cfb : Kernel bss
3ef30000-3ef3ffff : ACPI Tables
3ef40000-3efeffff : ACPI Non-volatile Storage
3eff0000-3effffff : reserved
3f000000-3fffffff : RAM buffer
40000000-400003ff : 0000:00:1f.1
40004000-40007fff : i915 MCHBAR
f0000000-f7ffffff : 0000:00:02.0
f8000000-fbffffff : 0000:00:00.0
fec00000-fec003ff : IOAPIC 0
fecf0000-fecf0fff : reserved
  fecf0000-fecf0fff : 0000:00:06.0
fed20000-fed9ffff : reserved
  fed20000-fed9ffff : pnp 00:0c
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : pnp 00:0c
ff800000-ff8fffff : PCI Bus 0000:01
  ff8e0000-ff8effff : 0000:01:02.0
  ff8ff000-ff8ff7ff : 0000:01:04.0
    ff8ff000-ff8ff7ff : firewire_ohci
  ff8ff800-ff8ff8ff : 0000:01:03.0
    ff8ff800-ff8ff8ff : 8139too
  ff8ffc00-ff8ffcff : 0000:01:01.0
    ff8ffc00-ff8ffcff : 8139too
ffa7f400-ffa7f4ff : 0000:00:1f.5
  ffa7f400-ffa7f4ff : Intel ICH5
ffa7f800-ffa7f9ff : 0000:00:1f.5
  ffa7f800-ffa7f9ff : Intel ICH5
ffa7fc00-ffa7ffff : 0000:00:1d.7
  ffa7fc00-ffa7ffff : ehci_hcd
ffa80000-ffafffff : 0000:00:02.0

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub Interface (rev 02)
        Subsystem: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub Interface
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [e4] Vendor Specific Information: Len=06 <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at ec00 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [d0] Power Management version 1
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: i915

00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to I/O Memory Interface (rev 02)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Region 0: Memory at fecf0000 (32-bit, non-prefetchable) [size=4K]

00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at c800 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])                                                                                                            
        Subsystem: Intel Corporation Device 0c4a                                                                                                                                                                                 
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-                                                                                                                    
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-                                                                                                                   
        Latency: 0                                                                                                                                                                                                               
        Interrupt: pin B routed to IRQ 19                                                                                                                                                                                        
        Region 4: I/O ports at cc00 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at d000 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at d400 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at ffa7fc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: ff800000-ff8fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-

00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ffa0 [size=16]
        Region 5: Memory at 40000000 (32-bit, non-prefetchable) [size=1K]
        Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at e800 [size=8]
        Region 1: I/O ports at e400 [size=4]
        Region 2: I/O ports at e000 [size=8]
        Region 3: I/O ports at dc00 [size=4]
        Region 4: I/O ports at d800 [size=16]
        Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at c400 [size=32]
        Kernel driver in use: i801_smbus

00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 2: Memory at ffa7f800 (32-bit, non-prefetchable) [size=512]
        Region 3: Memory at ffa7f400 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: Intel ICH

01:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at b800 [size=256]
        Region 1: Memory at ff8ffc00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: 8139too

01:02.0 Communication controller: Conexant Systems, Inc. HSF 56k Data/Fax/Voice/Spkp (w/Handset) Modem (WorldW SmartDAA) (rev 01)
        Subsystem: Conexant Systems, Inc. Generic SoftK56
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at ff8e0000 (32-bit, non-prefetchable) [size=64K]
        Region 1: I/O ports at bc00 [size=8]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

01:03.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Intel Corporation Device 0c4a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: I/O ports at b400 [size=256]
        Region 1: Memory at ff8ff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: 8139too

01:04.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev 46) (prog-if 10 [OHCI])
        Subsystem: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (8000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at ff8ff000 (32-bit, non-prefetchable) [size=2K]
        Region 1: I/O ports at b000 [size=128]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: firewire_ohci


[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Maxtor 6L080P0   Rev: BAH4
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: IBM-DPTA-372050  Rev: P76O
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-H10N  Rev: JL12
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: HL-DT-ST Model: CD-ROM GCR-8520B Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
/proc/kcore  
 This file represents the physical memory of the system and is stored in the ELF core file format. With this pseudo-file, and an unstripped kernel (/usr/src/linux/vmlinux) binary, GDB can be used to examine the current state of any kernel data structures. 
 The total length of the file is the size of physical memory (RAM) plus 4KB.
