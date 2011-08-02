Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab1HBHDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:03:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57454 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1HBHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:03:26 -0400
Message-ID: <4E37A13B.50106@bweb.at>
Date: Tue, 02 Aug 2011 09:03:23 +0200
From: Stephan Bertl <stephan@bweb.at>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: ThinkPad Edge: psmouse.c: TouchPad at isa0060/serio4/input0
 lost sync at byte 1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.]
psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1

[2.]
Hi, i have got a ThinkPad Edge 11 with TouchPad and TrackPoint, and the 
TouchPad repeatedly looses sync, so it ´hangs for some seconds, i tried 
various workarounds with kernel parameters like i8042.noloop 
i8042.nomux=1 psmouse.proto=imps etc... nothing really works.

GRUB_CMDLINE_LINUX="acpi_osi=linux noapic i8042.nomux=1 
psmouse.proto=imps i8042.noloop"

I tried these parameters, now it looses sync too.

psmouse.c: TouchPad at isa0060/serio1/input0 lost synchronization, 
throwing 2 bytes away.

[3.]
psmouse, lost sync, Thinkpad, Edge, ThinkPadEdge

[4.]
Linux version 3.0.0 (root@stephan-thinkpad) (gcc version 4.6.1 (Debian 
4.6.1-4) ) #2 SMP Thu Jul 28 21:35:13 CEST 2011

[5.]
no oops, but /var/log/messages

Aug  2 08:55:01 stephan-thinkpad kernel: [  638.530041] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 4
Aug  2 08:55:01 stephan-thinkpad kernel: [  638.531367] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:55:01 stephan-thinkpad kernel: [  638.543811] psmouse.c: 
TouchPad at isa0060/serio4/input0 - driver resynched.

[6.]
---

[7.]
[7.1.]
---
[7.2.]
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 6
model name	: AMD Athlon(tm) II Neo K345 Dual-Core Processor
stepping	: 3
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic 
cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt 
lbrv svm_lock nrip_save
bogomips	: 2794.36
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 6
model name	: AMD Athlon(tm) II Neo K345 Dual-Core Processor
stepping	: 3
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic 
cr8_legacy abm sse4a 3dnowprefetch osvw ibs skinit wdt nodeid_msr npt 
lbrv svm_lock nrip_save
bogomips	: 2794.43
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

