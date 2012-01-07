Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2AGSBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:01:42 -0500
Received: from nm5-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.204]:35117 "HELO
	nm5-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750884Ab2AGSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:01:39 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 678184.86204.bm@omp1047.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:MIME-Version:Content-Type;
  b=GWSMp/AuOdLc1y57xogqv2Owu2JIS+drB0Cz+v+sHguFRzOvU4WUKmFU0ebrbGsnDG2TLEen4meY1x1JraJFV+o2DGmZv1Ol4k47V3G88Oog0Ti0Vumkztexwg+02FxhNnBep0xXstKk2w8uvZYzWGLY1SCmS24wXwqi4JcxGjc=;
X-YMail-OSG: e1QwLS0VM1m55j_GX5h9ZuEq8JS7jH5fvpkOICIqBvFqZV5
 cEUAVS3_80NQojgtJlunfTDo18HWQEhiKAxo1aMO2k8MZu9wQOP5DzkfXIqA
 cB65LCe3Uj_oHLYJjDip2L_DpwMuqV7tKxLCJnPtIoR._CP6tLB1djEb.fSe
 v74kyJvImlRC5KYBB1ma4w3m3n_rMJ76rBrbYnNfeZ7AqNJDA3WC47xrdTY7
 mQwD6BNRNEF5Gf4FyMZT8Mh1gIb1lJYw3rvYiXyfTYKtW2eJmrDvO1q2jQjW
 THXcmg7M0sS4QVHDwvbKk529WdjBVg_l1H5tqTCrXJrjYWd1Cl.AYZSwvIX1
 z0LgSr.hysdxph0xhi9msvqwBZuBC7iFEN7wyuPxDSHrPPSY0yHMgrgHWNAT
 9fKeQ_wYBU9m4hiitp_0pc4R7PdhM655kCjC1SR9sp4Q-
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.331698
Message-ID: <1325959297.82022.YahooMailClassic@web38003.mail.mud.yahoo.com>
Date: Sat, 7 Jan 2012 10:01:37 -0800 (PST)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: PROBLEM: thinkpad_acpi: acpi_evalf(\BLTH, vd, ...) failed: AE_NOT_FOUND
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. thinkpad_acpi: acpi_evalf(\BLTH, vd, ...) failed: AE_NOT_FOUND
2. When my system halt or shutdown i can see this message about 0.5 seconds, then system restart/reboot
3. kernel, acpi, thinkpad_acpi, bug
4. Linux version 3.1.7-1-ARCH (tobias@T-POWA-LX) (gcc version 4.6.2 20111223 (prerelease) (GCC) ) #1 SMP PREEMPT Wed Jan 4 08:34:05 UTC 2012
5. -
6. -
7. Arch Linux -current version with last kernel on laptop Lenovo x120e
7.1. Linux lenarch 3.1.7-1-ARCH #1 SMP PREEMPT Wed Jan 4 08:34:05 UTC 2012 i686 AMD E-350 Processor AuthenticAMD GNU/Linux
 
