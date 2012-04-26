Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2DZHar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:30:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53560 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2DZHao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:30:44 -0400
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 13:15:42 +0545
Message-ID: <CAHRcSHXDRJVSF2m6R1SfB3Uck97QBE3vpJ=k-bgesuaFJMU59g@mail.gmail.com>
Subject: linux kernel 3.3 power regression
From: suren sth <srnsht@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been experiencing power regression in kernel 3.3 latest series.
I am using fedora 16 in dell n4110.
The usual battery backup lies between 1:30hr to 2hr under normal
stress(i.e while running no application at all).
The fan is always busy pumping out hot air.

keyword
-------------
kernel

kernel version
-----------------------
Linux version 3.3.2-1.fc16.x86_64
(mockbuild@x86-04.phx2.fedoraproject.org) (gcc version 4.6.3 20120306
(Red Hat 4.6.3-2) (GCC) ) #1 SMP Sat Apr 14 00:31:23 UTC 2012

Processor information
---------------------------------
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4984.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4984.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4984.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 42
model name	: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz
stepping	: 7
microcode	: 0x25
cpu MHz		: 800.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts
dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4984.17
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


Module information
------------------------------
snd_seq_dummy 12798 0 - Live 0xffffffffa07e1000
fuse 77686 3 - Live 0xffffffffa07cd000
ebtable_nat 12807 0 - Live 0xffffffffa07bc000
ebtables 30688 1 ebtable_nat, Live 0xffffffffa07c4000
rfcomm 68830 4 - Live 0xffffffffa07aa000
ipt_MASQUERADE 12880 3 - Live 0xffffffffa07a5000
iptable_nat 13383 1 - Live 0xffffffffa07a0000
nf_nat 25143 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffffa0794000
xt_CHECKSUM 12549 1 - Live 0xffffffffa0786000
iptable_mangle 12695 1 - Live 0xffffffffa078f000
bridge 90950 0 - Live 0xffffffffa076e000
stp 12823 1 bridge, Live 0xffffffffa074b000
llc 14090 2 bridge,stp, Live 0xffffffffa0724000
lockd 84763 0 - Live 0xffffffffa0758000
bnep 23683 2 - Live 0xffffffffa0751000
be2iscsi 72382 0 - Live 0xffffffffa0738000
iscsi_boot_sysfs 15641 1 be2iscsi, Live 0xffffffffa06e9000
bnx2i 54521 0 - Live 0xffffffffa0729000
cnic 62821 1 bnx2i, Live 0xffffffffa0713000
uio 19028 1 cnic, Live 0xffffffffa0672000
cxgb4i 32909 0 - Live 0xffffffffa0709000
cxgb4 103017 1 cxgb4i, Live 0xffffffffa06ee000
cxgb3i 32972 0 - Live 0xffffffffa06d0000
libcxgbi 56508 2 cxgb4i,cxgb3i, Live 0xffffffffa06da000
cxgb3 155458 1 cxgb3i, Live 0xffffffffa06a9000
mdio 13398 1 cxgb3, Live 0xffffffffa0699000
ib_iser 38001 0 - Live 0xffffffffa069e000
rdma_cm 41898 1 ib_iser, Live 0xffffffffa068d000
ib_cm 41692 1 rdma_cm, Live 0xffffffffa0681000
iw_cm 18176 1 rdma_cm, Live 0xffffffffa067b000
ib_sa 28417 2 rdma_cm,ib_cm, Live 0xffffffffa065c000
ib_mad 46392 2 ib_cm,ib_sa, Live 0xffffffffa0665000
ib_core 73803 6 ib_iser,rdma_cm,ib_cm,iw_cm,ib_sa,ib_mad, Live
0xffffffffa0648000
ib_addr 13745 1 rdma_cm, Live 0xffffffffa0643000
iscsi_tcp 18333 0 - Live 0xffffffffa0639000
libiscsi_tcp 23970 4 cxgb4i,cxgb3i,libcxgbi,iscsi_tcp, Live 0xffffffffa0624000
libiscsi 50527 8
be2iscsi,bnx2i,cxgb4i,cxgb3i,libcxgbi,ib_iser,iscsi_tcp,libiscsi_tcp,
Live 0xffffffffa062b000
scsi_transport_iscsi 51924 8
be2iscsi,bnx2i,libcxgbi,ib_iser,iscsi_tcp,libiscsi, Live
0xffffffffa0616000
ip6t_REJECT 12939 2 - Live 0xffffffffa060a000
nf_conntrack_ipv6 14290 2 - Live 0xffffffffa0601000
nf_defrag_ipv6 18139 1 nf_conntrack_ipv6, Live 0xffffffffa05f7000
nf_conntrack_ipv4 14622 6 iptable_nat,nf_nat, Live 0xffffffffa05ee000
nf_defrag_ipv4 12673 1 nf_conntrack_ipv4, Live 0xffffffffa05e9000
xt_state 12578 5 - Live 0xffffffffa0611000
nf_conntrack 82286 6
ipt_MASQUERADE,iptable_nat,nf_nat,nf_conntrack_ipv6,nf_conntrack_ipv4,xt_state,
Live 0xffffffffa05d3000
ip6table_filter 12815 1 - Live 0xffffffffa05c6000
ip6_tables 26976 1 ip6table_filter, Live 0xffffffffa05cb000
vhost_net 33675 0 - Live 0xffffffffa0597000
macvtap 18183 1 vhost_net, Live 0xffffffffa04f0000
macvlan 18569 1 macvtap, Live 0xffffffffa0591000
tun 22804 2 vhost_net, Live 0xffffffffa04dc000
virtio_net 23133 0 - Live 0xffffffffa058a000
kvm_intel 132406 0 - Live 0xffffffffa05a4000
kvm 406993 1 kvm_intel, Live 0xffffffffa0525000
snd_hda_codec_hdmi 36157 1 - Live 0xffffffffa051b000
snd_hda_codec_realtek 145364 1 - Live 0xffffffffa04f6000
snd_hda_intel 33276 2 - Live 0xffffffffa04e6000
snd_hda_codec 115767 3
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live
0xffffffffa04be000
snd_hwdep 17611 1 snd_hda_codec, Live 0xffffffffa046a000
snd_seq 64807 1 snd_seq_dummy, Live 0xffffffffa04ad000
snd_seq_device 14129 2 snd_seq_dummy,snd_seq, Live 0xffffffffa0006000
snd_pcm 97170 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa0494000
uinput 17606 0 - Live 0xffffffffa048e000
uvcvideo 76346 0 - Live 0xffffffffa047a000
videobuf2_core 31894 1 uvcvideo, Live 0xffffffffa0471000
videodev 106837 2 uvcvideo,videobuf2_core, Live 0xffffffffa044e000
media 20444 2 uvcvideo,videodev, Live 0xffffffffa039b000
videobuf2_vmalloc 12967 1 uvcvideo, Live 0xffffffffa0396000
videobuf2_memops 13262 1 videobuf2_vmalloc, Live 0xffffffffa0391000
binfmt_misc 17431 1 - Live 0xffffffffa03a3000
sunrpc 235361 2 lockd, Live 0xffffffffa040f000
ath3k 13310 0 - Live 0xffffffffa038c000
btusb 23911 2 - Live 0xffffffffa01e9000
bluetooth 269240 24 rfcomm,bnep,ath3k,btusb, Live 0xffffffffa03cc000
arc4 12529 2 - Live 0xffffffffa01f1000
ath9k 134768 0 - Live 0xffffffffa03aa000
mac80211 496450 1 ath9k, Live 0xffffffffa0311000
ath9k_common 13600 1 ath9k, Live 0xffffffffa0227000
ath9k_hw 408211 2 ath9k,ath9k_common, Live 0xffffffffa02ac000
ath 23089 3 ath9k,ath9k_common,ath9k_hw, Live 0xffffffffa026c000
cfg80211 195558 3 ath9k,mac80211,ath, Live 0xffffffffa027b000
joydev 17412 0 - Live 0xffffffffa0275000
dell_laptop 18119 0 - Live 0xffffffffa0256000
snd_timer 28815 2 snd_seq,snd_pcm, Live 0xffffffffa0263000
dell_wmi 12681 0 - Live 0xffffffffa0216000
snd 78908 14 snd_seq_dummy,snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq,snd_seq_device,snd_pcm,snd_timer,
Live 0xffffffffa0241000
sparse_keymap 13526 1 dell_wmi, Live 0xffffffffa025e000
soundcore 14484 1 snd, Live 0xffffffffa023c000
snd_page_alloc 18101 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0236000
i2c_i801 17765 0 - Live 0xffffffffa022c000
iTCO_wdt 17948 0 - Live 0xffffffffa0221000
iTCO_vendor_support 13419 1 iTCO_wdt, Live 0xffffffffa021c000
r8169 60789 0 - Live 0xffffffffa0206000
mii 13527 1 r8169, Live 0xffffffffa0201000
microcode 23348 0 - Live 0xffffffffa01fa000
rfkill 21342 5 bluetooth,cfg80211,dell_laptop, Live 0xffffffffa0100000
dcdbas 14828 1 dell_laptop, Live 0xffffffffa00f1000
ums_realtek 17983 0 - Live 0xffffffffa00fa000
usb_storage 52112 1 ums_realtek, Live 0xffffffffa0062000
wmi 18697 1 dell_wmi, Live 0xffffffffa0016000
radeon 824969 0 - Live 0xffffffffa011e000
ttm 79585 1 radeon, Live 0xffffffffa0109000
i915 466748 3 - Live 0xffffffffa007e000
drm_kms_helper 40231 2 radeon,i915, Live 0xffffffffa0073000
drm 242003 6 radeon,ttm,i915,drm_kms_helper, Live 0xffffffffa0025000
i2c_algo_bit 13156 2 radeon,i915, Live 0xffffffffa001c000
i2c_core 37991 7
videodev,i2c_i801,radeon,i915,drm_kms_helper,drm,i2c_algo_bit, Live
0xffffffffa000b000
video 18932 1 i915, Live 0xffffffffa0000000


