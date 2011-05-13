Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1EMVru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:47:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51841 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1EMVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=InXMjLOpQixUkg0MhZvHq85wnftGw2k3cqt21itHWqUqeal19QHn7TF8G6pX/pCWcy
         LGn43hrEN4/EuU4S5oUKgwzWGyN3uS6Tp9HNd/OqmGU6bZeTcDR0fBBPUPhjDdPSGG21
         2g4f0xhjmMfpH1Fm6fcq6l6/MQPsMxzBNfzcU=
MIME-Version: 1.0
Date: Fri, 13 May 2011 14:47:46 -0700
Message-ID: <BANLkTi=kHfbTGLPs+rsws0hrOaHs5HpeQw@mail.gmail.com>
Subject: PROBLEM: Freeze till mouse moved or key pressed
From: Thomas Suckow <tsuckow@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:
System freezes till mouse moved or key pressed.

[2.] Full description of the problem/report:
At random the system will freeze.  Moving the mouse or pressing a key
(including power button) will cause the system to continue operating
for a while. No logs indicate a problem (except time sensitive tasks,
eg Wireless).

[3.] Keywords (i.e., modules, networking, kernel):
Kernel

[4.] Kernel version (from /proc/version):
Linux version 2.6.35.13-91.fc14.i686
(mockbuild@x86-16.phx2.fedoraproject.org) (gcc version 4.5.1 20100924
(Red Hat 4.5.1-4) (GCC) ) #1 SMP Tue May 3 13:36:36 UTC 2011

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
N/A

[6.] A small shell script or example program which triggers the
     problem (if possible)
N/A

[7.] Environment
Acer Aspire 5004
Acer Aspire 3003WLMi

[7.1.] Software (add the output of the ver_linux script here)
?

[7.2.] Processor information (from /proc/cpuinfo):
Aspire 3003:
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 28
model name      : Mobile AMD Sempron(tm) Processor 3000+
stepping        : 0
cpu MHz         : 800.000
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt
3dnowext 3dnow up lahf_lm arat
bogomips        : 1600.17
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 32 bits virtual
power management: ts fid vid ttp

Aspire 5004
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 36
model name	: AMD Turion(tm) 64 Mobile Technology ML-34
stepping	: 2
cpu MHz		: 800.000
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat
pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext
3dnow up pni lahf_lm arat
bogomips	: 1599.97
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


