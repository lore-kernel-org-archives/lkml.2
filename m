Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1CJNI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:08:58 -0500
Received: from web38002.mail.mud.yahoo.com ([209.191.124.113]:41539 "HELO
	web38002.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751852Ab1CJNI4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:08:56 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 08:08:56 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=DIL786bcftz1T4HcyKIkttviAdfwNAI3e0HRfh3vtlgXoFqIllOr5MGpemubesf4XkV4msGgoMTJuBDMnJZr7MDPv2vC/csBPakweBUloNHaBZ8XqriYRvyWDFD1mYAPz5Gzru+jb5VyHZTOMPyg5wwO8OPsU55bGZ7syuxI800=;
Message-ID: <15741.74093.qm@web38002.mail.mud.yahoo.com>
X-YMail-OSG: mNh8DCkVM1mnaBSREUVxfNr9B8RnIjaUGSmqxgP2Imt03QI
 LJjSlsyqGPrwFt.NZixKK8zLFC4OvPS2lt_2zOY3ECFMugkcRueOHssgBNhF
 YO2GYbuZ5ugDq_q2gr1eo.wgz76yFQz6rjM28nNWXzZ98ZAna4_ZmeeUZtzx
 mVu1hypjl7PCOOJTXtur3K7D8IiYNCOCoXT2xikBFiMAkUmAD4xMj8x68440
 ZnF8emmQUiDhet0xBomthyKX1nr5hxbCZ9fgkigg8thdnz0vlxLMSzEU0pHz
 o465JmwK0o2xILwIIs1UolFfMSSkiU0m9TIibRGzvF.7aMu1yTWd2IinyLdK
 JVYOsWBZ_bat9KS5XUA5gDi_sWgcR0LiQAqPkvYpso0qjkb.xFcjz_A--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Thu, 10 Mar 2011 05:02:13 -0800 (PST)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: PROBLEM: Bugtrace STA Ralink driver
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. After upgrading kernel i caught some bugtrace in messages
2. Bugtrace about my pci wi-fi card ralink 30xx, but card continiue work OK
3. Modules, kernel
4. Linux version 2.6.37.3-smp (root@darkstar) (gcc version 4.5.2 (GCC) ) #4 SMP Wed Mar 9 21:31:44 YEKT 2011
5. Mar 10 17:10:16 darkstar kernel: ------------[ cut here ]------------
Mar 10 17:10:16 darkstar kernel: WARNING: at include/linux/netdevice.h:1557 RtmpPhyNetDevInit+0xd0/0xe0 [rt3562sta]()
Mar 10 17:10:16 darkstar kernel: Hardware name: System Product Name
Mar 10 17:10:16 darkstar kernel: Modules linked in: rt3562sta(P+)
Mar 10 17:10:16 darkstar kernel: Pid: 1014, comm: modprobe Tainted: P            2.6.37.3-smp #4
Mar 10 17:10:16 darkstar kernel: Call Trace:
Mar 10 17:10:16 darkstar kernel:  [<c1031bb8>] ? warn_slowpath_common+0x78/0xb0
Mar 10 17:10:16 darkstar kernel:  [<f826d2a0>] ? RtmpPhyNetDevInit+0xd0/0xe0 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f826d2a0>] ? RtmpPhyNetDevInit+0xd0/0xe0 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<c1031c0b>] ? warn_slowpath_null+0x1b/0x20
Mar 10 17:10:16 darkstar kernel:  [<f826d2a0>] ? RtmpPhyNetDevInit+0xd0/0xe0 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f8284264>] ? rt2860_probe+0x2b5/0x48b [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f826e1c0>] ? MainVirtualIF_open+0x0/0x100 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f826dc60>] ? MainVirtualIF_close+0x0/0x1c0 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f826d330>] ? rt28xx_send_packets+0x0/0x50 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f826d1b0>] ? rt28xx_ioctl+0x0/0x20 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<f826c9b0>] ? RT28xx_get_ether_stats+0x0/0x120 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<c10edc7b>] ? sysfs_do_create_link+0xbb/0x1d0
Mar 10 17:10:16 darkstar kernel:  [<c11c9a02>] ? local_pci_probe+0x42/0xb0
Mar 10 17:10:16 darkstar kernel:  [<c11ca071>] ? pci_device_probe+0x61/0x80
Mar 10 17:10:16 darkstar kernel:  [<c1246447>] ? driver_probe_device+0x77/0x170
Mar 10 17:10:16 darkstar kernel:  [<c11c9910>] ? pci_match_device+0x10/0xa0
Mar 10 17:10:16 darkstar kernel:  [<c12465b9>] ? __driver_attach+0x79/0x80
Mar 10 17:10:16 darkstar kernel:  [<c1246540>] ? __driver_attach+0x0/0x80
Mar 10 17:10:16 darkstar kernel:  [<c124574b>] ? bus_for_each_dev+0x4b/0x70
Mar 10 17:10:16 darkstar kernel:  [<c11c9f00>] ? pci_device_remove+0x0/0xf0
Mar 10 17:10:16 darkstar kernel:  [<c1246196>] ? driver_attach+0x16/0x20
Mar 10 17:10:16 darkstar kernel:  [<c1246540>] ? __driver_attach+0x0/0x80
Mar 10 17:10:16 darkstar kernel:  [<c1245e97>] ? bus_add_driver+0x177/0x250
Mar 10 17:10:16 darkstar kernel:  [<c11c9f00>] ? pci_device_remove+0x0/0xf0
Mar 10 17:10:16 darkstar kernel:  [<c124679f>] ? driver_register+0x5f/0x100
Mar 10 17:10:16 darkstar kernel:  [<c11ca28d>] ? __pci_register_driver+0x3d/0xb0
Mar 10 17:10:16 darkstar kernel:  [<c1001203>] ? do_one_initcall+0x33/0x170
Mar 10 17:10:16 darkstar kernel:  [<c109a458>] ? __vunmap+0xa8/0xe0
Mar 10 17:10:16 darkstar kernel:  [<f8023000>] ? rt2860_init_module+0x0/0x14 [rt3562sta]
Mar 10 17:10:16 darkstar kernel:  [<c105dcfb>] ? sys_init_module+0x13b/0x18b0
Mar 10 17:10:16 darkstar kernel:  [<c14a2f4d>] ? syscall_call+0x7/0xb
Mar 10 17:10:16 darkstar kernel: ---[ end trace a6dbdd1964a4bf1d ]---
6. -
7. cat /etc/slackware-version 
Slackware 13.1.0
7.1 If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux darkstar 2.6.37.3-smp #4 SMP Wed Mar 9 21:31:44 YEKT 2011 i686 AMD Athlon(tm) II X2 240 Processor AuthenticAMD GNU/Linux
 
