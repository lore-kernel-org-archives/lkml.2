Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0KYPHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:07:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53769 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0KYPHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:07:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=obhnLc9ShL1kZOR8+A46EBVz8cmWXS14Brv4IIlMLVnlUc1QkG8G1koNFPKw7bU1bd
         2sPB2qzAQKOPo0PpyvGTaJl8BfczEJTVJAecvqWY6TvkrwV0AyhmNO6qIVT30GI0pexP
         z7qb3VApetOOTwxoJBDVe4ColIs2hsUd/rKfg=
Message-ID: <4CEE7BBC.4000007@gmail.com>
Date: Thu, 25 Nov 2010 16:07:40 +0100
From: Petar Velkovski <pvelkovski@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: gspca REGRESION in 2.6.36 and 2.6.37
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.Webcam that used to work in linux 2.6.35 (an previous versions) does not work any more in linux 2.6.36 and 2.6.37

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2. My Logitech, Inc. QuickCam Messenger Plus (ID 046d:08f6) that used to work under linux 2.6.35 does not work any more under the latest versions of the kernel (I tried with both 2.6.36 and 2.6.37).
When I plug in the camera, it is recognized by the system but it is unusable under any program.

This is the output of dmesg when I plug in the camera:
....
[ 1826.708018] usb 3-1: new full speed USB device using uhci_hcd and address 3
[ 1826.903133] STV06xx: Probing for a stv06xx device
[ 1826.903137] gspca: probing 046d:08f6
[ 1826.903139] STV06xx: Configuring camera
[ 1826.903141] STV06xx: st6422 sensor detected
[ 1826.903143] STV06xx: Initializing camera
[ 1827.188084] input: STV06xx as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/input/input8
[ 1827.188184] gspca: video0 created
[ 1827.188268] STV06xx: Probing for a stv06xx device

This is the error message I get when I try running mplayer tv://

MPlayer 1.0rc4-4.4.5 (C) 2000-2010 MPlayer Team
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
  name: Video 4 Linux 2 input
  author: Martin Olschewski<olschewski@zpr.uni-koeln.de>
  comment: first try, more to come ;-)
v4l2: your device driver does not support VIDIOC_G_STD ioctl, VIDIOC_G_PARM was used instead.
Selected device: Camera
  Capabilites:  video capture  read/write  streaming
  supported norms:
  inputs: 0 = STV06xx;
  Current input: 0
  Current format: unknown (0x47425247)
tv.c: norm_from_string(pal): Bogus norm parameter, setting default.
v4l2: ioctl enum norm failed: Invalid argument
Error: Cannot set norm!
Selected input hasn't got a tuner!
v4l2: Cannot get fps
v4l2: ioctl set mute failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl streamon failed: Input/output error
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
open: No such file or directory
[MGA] Couldn't open: /dev/mga_vid
[VO_TDFXFB] Can't open /dev/fb0: No such file or directory.
[VO_3DFX] Unable to open /dev/3dfx.
==========================================================================
Cannot find codec matching selected -vo and video format 0x47425247.
==========================================================================

v4l2: ioctl set mute failed: Invalid argument
v4l2: 0 frames successfully processed, 0 frames dropped.

Exiting... (End of file)

After mplayer fails, dmesg gives the following message:

[ 1937.249467] gspca: no transfer endpoint found

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


3. Keywords: gspca, STV06xx

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


4. Linux version 2.6.37-5-generic (buildd@hassium) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #13-Ubuntu SMP Wed Nov 17 07:12:35 UTC 2010

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


5.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


6.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


7.

7.1 sh ver_linux

Linux aurora 2.6.37-5-generic #13-Ubuntu SMP Wed Nov 17 07:12:35 UTC 2010 i686 GNU/Linux

Gnu C                  4.4.5
Gnu make               3.81
binutils               2.20.51
util-linux             2.17.2
mount                  support
module-init-tools      3.12
e2fsprogs              1.41.12
pcmciautils            014
Linux C Library        2.12.1
Dynamic linker (ldd)   2.12.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               8.5
wireless-tools         30
Modules Loaded         binfmt_misc vboxnetadp vboxnetflt vboxdrv parport_pc ppdev ipt_REJECT ipt_LOG xt_limit snd_hda_codec_hdmi xt_tcpudp ipt_addrtype nvidia snd_hda_codec_realtek gspca_stv06xx xt_state snd_hda_intel snd_usb_audio snd_hda_codec gspca_main video ip6table_filter snd_pcm snd_hwdep ip6_tables snd_usbmidi_lib nf_nat_irc usbhid snd_seq_midi nf_conntrack_irc snd_rawmidi nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 snd_seq_midi_event intel_agp w83627ehf hwmon_vid snd_seq snd_timer nf_conntrack_ftp coretemp nf_conntrack intel_gtt agpgart uvcvideo output videodev psmouse snd_seq_device iptable_filter lp parport ip_tables hid serio_raw v4l1_compat snd snd_page_alloc x_tables soundcore r8169 mii

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