[7.3.] Module information (from /proc/modules):
tcp_lp 1779 0 - Live 0xf7887000
usb_storage 35815 0 - Live 0xf78c1000
fuse 51887 3 - Live 0xf789c000
aes_i586 7138 0 - Live 0xf7863000
aes_generic 26460 1 aes_i586, Live 0xf787e000
tun 11054 2 - Live 0xf816f000
sit 8531 0 - Live 0xf8160000
tunnel4 2005 1 sit, Live 0xf8154000
sunrpc 165546 1 - Live 0xf8116000
cpufreq_ondemand 7262 1 - Live 0xf80da000
powernow_k8 14270 0 - Live 0xf80cb000
mperf 1141 1 powernow_k8, Live 0xf80bd000
ip6t_REJECT 3470 2 - Live 0xf80a5000
nf_conntrack_ipv6 14441 6 - Live 0xf8097000
ip6table_filter 1207 1 - Live 0xf8086000
ip6_tables 9937 1 ip6table_filter, Live 0xf807a000
ipv6 229581 52 sit,ip6t_REJECT,nf_conntrack_ipv6, Live 0xf8028000
uinput 5228 0 - Live 0xf7df6000
arc4 1085 2 - Live 0xf7de2000
ecb 1595 2 - Live 0xf7dd9000
b43 144936 0 - Live 0xf7da6000
snd_intel8x0 23144 2 - Live 0xf7d69000
snd_intel8x0m 9516 0 - Live 0xf7d54000
mac80211 188720 1 b43, Live 0xf7c8c000
snd_ac97_codec 89730 2 snd_intel8x0,snd_intel8x0m, Live 0xf7d2d000
ac97_bus 922 1 snd_ac97_codec, Live 0xf7c3f000
snd_seq 43435 0 - Live 0xf7c04000
snd_seq_device 5056 1 snd_seq, Live 0xf7bdf000
snd_pcm 61769 3 snd_intel8x0,snd_intel8x0m,snd_ac97_codec, Live 0xf7b8f000
cfg80211 111003 2 b43,mac80211, Live 0xf7b50000
rfkill 13652 1 cfg80211, Live 0xf7b20000
ssb 42089 1 b43, Live 0xf7b00000
snd_timer 15435 2 snd_seq,snd_pcm, Live 0xf7ad2000
mmc_core 53226 2 b43,ssb, Live 0xf7ab3000
snd 47397 11 snd_intel8x0,snd_intel8x0m,snd_ac97_codec,snd_seq,snd_seq_device,snd_pcm,snd_timer,
Live 0xf7a89000
soundcore 5088 1 snd, Live 0xf7a47000
sis900 15063 0 - Live 0xf7a38000
i2c_sis96x 4651 0 - Live 0xf7a29000
mii 3578 1 sis900, Live 0xf7a1e000
snd_page_alloc 6180 3 snd_intel8x0,snd_intel8x0m,snd_pcm, Live 0xf7a07000
i2c_core 21552 1 i2c_sis96x, Live 0xf79f5000
k8temp 2971 0 - Live 0xf79e5000
joydev 7306 0 - Live 0xf79da000
microcode 11149 0 - Live 0xf79cb000
pata_acpi 2331 0 - Live 0xf7871000
ata_generic 2399 0 - Live 0xf7867000
yenta_socket 20882 0 - Live 0xf7853000
pata_sis 7973 2 - Live 0xf7841000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
Aspire 3003
0000-ffff : PCI Bus #00
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
  0170-0177 : 0000:00:02.5
    0170-0177 : pata_sis
  01f0-01f7 : 0000:00:02.5
    01f0-01f7 : pata_sis
  0376-0376 : 0000:00:02.5
    0376-0376 : pata_sis
  03c0-03df : vga+
  03f0-03f1 : pnp 00:04
  03f6-03f6 : 0000:00:02.5
    03f6-03f6 : pata_sis
  04d0-04d1 : pnp 00:04
  0cf8-0cff : PCI conf1
  1000-10ff : 0000:00:02.6
    1000-10ff : SiS SI7013 Modem
  1400-14ff : 0000:00:02.7
    1400-14ff : SiS SI7012
  1800-18ff : 0000:00:04.0
    1800-18ff : sis900
  1c00-1c7f : 0000:00:02.6
    1c00-1c7f : SiS SI7013 Modem
  1c80-1cff : 0000:00:02.7
    1c80-1cff : SiS SI7012
  2000-200f : 0000:00:02.5
    2000-200f : pata_sis
  2400-24ff : PCI CardBus 0000:02
  2800-28ff : PCI CardBus 0000:02
  8000-807f : pnp 00:04
    8000-8003 : ACPI PM1a_EVT_BLK
    8004-8005 : ACPI PM1a_CNT_BLK
    8008-800b : ACPI PM_TMR
    8010-8015 : ACPI CPU throttle
    8016-8016 : ACPI PM2_CNT_BLK
    8020-8023 : ACPI GPE0_BLK
    8030-8033 : ACPI GPE1_BLK
  8080-80ff : pnp 00:04
  8100-811f : 0000:00:02.1
    8100-811f : pnp 00:04
      8100-811f : sis96x_smbus
  a000-afff : PCI Bus 0000:01
    a000-a07f : 0000:01:00.0


00000000-00000fff : reserved
00001000-0009f3ff : System RAM
0009f400-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
  000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000dc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-4deeffff : System RAM
  00400000-007ae12d : Kernel code
  007ae12e-00a1ce6f : Kernel data
  00aa8000-00c2c8ff : Kernel bss