Gnu C                  4.5.2
Gnu make               3.82
binutils               2.21.51.0.6.20110118
util-linux             2.19
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.14
jfsutils               1.1.14
reiserfsprogs          3.6.21
xfsprogs               3.1.3
pcmciautils            017
quota-tools            3.17.
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Linux C++ Library      6.0.14
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
oprofile               0.9.6
Sh-utils               8.10
wireless-tools         29
Modules Loaded         nvidia rt3562sta
7.2  cat /proc/cpuinfo 
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 6
model name    : AMD Athlon(tm) II X2 240 Processor
stepping    : 2
cpu MHz        : 2813.003
cache size    : 1024 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt npt lbrv svm_lock nrip_save
bogomips    : 5626.00
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor    : 1
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 6
model name    : AMD Athlon(tm) II X2 240 Processor
stepping    : 2
cpu MHz        : 2813.003
cache size    : 1024 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 5
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt npt lbrv svm_lock nrip_save
bogomips    : 5625.44
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
7.3 cat /proc/modules 
nvidia 9233162 28 - Live 0xf8d25000 (P)
rt3562sta 855813 1 - Live 0xf81db000 (P)
7.4. cat /proc/ioports 
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:06.0
  01f0-01f7 : 0000:00:06.0
  0230-023f : pnp 00:09
  0290-029f : pnp 00:09
  0376-0376 : 0000:00:06.0
  03c0-03df : vga+
  03f6-03f6 : 0000:00:06.0
  04d0-04d1 : pnp 00:05
  0500-057f : pnp 00:05
    0500-0503 : ACPI PM1a_EVT_BLK
    0504-0505 : ACPI PM1a_CNT_BLK
    0508-050b : ACPI PM_TMR
    0510-0515 : ACPI CPU throttle
    0520-0527 : ACPI GPE0_BLK
  0580-05ff : pnp 00:05
  0600-063f : 0000:00:01.1
  0700-073f : 0000:00:01.1
    0700-073f : nForce2_smbus
  0800-080f : pnp 00:05
  0880-08ff : pnp 00:05
    08a0-08af : ACPI GPE1_BLK
  0900-09ff : 0000:00:01.0
  0a00-0a0f : pnp 00:09
  0a30-0a3f : pnp 00:09
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  0d00-0d7f : pnp 00:05
  0d80-0dff : pnp 00:05
  0e00-0e3f : 0000:00:01.1
  1100-117f : pnp 00:05
  1180-11ff : pnp 00:05
  d000-d00f : 0000:00:08.1
    d000-d00f : sata_nv
  d080-d083 : 0000:00:08.1
    d080-d083 : sata_nv
  d400-d407 : 0000:00:08.1
    d400-d407 : sata_nv
  d480-d483 : 0000:00:08.1
    d480-d483 : sata_nv
  d800-d807 : 0000:00:08.1
    d800-d807 : sata_nv
  d880-d88f : 0000:00:08.0
    d880-d88f : sata_nv
  dc00-dc03 : 0000:00:08.0
    dc00-dc03 : sata_nv
  e000-e007 : 0000:00:08.0
    e000-e007 : sata_nv
  e080-e083 : 0000:00:08.0
    e080-e083 : sata_nv
  e400-e407 : 0000:00:08.0
    e400-e407 : sata_nv
  e480-e487 : 0000:00:07.0
    e480-e487 : forcedeth
  ffa0-ffaf : 0000:00:06.0
 cat /proc/iomem 