[7.3.]
cryptd 14517 0 - Live 0xffffffffa06b1000
aes_x86_64 16796 2 - Live 0xffffffffa06ab000
aes_generic 33026 1 aes_x86_64, Live 0xffffffffa06a1000
cpufreq_powersave 12454 0 - Live 0xffffffffa069c000
cpufreq_stats 12777 0 - Live 0xffffffffa0697000
powernow_k8 17329 0 - Live 0xffffffffa0691000
mperf 12411 1 powernow_k8, Live 0xffffffffa068c000
cpufreq_userspace 12576 0 - Live 0xffffffffa0687000
cpufreq_conservative 13105 0 - Live 0xffffffffa0664000
parport_pc 26287 0 - Live 0xffffffffa067f000
ppdev 16782 0 - Live 0xffffffffa0673000
lp 17074 0 - Live 0xffffffffa0679000
parport 35743 3 parport_pc,ppdev,lp, Live 0xffffffffa0669000
rfcomm 40998 8 - Live 0xffffffffa0658000
bnep 17470 2 - Live 0xffffffffa064e000
binfmt_misc 16949 1 - Live 0xffffffffa0640000
uinput 17360 1 - Live 0xffffffffa0648000
fuse 69746 3 - Live 0xffffffffa062d000
ip6table_filter 12540 0 - Live 0xffffffffa0628000
ip6_tables 26056 1 ip6table_filter, Live 0xffffffffa061c000
xt_tcpudp 12527 2 - Live 0xffffffffa0617000
nf_conntrack_ipv4 18081 5 - Live 0xffffffffa0608000
nf_defrag_ipv4 12483 1 nf_conntrack_ipv4, Live 0xffffffffa0603000
xt_state 12503 5 - Live 0xffffffffa060e000
nf_conntrack 64016 2 nf_conntrack_ipv4,xt_state, Live 0xffffffffa05f2000
iptable_filter 12536 1 - Live 0xffffffffa054d000
ip_tables 25967 1 iptable_filter, Live 0xffffffffa05ea000
x_tables 22971 6 
ip6table_filter,ip6_tables,xt_tcpudp,xt_state,iptable_filter,ip_tables, 
Live 0xffffffffa0530000
nfsd 299197 2 - Live 0xffffffffa059f000
exportfs 12567 1 nfsd, Live 0xffffffffa0520000
nfs 296537 0 - Live 0xffffffffa0555000
lockd 79032 2 nfsd,nfs, Live 0xffffffffa0538000
fscache 36033 1 nfs, Live 0xffffffffa0526000
auth_rpcgss 44889 2 nfsd,nfs, Live 0xffffffffa044d000
nfs_acl 12511 2 nfsd,nfs, Live 0xffffffffa02c5000
sunrpc 191306 6 nfsd,nfs,lockd,auth_rpcgss,nfs_acl, Live 0xffffffffa04f0000
ext2 70675 1 - Live 0xffffffffa04dd000
loop 26506 0 - Live 0xffffffffa0445000
snd_hda_codec_hdmi 30348 1 - Live 0xffffffffa043c000
sg 29855 0 - Live 0xffffffffa04d4000
usb_storage 47847 0 - Live 0xffffffffa04c7000
uas 17272 0 - Live 0xffffffffa049e000
btusb 17289 2 - Live 0xffffffffa0483000
bluetooth 136092 23 rfcomm,bnep,btusb, Live 0xffffffffa04a4000
uvcvideo 65871 0 - Live 0xffffffffa048c000
videodev 74513 1 uvcvideo, Live 0xffffffffa046f000
media 18109 2 uvcvideo,videodev, Live 0xffffffffa024f000
v4l2_compat_ioctl32 16492 1 videodev, Live 0xffffffffa0348000
arc4 12458 2 - Live 0xffffffffa034e000
snd_hda_codec_conexant 53364 1 - Live 0xffffffffa045c000
radeon 938309 2 - Live 0xffffffffa0355000
snd_hda_intel 26018 1 - Live 0xffffffffa02bd000
joydev 17063 0 - Live 0xffffffffa02a5000
snd_hda_codec 80167 3 
snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live 
0xffffffffa0333000
rtl8192ce 72599 0 - Live 0xffffffffa0320000
rtl8192c_common 60268 1 rtl8192ce, Live 0xffffffffa0310000
rtlwifi 93087 1 rtl8192ce, Live 0xffffffffa02f8000
ttm 56328 1 radeon, Live 0xffffffffa0296000
snd_hwdep 13109 1 snd_hda_codec, Live 0xffffffffa023b000
ohci_hcd 26418 0 - Live 0xffffffffa028e000
drm_kms_helper 35137 1 radeon, Live 0xffffffffa0231000
drm 182635 4 radeon,ttm,drm_kms_helper, Live 0xffffffffa02ca000
i2c_algo_bit 12751 1 radeon, Live 0xffffffffa022c000
thinkpad_acpi 65291 0 - Live 0xffffffffa02ac000
snd_pcm 75241 3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 
0xffffffffa027a000
ehci_hcd 43856 0 - Live 0xffffffffa0215000
i2c_piix4 12536 0 - Live 0xffffffffa0227000
k10temp 12611 0 - Live 0xffffffffa0222000
i2c_core 23736 6 
videodev,radeon,drm_kms_helper,drm,i2c_algo_bit,i2c_piix4, Live 
0xffffffffa0162000
usbcore 139547 8 
usb_storage,uas,btusb,uvcvideo,rtlwifi,ohci_hcd,ehci_hcd, Live 
0xffffffffa0256000
snd_seq 52897 0 - Live 0xffffffffa0241000
evdev 17362 17 - Live 0xffffffffa01b8000
nvram 12997 1 thinkpad_acpi, Live 0xffffffffa01fa000
snd_timer 26768 2 snd_pcm,snd_seq, Live 0xffffffffa020d000
snd_seq_device 13132 1 snd_seq, Live 0xffffffffa0173000
mac80211 214045 3 rtl8192ce,rtl8192c_common,rtlwifi, Live 0xffffffffa01c4000
pcspkr 12579 0 - Live 0xffffffffa0178000
video 17628 0 - Live 0xffffffffa01be000
r8169 45590 0 - Live 0xffffffffa0200000
psmouse 59192 0 - Live 0xffffffffa017d000
serio_raw 12806 0 - Live 0xffffffffa016e000
mii 12675 1 r8169, Live 0xffffffffa0169000
cfg80211 164569 2 rtlwifi,mac80211, Live 0xffffffffa018e000
snd 60566 12 
snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,thinkpad_acpi,snd_pcm,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffffa0141000
edac_core 43315 0 - Live 0xffffffffa0156000
soundcore 13026 1 snd, Live 0xffffffffa013c000
edac_mce_amd 21199 0 - Live 0xffffffffa0129000
ac 12624 0 - Live 0xffffffffa0121000
battery 13109 0 - Live 0xffffffffa0151000
processor 27793 1 powernow_k8, Live 0xffffffffa0114000
button 12937 0 - Live 0xffffffffa0133000
wmi 17339 0 - Live 0xffffffffa010e000
power_supply 13475 3 radeon,ac,battery, Live 0xffffffffa011c000
snd_page_alloc 17065 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0108000
rfkill 18830 5 bluetooth,thinkpad_acpi,cfg80211, Live 0xffffffffa009b000
ext4 361572 2 - Live 0xffffffffa00ae000
mbcache 12985 2 ext2,ext4, Live 0xffffffffa00a5000
jbd2 73015 1 ext4, Live 0xffffffffa0088000
crc16 12343 2 bluetooth,ext4, Live 0xffffffffa0032000
sd_mod 39758 5 - Live 0xffffffffa007d000
crc_t10dif 12348 1 sd_mod, Live 0xffffffffa0071000
ahci 25089 4 - Live 0xffffffffa0069000
libahci 22685 1 ahci, Live 0xffffffffa0037000
thermal 17383 0 - Live 0xffffffffa002c000
thermal_sys 22005 3 video,processor,thermal, Live 0xffffffffa0076000
libata 147989 2 ahci,libahci, Live 0xffffffffa003f000
scsi_mod 173942 5 sg,usb_storage,uas,sd_mod,libata, Live 0xffffffffa0000000