4def0000-4def9fff : ACPI Tables
4defa000-4defffff : ACPI Non-volatile Storage
4df00000-4fffffff : reserved
50000000-ffffffff : PCI Bus #00
  50000000-53ffffff : PCI CardBus 0000:02
  54000000-57ffffff : PCI CardBus 0000:02
  58000000-5801ffff : 0000:00:04.0
  58020000-58020fff : 0000:00:06.0
    58020000-58020fff : yenta_socket
  e0000000-e1ffffff : 0000:00:00.0
    e0000000-e1ffffff : aperture
  e2000000-e2001fff : 0000:00:0b.0
    e2000000-e2001fff : 0000:00:0b.0
  e2002000-e2002fff : 0000:00:03.0
    e2002000-e2002fff : ohci_hcd
  e2003000-e2003fff : 0000:00:03.1
    e2003000-e2003fff : ohci_hcd
  e2004000-e2004fff : 0000:00:03.2
    e2004000-e2004fff : ehci_hcd
  e2005000-e2005fff : 0000:00:04.0
    e2005000-e2005fff : sis900
  e2100000-e21fffff : PCI Bus 0000:01
    e2100000-e211ffff : 0000:01:00.0
  e8000000-efffffff : PCI Bus 0000:01
    e8000000-efffffff : 0000:01:00.0
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : pnp 00:04
  fee00000-feefffff : pnp 00:04
    fee00000-fee00fff : Local APIC
  ffc00000-ffc00fff : pnp 00:04
  ffe00000-ffe00fff : pnp 00:04
  ffe80000-ffefffff : pnp 00:04
  fff00000-ffffffff : reserved
    fffe0000-fffeffff : pnp 00:04
    ffff0000-ffffffff : pnp 00:04


Aspire 5004
0000-ffff : PCI Bus #00
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
  0170-0177 : 0000:00:02.5
    0170-0177 : pata_sis
  01f0-01f7 : 0000:00:02.5
    01f0-01f7 : pata_sis
  0376-0376 : 0000:00:02.5
    0376-0376 : pata_sis
  03c0-03df : vga+
  03f0-03f1 : pnp 00:04
  03f6-03f6 : 0000:00:02.5
    03f6-03f6 : pata_sis
  04d0-04d1 : pnp 00:04
  0cf8-0cff : PCI conf1
  1000-10ff : 0000:00:02.6
    1000-10ff : SiS SI7013 Modem
  1400-14ff : 0000:00:02.7
    1400-14ff : SiS SI7012
  1800-18ff : 0000:00:04.0
    1800-18ff : sis900
  1c00-1c7f : 0000:00:02.6
    1c00-1c7f : SiS SI7013 Modem
  1c80-1cff : 0000:00:02.7
    1c80-1cff : SiS SI7012
  2000-200f : 0000:00:02.5
    2000-200f : pata_sis
  2400-24ff : PCI CardBus 0000:02
  2800-28ff : PCI CardBus 0000:02
  8000-807f : pnp 00:04
    8000-8003 : ACPI PM1a_EVT_BLK
    8004-8005 : ACPI PM1a_CNT_BLK
    8008-800b : ACPI PM_TMR
    8010-8015 : ACPI CPU throttle
    8016-8016 : ACPI PM2_CNT_BLK
    8020-8023 : ACPI GPE0_BLK
    8030-8033 : ACPI GPE1_BLK
  8080-80ff : pnp 00:04
  8100-811f : 0000:00:02.1
    8100-811f : pnp 00:04
      8100-811f : sis96x_smbus
  a000-afff : PCI Bus 0000:01
    a000-a07f : 0000:01:00.0

00000000-00000fff : reserved
00001000-0009f3ff : System RAM
0009f400-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
  000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000dc000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3beeffff : System RAM
  00400000-007ae12d : Kernel code
  007ae12e-00a1ce6f : Kernel data
  00aa8000-00c2c8ff : Kernel bss