Gnu C                  4.6.2
Gnu make               3.82
binutils               Binutils
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.14
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.7
PPP                    2.4.5
Linux C Library        > libc.2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      so.6.0
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.14
Modules Loaded         nls_cp437 vfat fat fuse uas ums_realtek usb_storage cpufreq_ondemand rfcomm bnep ipv6 ext2 qcserial usb_wwan uvcvideo usbserial videodev media cryptd aes_i586 aes_generic ecb btusb joydev bluetooth arc4 snd_hda_codec_conexant serio_raw radeon snd_hda_codec_hdmi rtl8192ce rtl8192c_common rtlwifi ttm snd_hda_intel snd_hda_codec mac80211 psmouse drm_kms_helper thinkpad_acpi snd_hwdep snd_pcm evdev drm cfg80211 agpgart rfkill snd_timer r8169 snd snd_page_alloc soundcore thermal video k10temp i2c_piix4 i2c_algo_bit wmi nvram i2c_core mii ac button battery powernow_k8 freq_table processor mperf ext4 mbcache jbd2 crc16 sd_mod ohci_hcd ahci libahci libata ehci_hcd usbcore scsi_mod
7.2. processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 1
model name	: AMD E-350 Processor
stepping	: 0
cpu MHz		: 800.000
cache size	: 512 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc nonstop_tsc extd_apicid aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt arat npt lbrv svm_lock nrip_save pausefilter
bogomips	: 3194.30
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 20
model		: 1
model name	: AMD E-350 Processor
stepping	: 0
cpu MHz		: 800.000
cache size	: 512 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc nonstop_tsc extd_apicid aperfmperf pni monitor ssse3 cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch ibs skinit wdt arat npt lbrv svm_lock nrip_save pausefilter
bogomips	: 3194.24
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
7.3. nls_cp437 4605 1 - Live 0xf80f5000
vfat 8611 1 - Live 0xf80ec000
fat 42946 1 vfat, Live 0xf80d6000
fuse 58437 2 - Live 0xf80ad000
uas 6440 0 - Live 0xf808e000
ums_realtek 5913 0 - Live 0xf8065000
usb_storage 35343 2 ums_realtek, Live 0xf804f000
cpufreq_ondemand 5056 2 - Live 0xfa4b0000
rfcomm 28655 8 - Live 0xfa49f000
bnep 7162 2 - Live 0xfa48a000
ipv6 247457 18 - Live 0xfa437000
ext2 54796 1 - Live 0xfa3b5000
qcserial 3482 0 - Live 0xfa399000
usb_wwan 7830 1 qcserial, Live 0xfa38e000
uvcvideo 57555 0 - Live 0xfa36e000
usbserial 26735 2 qcserial,usb_wwan, Live 0xfa34b000
videodev 77028 1 uvcvideo, Live 0xfa321000
media 8609 2 uvcvideo,videodev, Live 0xf9ed7000
cryptd 6925 0 - Live 0xf9ebf000
aes_i586 6940 2 - Live 0xf9eb6000
aes_generic 25702 1 aes_i586, Live 0xf9ea9000
ecb 1637 1 - Live 0xf8022000
btusb 9857 2 - Live 0xf9a76000
joydev 7439 0 - Live 0xf997c000
bluetooth 130968 23 rfcomm,bnep,btusb, Live 0xf9a41000
arc4 1086 2 - Live 0xf9947000
snd_hda_codec_conexant 39627 1 - Live 0xf9122000
serio_raw 3390 0 - Live 0xf90f9000
radeon 913985 2 - Live 0xf8bdf000
snd_hda_codec_hdmi 20797 1 - Live 0xf8ce4000
rtl8192ce 67227 0 - Live 0xf8aa3000
rtl8192c_common 52872 1 rtl8192ce, Live 0xf8a78000
rtlwifi 82968 1 rtl8192ce, Live 0xf8a47000
ttm 45685 1 radeon, Live 0xf8a13000
snd_hda_intel 19293 2 - Live 0xf89ea000
snd_hda_codec 69829 3 snd_hda_codec_conexant,snd_hda_codec_hdmi,snd_hda_intel, Live 0xf89a4000
mac80211 196411 3 rtl8192ce,rtl8192c_common,rtlwifi, Live 0xf8869000
psmouse 56772 0 - Live 0xf88c0000
drm_kms_helper 22237 1 radeon, Live 0xf8818000
thinkpad_acpi 54704 0 - Live 0xf87f3000
snd_hwdep 4942 1 snd_hda_codec, Live 0xf87c5000
snd_pcm 60207 4 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live 0xf8790000
evdev 7278 17 - Live 0xf8720000
drm 149266 4 radeon,ttm,drm_kms_helper, Live 0xf86e3000
cfg80211 142604 2 rtlwifi,mac80211, Live 0xf8675000
agpgart 22287 2 ttm,drm, Live 0xf8633000
rfkill 12470 5 bluetooth,thinkpad_acpi,cfg80211, Live 0xf861e000
snd_timer 15438 2 snd_pcm, Live 0xf85eb000
r8169 38567 0 - Live 0xf85d0000
snd 43817 10 snd_hda_codec_conexant,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,thinkpad_acpi,snd_hwdep,snd_pcm,snd_timer, Live 0xf8584000
snd_page_alloc 5869 2 snd_hda_intel,snd_pcm, Live 0xf8538000
soundcore 5018 1 snd, Live 0xf852d000
thermal 6531 0 - Live 0xf851c000
video 9716 0 - Live 0xf8504000
k10temp 2139 0 - Live 0xf84f9000
i2c_piix4 7084 0 - Live 0xf84f1000
i2c_algo_bit 4423 1 radeon, Live 0xf84e7000
wmi 7263 0 - Live 0xf84d7000
nvram 4765 1 thinkpad_acpi, Live 0xf84c6000
i2c_core 16816 6 videodev,radeon,drm_kms_helper,drm,i2c_piix4,i2c_algo_bit, Live 0xf84a0000
mii 3407 1 r8169, Live 0xf8491000
ac 1796 0 - Live 0xf8472000
button 3614 0 - Live 0xf846b000
battery 5053 0 - Live 0xf8462000
powernow_k8 12077 0 - Live 0xf8457000
freq_table 2079 2 cpufreq_ondemand,powernow_k8, Live 0xf844c000
processor 21844 3 powernow_k8, Live 0xf843e000
mperf 1027 1 powernow_k8, Live 0xf842d000
ext4 341420 2 - Live 0xf83c2000
mbcache 4281 2 ext2,ext4, Live 0xf8344000
jbd2 59633 1 ext4, Live 0xf8327000
crc16 1091 2 bluetooth,ext4, Live 0xf8308000
sd_mod 26147 7 - Live 0xf82fb000
ohci_hcd 19226 0 - Live 0xf82e1000
ahci 17497 4 - Live 0xf82ca000
libahci 16783 1 ahci, Live 0xf82b4000
libata 146564 2 ahci,libahci, Live 0xf8274000
ehci_hcd 36074 0 - Live 0xf8265000
usbcore 120796 12 uas,ums_realtek,usb_storage,qcserial,usb_wwan,uvcvideo,usbserial,btusb,rtlwifi,ohci_hcd,ehci_hcd, Live 0xf81c0000
scsi_mod 112473 4 uas,usb_storage,sd_mod,libata, Live 0xf806c000
7.4. 0000-0cf7 : PCI Bus 0000:00
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
  03c0-03df : vga+
  04d0-04d1 : pnp 00:08
  0530-0537 : pnp 00:08
  0800-0827 : pnp 00:08
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0820-0827 : ACPI GPE0_BLK
  0830-0830 : pnp 00:08
  0840-0847 : pnp 00:08
  0b00-0b1f : pnp 00:08
    0b00-0b07 : piix4_smbus
  0b20-0b3f : pnp 00:08
  0c00-0c01 : pnp 00:08
  0c14-0c14 : pnp 00:08
  0c50-0c52 : pnp 00:08
  0cd0-0cd1 : pnp 00:08
  0cd2-0cd3 : pnp 00:08
  0cd4-0cd5 : pnp 00:08
  0cd6-0cd7 : pnp 00:08
  0cd8-0cdf : pnp 00:08
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  0f50-0f51 : pnp 00:01
  2000-2fff : PCI Bus 0000:04
    2000-20ff : 0000:04:00.0
      2000-20ff : rtlwifi
  3000-3fff : PCI Bus 0000:01
    3000-30ff : 0000:01:00.0
      3000-30ff : r8169
  4000-40ff : 0000:00:01.0
  4100-410f : 0000:00:11.0
    4100-410f : ahci
  4110-4117 : 0000:00:11.0
    4110-4117 : ahci
  4118-411f : 0000:00:11.0
    4118-411f : ahci
  4120-4123 : 0000:00:11.0
    4120-4123 : ahci
  4124-4127 : 0000:00:11.0
    4124-4127 : ahci
  8100-81ff : pnp 00:08
  8200-82ff : pnp 00:08

