Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0DPJXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 05:23:03 -0400
Received: from fw1.qdcec.co.za ([196.211.186.106]:51706 "EHLO fw1.qdcec.co.za"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab0DPJW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 05:22:56 -0400
X-Greylist: delayed 2976 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 05:22:52 EDT
Subject: PROBLEM: kernel 2.6.32.11-99.fc12.x86_64 makes compiz-0.8.2-24 slow
From: Louis van Dyk <louis@qdcec.co.za>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 10:32:40 +0200
Message-ID: <1271406760.4379.59.camel@lvd-pc.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[1.] One line summary of the problem: kernel 2.6.32.11-99.fc12.x86_64
makes compiz-0.8.2-24 slow   
[2.] Full description of the problem/report: When I boot Fedora 12
x86_64 to kernel kernel 2.6.32.11-99.fc12.x86_64 then the response from
Compiz (Gnome) is very slow.  The mouse moves normally. For example,
when I click on a menu it takes 4 seconds before it opens. Other items
take much longer to display.  If I switch to Metacity, then response is
normal.  If I reboot and select kernel 2.6.32.10-90.fc12.x86_64 then
Compiz works normally.
[3.] Keywords (i.e., modules, networking, kernel): kernel, compiz,
compiz-gnome
[4.] Kernel version (from /proc/version): 2.6.32.11-99.fc12.x86_64 
[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)  None available
[6.] A small shell script or example program which triggers the
     problem (if possible)  Boot with kernel 2.6.32.11-99.fc12.x86_64
and have the Fusion-Icon in the startup applications which will auto
start Compiz
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux lvd-pc.localdomain 2.6.32.11-99.fc12.x86_64 #1 SMP Mon Apr 5
19:59:38 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.19.51.0.14
util-linux             2.16.2
mount                  support
module-init-tools      3.9
e2fsprogs              1.41.9
xfsprogs               3.0.3
pcmciautils            015
quota-tools            3.17.
PPP                    2.4.5
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
oprofile               0.9.5
Sh-utils               7.6
wireless-tools         29
Modules Loaded         rfcomm sco bridge stp llc bnep l2cap sunrpc
cpufreq_ondemand acpi_cpufreq freq_table nf_conntrack_ftp ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 fuse uinput
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm hp_wmi ppdev arc4 ecb hp_accel lis3lv02d
parport_pc input_polldev parport tpm_infineon wmi iwl3945 iwlcore
mac80211 cfg80211 snd_timer btusb snd tg3 iTCO_wdt soundcore bluetooth
snd_page_alloc rfkill iTCO_vendor_support serio_raw joydev cryptd
aes_x86_64 aes_generic xts gf128mul dm_crypt dm_multipath firewire_ohci
firewire_core crc_itu_t yenta_socket rsrc_nonstatic i915 drm_kms_helper
drm i2c_algo_bit i2c_core video output
[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow
vnmi flexpriority
bogomips        : 3989.90
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida tpr_shadow
vnmi flexpriority
bogomips        : 3989.82
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
rfcomm 66832 6 - Live 0xffffffffa03fc000
sco 16714 2 - Live 0xffffffffa02ea000
bridge 48306 0 - Live 0xffffffffa03ee000
stp 1935 1 bridge, Live 0xffffffffa0287000
llc 4739 2 bridge,stp, Live 0xffffffffa027a000
bnep 15431 2 - Live 0xffffffffa0263000
l2cap 45755 16 rfcomm,bnep, Live 0xffffffffa0239000
sunrpc 193819 1 - Live 0xffffffffa03ab000
cpufreq_ondemand 8793 2 - Live 0xffffffffa01bc000
acpi_cpufreq 7627 0 - Live 0xffffffffa0131000
freq_table 3947 2 cpufreq_ondemand,acpi_cpufreq, Live 0xffffffffa0118000
nf_conntrack_ftp 11741 0 - Live 0xffffffffa00fd000
ip6t_REJECT 4222 2 - Live 0xffffffffa00df000
nf_conntrack_ipv6 18504 2 - Live 0xffffffffa0184000
ip6table_filter 2791 1 - Live 0xffffffffa0056000
ip6_tables 16760 1 ip6table_filter, Live 0xffffffffa016b000
ipv6 279463 30 ip6t_REJECT,nf_conntrack_ipv6, Live 0xffffffffa0351000
fuse 57189 4 - Live 0xffffffffa0341000
uinput 7228 0 - Live 0xffffffffa033d000
snd_hda_codec_analog 73652 1 - Live 0xffffffffa0323000
snd_hda_intel 23888 2 - Live 0xffffffffa0315000
snd_hda_codec 71956 2 snd_hda_codec_analog,snd_hda_intel, Live
0xffffffffa02f9000
snd_hwdep 6446 1 snd_hda_codec, Live 0xffffffffa02f1000
snd_seq 52773 0 - Live 0xffffffffa02db000
snd_seq_device 6151 1 snd_seq, Live 0xffffffffa02d4000
snd_pcm 78247 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa02b6000
hp_wmi 4984 0 - Live 0xffffffffa02ae000
ppdev 7925 0 - Live 0xffffffffa02a7000
arc4 1425 2 - Live 0xffffffffa02a1000
ecb 2079 2 - Live 0xffffffffa029b000
hp_accel 12040 0 - Live 0xffffffffa0293000
lis3lv02d 6664 1 hp_accel, Live 0xffffffffa028c000
parport_pc 21189 0 - Live 0xffffffffa027f000
input_polldev 2744 1 lis3lv02d, Live 0xffffffffa012a000
parport 31685 2 ppdev,parport_pc, Live 0xffffffffa0270000
tpm_infineon 8240 0 - Live 0xffffffffa026b000
wmi 6872 1 hp_wmi, Live 0xffffffffa0110000
iwl3945 109397 0 - Live 0xffffffffa0246000
iwlcore 205300 1 iwl3945, Live 0xffffffffa0204000
mac80211 203817 2 iwl3945,iwlcore, Live 0xffffffffa01c2000
cfg80211 117514 3 iwl3945,iwlcore,mac80211, Live 0xffffffffa0199000
snd_timer 19840 2 snd_seq,snd_pcm, Live 0xffffffffa0192000
btusb 15380 2 - Live 0xffffffffa018c000
snd 62376 12
snd_hda_codec_analog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,snd_timer, Live 0xffffffffa0172000
tg3 101698 0 - Live 0xffffffffa0150000
iTCO_wdt 9726 0 - Live 0xffffffffa00ef000
soundcore 6271 1 snd, Live 0xffffffffa00cc000
bluetooth 89475 9 rfcomm,sco,bnep,l2cap,btusb, Live 0xffffffffa0138000
snd_page_alloc 7389 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00b5000
rfkill 16966 5 hp_wmi,cfg80211,bluetooth, Live 0xffffffffa0059000
iTCO_vendor_support 2547 1 iTCO_wdt, Live 0xffffffffa0053000
serio_raw 4642 0 - Live 0xffffffffa001b000
joydev 9512 0 - Live 0xffffffffa000d000
cryptd 6913 0 - Live 0xffffffffa0134000
aes_x86_64 7734 2 - Live 0xffffffffa012d000
aes_generic 27076 1 aes_x86_64, Live 0xffffffffa0121000
xts 2506 1 - Live 0xffffffffa011b000
gf128mul 7274 1 xts, Live 0xffffffffa0114000
dm_crypt 11176 1 - Live 0xffffffffa010b000
dm_multipath 14558 0 - Live 0xffffffffa0101000
firewire_ohci 20739 0 - Live 0xffffffffa00f5000
firewire_core 43768 1 firewire_ohci, Live 0xffffffffa00e2000
crc_itu_t 1539 1 firewire_core, Live 0xffffffffa00dc000
yenta_socket 23418 1 - Live 0xffffffffa00cf000
rsrc_nonstatic 8278 1 yenta_socket, Live 0xffffffffa00c7000
i915 282542 3 - Live 0xffffffffa006e000
drm_kms_helper 24568 1 i915, Live 0xffffffffa0061000
drm 171094 4 i915,drm_kms_helper, Live 0xffffffffa0027000
i2c_algo_bit 5005 1 i915, Live 0xffffffffa0020000
i2c_core 26876 4 i915,drm_kms_helper,drm,i2c_algo_bit, Live
0xffffffffa0012000
video 20118 1 i915, Live 0xffffffffa0006000
output 2213 1 video, Live 0xffffffffa0000000


[7.4.] Loaded driver and hardware information
(/proc/ioports, /proc/iomem)
cat /proc/ioports:
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
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
04d0-04d1 : pnp 00:0d
0500-055f : pnp 00:0b
0800-080f : pnp 00:0b
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : pnp 00:0d
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK
    1030-1033 : iTCO_wdt
    1060-107f : iTCO_wdt
1100-113f : 0000:00:1f.0
  1100-113f : pnp 00:0d
1200-121f : pnp 00:0d
1370-1377 : 0000:00:1f.2
  1370-1377 : ahci
13f0-13f7 : 0000:00:1f.2
  13f0-13f7 : ahci
1574-1577 : 0000:00:1f.2
  1574-1577 : ahci
15f4-15f7 : 0000:00:1f.2
  15f4-15f7 : ahci
2000-3fff : PCI Bus 0000:28
4000-4007 : 0000:00:02.0
4020-403f : 0000:00:1a.0
  4020-403f : uhci_hcd
4040-405f : 0000:00:1a.1
  4040-405f : uhci_hcd
4060-407f : 0000:00:1d.0
  4060-407f : uhci_hcd
4080-409f : 0000:00:1d.1
  4080-409f : uhci_hcd
40a0-40bf : 0000:00:1d.2
  40a0-40bf : uhci_hcd
40c0-40cf : 0000:00:1f.1
  40c0-40cf : ata_piix
4100-411f : 0000:00:1f.2
  4100-411f : ahci
5000-5fff : PCI Bus 0000:10
6000-6fff : PCI Bus 0000:18
7000-7fff : PCI Bus 0000:02
  7000-70ff : PCI CardBus 0000:03
  7400-74ff : PCI CardBus 0000:03


cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000cee00-000cffff : pnp 00:0e
000d2a00-000d3fff : pnp 00:0e
000e0000-000fffff : reserved
00100000-bf7affff : System RAM
  01000000-0145c772 : Kernel code
  0145c773-017fe99f : Kernel data
  018f4000-01a53ee7 : Kernel bss
bf7b0000-bf7c53ff : reserved
bf7c5400-bf7e7fb7 : ACPI Non-volatile Storage
bf7e7fb8-bfffffff : reserved
c0000000-c3ffffff : PCI Bus 0000:02
  c0000000-c3ffffff : PCI CardBus 0000:03
c4000000-c41fffff : PCI Bus 0000:10
c4200000-c43fffff : PCI Bus 0000:18
c4400000-c45fffff : PCI Bus 0000:28
c4600000-c4600fff : Intel Flush Page
c8000000-cbffffff : PCI CardBus 0000:03
d0000000-dfffffff : 0000:00:02.0
e0000000-e3ffffff : PCI Bus 0000:28
e4000000-e40fffff : PCI Bus 0000:18
  e4000000-e400ffff : 0000:18:00.0
    e4000000-e400ffff : tg3
e4100000-e41fffff : PCI Bus 0000:10
  e4100000-e4100fff : 0000:10:00.0
    e4100000-e4100fff : iwl3945
e4200000-e45fffff : PCI Bus 0000:02
  e4200000-e4200fff : 0000:02:04.0
    e4200000-e4200fff : yenta_socket
  e4201000-e42017ff : 0000:02:04.1
    e4201000-e42017ff : firewire_ohci
e4600000-e46fffff : 0000:00:02.0
e4700000-e47fffff : 0000:00:02.1
e4800000-e48003ff : 0000:00:1a.7
  e4800000-e48003ff : ehci_hcd
e4804000-e4807fff : 0000:00:1b.0
  e4804000-e4807fff : ICH HD audio
e4808000-e48083ff : 0000:00:1d.7
  e4808000-e48083ff : ehci_hcd
e4809000-e48097ff : 0000:00:1f.2
  e4809000-e48097ff : ahci
f8000000-fbffffff : PCI MMCONFIG 0 [00-3f]
  f8000000-fbffffff : pnp 00:0d
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : reserved
fed00000-fed003ff : HPET 0
fed20000-fed99fff : reserved
  fed20000-fed3ffff : pnp 00:0d
  fed45000-fed8ffff : pnp 00:0d
  fed90000-fed99fff : pnp 00:0d
feda0000-fedbffff : reserved
  feda0000-fedbffff : pnp 00:0e
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0e
ffb00000-ffbfffff : reserved
  ffb00000-ffbfffff : pnp 00:0b
fff00000-ffffffff : reserved
  fff00000-ffffffff : pnp 00:0b


[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
Controller Hub (rev 0c)
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0a <?>
        Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA controller])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 29
        Region 0: Memory at e4600000 (64-bit, non-prefetchable)
[size=1M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at 4000 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0200c  Data: 41a1
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+
        Kernel driver in use: i915
        Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 0c)
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at e4700000 (64-bit, non-prefetchable)
[size=1M]
        Capabilities: [d0] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                Bridge: PM- B3+

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #4 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at 4020 [size=32]
        Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #5 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 4040 [size=32]
        Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #2 (rev 03) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at e4800000 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 03)
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e4804000 (64-bit, non-prefetchable)
[size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated
Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown,
Latency L0 <64ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntrySize=0
                Arb:    Fixed- WRR32- WRR64- WRR128- 100ns- - - onfig-
TableOffset=0
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=80
                        Status: NegoPending- InProgress-
        Capabilities: [130 v1] Root Complex Link
                Desc:   PortNumber=0f ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed90000
        Kernel driver in use: HDA Intel
        Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot-), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4169
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device
30c0
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntrySize=0
                Arb:    Fixed+ WRR32- WRR64- WRR128- 100ns- - - onfig-
TableOffset=0
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=01 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed90001
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 2 (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=10, subordinate=10, sec-latency=0
        I/O behind bridge: 00005000-00005fff
        Memory behind bridge: e4100000-e41fffff
        Prefetchable memory behind bridge:
00000000c4000000-00000000c41fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
                        Slot #  2, PowerLimit 0.160000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet
+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4171
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device
30c0
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntrySize=0
                Arb:    Fixed+ WRR32- WRR64- WRR128- 100ns- - - onfig-
TableOffset=0
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=02 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed90001
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 3 (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=18, subordinate=18, sec-latency=0
        I/O behind bridge: 00006000-00006fff
        Memory behind bridge: e4000000-e40fffff
        Prefetchable memory behind bridge:
00000000c4200000-00000000c43fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
                        Slot #  3, PowerLimit 10.000000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet
+ Interlock-
                        Changed: MRL- PresDet- LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4179
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device
30c0
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntrySize=0
                Arb:    Fixed+ WRR32- WRR64- WRR128- 100ns- - - onfig-
TableOffset=0
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=03 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed90001
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 5 (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=28, subordinate=28, sec-latency=0
        I/O behind bridge: 00002000-00003fff
        Memory behind bridge: e0000000-e3ffffff
        Prefetchable memory behind bridge:
00000000c4400000-00000000c45fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <1us, L1 <4us
                        ClockPM- Surprise- LLActRep+ BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
Surprise+
                        Slot #  5, PowerLimit 0.160000; Interlock-
NoCompl-
                SltCtl: Enable: AttnBtn+ PwrFlt- MRL- PresDet+ CmdCplt-
HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown, Power-
Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet- Interlock-
                        Changed: MRL- PresDet- LinkState-
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee0300c  Data: 4181
        Capabilities: [90] Subsystem: Hewlett-Packard Company Device
30c0
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntrySize=0
                Arb:    Fixed+ WRR32- WRR64- WRR128- 100ns- - - onfig-
TableOffset=0
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [180 v1] Root Complex Link
                Desc:   PortNumber=05 ComponentID=02 EltType=Config
                Link0:  Desc:   TargetPort=00 TargetComponent=02
AssocRCRB- LinkType=MemMapped LinkValid+
                        Addr:   00000000fed90001
        Kernel driver in use: pcieport
        Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #1 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 4: I/O ports at 4060 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #2 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at 4080 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
Controller #3 (rev 03) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 40a0 [size=32]
        Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
Controller #1 (rev 03) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e4808000 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=02, subordinate=06, sec-latency=32
        I/O behind bridge: 00007000-00007fff
        Memory behind bridge: e4200000-e45fffff
        Prefetchable memory behind bridge:
00000000c0000000-00000000c3ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [50] Subsystem: Hewlett-Packard Company Device
30c0

00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
Controller (rev 03)
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 40c0 [size=16]
        Kernel driver in use: ata_piix
        Kernel modules: ata_generic, pata_acpi

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 28
        Region 0: I/O ports at 13f0 [size=8]
        Region 1: I/O ports at 15f4 [size=4]
        Region 2: I/O ports at 1370 [size=8]
        Region 3: I/O ports at 1574 [size=4]
        Region 4: I/O ports at 4100 [size=32]
        Region 5: Memory at e4809000 (32-bit, non-prefetchable)
[size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/4 Maskable- 64bit-
                Address: fee0100c  Data: 4189
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Kernel driver in use: ahci

02:04.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b6)
        Subsystem: Hewlett-Packard Company Compaq 6710b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at e4200000 (32-bit, non-prefetchable)
[size=4K]
        Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
        Memory window 0: c0000000-c3fff000 (prefetchable)
        Memory window 1: c8000000-cbfff000
        I/O window 0: 00007000-000070ff
        I/O window 1: 00007400-000074ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+
PostWrite+
        16-bit legacy interface ports at 0001
        Kernel driver in use: yenta_cardbus
        Kernel modules: yenta_socket

02:04.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
(rev 02) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company Device 30c0
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 17
        Region 0: Memory at e4201000 (32-bit, non-prefetchable)
[size=2K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1
+,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
        Kernel driver in use: firewire_ohci
        Kernel modules: firewire-ohci

10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)
        Subsystem: Hewlett-Packard Company Compaq 6710b or nx9420
Notebook
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 30
        Region 0: Memory at e4100000 (32-bit, non-prefetchable)
[size=4K]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0
+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0300c  Data: 41a9
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <128ns, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap-
ChkEn-
        Capabilities: [140 v1] Device Serial Number
00-1b-77-ff-ff-42-29-a8
        Kernel driver in use: iwl3945
        Kernel modules: iwl3945

18:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M
Gigabit Ethernet PCI Express (rev 02)
        Subsystem: Hewlett-Packard Company 6710b
        Physical Slot: 1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 31
        Region 0: Memory at e4000000 (64-bit, non-prefetchable)
[size=64K]
        Expansion ROM at <ignored> [disabled]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Connection timed out
                Not readable
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee0200c  Data: 41b1
        Capabilities: [d0] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <4us, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP+ Rollover- Timeout-
NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout-
NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
ChkEn-
        Capabilities: [13c v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntrySize=0
                Arb:    Fixed- WRR32- WRR64- WRR128- 100ns- - - onfig-
TableOffset=0
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1
RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128-
WRR256- Fixed- RR32-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                        Status: NegoPending- InProgress-
        Capabilities: [160 v1] Device Serial Number
00-1a-4b-ff-fe-70-47-4a
        Capabilities: [16c v1] Power Budgeting <?>
        Kernel driver in use: tg3
        Kernel modules: tg3


[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: FUJITSU MHW2160B Rev: 891F
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GSA-T20N  Rev: WC05
  Type:   CD-ROM                           ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

[8.] Other notes, patches, fixes, workarounds:
This is the list of "Compiz" and "Xorg" rpm's installed.

[root@lvd-pc ~]# rpm -qa | grep compiz
libcompizconfig-0.8.2-7.fc12.x86_64
compiz-0.8.2-24.fc12.x86_64
compiz-fusion-0.8.2-7.fc12.x86_64
compizconfig-python-0.8.2-2.fc12.x86_64
compiz-fusion-gnome-0.8.2-7.fc12.x86_64
compiz-gnome-0.8.2-24.fc12.x86_64
compiz-fusion-extras-0.8.2-5.fc12.x86_64
compiz-manager-0.6.0-10.fc12.noarch

[root@lvd-pc ~]# rpm -qa | grep -i xorg
xorg-x11-drv-fpit-1.3.0-4.fc12.x86_64
xorg-x11-drv-r128-6.8.1-2.fc12.x86_64
xorg-x11-drv-voodoo-1.2.3-1.fc12.x86_64
xorg-x11-drv-ati-firmware-6.13.0-0.21.20100219gite68d3a389.fc12.x86_64
xorg-x11-drv-cirrus-1.3.2-1.fc12.x86_64
xorg-x11-fonts-misc-7.2-9.fc12.noarch
xorg-x11-xauth-1.0.2-7.fc12.x86_64
xorg-x11-drv-mach64-6.8.2-1.fc12.x86_64
xorg-x11-drv-savage-2.3.1-1.fc12.x86_64
xorg-x11-drv-vesa-2.3.0-1.fc12.x86_64
xorg-x11-drv-evdev-2.3.2-3.fc12.x86_64
xorg-x11-xdm-1.1.6-14.fc12.x86_64
xorg-x11-drv-keyboard-1.4.0-2.fc12.x86_64
xorg-x11-drv-void-1.3.0-2.fc12.x86_64
xorg-x11-drv-elographics-1.2.3-4.fc12.x86_64
xorg-x11-drv-nouveau-0.0.15-21.20091105gite1c2efd.fc12.x86_64
xorg-x11-drv-i740-1.3.2-1.fc12.x86_64
xorg-x11-fonts-ISO8859-1-100dpi-7.2-9.fc12.noarch
xorg-x11-drv-trident-1.3.3-1.fc12.x86_64
xorg-x11-drv-tdfx-1.4.3-1.fc12.x86_64
xorg-x11-resutils-7.1-9.fc12.x86_64
xorg-x11-xinit-1.0.9-14.fc12.x86_64
xorg-x11-drv-fbdev-0.4.1-1.fc12.x86_64
xorg-x11-drv-mutouch-1.2.1-4.fc12.x86_64
xorg-x11-drv-synaptics-1.2.1-1.fc12.x86_64
xorg-x11-server-Xorg-1.7.6-1.fc12.x86_64
xorg-x11-drv-ast-0.89.9-1.fc12.x86_64
xorg-x11-drv-sisusb-0.9.3-1.fc12.x86_64
xorg-x11-xkb-utils-7.4-6.fc12.x86_64
xorg-x11-drv-hyperpen-1.3.0-3.fc12.x86_64
xorg-x11-drv-mga-1.4.11-1.fc12.x86_64
xorg-x11-drv-sis-0.10.2-1.fc12.x86_64
xorg-x11-font-utils-7.2-11.fc12.x86_64
xorg-x11-server-utils-7.4-13.fc12.x86_64
xorg-x11-drv-rendition-4.2.2-4.fc12.x86_64
xorg-x11-drv-vmware-10.16.7-2.fc12.x86_64
xorg-x11-drv-penmount-1.4.0-4.fc12.x86_64
xorg-x11-drv-siliconmotion-1.7.3-1.fc12.x86_64
xorg-x11-server-common-1.7.6-1.fc12.x86_64
xorg-x11-drv-intel-2.9.1-1.fc12.x86_64
xorg-x11-drv-acecad-1.4.0-1.fc12.x86_64
xorg-x11-drv-mouse-1.5.0-1.fc12.x86_64
xorg-x11-drivers-7.3-13.fc12.x86_64
xorg-x11-drv-apm-1.2.2-1.fc12.x86_64
xorg-x11-drv-openchrome-0.2.904-1.fc12.x86_64
xorg-x11-drv-glint-1.2.4-1.fc12.x86_64
xorg-x11-drv-ati-6.13.0-0.21.20100219gite68d3a389.fc12.x86_64
xorg-x11-drv-aiptek-1.3.0-1.fc12.x86_64
xorg-x11-apps-7.4-10.fc12.x86_64
xorg-x11-drv-s3virge-1.10.4-1.fc12.x86_64
xorg-x11-drv-vmmouse-12.6.5-2.fc12.x86_64
xorg-x11-drv-dummy-0.3.3-1.fc12.x86_64
xorg-x11-drv-nv-2.1.15-2.fc12.x86_64
xorg-x11-drv-wacom-0.10.4-2.fc12.x86_64
xorg-x11-utils-7.4-7.fc12.x86_64
xorg-x11-drv-i128-1.3.3-1.fc12.x86_64
xorg-x11-drv-v4l-0.2.0-3.fc12.1.x86_64