3bef0000-3bef9fff : ACPI Tables
3befa000-3befffff : ACPI Non-volatile Storage
3bf00000-3fffffff : reserved
40000000-ffffffff : PCI Bus #00
  40000000-43ffffff : PCI CardBus 0000:02
  44000000-47ffffff : PCI CardBus 0000:02
  48000000-4801ffff : 0000:00:04.0
  48020000-48020fff : 0000:00:06.0
    48020000-48020fff : yenta_socket
  e0000000-e1ffffff : 0000:00:00.0
    e0000000-e1ffffff : aperture
  e2000000-e2001fff : 0000:00:0b.0
    e2000000-e2001fff : 0000:00:0b.0
  e2002000-e2002fff : 0000:00:03.0
    e2002000-e2002fff : ohci_hcd
  e2003000-e2003fff : 0000:00:03.1
    e2003000-e2003fff : ohci_hcd
  e2004000-e2004fff : 0000:00:03.2
    e2004000-e2004fff : ehci_hcd
  e2005000-e2005fff : 0000:00:04.0
    e2005000-e2005fff : sis900
  e2100000-e21fffff : PCI Bus 0000:01
    e2100000-e211ffff : 0000:01:00.0
  e8000000-efffffff : PCI Bus 0000:01
    e8000000-efffffff : 0000:01:00.0
  fec00000-fec003ff : IOAPIC 0
  fed00000-fed003ff : pnp 00:04
  fee00000-feefffff : pnp 00:04
    fee00000-fee00fff : Local APIC
  ffc00000-ffc00fff : pnp 00:04
  ffe00000-ffe00fff : pnp 00:04
  ffe80000-ffefffff : pnp 00:04
  fff00000-ffffffff : reserved
    fffe0000-fffeffff : pnp 00:04
    ffff0000-ffffffff : pnp 00:04

[7.5.] PCI information ('lspci -vvv' as root)
Aspire 3003
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 760/M760 Host (rev 03)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 64
        Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=32M]
        Capabilities: <access denied>
        Kernel driver in use: agpgart-amd64

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SG86C202 (prog-if
00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 99
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: e2100000-e21fffff
        Prefetchable memory behind bridge: e8000000-efffffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL
Media IO] (rev 25)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin B routed to IRQ 0
        Region 4: I/O ports at 8100 [size=32]
        Kernel driver in use: sis96x_smbus
        Kernel modules: i2c-sis96x

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE]
(prog-if 80 [Master])
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 128
        Interrupt: pin ? routed to IRQ 16
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [size=1]
        Region 4: I/O ports at 2000 [size=16]
        Kernel driver in use: pata_sis
        Kernel modules: pata_sis