00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
  000a0000-000bffff : Video RAM area
000c0000-000ce1ff : Video ROM
  000c0000-000c1fff : PCI Bus 0000:00
  000c2000-000c3fff : PCI Bus 0000:00
  000c4000-000c5fff : PCI Bus 0000:00
  000c6000-000c7fff : PCI Bus 0000:00
  000c8000-000c9fff : PCI Bus 0000:00
  000ca000-000cbfff : PCI Bus 0000:00
  000cc000-000cdfff : PCI Bus 0000:00
000d0000-000d1fff : PCI Bus 0000:00
000d2000-000d3fff : PCI Bus 0000:00
000d4000-000d5fff : PCI Bus 0000:00
000d6000-000d7fff : PCI Bus 0000:00
000d8000-000d9fff : PCI Bus 0000:00
000da000-000dbfff : PCI Bus 0000:00
000dc000-000ddfff : PCI Bus 0000:00
000de000-000dffff : PCI Bus 0000:00
000e0000-000fffff : reserved
  000e0000-000e1fff : PCI Bus 0000:00
  000e2000-000e3fff : PCI Bus 0000:00
  000e4000-000e5fff : PCI Bus 0000:00
  000e6000-000e7fff : PCI Bus 0000:00
  000e8000-000e9fff : PCI Bus 0000:00
  000ea000-000ebfff : PCI Bus 0000:00
  000ec000-000edfff : PCI Bus 0000:00
  000ee000-000effff : PCI Bus 0000:00
  000f0000-000fffff : System ROM