7.2 cat /proc/cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping	: 10
cpu MHz		: 1998.000
cache size	: 6144 KB
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
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm dts tpr_shadow vnmi flexpriority
bogomips	: 6000.05
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
stepping	: 10
cpu MHz		: 1998.000
cache size	: 6144 KB
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
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm dts tpr_shadow vnmi flexpriority
bogomips	: 5999.80
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


7.3 cat /proc/modules

binfmt_misc 6598 1 - Live 0xf81c8000
vboxnetadp 6590 0 - Live 0xf81a5000
vboxnetflt 15156 0 - Live 0xf8102000
vboxdrv 190231 2 vboxnetadp,vboxnetflt, Live 0xf82a7000
parport_pc 26058 0 - Live 0xf80e3000
ppdev 5394 0 - Live 0xf8029000
ipt_REJECT 1972 1 - Live 0xf80d3000
ipt_LOG 6731 5 - Live 0xf8030000
xt_limit 1426 7 - Live 0xf81df000
snd_hda_codec_hdmi 21369 4 - Live 0xf81c0000
xt_tcpudp 1927 13 - Live 0xf81a9000
ipt_addrtype 1611 4 - Live 0xf802d000
nvidia 9330157 49 - Live 0xf8fbc000 (P)
snd_hda_codec_realtek 249081 1 - Live 0xf8f75000
gspca_stv06xx 23798 0 - Live 0xf8f41000
xt_state 1014 7 - Live 0xf8eb8000
snd_hda_intel 22006 2 - Live 0xf8eb0000
snd_usb_audio 88582 1 - Live 0xf8406000
snd_hda_codec 84295 3 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xf82d9000
gspca_main 22913 1 gspca_stv06xx, Live 0xf829f000
video 11788 0 - Live 0xf827f000
ip6table_filter 1243 1 - Live 0xf8170000
snd_pcm 72431 3 snd_hda_intel,snd_usb_audio,snd_hda_codec, Live 0xf8158000
snd_hwdep 5072 2 snd_usb_audio,snd_hda_codec, Live 0xf80fe000
ip6_tables 11796 1 ip6table_filter, Live 0xf80db000
snd_usbmidi_lib 17504 1 snd_usb_audio, Live 0xf80cc000
nf_nat_irc 1202 0 - Live 0xf8fb9000
usbhid 35953 0 - Live 0xf8f6a000
snd_seq_midi 4652 0 - Live 0xf8f52000
nf_conntrack_irc 3348 1 nf_nat_irc, Live 0xf8f25000
snd_rawmidi 17911 2 snd_usbmidi_lib,snd_seq_midi, Live 0xf8eeb000
nf_nat_ftp 1432 0 - Live 0xf8edb000
nf_nat 15461 2 nf_nat_irc,nf_nat_ftp, Live 0xf8ecd000
nf_conntrack_ipv4 10788 9 nf_nat, Live 0xf8ebb000
nf_defrag_ipv4 1149 1 nf_conntrack_ipv4, Live 0xf8ead000
snd_seq_midi_event 6047 1 snd_seq_midi, Live 0xf8e8a000
intel_agp 9842 0 - Live 0xf84af000
w83627ehf 19103 0 - Live 0xf849b000
hwmon_vid 2310 1 w83627ehf, Live 0xf848a000
snd_seq 47142 2 snd_seq_midi,snd_seq_midi_event, Live 0xf844a000
snd_timer 19195 2 snd_pcm,snd_seq, Live 0xf83ff000
nf_conntrack_ftp 5361 1 nf_nat_ftp, Live 0xf83ed000
coretemp 5043 0 - Live 0xf83e1000
nf_conntrack 64411 7 xt_state,nf_nat_irc,nf_conntrack_irc,nf_nat_ftp,nf_nat,nf_conntrack_ipv4,nf_conntrack_ftp, Live 0xf83c0000
intel_gtt 13224 1 intel_agp, Live 0xf839c000
agpgart 31115 3 nvidia,intel_agp,intel_gtt, Live 0xf8373000
uvcvideo 57794 0 - Live 0xf8336000
output 1851 1 video, Live 0xf831a000
videodev 67362 2 gspca_main,uvcvideo, Live 0xf8263000
psmouse 57346 0 - Live 0xf8231000
snd_seq_device 5776 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf81fa000
iptable_filter 1302 1 - Live 0xf81ec000
lp 7273 0 - Live 0xf81e1000
parport 31620 3 parport_pc,ppdev,lp, Live 0xf81cc000
ip_tables 10492 1 iptable_filter, Live 0xf810d000
hid 68861 1 usbhid, Live 0xf80eb000
serio_raw 3990 0 - Live 0xf8026000
v4l1_compat 13519 2 uvcvideo,videodev, Live 0xf8172000
snd 49262 18 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_usb_audio,snd_hda_codec,snd_pcm,snd_hwdep,snd_usbmidi_lib,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf8111000
snd_page_alloc 7184 2 snd_hda_intel,snd_pcm, Live 0xf8033000
x_tables 15921 10 ipt_REJECT,ipt_LOG,xt_limit,xt_tcpudp,ipt_addrtype,xt_state,ip6table_filter,ip6_tables,iptable_filter,ip_tables, Live 0xf8041000
soundcore 880 1 snd, Live 0xf8023000
r8169 34284 0 - Live 0xf8036000
mii 4425 1 r8169, Live 0xf801b000
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
7.4 cat /proc/ioports