+Loaded driver and hardware information
---------------------------------------------------------
--ioports
------------
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  0400-0453 : pnp 00:04
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:06
  0458-047f : pnp 00:04
    0460-047f : iTCO_wdt
  0500-057f : pnp 00:04
  0680-069f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  1000-1003 : pnp 00:04
  1004-1013 : pnp 00:04
  164e-164f : pnp 00:04
  2000-2fff : PCI Bus 0000:04
    2000-20ff : 0000:04:00.0
      2000-20ff : r8169
  3000-3fff : PCI Bus 0000:01
    3000-30ff : 0000:01:00.0
  4000-403f : 0000:00:02.0
  4060-407f : 0000:00:1f.2
    4060-407f : ahci
  4080-4087 : 0000:00:1f.2
    4080-4087 : ahci
  4088-408f : 0000:00:1f.2
    4088-408f : ahci
  4090-4093 : 0000:00:1f.2
    4090-4093 : ahci
  4094-4097 : 0000:00:1f.2
    4094-4097 : ahci
  efa0-efbf : 0000:00:1f.3
  ffff-ffff : pnp 00:04

--iomem
------------
00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cefff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bac8efff : System RAM
  01000000-0160060b : Kernel code
  0160060c-01cd9aff : Kernel data
  01ddc000-01f99fff : Kernel bss
