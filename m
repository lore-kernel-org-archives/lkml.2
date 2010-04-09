Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0DIR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:58:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:50703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0DIR6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:subject:x-priority:content-type;
        b=inc7BHd/LT6nxCmjYyEvHXwk0tQRMaJ8skR4ntASV0VDvi8rxgAMUNNnrvJtOGPdJo
         r6B/YNl23Sn2/No3zFyFmbBVyZgm8kVQR3hmJbntQ0o8bg1hyD1QLgICIK0yIY6lNJoz
         Tks0TmUQE/okYdwQJ2fr+//ACqRQxzouOfFwo=
Message-ID: <4BBF6AA9.9090909@gmail.com>
Date: Fri, 09 Apr 2010 19:58:01 +0200
From: Gabriele <gabriele.martina@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem between webcam and wireless card (all integrated)
X-Priority: 1 (Highest)
Content-Type: multipart/mixed;
 boundary="------------030207040302080901060905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030207040302080901060905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi
First of all sorry for my english...

I'm gabriele from italy and i have this problem with *Ubuntu 9.10* and 
my *laptot O.book 2.1 Belinea*: when i try to use or test webcam with 
cheese or camorama or emesene, etc (or doing gstreamer-properties)... my 
internet connection disconnect and crash the wifi card. To restore all 
wireless' functions i must remove laptop's battery and boot normally . 
If i don't remove battery  first of reboot my laptop the wireless card 
connect normally with the router but don't have access to internet.
If i try to use webcam with *guvcview or doing by terminal "luvcview -f 
yuv"* it start normally and perfect while internet wireless connection 
is online and it not crash!
I attach a text file with the results of "lsusb,lsmod,lspci" by 
terminal. Notebook's processor is *AMD TURION 64x2 TL-56*, *ATI radeon 
x1200 my graphic card, integrated webcam Chicony Gateway USB 2.0 Webcam 
(100% compatibile with ubuntu), integrated wireless card Ralink 
Technology, Corp. RT2501USB Wireless Adapter.
My OS is UBUNTU 9.10 Kernel 2.6.31-21 in dual boot with Windows 7

*Last, the problem don't disappear if i try in livemode with the 
bootable cd inserts and it persists also with other Distro like Fedora, 
OpenSuse, Ubuntu 10.04 beta1, Mandriva...ONLY WITH gOS i don't have any 
problem between webcam and wireless card...

Thanx


--------------030207040302080901060905
Content-Type: text/plain;
 name="iomem"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iomem"

00000000-0000ffff : reserved
00010000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cd3ff : Video ROM
000ce000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-a7e7ffff : System RAM
  00100000-00579d77 : Kernel code
  00579d78-00791847 : Kernel data
  00820000-008ae15f : Kernel bss
a7e80000-a7e93fff : ACPI Tables
a7e94000-a7e94fff : ACPI Non-volatile Storage
a7e95000-afffffff : reserved
b0000000-b00fffff : PCI Bus 0000:05
  b0000000-b001ffff : 0000:05:00.0
c0000000-c0003fff : 0000:00:14.2
  c0000000-c0003fff : ICH HD audio
c0004000-c00043ff : 0000:00:12.0
  c0004000-c00043ff : ahci
c0004400-c00044ff : 0000:00:13.5
  c0004400-c00044ff : ehci_hcd
c0005000-c0005fff : 0000:00:13.0
  c0005000-c0005fff : ohci_hcd
c0006000-c0006fff : 0000:00:13.1
  c0006000-c0006fff : ohci_hcd
c0007000-c0007fff : 0000:00:13.2
  c0007000-c0007fff : ohci_hcd
c0008000-c0008fff : 0000:00:13.3
  c0008000-c0008fff : ohci_hcd
c0009000-c0009fff : 0000:00:13.4
  c0009000-c0009fff : ohci_hcd
c0100000-c02fffff : PCI Bus 0000:01
  c0100000-c010ffff : 0000:01:05.0
  c0200000-c02fffff : 0000:01:05.0
c0300000-c03fffff : PCI Bus 0000:05
  c0300000-c0300fff : 0000:05:00.0
    c0300000-c0300fff : r8169
c8000000-cfffffff : PCI Bus 0000:01
  c8000000-cfffffff : 0000:01:05.0
e0000000-efffffff : reserved
  e0000000-e09fffff : PCI MMCONFIG 0 [00-09]
fec00000-fec0ffff : reserved
  fec00000-fec00fff : IOAPIC 0
fed00000-fed003ff : HPET 2
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:01
fff00000-ffffffff : reserved
  fff00000-ffffffff : pnp 00:09


--------------030207040302080901060905
Content-Type: text/plain;
 name="ioports"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ioports"

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
0170-0177 : 0000:00:14.1
  0170-0177 : pata_atiixp
01f0-01f7 : 0000:00:14.1
  01f0-01f7 : pata_atiixp
