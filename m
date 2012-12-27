Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2L0Mgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:36:49 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35472 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2L0Mgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:36:46 -0500
Message-ID: <50DC4ED6.1090007@gmail.com>
Date: Thu, 27 Dec 2012 13:36:22 +0000
From: Philip Miller <sighoya@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM:
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. no sound, cause of cx88_alsa crash
2. Round on every fifthly boot it appears a message like this: BUG: 
unable to handle kernel NULL pointer dereference at 00000000000000b8
After that I have no sound and the system cannot reboot or power down
3. Error in kernel modules
4. Linux version 3.6.10-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 
(GCC) ) #1 SMP PREEMPT Tue Dec 11 09:40:17 CET 2012
5.[    3.711830] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    3.712375] cx88[0]/2: cx2388x 8802 Driver Manager
[    3.712399] cx88[0]/2: found at 0000:05:07.2, rev: 5, irq: 21, 
latency: 32, mmio: 0xfb000000
[    3.713291] cx88[0]/0: found at 0000:05:07.0, rev: 5, irq: 21, 
latency: 32, mmio: 0xf9000000
[    3.715206] IR NEC protocol handler initialized
[    3.716062] input: Microsoft Basic Optical Mouse as 
/devices/pci0000:00/0000:00:12.0/usb6/6-1/6-1:1.0/input/input13
[    3.716368] hid-generic 0003:045E:0084.0001: input,hidraw0: USB HID 
v1.10 Mouse [Microsoft Basic Optical Mouse] on usb-0000:00:12.0-1/input0
[    3.718330] wm8775 8-001b: chip found @ 0x36 (cx88[0])
[    3.723684] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    3.723691] cx88/2: registering cx8802 driver, type: dvb access: shared
[    3.723698] cx88[0]/2: subsystem: 0070:9202, board: Hauppauge 
Nova-S-Plus DVB-S [card=37]
[    3.723703] cx88[0]/2: cx2388x based DVB/ATSC card
[    3.723707] cx8802_alloc_frontends() allocating 1 frontend(s)
[    3.724144] IR RC5(x) protocol handler initialized
[    3.726017] BUG: unable to handle kernel NULL pointer dereference at 
00000000000000b8
[    3.727663] IR RC6 protocol handler initialized
[    3.729334] CX24123: detected CX24123
[    3.731694] IR JVC protocol handler initialized
[    3.732484] DVB: registering new adapter (cx88[0])
[    3.732486] DVB: registering adapter 0 frontend 0 (Conexant 
CX24123/CX24109)...
[    3.733240] IR Sony protocol handler initialized
[    3.739760] cx88[0]/0: registered device video0 [v4l2]
[    3.739794] cx88[0]/0: registered device vbi0
[    3.741550] IR SANYO protocol handler initialized
[    3.745456] input: MCE IR Keyboard/Mouse (cx88xx) as 
/devices/virtual/input/input14
[    3.745756] IR MCE Keyboard/mouse protocol handler initialized
[    3.750744] lirc_dev: IR Remote Control driver registered, major 248
[    3.754637] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) 
registered at minor = 0
[    3.754640] IR LIRC bridge handler initialized
[    3.773818] IP: [<ffffffffa0055909>] snd_cx88_volume_put+0x139/0x260 
[cx88_alsa]
[    3.777333] PGD 19e9e4067 PUD 19e9e5067 PMD 0
[    3.780870] Oops: 0000 [#1] PREEMPT SMP
[    3.784422] Modules linked in: ir_lirc_codec lirc_dev 
ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder 
isl6421 cx24123 ir_rc6_decoder ir_rc5_decoder cx88_dvb cx88_vp3054_i2c 
videobuf_dvb wm8775 dvb_core hid_generic ir_nec_decoder usbhid hid 
rc_hauppauge raid1 kvm_amd kvm md_mod usb_storage uas evdev cx8800 
cx8802 cx88_alsa cx88xx firewire_ohci edac_core btcx_risc firewire_core 
tveeprom videobuf_dma_sg serio_raw pcspkr crc_itu_t microcode 
videobuf_core k10temp snd_hda_codec_hdmi sp5100_tco edac_mce_amd 
v4l2_common rc_core videodev media 8139too snd_hda_codec_realtek 
i2c_piix4 snd_hda_intel snd_hda_codec snd_hwdep r8169 snd_pcm mii 
snd_page_alloc snd_timer snd soundcore wmi button vboxnetadp(O) 
vboxnetflt(O) vboxdrv(O) powernow_k8 mperf processor ext4 crc16 jbd2 
mbcache sr_mod sd_mod
[    3.809870]  cdrom ata_generic ohci_hcd xhci_hcd ahci pata_atiixp 
libahci pata_acpi ehci_hcd pata_jmicron libata usbcore scsi_mod 
usb_common floppy radeon i2c_algo_bit drm_kms_helper ttm drm i2c_core
[    3.819300] CPU 2
[    3.819347] Pid: 417, comm: alsactl Tainted: G           O 
3.6.9-1-ARCH #1 Gigabyte Technology Co., Ltd. GA-890XA-UD3/GA-890XA-UD3
[    3.833890] RIP: 0010:[<ffffffffa0055909>] [<ffffffffa0055909>] 
snd_cx88_volume_put+0x139/0x260 [cx88_alsa]
[    3.839065] RSP: 0018:ffff88019eacbd88  EFLAGS: 00010212
[    3.844244] RAX: 0000000000000000 RBX: ffff8801a5bfc000 RCX: 
000000000000003f
[    3.849498] RDX: 0000000000000000 RSI: 0000000000980905 RDI: 
ffff8801a588f600
[    3.854727] RBP: ffff88019eacbdc8 R08: 2222222222222222 R09: 
2222222222222222
[    3.859954] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff8801a3f07800
[    3.865235] R13: ffff88019f3cd2b8 R14: 0000000000008000 R15: 
000000000000fc00
[    3.870540] FS:  00007f51bb2c5700(0000) GS:ffff8801afc80000(0000) 
knlGS:0000000000000000
[    3.875902] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.881249] CR2: 00000000000000b8 CR3: 000000019e9e6000 CR4: 
00000000000007e0
[    3.886625] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    3.891953] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[    3.897260] Process alsactl (pid: 417, threadinfo ffff88019eaca000, 
task ffff8801a39df0e0)
[    3.902666] Stack:
[    3.908027]  ffff88019eacbdd8 ffffffff8116cdd2 2222222222222222 
ffff8801a3f07800
[    3.913542]  ffff88019f3cd000 ffff8801a4066200 ffff88019f3cd198 
ffff88019f3cd000
[    3.919050]  ffff88019eacbe08 ffffffffa022d8dd ffff88019f3cd260 
ffff8801a3f07800
[    3.924494] Call Trace:
[    3.929828]  [<ffffffff8116cdd2>] ? __kmalloc_track_caller+0x32/0x180
[    3.935211]  [<ffffffffa022d8dd>] snd_ctl_elem_write+0x10d/0x150 [snd]
[    3.940556]  [<ffffffffa022e7fe>] snd_ctl_ioctl+0x23e/0x7f0 [snd]
[    3.945881]  [<ffffffff8118fe01>] ? do_filp_open+0x41/0xa0
[    3.951194]  [<ffffffff81191ec7>] do_vfs_ioctl+0x97/0x530
[    3.956495]  [<ffffffff8116ace0>] ? kmem_cache_free+0x20/0x120
[    3.961782]  [<ffffffff81190add>] ? set_close_on_exec+0x5d/0x80
[    3.967024]  [<ffffffff811923f9>] sys_ioctl+0x99/0xa0
[    3.972241]  [<ffffffff8149a1ad>] system_call_fastpath+0x1a/0x1f
[    3.977511] Code: 24 50 39 ce 0f 8c f0 00 00 00 41 89 f7 41 be 00 80 
00 00 41 c1 e7 0a 85 f6 0f 85 13 01 00 00 48 8b 83 88 08 00 00 be 05 09 
98 00 <48> 8b b8 b8 00 00 00 e8 1b af 2d 00 48 85 c0 74 48 44 8b 9b f4
[    3.988821] RIP  [<ffffffffa0055909>] snd_cx88_volume_put+0x139/0x260 
[cx88_alsa]
[    3.994289]  RSP <ffff88019eacbd88>
[    3.999688] CR2: 00000000000000b8
[    4.005135] ---[ end trace a4a2fc06b599c655 ]---
7.1
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux phantom 3.6.10-1-ARCH #1 SMP PREEMPT Tue Dec 11 09:40:17 CET 2012 
x86_64 GNU/Linux