bac8f000-bacacfff : reserved
bacad000-bacb8fff : ACPI Non-volatile Storage
bacb9000-badcefff : reserved
badcf000-badcffff : ACPI Non-volatile Storage
badd0000-bade9fff : reserved
badea000-badfafff : ACPI Non-volatile Storage
badfb000-bae0bfff : reserved
bae0c000-bae0dfff : ACPI Non-volatile Storage
bae0e000-bae0ffff : reserved
bae10000-bae12fff : ACPI Non-volatile Storage
bae13000-baf17fff : reserved
baf18000-baf1bfff : ACPI Non-volatile Storage
baf1c000-baf1efff : reserved
baf1f000-baf9efff : ACPI Non-volatile Storage
baf9f000-baffefff : ACPI Tables
bafff000-baffffff : System RAM
bb000000-bf9fffff : reserved
bfa00000-feafffff : PCI Bus 0000:00
  c0000000-cfffffff : PCI Bus 0000:01
    c0000000-cfffffff : 0000:01:00.0
  d0000000-dfffffff : 0000:00:02.0
  e0000000-e03fffff : 0000:00:02.0
  e0400000-e04fffff : PCI Bus 0000:04
    e0400000-e0403fff : 0000:04:00.0
      e0400000-e0403fff : r8169
    e0404000-e0404fff : 0000:04:00.0
      e0404000-e0404fff : r8169
  e0500000-e05fffff : PCI Bus 0000:03
    e0500000-e0501fff : 0000:03:00.0
      e0500000-e0501fff : xhci_hcd
  e0600000-e06fffff : PCI Bus 0000:02
    e0600000-e060ffff : 0000:02:00.0
      e0600000-e060ffff : ath9k
  e0700000-e07fffff : PCI Bus 0000:01
    e0700000-e071ffff : 0000:01:00.0
    e0720000-e073ffff : 0000:01:00.0
  e0800000-e0803fff : 0000:00:1b.0
    e0800000-e0803fff : ICH HD audio
  e0804000-e08040ff : 0000:00:1f.3
  e0805000-e080500f : 0000:00:16.0
  e0808000-e08087ff : 0000:00:1f.2
    e0808000-e08087ff : ahci
  e0809000-e08093ff : 0000:00:1d.0
    e0809000-e08093ff : ehci_hcd
  e080a000-e080a3ff : 0000:00:1a.0
    e080a000-e080a3ff : ehci_hcd
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:09
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed08000-fed08fff : reserved
fed10000-fed19fff : reserved
  fed10000-fed17fff : pnp 00:09
  fed18000-fed18fff : pnp 00:09
  fed19000-fed19fff : pnp 00:09
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:09
fed20000-fed3ffff : pnp 00:09
fed40000-fed44fff : PCI Bus 0000:00
fed45000-fed8ffff : pnp 00:09
fed90000-fed93fff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ffd80000-ffffffff : reserved
  fff00000-fff00fff : pnp 00:09