00100000-a5e79fff : System RAM
  00100000-00464354 : Kernel code
  00464355-005d6fbf : Kernel data
  0065b000-0073ffff : Kernel bss
a5e7a000-a6289fff : reserved
a628a000-a6309fff : ACPI Non-volatile Storage
a630a000-a6369fff : ACPI Tables
a636a000-a6d7ffff : System RAM
a6d80000-a6ffffff : reserved
a7000000-a7ffffff : RAM buffer
bf000000-f7ffffff : PCI Bus 0000:00
  bf000000-bf0fffff : PCI Bus 0000:01
  bf100000-bf2fffff : PCI Bus 0000:04
  c0000000-cfffffff : 0000:00:01.0
  d0000000-d00fffff : PCI Bus 0000:01
    d0000000-d0003fff : 0000:01:00.0
      d0000000-d0003fff : r8169
    d0004000-d0004fff : 0000:01:00.0
      d0004000-d0004fff : r8169
    d0020000-d003ffff : 0000:01:00.0
  d0100000-d01fffff : PCI Bus 0000:04
    d0100000-d0103fff : 0000:04:00.0
      d0100000-d0103fff : rtlwifi
  d0200000-d023ffff : 0000:00:01.0
  d0240000-d0243fff : 0000:00:14.2
    d0240000-d0243fff : ICH HD audio
  d0244000-d0247fff : 0000:00:01.1
    d0244000-d0247fff : ICH HD audio
  d0248000-d0248fff : 0000:00:13.0
    d0248000-d0248fff : ohci_hcd
  d0249000-d0249fff : 0000:00:12.0
    d0249000-d0249fff : ohci_hcd
  d024a000-d024a3ff : 0000:00:11.0
    d024a000-d024a3ff : ahci
  d024a400-d024a4ff : 0000:00:13.2
    d024a400-d024a4ff : ehci_hcd
  d024a500-d024a5ff : 0000:00:12.2
    d024a500-d024a5ff : ehci_hcd
f8000000-ffffffff : PCI Bus 0000:00
  f8000000-f9ffffff : PCI MMCONFIG 0000 [bus 00-1f]
    f8000000-f9ffffff : pnp 00:01
  fec00000-fecfffff : reserved
    fec00000-fec003ff : IOAPIC 0
    fec10000-fec1001f : pnp 00:09
  fed00000-fed003ff : HPET 2
    fed00000-fed003ff : pnp 00:09
  fed61000-fed613ff : pnp 00:09
  fed80000-fed80fff : reserved
    fed80000-fed80fff : pnp 00:09
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:01
  ffe00000-ffffffff : reserved
    ffe00000-ffffffff : pnp 00:09

7.5. 00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
	Subsystem: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64