0000-0cf7 : PCI Bus 0000:00
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
   03c0-03df : vga+
   03f6-03f6 : 0000:00:1f.1
     03f6-03f6 : ata_piix
   0400-041f : 0000:00:1f.3
   0480-04bf : 0000:00:1f.0
     0480-04bf : pnp 00:02
   04d0-04d1 : pnp 00:07
   0800-087f : 0000:00:1f.0
     0800-087f : pnp 00:02
       0800-0803 : ACPI PM1a_EVT_BLK
       0804-0805 : ACPI PM1a_CNT_BLK
       0808-080b : ACPI PM_TMR
       0810-0815 : ACPI CPU throttle
       0828-082f : ACPI GPE0_BLK
   0a15-0a16 : w83627ehf
     0a15-0a16 : w83627ehf
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   c000-cfff : PCI Bus 0000:02
   d000-dfff : PCI Bus 0000:03
     d000-d0ff : 0000:03:00.0
       d000-d0ff : r8169
   e000-efff : PCI Bus 0000:01
     e000-e07f : 0000:01:00.0
   f020-f03f : 0000:00:1d.3
     f020-f03f : uhci_hcd
   f040-f05f : 0000:00:1d.2
     f040-f05f : uhci_hcd
   f060-f07f : 0000:00:1d.1
     f060-f07f : uhci_hcd
   f080-f09f : 0000:00:1d.0
     f080-f09f : uhci_hcd
   f0a0-f0af : 0000:00:1f.2
     f0a0-f0af : ata_piix
   f0b0-f0b3 : 0000:00:1f.2
     f0b0-f0b3 : ata_piix
   f0c0-f0c7 : 0000:00:1f.2
     f0c0-f0c7 : ata_piix
   f0d0-f0d3 : 0000:00:1f.2
     f0d0-f0d3 : ata_piix
   f0e0-f0e7 : 0000:00:1f.2
     f0e0-f0e7 : ata_piix
   f0f0-f0ff : 0000:00:1f.1
     f0f0-f0ff : ata_piix

cat /proc/iomem

00000000-0000ffff : reserved
00010000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
   000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-7f391fff : System RAM
   00100000-005f2b09 : Kernel code
   005f2b0a-00842907 : Kernel data
   008f5000-009cb943 : Kernel bss