Gnu C                  4.7.2
Gnu make               3.82
binutils               2.23.1
util-linux             2.22.2
mount                  debug
module-init-tools      12
e2fsprogs              1.42.6
jfsutils               1.1.15
reiserfsprogs          3.6.21
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.16
Dynamic linker (ldd)   2.16
Linux C++ Library      so.6.0
Procps                 3.3.5
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.20
Modules Loaded         ufs nls_utf8 isofs fuse joydev hid_cherry 
snd_hda_codec_hdmi ir_lirc_codec lirc_dev ir_mce_kbd_decoder isl6421 
ir_sanyo_decoder ir_sony_decoder cx24123 ir_jvc_decoder cx88_dvb 
cx88_vp3054_i2c ir_rc6_decoder videobuf_dvb dvb_core wm8775 
ir_rc5_decoder ir_nec_decoder rc_hauppauge hid_generic usbhid hid 
kvm_amd kvm raid1 evdev md_mod cx8800 cx88_alsa cx8802 cx88xx sp5100_tco 
btcx_risc tveeprom videobuf_dma_sg nvidia microcode serio_raw pcspkr 
videobuf_core edac_core snd_hda_codec_realtek v4l2_common rc_core 
k10temp edac_mce_amd videodev media i2c_algo_bit i2c_piix4 snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_timer r8169 mii snd 
wmi soundcore i2c_core button vboxnetadp vboxnetflt vboxdrv powernow_k8 
mperf processor ext4 crc16 jbd2 mbcache usb_storage sr_mod cdrom sd_mod 
ohci_hcd firewire_ohci ata_generic pata_acpi pata_atiixp ahci xhci_hcd 
libahci firewire_core pata_jmicron ehci_hcd crc_itu_t libata usbcore 
scsi_mod usb_common floppy
7.2
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1090T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 0
cpu cores    : 6
apicid        : 0
initial apicid    : 0
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6431.80
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor    : 1
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1090T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 1
cpu cores    : 6
apicid        : 1
initial apicid    : 1
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6431.80
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor    : 2
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1090T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 3
cpu cores    : 6
apicid        : 2
initial apicid    : 3
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6431.80
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor    : 3
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1090T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 5
cpu cores    : 6
apicid        : 3
initial apicid    : 5
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6431.80
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor    : 4
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1090T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 2
cpu cores    : 6
apicid        : 4
initial apicid    : 2
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6431.80
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb

processor    : 5
vendor_id    : AuthenticAMD
cpu family    : 16
model        : 10
model name    : AMD Phenom(tm) II X6 1090T Processor
stepping    : 0
microcode    : 0x10000dc
cpu MHz        : 800.000
cache size    : 512 KB
physical id    : 0
siblings    : 6
core id        : 4
cpu cores    : 6
apicid        : 5
initial apicid    : 4
fpu        : yes
fpu_exception    : yes
cpuid level    : 6
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt 
pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc 
extd_apicid aperfmperf pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt cpb hw_pstate npt lbrv svm_lock nrip_save pausefilter
bogomips    : 6431.80
TLB size    : 1024 4K pages
clflush size    : 64
cache_alignment    : 64
address sizes    : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate cpb
7.3
cat /proc/modules
ufs 69293 0 - Live 0xffffffffa0319000
nls_utf8 1353 1 - Live 0xffffffffa007e000
isofs 32411 1 - Live 0xffffffffa0259000
fuse 69213 2 - Live 0xffffffffa02ae000
joydev 9992 0 - Live 0xffffffffa1072000
hid_cherry 1578 0 - Live 0xffffffffa106a000
snd_hda_codec_hdmi 24529 4 - Live 0xffffffffa105f000
ir_lirc_codec 4028 0 - Live 0xffffffffa105b000
lirc_dev 9040 1 ir_lirc_codec, Live 0xffffffffa1054000
ir_mce_kbd_decoder 3255 0 - Live 0xffffffffa1050000
isl6421 1509 1 - Live 0xffffffffa104c000
ir_sanyo_decoder 1614 0 - Live 0xffffffffa1048000
ir_sony_decoder 1580 0 - Live 0xffffffffa1044000
cx24123 12929 1 - Live 0xffffffffa103c000
ir_jvc_decoder 1674 0 - Live 0xffffffffa1038000
cx88_dvb 23416 0 - Live 0xffffffffa102d000
cx88_vp3054_i2c 1933 1 cx88_dvb, Live 0xffffffffa0347000
ir_rc6_decoder 2154 0 - Live 0xffffffffa0315000
videobuf_dvb 4891 1 cx88_dvb, Live 0xffffffffa032d000
dvb_core 96169 2 cx88_dvb,videobuf_dvb, Live 0xffffffffa1006000
wm8775 3981 1 - Live 0xffffffffa028a000
ir_rc5_decoder 1610 0 - Live 0xffffffffa024b000
ir_nec_decoder 1706 0 - Live 0xffffffffa0126000
rc_hauppauge 2255 0 - Live 0xffffffffa00ae000
hid_generic 1114 0 - Live 0xffffffffa0076000
usbhid 37036 0 - Live 0xffffffffa0ffb000
hid 85974 3 hid_cherry,hid_generic,usbhid, Live 0xffffffffa0fdf000
kvm_amd 52188 0 - Live 0xffffffffa02db000
kvm 374014 1 kvm_amd, Live 0xffffffffa0e38000
raid1 28629 1 - Live 0xffffffffa02a6000
evdev 10267 9 - Live 0xffffffffa0247000
md_mod 104017 2 raid1, Live 0xffffffffa0e1d000
cx8800 30791 0 - Live 0xffffffffa022e000
cx88_alsa 9614 0 - Live 0xffffffffa0132000
cx8802 13026 1 cx88_dvb, Live 0xffffffffa0219000
cx88xx 73878 4 cx88_dvb,cx8800,cx88_alsa,cx8802, Live 0xffffffffa02c7000
sp5100_tco 4505 0 - Live 0xffffffffa0123000
btcx_risc 3372 4 cx8800,cx88_alsa,cx8802,cx88xx, Live 0xffffffffa00e1000
tveeprom 13778 1 cx88xx, Live 0xffffffffa02a1000
videobuf_dma_sg 7873 5 cx88_dvb,cx8800,cx88_alsa,cx8802,cx88xx, Live 
0xffffffffa028d000
nvidia 9340873 28 - Live 0xffffffffa051f000 (PO)
microcode 12346 0 - Live 0xffffffffa0274000
serio_raw 4690 0 - Live 0xffffffffa026f000
pcspkr 1900 0 - Live 0xffffffffa0012000
videobuf_core 16008 5 videobuf_dvb,cx8800,cx8802,cx88xx,videobuf_dma_sg, 
Live 0xffffffffa0266000
edac_core 42567 0 - Live 0xffffffffa024d000
snd_hda_codec_realtek 61420 1 - Live 0xffffffffa0237000
v4l2_common 5371 3 wm8775,cx8800,cx88xx, Live 0xffffffffa022b000
rc_core 13089 11 
ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,rc_hauppauge,cx88xx, 
Live 0xffffffffa021e000
k10temp 2955 0 - Live 0xffffffffa0215000
edac_mce_amd 12278 0 - Live 0xffffffffa01d1000
videodev 100860 5 wm8775,cx8800,cx88_alsa,cx88xx,v4l2_common, Live 
0xffffffffa01ee000
media 10406 1 videodev, Live 0xffffffffa00d3000
i2c_algo_bit 5392 2 cx88_vp3054_i2c,cx88xx, Live 0xffffffffa0088000
i2c_piix4 8072 0 - Live 0xffffffffa006d000
snd_hda_intel 26181 0 - Live 0xffffffffa011b000
snd_hda_codec 98034 3 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel, Live 
0xffffffffa01d5000
snd_hwdep 6429 1 snd_hda_codec, Live 0xffffffffa007b000
snd_pcm 75735 4 
snd_hda_codec_hdmi,cx88_alsa,snd_hda_intel,snd_hda_codec, Live 
0xffffffffa00bf000
snd_page_alloc 7218 2 snd_hda_intel,snd_pcm, Live 0xffffffffa005e000
snd_timer 18935 1 snd_pcm, Live 0xffffffffa01cb000
r8169 56872 0 - Live 0xffffffffa01bc000
mii 4092 1 r8169, Live 0xffffffffa0014000
snd 60189 8 
snd_hda_codec_hdmi,cx88_alsa,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer, 
Live 0xffffffffa01ac000
wmi 8380 0 - Live 0xffffffffa0117000
soundcore 5443 1 snd, Live 0xffffffffa00b8000
i2c_core 20708 13 
isl6421,cx24123,cx88_dvb,cx88_vp3054_i2c,wm8775,cx8800,cx88xx,tveeprom,nvidia,v4l2_common,videodev,i2c_algo_bit,i2c_piix4, 
Live 0xffffffffa00a7000
button 4663 0 - Live 0xffffffffa0078000
vboxnetadp 18420 0 - Live 0xffffffffa0070000 (O)
vboxnetflt 16845 0 - Live 0xffffffffa0064000 (O)
vboxdrv 1823470 2 vboxnetadp,vboxnetflt, Live 0xffffffffa0360000 (O)
powernow_k8 13310 0 - Live 0xffffffffa0059000
mperf 1300 1 powernow_k8, Live 0xffffffffa0010000
processor 26856 1 powernow_k8, Live 0xffffffffa00b0000
ext4 440435 3 - Live 0xffffffffa013f000
crc16 1360 1 ext4, Live 0xffffffffa0038000
jbd2 78802 1 ext4, Live 0xffffffffa008b000
mbcache 6027 1 ext4, Live 0xffffffffa0061000
usb_storage 47385 0 - Live 0xffffffffa0045000
sr_mod 14824 1 - Live 0xffffffffa013a000
cdrom 35521 1 sr_mod, Live 0xffffffffa0128000
sd_mod 29560 9 - Live 0xffffffffa0109000
ohci_hcd 21785 0 - Live 0xffffffffa0052000
firewire_ohci 31942 0 - Live 0xffffffffa003a000
ata_generic 3339 0 - Live 0xffffffffa0043000
pata_acpi 3452 0 - Live 0xffffffffa006b000
pata_atiixp 4876 0 - Live 0xffffffffa00bc000
ahci 21361 5 - Live 0xffffffffa00a0000
xhci_hcd 87083 0 - Live 0xffffffffa0349000
libahci 20024 1 ahci, Live 0xffffffffa0082000
firewire_core 53174 1 firewire_ohci, Live 0xffffffffa0330000
pata_jmicron 2492 1 - Live 0xffffffffa0345000
ehci_hcd 41817 0 - Live 0xffffffffa0295000
crc_itu_t 1364 1 firewire_core, Live 0xffffffffa0317000
libata 167757 6 
ata_generic,pata_acpi,pata_atiixp,ahci,libahci,pata_jmicron, Live 
0xffffffffa02e9000
usbcore 150472 5 usbhid,usb_storage,ohci_hcd,xhci_hcd,ehci_hcd, Live 
0xffffffffa00e3000
scsi_mod 133434 4 usb_storage,sr_mod,sd_mod,libata, Live 0xffffffffa0016000
usb_common 955 1 usbcore, Live 0xffffffffa0080000
floppy 58259 0 - Live 0xffffffffa0000000
7.4 cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0064-0064 : keyboard
   0070-0073 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0170-0177 : 0000:00:14.1
     0170-0177 : pata_atiixp
   01f0-01f7 : 0000:00:14.1
     01f0-01f7 : pata_atiixp
   0220-0225 : pnp 00:01
   0228-022f : pnp 00:02
   0290-0294 : pnp 00:01
   0376-0376 : 0000:00:14.1
     0376-0376 : pata_atiixp
   03c0-03df : vesafb
   03f2-03f2 : floppy
   03f4-03f5 : floppy
   03f6-03f6 : 0000:00:14.1
     03f6-03f6 : pata_atiixp
   03f7-03f7 : floppy
   03f8-03ff : serial
   040b-040b : pnp 00:02
   04d0-04d1 : pnp 00:01
   04d6-04d6 : pnp 00:02
   0b00-0b0f : pnp 00:02
   0b10-0b1f : pnp 00:02
   0b20-0b3f : pnp 00:02
   0c00-0c01 : pnp 00:02
   0c14-0c14 : pnp 00:02
   0c50-0c52 : pnp 00:02
   0c6c-0c6d : pnp 00:02
   0c6f-0c6f : pnp 00:02
   0cd0-0cd1 : pnp 00:02
   0cd2-0cd3 : pnp 00:02
   0cd4-0cdf : pnp 00:02
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   4000-40fe : pnp 00:02
     4000-4003 : ACPI PM1a_EVT_BLK
     4004-4005 : ACPI PM1a_CNT_BLK
     4008-400b : ACPI PM_TMR
     4010-4015 : ACPI CPU throttle
     4020-4027 : ACPI GPE0_BLK
     4050-4050 : ACPI PM2_CNT_BLK
   4100-411f : pnp 00:02
   4210-4217 : pnp 00:02
   9000-9fff : PCI Bus 0000:06
     9b00-9b0f : 0000:06:00.1
       9b00-9b0f : pata_jmicron
     9c00-9c03 : 0000:06:00.1
       9c00-9c03 : pata_jmicron
     9d00-9d07 : 0000:06:00.1
       9d00-9d07 : pata_jmicron
     9e00-9e03 : 0000:06:00.1
       9e00-9e03 : pata_jmicron
     9f00-9f07 : 0000:06:00.1
       9f00-9f07 : pata_jmicron
   a000-afff : PCI Bus 0000:05
   b000-bfff : PCI Bus 0000:02
     bb00-bb0f : 0000:02:00.1
       bb00-bb0f : pata_jmicron
     bc00-bc03 : 0000:02:00.1
       bc00-bc03 : pata_jmicron
     bd00-bd07 : 0000:02:00.1
       bd00-bd07 : pata_jmicron
     be00-be03 : 0000:02:00.1
       be00-be03 : pata_jmicron
     bf00-bf07 : 0000:02:00.1
       bf00-bf07 : pata_jmicron
   c000-cfff : PCI Bus 0000:01
     cf00-cf7f : 0000:01:00.0
   d000-dfff : PCI Bus 0000:04
     de00-deff : 0000:04:00.0
       de00-deff : r8169
   e000-efff : PCI Bus 0000:03
   fa00-fa0f : 0000:00:14.1
     fa00-fa0f : pata_atiixp
   fb00-fb0f : 0000:00:11.0
     fb00-fb0f : ahci
   fc00-fc03 : 0000:00:11.0
     fc00-fc03 : ahci
   fd00-fd07 : 0000:00:11.0
     fd00-fd07 : ahci
   fe00-fe03 : 0000:00:11.0
     fe00-fe03 : ahci
   ff00-ff07 : 0000:00:11.0
     ff00-ff07 : ahci
cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
   0000-001f : dma1
   0020-0021 : pic1
   0040-0043 : timer0
   0050-0053 : timer1
   0060-0060 : keyboard
   0064-0064 : keyboard
   0070-0073 : rtc0
   0080-008f : dma page reg
   00a0-00a1 : pic2
   00c0-00df : dma2
   00f0-00ff : fpu
   0170-0177 : 0000:00:14.1
     0170-0177 : pata_atiixp
   01f0-01f7 : 0000:00:14.1
     01f0-01f7 : pata_atiixp
   0220-0225 : pnp 00:01
   0228-022f : pnp 00:02
   0290-0294 : pnp 00:01
   0376-0376 : 0000:00:14.1
     0376-0376 : pata_atiixp
   03c0-03df : vesafb
   03f2-03f2 : floppy
   03f4-03f5 : floppy
   03f6-03f6 : 0000:00:14.1
     03f6-03f6 : pata_atiixp
   03f7-03f7 : floppy
   03f8-03ff : serial
   040b-040b : pnp 00:02
   04d0-04d1 : pnp 00:01
   04d6-04d6 : pnp 00:02
   0b00-0b0f : pnp 00:02
   0b10-0b1f : pnp 00:02
   0b20-0b3f : pnp 00:02
   0c00-0c01 : pnp 00:02
   0c14-0c14 : pnp 00:02
   0c50-0c52 : pnp 00:02
   0c6c-0c6d : pnp 00:02
   0c6f-0c6f : pnp 00:02
   0cd0-0cd1 : pnp 00:02
   0cd2-0cd3 : pnp 00:02
   0cd4-0cdf : pnp 00:02
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
   4000-40fe : pnp 00:02
     4000-4003 : ACPI PM1a_EVT_BLK
     4004-4005 : ACPI PM1a_CNT_BLK
     4008-400b : ACPI PM_TMR
     4010-4015 : ACPI CPU throttle
     4020-4027 : ACPI GPE0_BLK
     4050-4050 : ACPI PM2_CNT_BLK
   4100-411f : pnp 00:02
   4210-4217 : pnp 00:02
   9000-9fff : PCI Bus 0000:06
     9b00-9b0f : 0000:06:00.1
       9b00-9b0f : pata_jmicron
     9c00-9c03 : 0000:06:00.1
       9c00-9c03 : pata_jmicron
     9d00-9d07 : 0000:06:00.1
       9d00-9d07 : pata_jmicron
     9e00-9e03 : 0000:06:00.1
       9e00-9e03 : pata_jmicron
     9f00-9f07 : 0000:06:00.1
       9f00-9f07 : pata_jmicron
   a000-afff : PCI Bus 0000:05
   b000-bfff : PCI Bus 0000:02
     bb00-bb0f : 0000:02:00.1
       bb00-bb0f : pata_jmicron
     bc00-bc03 : 0000:02:00.1
       bc00-bc03 : pata_jmicron
     bd00-bd07 : 0000:02:00.1
       bd00-bd07 : pata_jmicron
     be00-be03 : 0000:02:00.1
       be00-be03 : pata_jmicron
     bf00-bf07 : 0000:02:00.1
       bf00-bf07 : pata_jmicron
   c000-cfff : PCI Bus 0000:01
     cf00-cf7f : 0000:01:00.0
   d000-dfff : PCI Bus 0000:04
     de00-deff : 0000:04:00.0
       de00-deff : r8169
   e000-efff : PCI Bus 0000:03
   fa00-fa0f : 0000:00:14.1
     fa00-fa0f : pata_atiixp
   fb00-fb0f : 0000:00:11.0
     fb00-fb0f : ahci
   fc00-fc03 : 0000:00:11.0
     fc00-fc03 : ahci
   fd00-fd07 : 0000:00:11.0
     fd00-fd07 : ahci
   fe00-fe03 : 0000:00:11.0
     fe00-fe03 : ahci
   ff00-ff07 : 0000:00:11.0
     ff00-ff07 : ahci
