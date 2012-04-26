Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab2DZQJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:09:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50077 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758267Ab2DZQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:09:06 -0400
X-Authenticated: #25741485
X-Provags-ID: V01U2FsdGVkX18wqTJmylAwVb/uMdtrWGk+2HpD3MoecSGQdMI2JM
	WTlSOU0yZQmMak
Message-ID: <4F997340.3070401@quantentunnel.de>
Date: Thu, 26 Apr 2012 18:09:36 +0200
From: Kris Erik Schwerdt <kriserik@quantentunnel.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: cp210x
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig695C1BAC3292E006D28FA2DA"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig695C1BAC3292E006D28FA2DA
Content-Type: multipart/mixed;
 boundary="------------080000060305020408070605"

This is a multi-part message in MIME format.
--------------080000060305020408070605
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear Sir or Madam,

I would like to report a bug sice kernel 3.3.1.

[1.] One line summary of the problem:

	The module cp210x causes kernelpanic.

[2.] Full description of the problem/report:
=09
	By connecting a usb-device with ID 10c4:ea60 to the computer the module
cp210x causes a recursive fault and the kernel is halted.

[3.] Keywords (i.e., modules, networking, kernel):
=09
	module: cp210x, usb to serial converter, kernel 3.3.1, kernel 3.3.2,
kernel 3.3.3

[4.] Kernel version (from /proc/version):

	Linux version 3.3.3-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.0
20120414 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Apr 23 09:41:07 CEST 201=
2

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)

	it was not possible to save the oops message. but at the and there was
a line with "recursive fault fixed, but system has to reboot"

[6.] A small shell script or example program which triggers the
     problem (if possible)

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

Linux fridolin 3.3.3-1-ARCH #1 SMP PREEMPT Mon Apr 23 09:41:07 CEST 2012
x86_64 Intel(R) Core(TM) i5 CPU M 520 @ 2.40GHz GenuineIntel GNU/Linux

Gnu C                  4.7.0
Gnu make               3.82
binutils               2.22.0.20120323
util-linux             2.21.1
mount                  support
module-init-tools      8
e2fsprogs              1.42.2
jfsutils               1.1.15
reiserfsprogs          3.6.21
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      so.6.0
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.16
wireless-tools         29
Modules Loaded         usbhid hid tun snd_usb_audio snd_usbmidi_lib
snd_rawmidi snd_seq_device nfnetlink_log nfnetlink fuse qcserial
usb_wwan usbserial uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_core videodev v4l2_compat_ioctl32 media btusb bluetooth
snd_hda_codec_hdmi vboxdrv nvidia snd_hda_codec_conexant tp_smapi arc4
thinkpad_ec acpi_cpufreq mperf fan iwlwifi mxm_wmi mac80211 serio_raw
psmouse pcspkr evdev i2c_i801 cfg80211 battery sdhci_pci thermal
thinkpad_acpi sdhci nvram ac mmc_core rfkill snd_hda_intel snd_hda_codec
i2c_core snd_hwdep snd_pcm intel_agp snd_page_alloc intel_gtt snd_timer
e1000e mei snd iTCO_wdt iTCO_vendor_support soundcore video wmi button
processor microcode aesni_intel aes_x86_64 cryptd aes_generic intel_ips
ext4 crc16 jbd2 mbcache sd_mod ahci libahci libata scsi_mod ehci_hcd
usbcore usb_common uvesafb

[7.2.] Processor information (from /proc/cpuinfo):

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
stepping	: 2
microcode	: 0xd
cpu MHz		: 2400.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4789.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
stepping	: 2
microcode	: 0xd
cpu MHz		: 2400.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4789.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
stepping	: 2
microcode	: 0xd
cpu MHz		: 2400.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 2
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4789.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz
stepping	: 2
microcode	: 0xd
cpu MHz		: 2400.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 2
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est
tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts
tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4789.11
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


[7.3.] Module information (from /proc/modules):