00:01.0 VGA compatible controller: ATI Technologies Inc Wrestler [Radeon HD 6310] (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 4000 [size=256]
	Region 2: Memory at d0200000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4181
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: radeon
	Kernel modules: radeon

00:01.1 Audio device: ATI Technologies Inc Wrestler HDMI Audio [Radeon HD 6250/6310]
	Subsystem: ATI Technologies Inc Wrestler HDMI Audio [Radeon HD 6250/6310]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 44
	Region 0: Memory at d0244000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4179
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:06.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: bf000000-bf0fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #6, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4149
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] Device 1234
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 4118 [size=8]
	Region 1: I/O ports at 4124 [size=4]
	Region 2: I/O ports at 4110 [size=8]
	Region 3: I/O ports at 4120 [size=4]
	Region 4: I/O ports at 4100 [size=16]
	Region 5: Memory at d024a000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] SATA HBA v1.0 InCfgSpace
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci
	Kernel modules: ahci

00:12.0 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d0249000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:12.2 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d024a500 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:13.0 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d0248000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci-hcd

00:13.2 USB controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d024a400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 42)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Kernel driver in use: piix4_smbus
	Kernel modules: i2c-piix4, sp5100_tco

00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
	Subsystem: Lenovo Device 21df
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d0240000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:15.0 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #247, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4151
	Capabilities: [b0] Subsystem: ATI Technologies Inc Device 0000
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:15.1 PCI bridge: ATI Technologies Inc SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d0100000-d01fffff
	Prefetchable memory behind bridge: 00000000bf100000-00000000bf2fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4159
	Capabilities: [b0] Subsystem: ATI Technologies Inc Device 0000
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k10temp
	Kernel modules: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
	Subsystem: Lenovo Device 21df
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: I/O ports at 3000 [size=256]
	Region 2: Memory at d0004000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at d0000000 (64-bit, prefetchable) [size=16K]
	Expansion ROM at d0020000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4171
	Capabilities: [70] Express (v2) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
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
	Capabilities: [160 v1] Device Serial Number 16-02-00-00-68-4c-e0-00
	Kernel driver in use: r8169
	Kernel modules: r8169

04:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device 8195
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at d0100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
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
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis+
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP+ Rollover- Timeout+ NonFatalErr+
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
	Kernel modules: rtl8192ce
7.6. Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD3200BEVT-0 Rev: 02.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic- Model: Multi-Card       Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
7.7. [root@lenarch tmp]# cat /proc/acpi/wakeup 
Device	S-state	  Status   Sysfs node
PB4	  S4	*disabled  
PB5	  S4	*disabled  
PB6	  S4	*disabled  pci:0000:00:06.0
PB7	  S4	*disabled  
OHC1	  S3	*disabled  pci:0000:00:12.0
EHC1	  S3	*disabled  pci:0000:00:12.2
OHC2	  S3	*disabled  pci:0000:00:13.0
EHC2	  S3	*disabled  pci:0000:00:13.2
OHC3	  S3	*disabled  
EHC3	  S3	*disabled  
OHC4	  S3	*disabled  
SBAZ	  S4	*disabled  pci:0000:00:14.2
GEC	  S4	*disabled  
P2P	  S5	*disabled  pci:0000:00:14.4
SPB0	  S4	*disabled  pci:0000:00:15.0
SPB1	  S4	*disabled  pci:0000:00:15.1
SPB2	  S4	*disabled  
SPB3	  S4	*disabled  
LID	  S4	*enabled   
[root@lenarch tmp]# tail -n 100 /proc/acpi/ibm/*
==> /proc/acpi/ibm/beep <==
status:		supported
commands:	<cmd> (<cmd> is 0-17)

==> /proc/acpi/ibm/bluetooth <==
status:		enabled
commands:	enable, disable

==> /proc/acpi/ibm/driver <==
driver:		ThinkPad ACPI Extras
version:	0.24

==> /proc/acpi/ibm/fan <==
status:		enabled
speed:		500
level:		auto

==> /proc/acpi/ibm/hotkey <==
status:		enabled
mask:		0x048988fc
commands:	enable, disable, reset, <mask>

==> /proc/acpi/ibm/led <==
status:		supported
commands:	<led> on, <led> off, <led> blink (<led> is 0-15)

==> /proc/acpi/ibm/thermal <==
temperatures:	64 0 64 0 0 0 31 0

==> /proc/acpi/ibm/volume <==
level:		unsupported
mute:		off

[root@lenarch tmp]# cat /proc/acpi/button/lid/LID/state 
state:      open

Thank you!
Your sincerely, Denis Lotarev