0376-0376 : 0000:00:14.1
  0376-0376 : pata_atiixp
0378-037f : pnp 00:08
03c0-03df : vga+
03f6-03f6 : 0000:00:14.1
  03f6-03f6 : pata_atiixp
040b-040b : pnp 00:08
04d0-04d1 : pnp 00:08
04d6-04d6 : pnp 00:08
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
0f40-0f47 : pnp 00:08
8000-805f : pnp 00:08
  8000-8003 : ACPI PM1a_EVT_BLK
  8004-8005 : ACPI PM1a_CNT_BLK
  8008-800b : ACPI PM_TMR
  8010-8015 : ACPI CPU throttle
  8020-8027 : ACPI GPE0_BLK
8104-8107 : ACPI PM1b_EVT_BLK
8200-8200 : ACPI PM2_CNT_BLK
8400-840f : 0000:00:12.0
  8400-840f : ahci
8410-841f : 0000:00:14.0
  8410-8417 : piix4_smbus
8420-842f : 0000:00:14.1
  8420-842f : pata_atiixp
8430-8433 : 0000:00:12.0
  8430-8433 : ahci
8434-8437 : 0000:00:12.0
  8434-8437 : ahci
8438-843f : 0000:00:12.0
  8438-843f : ahci
8440-8447 : 0000:00:12.0
  8440-8447 : ahci
9000-9fff : PCI Bus 0000:01
  9000-90ff : 0000:01:05.0
a000-afff : PCI Bus 0000:05
  a000-a0ff : 0000:05:00.0
    a000-a0ff : r8169


--------------030207040302080901060905
Content-Type: text/plain;
 name="modules"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="modules"

aes_i586 8124 1 - Live 0xf80bf000
aes_generic 27484 1 aes_i586, Live 0xf8158000
binfmt_misc 8356 1 - Live 0xf80ad000
bridge 47952 0 - Live 0xf8125000
stp 2272 1 bridge, Live 0xf80c7000
ppdev 6688 0 - Live 0xf80bb000
bnep 12060 2 - Live 0xf8052000
snd_hda_codec_realtek 203328 1 - Live 0xf88ba000
snd_hda_codec_si3054 4636 1 - Live 0xf886e000
snd_hda_intel 26920 2 - Live 0xf8856000
snd_hda_codec 75708 3 snd_hda_codec_realtek,snd_hda_codec_si3054,snd_hda_intel, Live 0xf8834000
snd_hwdep 7200 1 snd_hda_codec, Live 0xf8813000
arc4 1660 2 - Live 0xf8807000
ecb 2524 2 - Live 0xf87fe000
snd_pcm_oss 37920 0 - Live 0xf87eb000
snd_mixer_oss 16028 1 snd_pcm_oss, Live 0xf87d3000
joydev 10240 0 - Live 0xf87c3000
snd_pcm 75296 4 snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf87a4000
snd_seq_dummy 2656 0 - Live 0xf8784000
snd_seq_oss 28576 0 - Live 0xf8774000
snd_seq_midi 6464 0 - Live 0xf8761000
snd_rawmidi 22176 1 snd_seq_midi, Live 0xf8751000
snd_seq_midi_event 6940 2 snd_seq_oss,snd_seq_midi, Live 0xf8740000
rt73usb 26336 0 - Live 0xf872f000
snd_seq 50224 7 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf8711000
crc_itu_t 1852 1 rt73usb, Live 0xf86fb000
snd_timer 22276 2 snd_pcm,snd_seq, Live 0xf86ed000
snd_seq_device 6920 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf86db000
snd 59204 18 snd_hda_codec_realtek,snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf86c2000
rt2500usb 21152 0 - Live 0xf86a2000
soundcore 7264 1 snd, Live 0xf8691000
rt2x00usb 11548 2 rt73usb,rt2500usb, Live 0xf8687000
rt2x00lib 29756 3 rt73usb,rt2500usb,rt2x00usb, Live 0xf8676000
snd_page_alloc 9156 2 snd_hda_intel,snd_pcm, Live 0xf8662000
led_class 4096 1 rt2x00lib, Live 0xf8656000
uvcvideo 59080 0 - Live 0xf863e000
input_polldev 3716 1 rt2x00lib, Live 0xf8626000
iptable_filter 3100 0 - Live 0xf8619000
videodev 36736 1 uvcvideo, Live 0xf8607000
mac80211 181140 2 rt2x00usb,rt2x00lib, Live 0xf85c7000
psmouse 57332 0 - Live 0xf853b000
ip_tables 11692 1 iptable_filter, Live 0xf851e000
cfg80211 93052 2 rt2x00lib,mac80211, Live 0xf84fe000
x_tables 16544 1 ip_tables, Live 0xf84d5000
v4l1_compat 14336 2 uvcvideo,videodev, Live 0xf84c6000
lp 8964 0 - Live 0xf84b7000
serio_raw 5280 0 - Live 0xf849b000
btusb 11856 2 - Live 0xf8487000
i2c_piix4 9932 0 - Live 0xf8478000
parport 35340 2 ppdev,lp, Live 0xf8464000
shpchp 32272 0 - Live 0xf844c000
k8temp 4188 0 - Live 0xf8297000
dm_raid45 84228 0 - Live 0xf80e2000
xor 15620 1 dm_raid45, Live 0xf80a7000
usbhid 38208 0 - Live 0xf8039000
usb_storage 52768 1 - Live 0xf82f1000
r8169 32064 0 - Live 0xf82c8000
mii 5212 1 r8169, Live 0xf82b6000
radeon 636000 2 - Live 0xf81f9000
ttm 36212 1 radeon, Live 0xf8137000
drm 160032 4 radeon,ttm, Live 0xf80fb000
i2c_algo_bit 5760 1 radeon, Live 0xf80c3000
video 19380 0 - Live 0xf80b4000
ati_agp 6760 0 - Live 0xf80a3000
output 2780 1 video, Live 0xf8097000
agpgart 34988 3 ttm,drm,ati_agp, Live 0xf8047000