[7.4.]
cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0062-0062 : EC data
   0064-0064 : keyboard
   0066-0066 : EC cmd
   0070-0071 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0220-022f : pnp 00:08
   03c0-03df : vga+
   040b-040b : pnp 00:08
   04d0-04d1 : pnp 00:08
   04d6-04d6 : pnp 00:08
   0530-0537 : pnp 00:08
   087f-087f : pnp 00:08
   0c00-0c01 : pnp 00:08
   0c14-0c14 : pnp 00:08
   0c50-0c52 : pnp 00:08
   0c6c-0c6c : pnp 00:08
   0c6f-0c6f : pnp 00:08
   0cd0-0cd1 : pnp 00:08
   0cd2-0cd3 : pnp 00:08
   0cd4-0cd5 : pnp 00:08
   0cd6-0cd7 : pnp 00:08
   0cd8-0cdf : pnp 00:08
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   0f40-0f47 : pnp 00:08
   0f50-0f51 : pnp 00:01
   8000-805f : pnp 00:08
     8000-8003 : ACPI PM1a_EVT_BLK
     8004-8005 : ACPI PM1a_CNT_BLK
     8008-800b : ACPI PM_TMR
     8010-8015 : ACPI CPU throttle
     8020-8027 : ACPI GPE0_BLK
     8040-8047 : piix4_smbus
   8100-81ff : pnp 00:08
   8200-82ff : pnp 00:08
     8200-8200 : ACPI PM2_CNT_BLK
   8400-840f : 0000:00:11.0
     8400-840f : ahci
   8410-8413 : 0000:00:11.0
     8410-8413 : ahci
   8420-8427 : 0000:00:11.0
     8420-8427 : ahci
   8430-8433 : 0000:00:11.0
     8430-8433 : ahci
   8440-8447 : 0000:00:11.0
     8440-8447 : ahci
   9000-9fff : PCI Bus 0000:01
     9000-90ff : 0000:01:05.0
   a000-bfff : PCI Bus 0000:02
     bc00-bcff : 0000:02:00.0
       bc00-bcff : r8169
   c000-cfff : PCI Bus 0000:08
     c000-c0ff : 0000:08:00.0
       c000-c0ff : rtlwifi


cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cedff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-afe8dfff : System RAM
   01000000-013d1d89 : Kernel code
   013d1d8a-0167147f : Kernel data
   01710000-017dcfff : Kernel bss
   a4000000-a7ffffff : GART
afe8e000-afe9ffff : ACPI Non-volatile Storage
afea0000-afeb0fff : ACPI Tables
afeb1000-afeb2fff : ACPI Non-volatile Storage
afeb3000-afefefff : reserved
afeff000-afefffff : RAM buffer
aff00000-bfffffff : reserved
c0000000-dfffffff : PCI Bus 0000:00
   c0000000-cfffffff : PCI Bus 0000:01
     c0000000-cfffffff : 0000:01:05.0
   d0000000-d03fffff : PCI Bus 0000:02
     d0000000-d0003fff : 0000:02:00.0
       d0000000-d0003fff : r8169
     d0020000-d003ffff : 0000:02:00.0
     d0200000-d0200fff : 0000:02:00.0
       d0200000-d0200fff : r8169
   d0400000-d05fffff : PCI Bus 0000:01
     d0400000-d04fffff : 0000:01:05.0
     d0500000-d050ffff : 0000:01:05.0
     d0510000-d0513fff : 0000:01:05.1
       d0510000-d0513fff : ICH HD audio
   d0600000-d06fffff : PCI Bus 0000:08
     d0600000-d0603fff : 0000:08:00.0
       d0600000-d0603fff : rtlwifi
   d0700000-d07fffff : PCI Bus 0000:02
   d0900000-d0903fff : 0000:00:14.2
     d0900000-d0903fff : ICH HD audio
   d0904000-d0904fff : 0000:00:12.0
     d0904000-d0904fff : ohci_hcd
   d0905000-d0905fff : 0000:00:13.0
     d0905000-d0905fff : ohci_hcd
   d0906000-d09060ff : 0000:00:12.2
     d0906000-d09060ff : ehci_hcd
   d0906400-d09064ff : 0000:00:13.2
     d0906400-d09064ff : ehci_hcd
   d0906800-d0906bff : 0000:00:11.0
     d0906800-d0906bff : ahci
f0000000-ffffffff : PCI Bus 0000:00
   fec00000-fec0ffff : reserved
     fec00000-fec003ff : IOAPIC 0
   fec10000-fec1001f : pnp 00:09
   fed00000-fed003ff : HPET 0
     fed00000-fed003ff : pnp 00:09
   fed61000-fed613ff : pnp 00:09
   fed80000-fed80fff : pnp 00:09
   fee00000-fee00fff : Local APIC
     fee00000-fee00fff : reserved
       fee00000-fee00fff : pnp 00:01
   fff00000-ffffffff : reserved
100000000-13fffffff : System RAM

[7.5.]
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
	Subsystem: Lenovo Device 21ca
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 
IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- 
LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 
800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- 
RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI 
bridge (int gfx) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: d0400000-d05fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] RS780/RS880 
PCI to PCI bridge (int gfx)