100000000-13e9fefff : System RAM
13e9ff000-13fdfffff : reserved
13fe00000-13fffffff : RAM buffer


PCI information
-----------------------
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
Family DRAM Controller (rev 09)
	Subsystem: Dell Device 04c1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core
Processor Family PCI Express Root Port (rev 09) (prog-if 00 [Normal
decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: e0700000-e07fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Intel Corporation Device 2010
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4151
	Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
Core Processor Family Integrated Graphics Controller (rev 09) (prog-if
00 [VGA controller])
	Subsystem: Dell Device 04c1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 4000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4191
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: i915
	Kernel modules: i915

00:16.0 Communication controller: Intel Corporation 6 Series/C200
Series Chipset Family MEI Controller #1 (rev 04)
	Subsystem: Dell Device 04c1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e0805000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:1a.0 USB Controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 04c1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e080a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
Family High Definition Audio Controller (rev 05)
	Subsystem: Dell Device 04c1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 50
	Region 0: Memory at e0800000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41b1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
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
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=22
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: e0600000-e06fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 04c1
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 3 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: e0500000-e05fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 04c1
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
Family PCI Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000e0400000-00000000e04fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #4, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: Dell Device 04c1
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 6 Series/C200 Series Chipset
Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
	Subsystem: Dell Device 04c1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at e0809000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP+
	Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC
Controller (rev 05)
	Subsystem: Dell Device 04c1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
Chipset Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI
1.0])
	Subsystem: Dell Device 04c1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 41
	Region 0: I/O ports at 4088 [size=8]
	Region 1: I/O ports at 4094 [size=4]
	Region 2: I/O ports at 4080 [size=8]
	Region 3: I/O ports at 4090 [size=4]
	Region 4: I/O ports at 4060 [size=32]
	Region 5: Memory at e0808000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0c00c  Data: 4161
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
SMBus Controller (rev 05)
	Subsystem: Dell Device 04c1
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at e0804000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at efa0 [size=32]
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: ATI Technologies Inc NI Whistler
[AMD Radeon HD 6600M Series] (prog-if 00 [VGA controller])
	Subsystem: Dell Device 04c1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 48
	Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at e0700000 (64-bit, non-prefetchable) [size=128K]
	Region 4: I/O ports at 3000 [size=256]
	Expansion ROM at e0720000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4199
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap+ ChkEn-
	Kernel driver in use: radeon
	Kernel modules: radeon

02:00.0 Network controller: Atheros Communications Inc. AR9285
Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Dell Device 0205
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e0600000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-15-17-ff-ff-24-14-12
	Capabilities: [170 v1] Power Budgeting <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

03:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host
Controller (rev 04) (prog-if 30 [XHCI])
	Subsystem: Dell Device 04c1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at e0500000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
		Vector table: BAR=0 offset=00001000
		PBA: BAR=0 offset=00001080
	Capabilities: [a0] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<4us, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
	Capabilities: [150 v1] #18
	Kernel driver in use: xhci_hcd

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 05)
	Subsystem: Dell Device 04c1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 49
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at e0404000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at e0400000 (64-bit, prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 41a1
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 01-00-00-00-36-4c-e0-00
	Kernel driver in use: r8169
	Kernel modules: r8169


 SCSI information
---------------------------
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: TOSHIBA MK5061GS Rev: MH00
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: MATSHITA Model: DVD+-RW UJ8C1    Rev: D.02
  Type:   CD-ROM                           ANSI  SCSI revision: 05