phantom210@phantom:~/linux$ /proc/iomem
bash: /proc/iomem: Keine Berechtigung
phantom210@phantom:~/linux$ cat //proc/iomem
00000000-0000ffff : reserved
00010000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000dffff : PCI Bus 0000:00
   000c0000-000c7fff : Video ROM
000f0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-bfdeffff : System RAM
   01000000-0149e061 : Kernel code
   0149e062-018a9bbf : Kernel data
   01971000-01aaffff : Kernel bss
   b4000000-b7ffffff : GART
bfdf0000-bfdf0fff : ACPI Non-volatile Storage
bfdf1000-bfdfffff : ACPI Tables
bfe00000-bfefffff : reserved
   bfe00000-bfefffff : pnp 00:0a
bff00000-bfffffff : RAM buffer
c0000000-febfffff : PCI Bus 0000:00
   c0000000-dfffffff : PCI Bus 0000:01
     c0000000-cfffffff : 0000:01:00.0
     d0000000-d007ffff : 0000:01:00.0
     de000000-dfffffff : 0000:01:00.0
       df000000-df2fffff : vesafb
   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
     e0000000-efffffff : reserved
       e0000000-efffffff : pnp 00:09
   f6000000-faffffff : PCI Bus 0000:05
     f6000000-f6ffffff : 0000:05:07.1
       f6000000-f6ffffff : cx88[0]
     f7000000-f7ffffff : 0000:05:07.0
       f7000000-f7ffffff : cx88[0]
     f8000000-f8ffffff : 0000:05:07.4
     f9000000-f9ffffff : 0000:05:07.2
       f9000000-f9ffffff : cx88[0]
     faff8000-faffbfff : 0000:05:0e.0
     fafff000-fafff7ff : 0000:05:0e.0
       fafff000-fafff7ff : firewire_ohci
   fb000000-fcffffff : PCI Bus 0000:01
     fb000000-fbffffff : 0000:01:00.0
       fb000000-fbffffff : nvidia
     fcffc000-fcffffff : 0000:01:00.1
       fcffc000-fcffffff : ICH HD audio
   fd700000-fd7fffff : PCI Bus 0000:03
     fd7fe000-fd7fffff : 0000:03:00.0
       fd7fe000-fd7fffff : xhci_hcd
   fd800000-fd8fffff : PCI Bus 0000:02
   fd900000-fd9fffff : PCI Bus 0000:06
   fda00000-fdafffff : PCI Bus 0000:06
     fdafe000-fdafffff : 0000:06:00.0
       fdafe000-fdafffff : ahci
   fdb00000-fdbfffff : PCI Bus 0000:02
     fdbfe000-fdbfffff : 0000:02:00.0
       fdbfe000-fdbfffff : ahci
   fdc00000-fdcfffff : PCI Bus 0000:05
   fdd00000-fddfffff : PCI Bus 0000:04
     fdd00000-fdd1ffff : 0000:04:00.0
     fddf8000-fddfbfff : 0000:04:00.0
       fddf8000-fddfbfff : r8169
     fddff000-fddfffff : 0000:04:00.0
       fddff000-fddfffff : r8169
   fde00000-fdefffff : PCI Bus 0000:04
   fdf00000-fdffffff : PCI Bus 0000:03
   fe024000-fe027fff : 0000:00:14.2
     fe024000-fe027fff : ICH HD audio
   fe028000-fe0280ff : 0000:00:16.2
     fe028000-fe0280ff : ehci_hcd
   fe029000-fe029fff : 0000:00:16.0
     fe029000-fe029fff : ohci_hcd
   fe02a000-fe02afff : 0000:00:14.5
     fe02a000-fe02afff : ohci_hcd
   fe02b000-fe02b0ff : 0000:00:13.2
     fe02b000-fe02b0ff : ehci_hcd
   fe02c000-fe02cfff : 0000:00:13.0
     fe02c000-fe02cfff : ohci_hcd
   fe02d000-fe02d0ff : 0000:00:12.2
     fe02d000-fe02d0ff : ehci_hcd
   fe02e000-fe02efff : 0000:00:12.0
     fe02e000-fe02efff : ohci_hcd
   fe02f000-fe02f3ff : 0000:00:11.0
     fe02f000-fe02f3ff : ahci