00000000-0000ffff : reserved
00010000-0009b3ff : System RAM
0009b400-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000cebff : Video ROM
000d0000-000dffff : PCI Bus 0000:00
  000d0000-000d3fff : pnp 00:05
  000d4000-000d7fff : pnp 00:05
  000de000-000dffff : pnp 00:05
000e2000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-aff9ffff : System RAM
  01000000-014a4200 : Kernel code
  014a4201-01667c37 : Kernel data
  016c4000-016f65d3 : Kernel bss
affa0000-affb7fff : ACPI Tables
affb8000-affdffff : ACPI Non-volatile Storage
affe0000-affedfff : reserved
affee000-affeffff : RAM buffer
afff0000-afffffff : reserved
b0000000-dfffffff : PCI Bus 0000:00
  b0000000-bfffffff : pnp 00:07
  c0000000-cfffffff : 0000:00:0d.0
  dd000000-ddffffff : 0000:00:0d.0
  de000000-deffffff : 0000:00:0d.0
    de000000-deffffff : nvidia
  dfec0000-dfedffff : 0000:00:0d.0
  dfeef000-dfeeffff : 0000:00:08.1
    dfeef000-dfeeffff : sata_nv
  dfef4000-dfef7fff : 0000:00:05.0
    dfef4000-dfef7fff : ICH HD audio
  dfef8000-dfef8fff : 0000:00:08.0
    dfef8000-dfef8fff : sata_nv
  dfef9000-dfef9fff : 0000:00:07.0
    dfef9000-dfef9fff : forcedeth
  dfefac00-dfefacff : 0000:00:02.1
    dfefac00-dfefacff : ehci_hcd
  dfefb000-dfefbfff : 0000:00:02.0
    dfefb000-dfefbfff : ohci_hcd
  dff00000-dfffffff : PCI Bus 0000:01
    dfff0000-dfffffff : 0000:01:06.0
      dfff0000-dfffffff : 0000:01:06.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
  e0000000-efffffff : pnp 00:0a
f0000000-febfffff : PCI Bus 0000:00
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:07
  fee01000-feefffff : pnp 00:05
fefe0000-fefe01ff : pnp 00:05
fefe1000-fefe1fff : pnp 00:05
fff00000-ffffffff : reserved
7.5. lspci -vvv
00:00.0 RAM memory: nVidia Corporation MCP61 LPC Bridge (rev a1)
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Capabilities: [44] HyperTransport: Slave or Primary Interface
        Command: BaseUnitID=0 UnitCnt=17 MastHost- DefDir- DUL-
        Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=1 IsocEn- LSEn- ExtCTL- 64b-
        Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
        Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
        Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
        Revision ID: 1.03
        Link Frequency 0: 1.0GHz
        Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
        Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
        Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
        Link Frequency 1: 200MHz
        Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
        Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
        Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
        Prefetchable memory behind bridge Upper: 00-00
        Bus Number: 00
    Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
        Mapping Address Base: 00000000fee00000

00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Region 0: I/O ports at 0900 [size=256]

00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 10
    Region 0: I/O ports at 0e00 [size=64]
    Region 4: I/O ports at 0600 [size=64]
    Region 5: I/O ports at 0700 [size=64]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: nForce2_smbus

00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3) (prog-if 10 [OHCI])
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin A routed to IRQ 23
    Region 0: Memory at dfefb000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ohci_hcd

00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3) (prog-if 20 [EHCI])
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin B routed to IRQ 20
    Region 0: Memory at dfefac00 (32-bit, non-prefetchable) [size=256]
    Capabilities: [44] Debug port: BAR=1 offset=0098
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ehci_hcd