00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 0) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=07, sec-latency=0
	I/O behind bridge: 0000a000-0000bfff
	Memory behind bridge: d0700000-d07fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, 
L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #4, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4149
	Capabilities: [b0] Subsystem: Lenovo Device 21ca
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
	Capabilities: [110 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: d0600000-d06fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, 
L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #5, PowerLimit 25.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, 
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4151
	Capabilities: [b0] Subsystem: Lenovo Device 21ca
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
	Capabilities: [110 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: pcieport

00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA 
Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 42
	Region 0: I/O ports at 8440 [size=8]
	Region 1: I/O ports at 8430 [size=4]
	Region 2: I/O ports at 8420 [size=8]
	Region 3: I/O ports at 8410 [size=4]
	Region 4: I/O ports at 8400 [size=16]
	Region 5: Memory at d0906800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] MSI: Enable+ Count=1/8 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4161
	Capabilities: [70] SATA HBA v1.0 InCfgSpace
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 
Controller (prog-if 10 [OHCI])
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d0904000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI 
Controller (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d0906000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 
Controller (prog-if 10 [OHCI])
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d0905000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI 
Controller (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d0906400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: piix4_smbus

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
	Subsystem: Lenovo Device 21ca
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0900000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: HDA Intel

00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host 
controller (rev 40)
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 
40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- 
<EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 
IsocEn- LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: 1.0GHz
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 
800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- 
UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility 
Radeon HD 4200] (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device 21ca
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at d0500000 (32-bit, non-prefetchable) [size=64K]
	Region 5: Memory at d0400000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: radeon

01:05.1 Audio device: ATI Technologies Inc RS880 Audio Device [Radeon HD 
4200]
	Subsystem: ATI Technologies Inc Device 9712
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at d0510000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: HDA Intel

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
	Subsystem: Lenovo Device 21c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: I/O ports at bc00 [size=256]
	Region 2: Memory at d0200000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at d0000000 (64-bit, prefetchable) [size=16K]
	[virtual] Expansion ROM at d0020000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4169
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<512ns, L1 <64us
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
	Capabilities: [ac] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [cc] Vital Product Data
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
	Capabilities: [160 v1] Device Serial Number 81-00-00-00-68-4c-e0-00
	Kernel driver in use: r8169

08:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE 
802.11b/g/n WiFi Adapter (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device 8195
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at c000 [size=256]
	Region 2: Memory at d0600000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 
<512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
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
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
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
	Capabilities: [160 v1] Device Serial Number 01-91-81-fe-ff-4c-e0-00
	Kernel driver in use: rtl8192ce

[7.6.]
---

[7.7.]

/var/log/messages

Aug  2 08:46:11 stephan-thinkpad kernel: [  108.770067] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:46:11 stephan-thinkpad kernel: [  108.772624] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:46:11 stephan-thinkpad kernel: [  108.773972] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:46:11 stephan-thinkpad kernel: [  108.775401] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:46:11 stephan-thinkpad kernel: [  108.776496] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:46:11 stephan-thinkpad kernel: [  108.776503] psmouse.c: 
issuing reconnect request
Aug  2 08:55:01 stephan-thinkpad kernel: [  638.530041] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 4
Aug  2 08:55:01 stephan-thinkpad kernel: [  638.531367] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:55:01 stephan-thinkpad kernel: [  638.543811] psmouse.c: 
TouchPad at isa0060/serio4/input0 - driver resynched.
Aug  2 08:57:18 stephan-thinkpad kernel: [  774.987821] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 4
Aug  2 08:57:18 stephan-thinkpad kernel: [  774.989102] psmouse.c: 
TouchPad at isa0060/serio4/input0 lost sync at byte 1
Aug  2 08:57:18 stephan-thinkpad kernel: [  774.996836] psmouse.c: 
TouchPad at isa0060/serio4/input0 - driver resynched.