fec00000-ffffffff : reserved
   fec00000-fec003ff : IOAPIC 0
   fed00000-fed003ff : HPET 0
   fee00000-fee00fff : Local APIC
     fee00400-fee00fff : pnp 00:02
   fff80000-fffeffff : pnp 00:0a
   ffff0000-ffffffff : pnp 00:0a
100000000-1bfffffff : System RAM
7.5 lspci -vvv
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RD780 
Northbridge only dual slot PCI-e_GFX and HT1 K8 part
     Subsystem: Advanced Micro Devices [AMD] nee ATI RD780 Northbridge 
only dual slot PCI-e_GFX and HT1 K8 part
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 32
     Region 3: Memory at <ignored> (64-bit, non-prefetchable) [size=512M]
     Capabilities: [c4] HyperTransport: Slave or Primary Interface
         Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
         Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- 
<CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
         Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
DwFcInEn- LWO=16bit DwFcOutEn-
         Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ 
<CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
         Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit 
DwFcInEn- LWO=8bit DwFcOutEn-
         Revision ID: 3.00
         Link Frequency 0: [b]
         Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
         Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 
600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
         Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
         Link Frequency 1: 200MHz
         Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
         Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 
600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
         Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- 
SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
         Prefetchable memory behind bridge Upper: 00-00
         Bus Number: 00
     Capabilities: [40] HyperTransport: Retry Mode
     Capabilities: [54] HyperTransport: UnitID Clumping
     Capabilities: [9c] HyperTransport: #1a

00:02.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD790 PCI to 
PCI bridge (external gfx0 port A) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 0000c000-0000cfff
     Memory behind bridge: fb000000-fcffffff
     Prefetchable memory behind bridge: 00000000c0000000-00000000dfffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee3f00c  Data: 4171
     Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI 