00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1) (prog-if 01 [Subtractive decode])
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: dff00000-dfffffff
    Prefetchable memory behind bridge: fff00000-000fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
    Capabilities: [b8] Subsystem: ASUSTeK Computer Inc. Device 83a4
    Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000

00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio (rev a2)
    Subsystem: ASUSTeK Computer Inc. Device 8415
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (500ns min, 1250ns max)
    Interrupt: pin B routed to IRQ 22
    Region 0: Memory at dfef4000 (32-bit, non-prefetchable) [size=16K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
        Address: 0000000000000000  Data: 0000
        Masking: 00000000  Pending: 00000000
    Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
    Kernel driver in use: HDA Intel

00:06.0 IDE interface: nVidia Corporation MCP61 IDE (rev a2) (prog-if 8a [Master SecP PriP])
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
    Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
    Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
    Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
    Region 4: I/O ports at ffa0 [size=16]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (250ns min, 5000ns max)
    Interrupt: pin A routed to IRQ 40
    Region 0: Memory at dfef9000 (32-bit, non-prefetchable) [size=4K]
    Region 1: I/O ports at e480 [size=8]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit+
        Address: 00000000fee0300c  Data: 4169
        Masking: 000000fe  Pending: 00000000
    Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
    Kernel driver in use: forcedeth

00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin A routed to IRQ 23
    Region 0: I/O ports at e400 [size=8]
    Region 1: I/O ports at e080 [size=4]
    Region 2: I/O ports at e000 [size=8]
    Region 3: I/O ports at dc00 [size=4]
    Region 4: I/O ports at d880 [size=16]
    Region 5: Memory at dfef8000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
    Kernel driver in use: sata_nv

00:08.1 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin B routed to IRQ 22
    Region 0: I/O ports at d800 [size=8]
    Region 1: I/O ports at d480 [size=4]
    Region 2: I/O ports at d400 [size=8]
    Region 3: I/O ports at d080 [size=4]
    Region 4: I/O ports at d000 [size=16]
    Region 5: Memory at dfeef000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [b0] MSI: Enable- Count=1/4 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
    Kernel driver in use: sata_nv

00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
    Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: nVidia Corporation Device 0000
    Capabilities: [48] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #  1, PowerLimit 75.000000; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100] Virtual Channel <?>

00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
    Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: nVidia Corporation Device 0000
    Capabilities: [48] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #  2, PowerLimit 10.000000; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100] Virtual Channel <?>

00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
    Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
    Capabilities: [40] Subsystem: nVidia Corporation Device 0000
    Capabilities: [48] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Mapping Address Base: 00000000fee00000
    Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
        DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- RBE+ FLReset-
        DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
            ClockPM- Surprise- LLActRep+ BwNot-
        LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
            Slot #  3, PowerLimit 10.000000; Interlock- NoCompl-
        SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
            Control: AttnInd Off, PwrInd On, Power- Interlock-
        SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
            Changed: MRL- PresDet- LinkState-
        RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
        RootCap: CRSVisible-
        RootSta: PME ReqID 0000, PMEStatus- PMEPending-
    Capabilities: [100] Virtual Channel <?>

00:0d.0 VGA compatible controller: nVidia Corporation C61 [GeForce 7025 / nForce 630a] (rev a2) (prog-if 00 [VGA controller])
    Subsystem: ASUSTeK Computer Inc. Device 83a4
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 21
    Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
    Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
    Region 3: Memory at dd000000 (64-bit, non-prefetchable) [size=16M]
    [virtual] Expansion ROM at dfec0000 [disabled] [size=128K]
    Capabilities: [48] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Kernel driver in use: nvidia
    Kernel modules: nvidia

00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [80] HyperTransport: Host or Secondary Interface
        Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
        Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
        Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
        Revision ID: 3.00
        Link Frequency: 1.0GHz
        Link Error: <Prot- <Ovfl- <EOC- CTLTm-
        Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
        Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:06.0 Network controller: RaLink Device 3060
    Subsystem: D-Link System Inc Device 3c04
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at dfff0000 (32-bit, non-prefetchable) [size=64K]
    Capabilities: [40] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: rt2860
    Kernel modules: rt3562sta
7.6. cat /proc/scsi/scsi 
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3250318AS      Rev: CC46
  Type:   Direct-Access                    ANSI  SCSI revision: 05
7.7. -
X. Earlier on 2.6.36.11 Longterm this bugtrace doesnt appear, this bugtrace appear only in 2.6.37.3 Kernel.

Your sincerely, Denis Lotarev


      