--------------030207040302080901060905
Content-Type: text/plain;
 name="lsusb-lsmod-lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb-lsmod-lspci"

gabriele@gabriele-laptop:~$ lsusb
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 006: ID 04f2:b022 Chicony Electronics Co., Ltd Gateway USB 2.0 Webcam
Bus 001 Device 005: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter
Bus 001 Device 003: ID 043e:70f1 LG Electronics USA, Inc. 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 045e:0737 Microsoft Corp. 
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
gabriele@gabriele-laptop:~$ lspci
00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal gfx)
00:06.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 2)
00:07.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI Express Port 3)
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc RS690M [Radeon X1200 Series]
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 01)
gabriele@gabriele-laptop:~$ lsmod
Module                  Size  Used by
aes_i586                8124  1 
aes_generic            27484  1 aes_i586
binfmt_misc             8356  1 
bridge                 47952  0 
stp                     2272  1 bridge
ppdev                   6688  0 
bnep                   12060  2 
snd_hda_codec_realtek   203328  1 
snd_hda_codec_si3054     4636  1 
snd_hda_intel          26920  2 
snd_hda_codec          75708  3 snd_hda_codec_realtek,snd_hda_codec_si3054,snd_hda_intel
snd_hwdep               7200  1 snd_hda_codec
arc4                    1660  2 
ecb                     2524  2 
snd_pcm_oss            37920  0 
snd_mixer_oss          16028  1 snd_pcm_oss
joydev                 10240  0 
snd_pcm                75296  4 snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           2656  0 
snd_seq_oss            28576  0 
snd_seq_midi            6464  0 
snd_rawmidi            22176  1 snd_seq_midi
snd_seq_midi_event      6940  2 snd_seq_oss,snd_seq_midi
rt73usb                26336  0 
snd_seq                50224  7 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
crc_itu_t               1852  1 rt73usb
snd_timer              22276  2 snd_pcm,snd_seq
snd_seq_device          6920  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    59204  18 snd_hda_codec_realtek,snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
rt2500usb              21152  0 
soundcore               7264  1 snd
rt2x00usb              11548  2 rt73usb,rt2500usb
rt2x00lib              29756  3 rt73usb,rt2500usb,rt2x00usb
snd_page_alloc          9156  2 snd_hda_intel,snd_pcm
led_class               4096  1 rt2x00lib
uvcvideo               59080  0 
input_polldev           3716  1 rt2x00lib
iptable_filter          3100  0 
videodev               36736  1 uvcvideo
mac80211              181140  2 rt2x00usb,rt2x00lib
psmouse                57332  0 
ip_tables              11692  1 iptable_filter
cfg80211               93052  2 rt2x00lib,mac80211
x_tables               16544  1 ip_tables
v4l1_compat            14336  2 uvcvideo,videodev
lp                      8964  0 
serio_raw               5280  0 
btusb                  11856  2 
i2c_piix4               9932  0 
parport                35340  2 ppdev,lp
shpchp                 32272  0 
k8temp                  4188  0 
dm_raid45              84228  0 
xor                    15620  1 dm_raid45
usbhid                 38208  0 
usb_storage            52768  1 
r8169                  32064  0 
mii                     5212  1 r8169
radeon                636000  2 
ttm                    36212  1 radeon
drm                   160032  4 radeon,ttm
i2c_algo_bit            5760  1 radeon
video                  19380  0 
ati_agp                 6760  0 
output                  2780  1 video
agpgart                34988  3 ttm,drm,ati_agp
gabriele@gabriele-laptop:~$ 



--------------030207040302080901060905--