Device 5958
     Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
     Capabilities: [110 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Kernel driver in use: pcieport

00:06.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD790 PCI to 
PCI bridge (PCI express gpp port C) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 0000b000-0000bfff
     Memory behind bridge: fdb00000-fdbfffff
     Prefetchable memory behind bridge: 00000000fd800000-00000000fd8fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee3f00c  Data: 4181
     Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI 
Device 5958
     Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
     Capabilities: [110 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Kernel driver in use: pcieport

00:07.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD790 PCI to 
PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 0000e000-0000efff
     Memory behind bridge: fd700000-fd7fffff
     Prefetchable memory behind bridge: 00000000fdf00000-00000000fdffffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee3f00c  Data: 4191
     Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI 
Device 5958
     Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
     Capabilities: [110 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Kernel driver in use: pcieport

00:0a.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD790 PCI to 
PCI bridge (PCI express gpp port F) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
     I/O behind bridge: 0000d000-0000dfff
     Memory behind bridge: fde00000-fdefffff
     Prefetchable memory behind bridge: 00000000fdd00000-00000000fddfffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, 
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee3f00c  Data: 41a1
     Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI 
Device 5958
     Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
     Capabilities: [110 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Kernel driver in use: pcieport

00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 SATA Controller [IDE mode] (rev 40) (prog-if 01 [AHCI 
1.0])
     Subsystem: Giga-byte Technology GA-MA770-DS3rev2.0 Motherboard
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 51
     Region 0: I/O ports at ff00 [size=8]
     Region 1: I/O ports at fe00 [size=4]
     Region 2: I/O ports at fd00 [size=8]
     Region 3: I/O ports at fc00 [size=4]
     Region 4: I/O ports at fb00 [size=16]
     Region 5: Memory at fe02f000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] MSI: Enable+ Count=1/4 Maskable- 64bit+
         Address: 00000000fee3f00c  Data: 4162
     Capabilities: [70] SATA HBA v1.0 InCfgSpace
     Capabilities: [a4] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ahci

00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci_hcd

00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Bridge: PM- B3+
     Capabilities: [e4] Debug port: BAR=1 offset=00e0
     Kernel driver in use: ehci_hcd

00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci_hcd

00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Bridge: PM- B3+
     Capabilities: [e4] Debug port: BAR=1 offset=00e0
     Kernel driver in use: ehci_hcd

00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus 
Controller (rev 41)
     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:14.1 IDE interface: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 IDE Controller (rev 40) (prog-if 8a [Master SecP PriP])
     Subsystem: Giga-byte Technology Device 5002
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 17
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374
     Region 4: I/O ports at fa00 [size=16]
     Kernel driver in use: pata_atiixp

00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00 Azalia 
(Intel HDA) (rev 40)
     Subsystem: Giga-byte Technology Device a102
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 16
     Region 0: Memory at fe024000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: snd_hda_intel

00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
     Subsystem: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 
LPC host controller
     Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0

00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to 
PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64
     Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
     I/O behind bridge: 0000a000-0000afff
     Memory behind bridge: f6000000-faffffff
     Prefetchable memory behind bridge: fdc00000-fdcfffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller (prog-if 10 [OHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin C routed to IRQ 18
     Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci_hcd

00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI 
SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0) (prog-if 00 [Normal 
decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
     I/O behind bridge: 00009000-00009fff
     Memory behind bridge: fda00000-fdafffff
     Prefetchable memory behind bridge: 00000000fd900000-00000000fd9fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag+ RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <64ns, L1 <1us
             ClockPM- Surprise- LLActRep+ BwNot+
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise-
             Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, 
OBFF Not Supported ARIFwd-
         DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, 
OBFF Disabled ARIFwd-
         LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] nee ATI 
Device 0000
     Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
     Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
     Kernel driver in use: pcieport

00:16.0 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fe029000 (32-bit, non-prefetchable) [size=4K]
     Kernel driver in use: ohci_hcd

00:16.2 USB controller: Advanced Micro Devices [AMD] nee ATI 
SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
     Subsystem: Giga-byte Technology Device 5004
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 64 bytes
     Interrupt: pin B routed to IRQ 17
     Region 0: Memory at fe028000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Bridge: PM- B3+
     Capabilities: [e4] Debug port: BAR=1 offset=00e0
     Kernel driver in use: ehci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
HyperTransport Configuration
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Capabilities: [80] HyperTransport: Host or Secondary Interface
         Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- 
<EOCErr- DUL-
         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- 
<CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
         Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit 
DwFcInEn- LWO=16bit DwFcOutEn-
         Revision ID: 3.00
         Link Frequency: [b]
         Link Error: <Prot- <Ovfl- <EOC- CTLTm-
         Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 
600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
         Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- 
ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Address Map
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
DRAM Controller
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Miscellaneous Control
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Capabilities: [f0] Secure device <?>
     Kernel driver in use: k10temp

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Link Control
     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

01:00.0 VGA compatible controller: NVIDIA Corporation GT216 [GeForce GT 
220] (rev a2) (prog-if 00 [VGA controller])
     Subsystem: Micro-Star International Co., Ltd. Device 8051
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
     Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
     Region 3: Memory at de000000 (64-bit, prefetchable) [size=32M]
     Region 5: I/O ports at cf00 [size=128]
     [virtual] Expansion ROM at d0000000 [disabled] [size=512K]
     Capabilities: [60] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [78] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 <64us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk+
             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, 
OBFF Not Supported
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
         LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [b4] Vendor Specific Information: Len=14 <?>
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [128 v1] Power Budgeting <?>
     Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=024 <?>
     Kernel driver in use: nvidia

01:00.1 Audio device: NVIDIA Corporation High Definition Audio 
Controller (rev a1)
     Subsystem: Micro-Star International Co., Ltd. Device 8051
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fcffc000 (32-bit, non-prefetchable) [size=16K]
     Capabilities: [60] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [78] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 <64us
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
         LnkCap:    Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, 
Latency L0 <256ns, L1 <1us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 128 bytes Disabled- 
Retrain- CommClk+
             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, 
OBFF Not Supported
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Kernel driver in use: snd_hda_intel

02:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE 
Controller (rev 03) (prog-if 01 [AHCI 1.0])
     Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 18
     Region 5: Memory at fdbfe000 (32-bit, non-prefetchable) [size=8K]
     Capabilities: [68] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr+ UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 <1us, L1 <16us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Kernel driver in use: ahci

02:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE 
Controller (rev 03) (prog-if 85 [Master SecO PriO])
     Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at bf00 [size=8]
     Region 1: I/O ports at be00 [size=4]
     Region 2: I/O ports at bd00 [size=8]
     Region 3: I/O ports at bc00 [size=4]
     Region 4: I/O ports at bb00 [size=16]
     Capabilities: [68] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pata_jmicron

03:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 03) (prog-if 30 [XHCI])
     Subsystem: Giga-byte Technology Device 5007
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 19
     Region 0: Memory at fd7fe000 (64-bit, non-prefetchable) [size=8K]
     Capabilities: [50] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
         Address: 0000000000000000  Data: 0000
     Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
         Vector table: BAR=0 offset=00001000
         PBA: BAR=0 offset=00001080
     Capabilities: [a0] Express (v2) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 unlimited
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <4us, L1 unlimited
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, 
OBFF Not Supported
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
         LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
     Capabilities: [140 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
     Capabilities: [150 v1] Latency Tolerance Reporting
         Max snoop latency: 0ns
         Max no snoop latency: 0ns
     Kernel driver in use: xhci_hcd

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
     Subsystem: Giga-byte Technology GA-EP45-DS5/GA-EG45M-DS2H Motherboard
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 52
     Region 0: I/O ports at de00 [size=256]
     Region 2: Memory at fddff000 (64-bit, prefetchable) [size=4K]
     Region 4: Memory at fddf8000 (64-bit, prefetchable) [size=16K]
     [virtual] Expansion ROM at fdd00000 [disabled] [size=128K]
     Capabilities: [40] Power Management version 3
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee3f00c  Data: 4182
     Capabilities: [70] Express (v2) Endpoint, MSI 01
         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, 
OBFF Not Supported
         DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, 
OBFF Disabled
         LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
              Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
              Compliance De-emphasis: -6dB
         LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
              EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
     Capabilities: [ac] MSI-X: Enable- Count=4 Masked-
         Vector table: BAR=4 offset=00000000
         PBA: BAR=4 offset=00000800
     Capabilities: [cc] Vital Product Data
         Unknown small resource type 00, will not decode more.
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Capabilities: [140 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
             Status:    NegoPending- InProgress-
     Capabilities: [160 v1] Device Serial Number 03-00-00-00-68-4c-e0-00
     Kernel driver in use: r8169

05:07.0 Multimedia video controller: Conexant Systems, Inc. 
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
     Subsystem: Hauppauge computer works Inc. Nova-S-Plus DVB-S
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 21
     Region 0: Memory at f7000000 (32-bit, non-prefetchable) [size=16M]
     Capabilities: [44] Vital Product Data
         Unknown large resource type 04, will not decode more.
     Capabilities: [4c] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: cx8800

05:07.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [Audio Port] (rev 05)
     Subsystem: Hauppauge computer works Inc. Device 9202
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 21
     Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
     Capabilities: [4c] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: cx88_audio

05:07.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [MPEG Port] (rev 05)
     Subsystem: Hauppauge computer works Inc. Device 9202
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 21
     Region 0: Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
     Capabilities: [4c] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: cx88-mpeg driver manager

05:07.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder [IR Port] (rev 05)
     Subsystem: Hauppauge computer works Inc. Device 9202
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 7
     Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
     Capabilities: [4c] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

05:0e.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 
IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
     Subsystem: Giga-byte Technology GA-EP45-DS5/GA-EG45M-DS2H Motherboard
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 22
     Region 0: Memory at fafff000 (32-bit, non-prefetchable) [size=2K]
     Region 1: Memory at faff8000 (32-bit, non-prefetchable) [size=16K]
     Capabilities: [44] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
     Kernel driver in use: firewire_ohci

06:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE 
Controller (rev 02) (prog-if 01 [AHCI 1.0])
     Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 64 bytes
     Interrupt: pin A routed to IRQ 17
     Region 5: Memory at fdafe000 (32-bit, non-prefetchable) [size=8K]
     Capabilities: [68] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Kernel driver in use: ahci

06:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE 
Controller (rev 02) (prog-if 85 [Master SecO PriO])
     Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 17
     Region 0: I/O ports at 9f00 [size=8]
     Region 1: I/O ports at 9e00 [size=4]
     Region 2: I/O ports at 9d00 [size=8]
     Region 3: I/O ports at 9c00 [size=4]
     Region 4: I/O ports at 9b00 [size=16]
     Capabilities: [68] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pata_jmicron
7.6
cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: TSSTcorp Model: CDDVDW SH-S222A  Rev: SB02
   Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAJS-0 Rev: 01.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 01.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000AAKS-0 Rev: 01.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: OCZ-AGILITY3     Rev: 2.25
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi14 Channel: 00 Id: 00 Lun: 00
   Vendor: Disk     Model: Name             Rev: 01.0
   Type:   Direct-Access                    ANSI  SCSI revision: 02