usbhid 36142 0 - Live 0xffffffffa0352000
hid 84549 1 usbhid, Live 0xffffffffa0f7c000
tun 15241 2 - Live 0xffffffffa0255000
snd_usb_audio 93519 2 - Live 0xffffffffa0f64000
snd_usbmidi_lib 18744 1 snd_usb_audio, Live 0xffffffffa0292000
snd_rawmidi 18991 1 snd_usbmidi_lib, Live 0xffffffffa0272000
snd_seq_device 5300 1 snd_rawmidi, Live 0xffffffffa0252000
nfnetlink_log 8037 0 - Live 0xffffffffa01f5000
nfnetlink 3210 1 nfnetlink_log, Live 0xffffffffa016b000
fuse 68162 2 - Live 0xffffffffa0f52000
qcserial 4898 0 - Live 0xffffffffa029b000
usb_wwan 9366 1 qcserial, Live 0xffffffffa10f8000
usbserial 32395 2 qcserial,usb_wwan, Live 0xffffffffa10e9000
uvcvideo 67853 0 - Live 0xffffffffa10d2000
videobuf2_vmalloc 2276 1 uvcvideo, Live 0xffffffffa0249000
videobuf2_memops 2182 1 videobuf2_vmalloc, Live 0xffffffffa01c0000
videobuf2_core 20415 1 uvcvideo, Live 0xffffffffa10c9000
videodev 83373 1 uvcvideo, Live 0xffffffffa10ab000
v4l2_compat_ioctl32 8348 1 videodev, Live 0xffffffffa035c000
media 10469 2 uvcvideo,videodev, Live 0xffffffffa0261000
btusb 11643 0 - Live 0xffffffffa00df000
bluetooth 171342 1 btusb, Live 0xffffffffa0fff000
snd_hda_codec_hdmi 24120 4 - Live 0xffffffffa01b9000
vboxdrv 1792230 0 - Live 0xffffffffa1c5e000 (O)
nvidia 12257807 33 - Live 0xffffffffa03a0000 (PO)
snd_hda_codec_conexant 46856 1 - Live 0xffffffffa0345000
tp_smapi 20660 0 - Live 0xffffffffa026b000 (O)
arc4 1410 2 - Live 0xffffffffa0202000
thinkpad_ec 4285 1 tp_smapi, Live 0xffffffffa024c000 (O)
acpi_cpufreq 5941 1 - Live 0xffffffffa01ff000
mperf 1275 1 acpi_cpufreq, Live 0xffffffffa01f3000
fan 2426 0 - Live 0xffffffffa0081000
iwlwifi 252526 0 - Live 0xffffffffa0361000
mxm_wmi 1425 0 - Live 0xffffffffa0189000
mac80211 391455 1 iwlwifi, Live 0xffffffffa02e4000
serio_raw 4653 0 - Live 0xffffffffa01e7000
psmouse 69539 0 - Live 0xffffffffa02d2000
pcspkr 1835 0 - Live 0xffffffffa00c5000
evdev 9402 22 - Live 0xffffffffa01ef000
i2c_i801 8116 0 - Live 0xffffffffa00cd000
cfg80211 176857 2 iwlwifi,mac80211, Live 0xffffffffa021c000
battery 6485 0 - Live 0xffffffffa0050000
sdhci_pci 10535 0 - Live 0xffffffffa02cb000
thermal 7959 0 - Live 0xffffffffa02c5000
thinkpad_acpi 62497 0 - Live 0xffffffffa029e000
sdhci 23662 1 sdhci_pci, Live 0xffffffffa02bb000
nvram 5906 1 thinkpad_acpi, Live 0xffffffffa0298000
ac 2376 0 - Live 0xffffffffa003c000
mmc_core 82671 2 sdhci_pci,sdhci, Live 0xffffffffa0278000
rfkill 15604 3 bluetooth,cfg80211,thinkpad_acpi, Live 0xffffffffa0266000
snd_hda_intel 23989 0 - Live 0xffffffffa025a000
snd_hda_codec 92713 3
snd_hda_codec_hdmi,snd_hda_codec_conexant,snd_hda_intel, Live
0xffffffffa0204000
i2c_core 20593 3 videodev,nvidia,i2c_i801, Live 0xffffffffa01f8000
snd_hwdep 6556 2 snd_usb_audio,snd_hda_codec, Live 0xffffffffa01e0000
snd_pcm 74812 4
snd_usb_audio,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec, Live
0xffffffffa01c8000
intel_agp 10872 0 - Live 0xffffffffa0182000
snd_page_alloc 7217 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00d7000
intel_gtt 14007 1 intel_agp, Live 0xffffffffa0163000
snd_timer 19222 1 snd_pcm, Live 0xffffffffa01c2000
e1000e 144866 0 - Live 0xffffffffa0194000
mei 32216 0 - Live 0xffffffffa018b000 (C)
snd 59656 16
snd_usb_audio,snd_usbmidi_lib,snd_rawmidi,snd_seq_device,snd_hda_codec_hd=
mi,snd_hda_codec_conexant,thinkpad_acpi,snd_hda_intel,snd_hda_codec,snd_h=
wdep,snd_pcm,snd_timer,
Live 0xffffffffa0172000
iTCO_wdt 12877 0 - Live 0xffffffffa01ea000
iTCO_vendor_support 1929 1 iTCO_wdt, Live 0xffffffffa0042000
soundcore 6082 1 snd, Live 0xffffffffa01e4000
video 11243 0 - Live 0xffffffffa01dc000
wmi 8475 1 mxm_wmi, Live 0xffffffffa016e000
button 4502 0 - Live 0xffffffffa0168000
processor 26144 1 acpi_cpufreq, Live 0xffffffffa015b000
microcode 12217 0 - Live 0xffffffffa00db000
aesni_intel 49946 0 - Live 0xffffffffa014d000
aes_x86_64 7508 1 aesni_intel, Live 0xffffffffa007e000
cryptd 8383 1 aesni_intel, Live 0xffffffffa003e000
aes_generic 26138 2 aesni_intel,aes_x86_64, Live 0xffffffffa0034000
intel_ips 11347 0 - Live 0xffffffffa0084000
ext4 424467 5 - Live 0xffffffffa00e4000
crc16 1359 2 bluetooth,ext4, Live 0xffffffffa000d000
jbd2 71704 1 ext4, Live 0xffffffffa00b2000
mbcache 5977 1 ext4, Live 0xffffffffa0007000
sd_mod 28059 7 - Live 0xffffffffa0076000
ahci 20261 5 - Live 0xffffffffa00d1000
libahci 19999 1 ahci, Live 0xffffffffa00c7000
libata 167019 2 ahci,libahci, Live 0xffffffffa0088000
scsi_mod 133422 2 sd_mod,libata, Live 0xffffffffa0054000
ehci_hcd 43944 0 - Live 0xffffffffa0044000
usbcore 146847 10
usbhid,snd_usb_audio,snd_usbmidi_lib,qcserial,usb_wwan,usbserial,uvcvideo=
,btusb,ehci_hcd,
Live 0xffffffffa000f000
usb_common 954 1 usbcore, Live 0xffffffffa000b000
uvesafb 21439 1 - Live 0xffffffffa0000000

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:


Thank you

--------------080000060305020408070605
Content-Type: application/pgp-keys;
 name="0xB88BC872.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0xB88BC872.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.19 (GNU/Linux)

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3D=3D
=3D3zZ+
-----END PGP PUBLIC KEY BLOCK-----

--------------080000060305020408070605--

--------------enig695C1BAC3292E006D28FA2DA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPmXNLAAoJEGajRCW4i8hy45wQAJTUjIxMZLz+YYW2UlhbY1z+
ie9d8xq1gtxCVubeAfyWk5OePLMrYGv6DmnA/yUT6SME9RQkYneRulEj2M+NS8Iz
tKpUF6NzahR/q8cuPNuZAvu3GYA2BYshPGYXt6wPgD4OcdI11QoGs2mgX1l/gtx0
jN2DyRxpq5A86MmmBX++Neal9MPg3ATdZCpJK8C7g16XQSg9jZB2IAyvwFnCafCm
TDBOFBody7naAp7VXfCd8p39KL3mB0jMPjpSg85bUVMHzw4t0Xgn7kqok1tIoIFb
bH5fte0HEkOgmCWfvmqzNf6+SytokbJG7EMOqRZ0vP25pN5qJR8vFrW91mIKfrXl
leNT/ymNvrV6ufNr/vbjVXzCKQHNOc65eEAyBmWHDmOIHLWtc4/wZVeHLtItTwdG
okpkt5cYOnrxCWOgqG+vC8V3dXC0+yt3ooZt1rBfzZ6kWKbYB4oCk8WfrSzLwiJN
b2Mi51V8lRxHyd64nle/OicJWGczZLvEBb4dFjFlhcBfHY3XGCAN1F/0UDET/mHW
PMzDOOFv+b2IF5GBOX9h0LAH1nghs/Lr024JF+sfeJX7wHOYzDC3KfgdVdIfh94c
nwoMbCtMwrVF6A6QMXP419vqfHcOpeFUxKDJwVhiidY30d6U9dPFRQD1awcKAKBH
5+yr5UGVh/CAq9TAFX3X
=PR3y
-----END PGP SIGNATURE-----

--------------enig695C1BAC3292E006D28FA2DA--