7f392000-7f414fff : ACPI Non-volatile Storage
7f415000-7f654fff : reserved
7f655000-7f65dfff : ACPI Tables
7f65e000-7f667fff : ACPI Non-volatile Storage
7f668000-7f688fff : reserved
7f689000-7f68efff : ACPI Non-volatile Storage
7f68f000-7f7fffff : System RAM
7f800000-7fffffff : RAM buffer
80000000-ffffffff : PCI Bus 0000:00
   d0000000-e30fffff : PCI Bus 0000:01
     d0000000-dfffffff : 0000:01:00.0
     e0000000-e1ffffff : 0000:01:00.0
     e2000000-e2ffffff : 0000:01:00.0
       e2000000-e2ffffff : nvidia
     e3000000-e307ffff : 0000:01:00.0
     e3080000-e3083fff : 0000:01:00.1
       e3080000-e3083fff : ICH HD audio
   e3100000-e31fffff : PCI Bus 0000:03
     e3100000-e310ffff : 0000:03:00.0
     e3110000-e3113fff : 0000:03:00.0
       e3110000-e3113fff : r8169
     e3114000-e3114fff : 0000:03:00.0
       e3114000-e3114fff : r8169
   e3200000-e3203fff : 0000:00:1b.0
     e3200000-e3203fff : ICH HD audio
   e3204000-e32043ff : 0000:00:1d.7
     e3204000-e32043ff : ehci_hcd
   f0000000-f7ffffff : PCI MMCONFIG 0000 [bus 00-7f]
     f0000000-f7ffffff : pnp 00:01
   fec00000-fec00fff : reserved
     fec00000-fec003ff : IOAPIC 0
   fed00000-fed00fff : reserved
     fed00000-fed003ff : HPET 0
   fed14000-fed19fff : pnp 00:01
   fed1c000-fed8ffff : reserved
     fed1c000-fed1ffff : pnp 00:02
     fed20000-fed8ffff : pnp 00:02
   fee00000-fee00fff : Local APIC
     fee00000-fee00fff : pnp 00:02
   ff900000-ffafffff : PCI Bus 0000:03
   ffb00000-ffcfffff : PCI Bus 0000:02
   ffd00000-ffefffff : PCI Bus 0000:02
   fff00000-ffffffff : reserved

7.5 sudo lspci -vvv
[sudo] password for petar:
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
	Subsystem: Intel Corporation Device d613
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort+>SERR-<PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c<?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root Port (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: d0000000-e30fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort-<SERR-<PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort->Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Intel Corporation Device d613
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4149
	Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s<64ns, L1<1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM unknown, Latency L0<256ns, L1<4us
			ClockPM- Surprise- LLActRep- BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 01)
	Subsystem: Intel Corporation Device d613
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at e3200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4181
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s<64ns, L1<1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0<64ns, L1<1us
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
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: ffd00000-ffefffff
	Prefetchable memory behind bridge: 00000000ffb00000-00000000ffcfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort-<SERR-<PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort->Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0<256ns, L1<4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4151
	Capabilities: [90] Subsystem: Intel Corporation Device d613
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: e3100000-e31fffff
	Prefetchable memory behind bridge: 00000000ff900000-00000000ffafffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort-<SERR-<PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort->Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0<256ns, L1<4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt+ HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4159
	Capabilities: [90] Subsystem: Intel Corporation Device d613
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=1 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c001
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at f080 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at f060 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at f040 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at f020 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device d613
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at e3204000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort+<SERR-<PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort->Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Intel Corporation Device d613

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c<?>
	Kernel modules: leds-ss4200, iTCO_wdt, intel-rng

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at f0f0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation N10/ICH7 Family SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at f0e0 [size=8]
	Region 1: I/O ports at f0d0 [size=4]
	Region 2: I/O ports at f0c0 [size=8]
	Region 3: I/O ports at f0b0 [size=4]
	Region 4: I/O ports at f0a0 [size=16]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 01)
	Subsystem: Intel Corporation Device d613
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Interrupt: pin B routed to IRQ 4
	Region 4: I/O ports at 0400 [size=32]
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation GT215 [GeForce GT 240] (rev a2) (prog-if 00 [VGA controller])
	Subsystem: nVidia Corporation Device 0789
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at e0000000 (64-bit, prefetchable) [size=32M]
	Region 5: I/O ports at e000 [size=128]
	[virtual] Expansion ROM at e3000000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1<64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0<512ns, L1<4us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [b4] Vendor Specific Information: Len=14<?>
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting<?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024<?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia-current, nouveau, nvidiafb

01:00.1 Audio device: nVidia Corporation High Definition Audio Controller (rev a1)
	Subsystem: nVidia Corporation Device 0789
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at e3080000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s<4us, L1<64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0<512ns, L1<1us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
	Subsystem: Intel Corporation Device d613
	Physical Slot: 0-1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast>TAbort-<TAbort-<MAbort->SERR-<PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: I/O ports at d000 [size=256]
	Region 2: Memory at e3114000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at e3110000 (64-bit, prefetchable) [size=16K]
	Expansion ROM at e3100000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4179
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s<512ns, L1<64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0<512ns, L1<64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [ac] MSI-X: Enable- Count=4 Masked-
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [cc] Vital Product Data
		Unknown small resource type 00, will not decode more.
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169
	Kernel modules: r8169

7.6 cat /proc/scsi/scsi

Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: Hitachi HDT72103 Rev: ST2O
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: SAMSUNG HD082GJ  Rev: JE10
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 01 Lun: 00
   Vendor: ATA      Model: Hitachi HDS72105 Rev: JP2O
   Type:   Direct-Access                    ANSI  SCSI revision: 05