00:02.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem Controller
(rev a0) (prog-if 00 [Generic])
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 173 (13000ns min, 2750ns max)
        Interrupt: pin C routed to IRQ 18
        Region 0: I/O ports at 1000 [size=256]
        Region 1: I/O ports at 1c00 [size=128]
        Capabilities: <access denied>
        Kernel driver in use: Intel ICH Modem
        Kernel modules: snd-intel8x0m

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
AC'97 Sound Controller (rev a0)
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 173 (13000ns min, 2750ns max)
        Interrupt: pin C routed to IRQ 18
        Region 0: I/O ports at 1400 [size=256]
        Region 1: I/O ports at 1c80 [size=128]
        Capabilities: <access denied>
        Kernel driver in use: Intel ICH
        Kernel modules: snd-intel8x0

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (20000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e2002000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (20000ns max)
        Interrupt: pin B routed to IRQ 21
        Region 0: Memory at e2003000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: ohci_hcd

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 2.0
Controller (prog-if 20 [EHCI])
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (20000ns max)
        Interrupt: pin D routed to IRQ 23
        Region 0: Memory at e2004000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel driver in use: ehci_hcd

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900
PCI Fast Ethernet (rev 91)
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 173 (13000ns min, 2750ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: I/O ports at 1800 [size=256]
        Region 1: Memory at e2005000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 58000000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: sis900
        Kernel modules: sis900

00:06.0 CardBus bridge: Texas Instruments PCI1410 PC card Cardbus
Controller (rev 02)
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at 58020000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
        Memory window 0: 50000000-53fff000 (prefetchable)
        Memory window 1: 54000000-57fff000
        I/O window 0: 00002400-000024ff
        I/O window 1: 00002800-000028ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus
        Kernel modules: yenta_socket

00:0b.0 Network controller: Broadcom Corporation BCM4318 [AirForce One
54g] 802.11g Wireless LAN Controller (rev 02)
        Subsystem: AMBIT Microsystem Corp. TravelMate 2410
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at e2000000 (32-bit, non-prefetchable) [size=8K]
        Kernel driver in use: b43-pci-bridge
        Kernel modules: ssb

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Capabilities: <access denied>

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Kernel driver in use: k8temp
        Kernel modules: k8temp

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display Adapter (prog-if 00
[VGA controller])
        Subsystem: Acer Incorporated [ALI] Device 0083
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 7
        BIST result: 00
        Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at e2100000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at a000 [size=128]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>

Aspire 5004
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 760/M760 Host (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 64
	Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=32M]
	Capabilities: [a0] AGP version 3.0
		Status: RQ=32 Iso- ArqSz=2 Cal=3 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [d0] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=9 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC+ TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=N/C DwFcIn- MLWO=N/C DwFcOut- LWI=N/C DwFcInEn-
LWO=N/C DwFcOutEn-
		Revision ID: 1.02
		Link Frequency 0: 800MHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz-
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF-
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [f0] HyperTransport: Interrupt Discovery and Configuration
	Kernel driver in use: agpgart-amd64

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SG86C202 (prog-if
00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 99
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: e2100000-e21fffff
	Prefetchable memory behind bridge: e8000000-efffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL
Media IO] (rev 25)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 0
	Region 4: I/O ports at 8100 [size=32]
	Kernel driver in use: sis96x_smbus
	Kernel modules: i2c-sis96x

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE]
(prog-if 80 [Master])
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 128
	Interrupt: pin ? routed to IRQ 16
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at 2000 [size=16]
	Kernel driver in use: pata_sis
	Kernel modules: pata_sis

00:02.6 Modem: Silicon Integrated Systems [SiS] AC'97 Modem Controller
(rev a0) (prog-if 00 [Generic])
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 173 (13000ns min, 2750ns max)
	Interrupt: pin C routed to IRQ 18
	Region 0: I/O ports at 1000 [size=256]
	Region 1: I/O ports at 1c00 [size=128]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Intel ICH Modem
	Kernel modules: snd-intel8x0m

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
AC'97 Sound Controller (rev a0)
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 173 (13000ns min, 2750ns max)
	Interrupt: pin C routed to IRQ 18
	Region 0: I/O ports at 1400 [size=256]
	Region 1: I/O ports at 1c80 [size=128]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Intel ICH
	Kernel modules: snd-intel8x0

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (20000ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e2002000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
Controller (rev 0f) (prog-if 10 [OHCI])
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (20000ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at e2003000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 2.0
Controller (prog-if 20 [EHCI])
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (20000ns max)
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at e2004000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900
PCI Fast Ethernet (rev 91)
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 173 (13000ns min, 2750ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 1800 [size=256]
	Region 1: Memory at e2005000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 48000000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: sis900
	Kernel modules: sis900

00:06.0 CardBus bridge: Texas Instruments PCI1410 PC card Cardbus
Controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 48020000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 40000000-43fff000 (prefetchable)
	Memory window 1: 44000000-47fff000
	I/O window 0: 00002400-000024ff
	I/O window 1: 00002800-000028ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
	Kernel modules: yenta_socket

00:0b.0 Network controller: Broadcom Corporation BCM4318 [AirForce One
54g] 802.11g Wireless LAN Controller (rev 02)
	Subsystem: AMBIT Microsystem Corp. TravelMate 2410
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at e2000000 (32-bit, non-prefetchable) [size=8K]
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn+ ExtCTL- 64b+
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.02
		Link Frequency: 800MHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: k8temp
	Kernel modules: k8temp

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]
661/741/760 PCI/AGP or 662/761Gx PCIE VGA Display Adapter (prog-if 00
[VGA controller])
	Subsystem: Acer Incorporated [ALI] Device 0083
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 7
	BIST result: 00
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at e2100000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at a000 [size=128]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] AGP version 3.0
		Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans-
64bit- FW- AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>



[7.6.] SCSI information (from /proc/scsi/scsi)
Aspire 3003
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD800BEVE-00 Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: PIONEER  Model: DVD-RW DVR-K15RA Rev: 1.04
  Type:   CD-ROM                           ANSI  SCSI revision: 05

Aspire 5004
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: TOSHIBA MK1031GA Rev: AA20
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: UJ-840D          Rev: 1.03
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
Interrupts:
Aspire 3003
           CPU0
   0:        130   IO-APIC-edge      timer
   1:       5287   IO-APIC-edge      i8042
   8:          0   IO-APIC-edge      rtc0
  11:      11003   IO-APIC-fasteoi   acpi
  12:     396198   IO-APIC-edge      i8042
  14:     240929   IO-APIC-edge      pata_sis
  15:      79988   IO-APIC-edge      pata_sis
  17:     153782   IO-APIC-fasteoi   b43
  18:       9571   IO-APIC-fasteoi   SiS SI7013 Modem, SiS SI7012
  19:          1   IO-APIC-fasteoi   yenta, eth0
  20:          0   IO-APIC-fasteoi   ohci_hcd:usb2
  21:          0   IO-APIC-fasteoi   ohci_hcd:usb3
  23:       3405   IO-APIC-fasteoi   ehci_hcd:usb1
 NMI:          0   Non-maskable interrupts
 LOC:    2704419   Local timer interrupts
 SPU:          0   Spurious interrupts
 PMI:          0   Performance monitoring interrupts
 PND:          0   Performance pending work
 RES:          0   Rescheduling interrupts
 CAL:          0   Function call interrupts
 TLB:          0   TLB shootdowns
 TRM:          0   Thermal event interrupts
 THR:          0   Threshold APIC interrupts
 MCE:          0   Machine check exceptions
 MCP:         23   Machine check polls
 ERR:          0
 MIS:          0


Aspire 5004
         CPU0
   0:        131   IO-APIC-edge      timer
   1:       1113   IO-APIC-edge      i8042
   8:          0   IO-APIC-edge      rtc0
  11:        475   IO-APIC-fasteoi   acpi
  12:      24604   IO-APIC-edge      i8042
  14:       4629   IO-APIC-edge      pata_sis
  15:       2422   IO-APIC-edge      pata_sis
  18:          0   IO-APIC-fasteoi   SiS SI7012, SiS SI7013 Modem
  19:        124   IO-APIC-fasteoi   yenta, eth0
  20:         41   IO-APIC-fasteoi   ohci_hcd:usb2
  21:          0   IO-APIC-fasteoi   ohci_hcd:usb3
  23:          2   IO-APIC-fasteoi   ehci_hcd:usb1
 NMI:          0   Non-maskable interrupts
 LOC:      18136   Local timer interrupts
 SPU:          0   Spurious interrupts
 PMI:          0   Performance monitoring interrupts
 PND:          0   Performance pending work
 RES:          0   Rescheduling interrupts
 CAL:          0   Function call interrupts
 TLB:          0   TLB shootdowns
 TRM:          0   Thermal event interrupts
 THR:          0   Threshold APIC interrupts
 MCE:          0   Machine check exceptions
 MCP:          2   Machine check polls
 ERR:          0
 MIS:          0

[X.] Other notes, patches, fixes, workarounds:
I've heard of symptoms of this being related to APIC before

This problem only started after updating kernel.

Thomas Suckow
