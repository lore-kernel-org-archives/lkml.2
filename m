Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2BMUhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:37:23 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48156 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2BMUhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:37:19 -0500
MIME-Version: 1.0
From: Brian Minton <brian@minton.name>
Date: Mon, 13 Feb 2012 15:36:58 -0500
X-Google-Sender-Auth: 00rhC_IPkT-mkkKkCKrdD3QVEzg
Message-ID: <CANyOob3ttWBhVeC0YcNK3y4h9Zz1eWrCFpBKU6ytFBBpX+NvtA@mail.gmail.com>
Subject: kernel oops (BUG: unable to handle kernel paging request at ffff88ff70aec270)
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bminton:/usr/local/src/linux-3.1.6# sh scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux bminton.is-a-geek.net 3.1.6 #1 SMP Sat Jan 7 12:05:54 EST 2012
x86_64 GNU/Linux

Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
jfsutils               1.1.15
reiserfsprogs          3.6.19
reiser4progs           1.0.2
xfsprogs               3.1.7
pcmciautils            018
quota-tools            4.00.
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.3.2
Net-tools              1.60
Console-tools          0.2.3
oprofile               0.9.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         xt_multiport binfmt_misc nfnetlink_log
nfnetlink bluetooth rfkill uinput xt_limit nf_conntrack_ipv4
nf_defrag_ipv4 xt_recent xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables ppdev lp battery powernow_k8 mperf
cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats
nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc dummy bridge stp
decnet xfs exportfs fuse dm_crypt snd_ali5451 nvram ch st osst loop
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
snd_mpu401 snd_mpu401_uart snd_seq_midi snd_rawmidi irtty_sir sir_dev
i2c_ali15x3 irda snd_seq_midi_event snd_seq tpm_tis tpm snd_timer
i2c_ali1535 evdev shpchp pci_hotplug k8temp psmouse snd_seq_device
ns558 gameport i2c_ali1563 i2c_core tpm_bios crc_ccitt snd pcspkr
serio_raw edac_core parport_pc button soundcore parport processor
thermal_sys snd_page_alloc ext3 jbd mbcache btrfs zlib_deflate crc32c
libcrc32c raid1 md_mod nbd dm_mirror dm_region_hash dm_log dm_mod sg
sr_mod cdrom ata_generic ide_gd_mod sd_mod crc_t10dif usb_storage
ohci_hcd sata_uli sata_sil floppy ahci libahci r8169 mii siimage
libata scsi_mod alim15x3 uli526x ide_pci_generic ide_core ehci_hcd
bminton:/usr/local/src/linux-3.1.6# cat /proc/version
Linux version 3.1.6 (root@bminton.is-a-geek.net) (gcc version 4.6.2
(Debian 4.6.2-7) ) #1 SMP Sat Jan 7 12:05:54 EST 2012
bminton:/usr/local/src/linux-3.1.6# cat /root/oops
Feb 13 14:10:37 bminton kernel: [87956.259635] BUG: unable to handle
kernel paging request at ffff88ff70aec270
Feb 13 14:10:37 bminton kernel: [87956.259643] IP:
[<ffffffffa01f6076>] bit_spin_lock+0xd/0x18 [jbd]
Feb 13 14:10:37 bminton kernel: [87956.259659] PGD 0
Feb 13 14:10:37 bminton kernel: [87956.259663] Oops: 0002 [#1] SMP
Feb 13 14:10:37 bminton kernel: [87956.259667] CPU 1
Feb 13 14:10:37 bminton kernel: [87956.259669] Modules linked in:
xt_multiport binfmt_misc nfnetlink_log nfnetlink bluetooth rfkill
uinput xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 xt_recent xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
ppdev lp battery powernow_k8 mperf cpufreq_powersave cpufreq_userspace
cpufreq_conservative cpufreq_stats nfsd nfs lockd fscache auth_rpcgss
nfs_acl sunrpc dummy bridge stp decnet xfs exportfs fuse dm_crypt
snd_ali5451 nvram ch st osst loop snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_mpu401 snd_mpu401_uart
snd_seq_midi snd_rawmidi irtty_sir sir_dev i2c_ali15x3 irda
snd_seq_midi_event snd_seq tpm_tis tpm snd_timer i2c_ali1535 evdev
shpchp pci_hotplug k8temp psmouse snd_seq_device ns558 gameport
i2c_ali1563 i2c_core tpm_bios crc_ccitt snd pcspkr serio_raw edac_core
parport_pc button soundcore parport processor thermal_sys
snd_page_alloc ext3 jbd mbcache btrfs zlib_deflate crc32c libcrc32c
raid1 md_mod nbd dm_mirror dm_reg
Feb 13 14:10:37 bminton kernel: ion_hash dm_log dm_mod sg sr_mod cdrom
ata_generic ide_gd_mod sd_mod crc_t10dif usb_storage ohci_hcd sata_uli
sata_sil floppy ahci libahci r8169 mii siimage libata scsi_mod
alim15x3 uli526x ide_pci_generic ide_core ehci_hcd [last unloaded:
scsi_wait_scan]
Feb 13 14:10:37 bminton kernel: [87956.259758]
Feb 13 14:10:37 bminton kernel: [87956.259761] Pid: 355, comm: kswapd0
Not tainted 3.1.6 #1          939Dual-SATA2/939Dual-SATA2
Feb 13 14:10:37 bminton kernel: [87956.259767] RIP:
0010:[<ffffffffa01f6076>]  [<ffffffffa01f6076>] bit_spin_lock+0xd/0x18
[jbd]
Feb 13 14:10:37 bminton kernel: [87956.259775] RSP:
0018:ffff880177f45b30  EFLAGS: 00010246
Feb 13 14:10:37 bminton kernel: [87956.259778] RAX: 0000000000000000
RBX: 0000000000000000 RCX: ffff880177f45c28
Feb 13 14:10:37 bminton kernel: [87956.259780] RDX: 00000000000000d0
RSI: ffff88ff70aec270 RDI: 0000000000000015
Feb 13 14:10:37 bminton kernel: [87956.259783] RBP: ffff88ff70aec270
R08: 0000000000000001 R09: ffffea0001ffc960
Feb 13 14:10:37 bminton kernel: [87956.259786] R10: ffffea0001ffc960
R11: ffffea0001ffc960 R12: ffff8801778d394c
Feb 13 14:10:37 bminton kernel: [87956.259789] R13: ffff880170aec270
R14: 0000000000000000 R15: 0000000000000000
Feb 13 14:10:37 bminton kernel: [87956.259793] FS:
0000000000000000(0000) GS:ffff88017fd00000(0000)
knlGS:00000000f7482700
Feb 13 14:10:37 bminton kernel: [87956.259796] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Feb 13 14:10:37 bminton kernel: [87956.259798] CR2: ffff88ff70aec270
CR3: 000000006e453000 CR4: 00000000000006f0
Feb 13 14:10:37 bminton kernel: [87956.259802] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Feb 13 14:10:37 bminton kernel: [87956.259805] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 13 14:10:37 bminton kernel: [87956.259808] Process kswapd0 (pid:
355, threadinfo ffff880177f44000, task ffff88017ab96270)
Feb 13 14:10:37 bminton kernel: [87956.259810] Stack:
Feb 13 14:10:37 bminton kernel: [87956.259812]  ffffffffa01f7dc7
ffff88ff70aec270 ffffea0001d60280 ffffffffa01f1a78
Feb 13 14:10:37 bminton kernel: [87956.259816]  ffff880177f45e48
ffffea0001d602a0 ffffea0001d60280 ffff880177f45e48
Feb 13 14:10:37 bminton kernel: [87956.259821]  ffff880177f45c98
0000000000000001 0000000000000000 ffffffff810abe65
Feb 13 14:10:37 bminton kernel: [87956.259826] Call Trace:
Feb 13 14:10:37 bminton kernel: [87956.259834]  [<ffffffffa01f7dc7>] ?
journal_grab_journal_head+0x14/0x37 [jbd]
Feb 13 14:10:37 bminton kernel: [87956.259841]  [<ffffffffa01f1a78>] ?
journal_try_to_free_buffers+0x38/0xf9 [jbd]
Feb 13 14:10:37 bminton kernel: [87956.259848]  [<ffffffff810abe65>] ?
shrink_page_list+0x4e8/0x693
Feb 13 14:10:37 bminton kernel: [87956.259853]  [<ffffffff810b26a2>] ?
zone_page_state_add+0x14/0x23
Feb 13 14:10:37 bminton kernel: [87956.259857]  [<ffffffff810b2cd1>] ?
__mod_zone_page_state+0x3c/0x45
Feb 13 14:10:37 bminton kernel: [87956.259861]  [<ffffffff810aad46>] ?
update_isolated_counts.isra.58+0x10d/0x132
Feb 13 14:10:37 bminton kernel: [87956.259865]  [<ffffffff810ac377>] ?
shrink_inactive_list+0x1d9/0x338
Feb 13 14:10:37 bminton kernel: [87956.259869]  [<ffffffff810aca8f>] ?
shrink_zone+0x37d/0x45e
Feb 13 14:10:37 bminton kernel: [87956.259873]  [<ffffffff810ad740>] ?
kswapd+0x510/0x7a4
Feb 13 14:10:37 bminton kernel: [87956.259879]  [<ffffffff810510af>] ?
add_wait_queue+0x3c/0x3c
Feb 13 14:10:37 bminton kernel: [87956.259883]  [<ffffffff810ad230>] ?
try_to_free_pages+0xe9/0xe9
Feb 13 14:10:37 bminton kernel: [87956.259887]  [<ffffffff81050a70>] ?
kthread+0x76/0x7e
Feb 13 14:10:37 bminton kernel: [87956.259892]  [<ffffffff812f2774>] ?
kernel_thread_helper+0x4/0x10
Feb 13 14:10:37 bminton kernel: [87956.259896]  [<ffffffff810509fa>] ?
kthread_worker_fn+0x139/0x139
Feb 13 14:10:37 bminton kernel: [87956.259899]  [<ffffffff812f2770>] ?
gs_change+0x13/0x13
Feb 13 14:10:37 bminton kernel: [87956.259901] Code: 89 fa 4c 89 f6 e8
35 54 e9 e0 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 f0 0f b3 3e
c3 eb 0b f3 90 0f a3 3e 19 c0 85 c0 75 f5 <f0> 0f ab 3e 19 c0 85 c0 75
eb c3 53 48 89 fb 48 8d 7f 24 e8 68
Feb 13 14:10:37 bminton kernel: [87956.259940] RIP
[<ffffffffa01f6076>] bit_spin_lock+0xd/0x18 [jbd]
Feb 13 14:10:37 bminton kernel: [87956.259947]  RSP <ffff880177f45b30>
Feb 13 14:10:37 bminton kernel: [87956.259949] CR2: ffff88ff70aec270
Feb 13 14:10:37 bminton kernel: [87956.259952] ---[ end trace
59d18b8661c6b30a ]---
bminton:/usr/local/src/linux-3.1.6# scripts/decodecode < /root/oops
Feb 13 14:10:37 bminton kernel: [87956.259901] Code: 89 fa 4c 89 f6 e8
35 54 e9 e0 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 f0 0f b3 3e
c3 eb 0b f3 90 0f a3 3e 19 c0 85 c0 75 f5 <f0> 0f ab 3e 19 c0 85 c0 75
eb c3 53 48 89 fb 48 8d 7f 24 e8 68
All code
========
   0:	89 fa                	mov    %edi,%edx
   2:	4c                   	dec    %esp
   3:	89 f6                	mov    %esi,%esi
   5:	e8 35 54 e9 e0       	call   0xe0e9543f
   a:	48                   	dec    %eax
   b:	83 c4 18             	add    $0x18,%esp
   e:	5b                   	pop    %ebx
   f:	5d                   	pop    %ebp
  10:	41                   	inc    %ecx
  11:	5c                   	pop    %esp
  12:	41                   	inc    %ecx
  13:	5d                   	pop    %ebp
  14:	41                   	inc    %ecx
  15:	5e                   	pop    %esi
  16:	41                   	inc    %ecx
  17:	5f                   	pop    %edi
  18:	c3                   	ret
  19:	f0 0f b3 3e          	lock btr %edi,(%esi)
  1d:	c3                   	ret
  1e:	eb 0b                	jmp    0x2b
  20:	f3 90                	pause
  22:	0f a3 3e             	bt     %edi,(%esi)
  25:	19 c0                	sbb    %eax,%eax
  27:	85 c0                	test   %eax,%eax
  29:	75 f5                	jne    0x20
  2b:*	f0 0f ab 3e          	lock bts %edi,(%esi)     <-- trapping instruction
  2f:	19 c0                	sbb    %eax,%eax
  31:	85 c0                	test   %eax,%eax
  33:	75 eb                	jne    0x20
  35:	c3                   	ret
  36:	53                   	push   %ebx
  37:	48                   	dec    %eax
  38:	89 fb                	mov    %edi,%ebx
  3a:	48                   	dec    %eax
  3b:	8d 7f 24             	lea    0x24(%edi),%edi
  3e:	e8                   	.byte 0xe8
  3f:	68                   	.byte 0x68

Code starting with the faulting instruction
===========================================
   0:	f0 0f ab 3e          	lock bts %edi,(%esi)
   4:	19 c0                	sbb    %eax,%eax
   6:	85 c0                	test   %eax,%eax
   8:	75 eb                	jne    0xfffffff5
   a:	c3                   	ret
   b:	53                   	push   %ebx
   c:	48                   	dec    %eax
   d:	89 fb                	mov    %edi,%ebx
   f:	48                   	dec    %eax
  10:	8d 7f 24             	lea    0x24(%edi),%edi
  13:	e8                   	.byte 0xe8
  14:	68                   	.byte 0x68
bminton:/usr/local/src/linux-3.1.6# cat /proc/cpuinfo
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 43
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 1
cpu MHz		: 2200.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
3dnowext 3dnow rep_good nopl pni lahf_lm cmp_legacy
bogomips	: 4400.45
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 43
model name	: AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping	: 1
cpu MHz		: 2200.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm
3dnowext 3dnow rep_good nopl pni lahf_lm cmp_legacy
bogomips	: 4400.45
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

bminton:/usr/local/src/linux-3.1.6# cat /proc/modules
xt_multiport 1564 1 - Live 0xffffffffa0075000
binfmt_misc 6117 1 - Live 0xffffffffa0117000
nfnetlink_log 6828 0 - Live 0xffffffffa00bd000
nfnetlink 2706 1 nfnetlink_log, Live 0xffffffffa006d000
bluetooth 67241 2 - Live 0xffffffffa02c6000
rfkill 12964 3 bluetooth, Live 0xffffffffa0106000
uinput 6408 3 - Live 0xffffffffa0036000
xt_limit 1710 5 - Live 0xffffffffa014c000
nf_conntrack_ipv4 9710 2 - Live 0xffffffffa01fe000
nf_defrag_ipv4 1195 1 nf_conntrack_ipv4, Live 0xffffffffa0142000
xt_recent 6244 2 - Live 0xffffffffa011e000
xt_state 1151 2 - Live 0xffffffffa0112000
nf_conntrack 45281 2 nf_conntrack_ipv4,xt_state, Live 0xffffffffa01d3000
ipt_REJECT 2046 2 - Live 0xffffffffa010b000
xt_tcpudp 2274 9 - Live 0xffffffffa00ac000
iptable_filter 1344 1 - Live 0xffffffffa0070000
ip_tables 13618 1 iptable_filter, Live 0xffffffffa013d000
x_tables 13920 8
xt_multiport,xt_limit,xt_recent,xt_state,ipt_REJECT,xt_tcpudp,iptable_filter,ip_tables,
Live 0xffffffffa00f2000
ppdev 4987 0 - Live 0xffffffffa00b3000
lp 7737 0 - Live 0xffffffffa006a000
battery 6101 0 - Live 0xffffffffa0009000
powernow_k8 11790 1 - Live 0xffffffffa0720000
mperf 1173 1 powernow_k8, Live 0xffffffffa071c000
cpufreq_powersave 910 0 - Live 0xffffffffa0718000
cpufreq_userspace 1856 0 - Live 0xffffffffa0714000
cpufreq_conservative 4315 0 - Live 0xffffffffa070f000
cpufreq_stats 2690 0 - Live 0xffffffffa070b000
nfsd 245869 6 - Live 0xffffffffa06c1000
nfs 247079 0 - Live 0xffffffffa066f000
lockd 59960 2 nfsd,nfs, Live 0xffffffffa0658000
fscache 28826 1 nfs, Live 0xffffffffa0648000
auth_rpcgss 33735 2 nfsd,nfs, Live 0xffffffffa0639000
nfs_acl 1991 2 nfsd,nfs, Live 0xffffffffa0635000
sunrpc 159221 19 nfsd,nfs,lockd,auth_rpcgss,nfs_acl, Live 0xffffffffa05f8000
dummy 1984 0 - Live 0xffffffffa05f4000
bridge 60206 0 - Live 0xffffffffa05dc000
stp 1432 1 bridge, Live 0xffffffffa05d8000
decnet 55636 0 [permanent], Live 0xffffffffa05c3000
xfs 581148 3 - Live 0xffffffffa0507000
exportfs 3004 2 nfsd,xfs, Live 0xffffffffa0503000
fuse 53773 1 - Live 0xffffffffa04ed000
dm_crypt 13402 0 - Live 0xffffffffa04e5000
snd_ali5451 13645 0 - Live 0xffffffffa04dd000
nvram 4913 0 - Live 0xffffffffa04d8000
ch 9715 0 - Live 0xffffffffa04d1000
st 28637 0 - Live 0xffffffffa04c6000
osst 42753 0 - Live 0xffffffffa04b7000
loop 13349 0 - Live 0xffffffffa04af000
snd_intel8x0 23783 5 - Live 0xffffffffa04a4000
snd_ac97_codec 98843 2 snd_ali5451,snd_intel8x0, Live 0xffffffffa0482000
ac97_bus 1078 1 snd_ac97_codec, Live 0xffffffffa047e000
snd_pcm_oss 30581 0 - Live 0xffffffffa0471000
snd_mixer_oss 11969 2 snd_pcm_oss, Live 0xffffffffa046a000
snd_pcm 58644 5 snd_ali5451,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,
Live 0xffffffffa0451000
snd_mpu401 4889 0 - Live 0xffffffffa044b000
snd_mpu401_uart 4891 1 snd_mpu401, Live 0xffffffffa0441000
snd_seq_midi 4064 0 - Live 0xffffffffa0435000
snd_rawmidi 15120 2 snd_mpu401_uart,snd_seq_midi, Live 0xffffffffa041a000
irtty_sir 3125 0 - Live 0xffffffffa0416000
sir_dev 8195 1 irtty_sir, Live 0xffffffffa040f000
i2c_ali15x3 4610 0 - Live 0xffffffffa040a000
irda 83627 1 sir_dev, Live 0xffffffffa03e9000
snd_seq_midi_event 4636 1 snd_seq_midi, Live 0xffffffffa03e4000
snd_seq 39713 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa03c2000
tpm_tis 8190 0 - Live 0xffffffffa03bc000
tpm 9830 1 tpm_tis, Live 0xffffffffa038c000
snd_timer 15450 3 snd_pcm,snd_seq, Live 0xffffffffa037f000
i2c_ali1535 4466 0 - Live 0xffffffffa0375000
evdev 7838 19 - Live 0xffffffffa035d000
shpchp 21461 0 - Live 0xffffffffa0352000
pci_hotplug 19634 1 shpchp, Live 0xffffffffa0348000
k8temp 3199 0 - Live 0xffffffffa0344000
psmouse 33477 0 - Live 0xffffffffa0334000
snd_seq_device 4464 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffffa032a000
ns558 2143 0 - Live 0xffffffffa0326000
gameport 6668 2 ns558, Live 0xffffffffa0320000
i2c_ali1563 4666 0 - Live 0xffffffffa031b000
i2c_core 15852 3 i2c_ali15x3,i2c_ali1535,i2c_ali1563, Live 0xffffffffa030c000
tpm_bios 4412 1 tpm, Live 0xffffffffa02e9000
crc_ccitt 1315 1 irda, Live 0xffffffffa02e5000
snd 45922 18 snd_ali5451,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_mpu401,snd_mpu401_uart,snd_rawmidi,snd_seq,snd_timer,snd_seq_device,
Live 0xffffffffa02b9000
pcspkr 1707 0 - Live 0xffffffffa02b1000
serio_raw 3698 0 - Live 0xffffffffa02ad000
edac_core 29546 0 - Live 0xffffffffa0295000
parport_pc 17212 1 - Live 0xffffffffa028b000
button 4217 0 - Live 0xffffffffa0281000
soundcore 4505 2 snd, Live 0xffffffffa0275000
parport 26142 3 ppdev,lp,parport_pc, Live 0xffffffffa0268000
processor 23213 1 powernow_k8, Live 0xffffffffa0250000
thermal_sys 12240 1 processor, Live 0xffffffffa0242000
snd_page_alloc 5971 2 snd_intel8x0,snd_pcm, Live 0xffffffffa023c000
ext3 156852 3 - Live 0xffffffffa0206000
jbd 47818 1 ext3, Live 0xffffffffa01f1000
mbcache 4425 1 ext3, Live 0xffffffffa01eb000
btrfs 467493 0 - Live 0xffffffffa015f000
zlib_deflate 17342 1 btrfs, Live 0xffffffffa0157000
crc32c 2584 1 - Live 0xffffffffa0153000
libcrc32c 954 1 btrfs, Live 0xffffffffa014f000
raid1 20468 1 - Live 0xffffffffa0146000
md_mod 82190 2 raid1, Live 0xffffffffa0127000
nbd 7649 0 - Live 0xffffffffa0121000
dm_mirror 11227 0 - Live 0xffffffffa011a000
dm_region_hash 6390 1 dm_mirror, Live 0xffffffffa0114000
dm_log 7480 2 dm_mirror,dm_region_hash, Live 0xffffffffa010f000
dm_mod 56409 9 dm_crypt,dm_mirror,dm_log, Live 0xffffffffa00f7000
sg 18064 0 - Live 0xffffffffa00ec000
sr_mod 12323 0 - Live 0xffffffffa00d2000
cdrom 28953 1 sr_mod, Live 0xffffffffa00e3000
ata_generic 3247 0 - Live 0xffffffffa0024000
ide_gd_mod 20094 9 - Live 0xffffffffa00a6000
sd_mod 29424 5 - Live 0xffffffffa00da000
crc_t10dif 1284 1 sd_mod, Live 0xffffffffa002f000
usb_storage 40111 0 - Live 0xffffffffa00c7000
ohci_hcd 17094 0 - Live 0xffffffffa00c1000
sata_uli 2913 0 - Live 0xffffffffa002b000
sata_sil 7052 4 - Live 0xffffffffa0028000
floppy 48447 0 - Live 0xffffffffa0099000
ahci 18981 3 - Live 0xffffffffa00b7000
libahci 16132 1 ahci, Live 0xffffffffa00ae000
r8169 35393 0 - Live 0xffffffffa0060000
mii 3307 1 r8169, Live 0xffffffffa0026000
siimage 5876 2 - Live 0xffffffffa0021000
libata 132805 5 ata_generic,sata_uli,sata_sil,ahci,libahci, Live
0xffffffffa0077000
scsi_mod 153165 8 ch,st,osst,sg,sr_mod,sd_mod,usb_storage,libata, Live
0xffffffffa0039000
alim15x3 5441 7 - Live 0xffffffffa0072000
uli526x 12794 0 - Live 0xffffffffa0031000
ide_pci_generic 2892 0 - Live 0xffffffffa002d000
ide_core 75768 4 ide_gd_mod,siimage,alim15x3,ide_pci_generic, Live
0xffffffffa000d000
ehci_hcd 32599 0 - Live 0xffffffffa0000000
bminton:/usr/local/src/linux-3.1.6# cat /proc/ioports
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
  0170-0177 : 0000:00:12.0
    0170-0177 : alim15x3
  01f0-01f7 : 0000:00:12.0
    01f0-01f7 : alim15x3
  0200-0207 : ns558-pnp
  0290-029f : pnp 00:0f
  02f8-02ff : serial
  0330-0331 : MPU401 UART
  0376-0376 : 0000:00:12.0
    0376-0376 : alim15x3
  0378-037a : parport0
  037b-037f : parport0
  03c0-03df : vga+
  03f2-03f2 : floppy
  03f4-03f5 : floppy
  03f6-03f6 : 0000:00:12.0
    03f6-03f6 : alim15x3
  03f7-03f7 : floppy
  03f8-03ff : serial
  0400-040f : pnp 00:0a
    0400-040f : ali1563_smbus
  0480-048f : pnp 00:0a
  04d0-04d1 : pnp 00:0a
  0800-083f : 0000:00:07.1
    0800-0803 : ACPI PM1a_EVT_BLK
    0804-0805 : ACPI PM1a_CNT_BLK
    0808-080b : ACPI PM_TMR
    0810-0815 : ACPI CPU throttle
    0818-0827 : ACPI GPE0_BLK
    0830-0830 : ACPI PM2_CNT_BLK
  0cf8-0cff : PCI conf1
  a000-afff : PCI Bus 0000:03
    a400-a40f : 0000:03:00.0
      a400-a40f : ahci
    a480-a483 : 0000:03:00.0
      a480-a483 : ahci
    a800-a807 : 0000:03:00.0
      a800-a807 : ahci
    a880-a883 : 0000:03:00.0
      a880-a883 : ahci
    ac00-ac07 : 0000:03:00.0
      ac00-ac07 : ahci
  b000-cfff : PCI Bus 0000:05
    b400-b4ff : 0000:05:07.0
      b400-b4ff : r8169
    b800-b80f : 0000:05:06.0
      b800-b80f : siimage
    b880-b883 : 0000:05:06.0
      b880-b883 : siimage
    bc00-bc07 : 0000:05:06.0
      bc00-bc07 : siimage
    c000-c003 : 0000:05:06.0
      c000-c003 : siimage
    c080-c087 : 0000:05:06.0
      c080-c087 : siimage
    c400-c40f : 0000:05:05.0
    c480-c483 : 0000:05:05.0
    c800-c807 : 0000:05:05.0
    c880-c883 : 0000:05:05.0
    cc00-cc07 : 0000:05:05.0
  d880-d88f : 0000:00:12.1
    d880-d88f : sata_uli
  dc00-dc03 : 0000:00:12.1
    dc00-dc03 : sata_uli
  e000-e007 : 0000:00:12.1
    e000-e007 : sata_uli
  e080-e083 : 0000:00:12.1
    e080-e083 : sata_uli
  e400-e4ff : 0000:00:11.0
    e400-e4ff : uli526x
  e800-e8ff : 0000:00:08.0
    e800-e8ff : ALi M5455
  ec00-ec07 : 0000:00:12.1
    ec00-ec07 : sata_uli
  ff00-ff0f : 0000:00:12.0
    ff00-ff0f : alim15x3
bminton:/usr/local/src/linux-3.1.6# cat /proc/iomem
00000000-0000ffff : reserved
00010000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus #00
000c0000-000c7fff : Video ROM
000e8000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ffaffff : System RAM
  01000000-012f4db8 : Kernel code
  012f4db9-016643ff : Kernel data
  016f9000-017bcfff : Kernel bss
7ffb0000-7ffbffff : ACPI Tables
7ffc0000-7ffeffff : ACPI Non-volatile Storage
7fff0000-7fffffff : reserved
80000000-ffffffff : PCI Bus #00
  80000000-800fffff : PCI Bus 0000:05
    80000000-8001ffff : 0000:05:07.0
  b7f00000-d7efffff : PCI Bus 0000:04
    c0000000-cfffffff : 0000:04:00.0
  dc000000-dfffffff : GART
    dc000000-dfffffff : aperture
  e0000000-efffffff : pnp 00:0b
  fa400000-fa4fffff : PCI Bus 0000:01
  fa500000-fa5fffff : PCI Bus 0000:02
  fa600000-fa6fffff : PCI Bus 0000:03
    fa6fe000-fa6fffff : 0000:03:00.0
      fa6fe000-fa6fffff : ahci
  fa700000-fe7fffff : PCI Bus 0000:04
    fc000000-fcffffff : 0000:04:00.0
    fd000000-fdffffff : 0000:04:00.0
    fe7e0000-fe7fffff : 0000:04:00.0
  fe800000-feafffff : PCI Bus 0000:05
    fe980000-fe9fffff : 0000:05:06.0
    fea00000-fea7ffff : 0000:05:05.0
    feaff400-feaff4ff : 0000:05:07.0
      feaff400-feaff4ff : r8169
    feaff800-feaff8ff : 0000:05:06.0
      feaff800-feaff8ff : siimage
    feaffc00-feafffff : 0000:05:05.0
      feaffc00-feafffff : sata_sil
  febfb000-febfbfff : 0000:00:13.2
    febfb000-febfbfff : ohci_hcd
  febfc000-febfcfff : 0000:00:13.1
    febfc000-febfcfff : ohci_hcd
  febfd000-febfdfff : 0000:00:13.0
    febfd000-febfdfff : ohci_hcd
  febfe800-febfe8ff : 0000:00:13.3
    febfe800-febfe8ff : ehci_hcd
  febfec00-febfecff : 0000:00:11.0
    febfec00-febfecff : uli526x
  febff000-febfffff : 0000:00:08.0
    febff000-febfffff : ALi M5455
  fec00000-fec003ff : IOAPIC 0
  fec10000-fec103ff : IOAPIC 1
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0b
  ff7c0000-ffffffff : reserved
    ffb80000-ffffffff : pnp 00:0b
100000000-17fffffff : System RAM
180000000-fcffffffff : PCI Bus #00
bminton:/usr/local/src/linux-3.1.6# lspci -vvv
00:00.0 Host bridge: ALi Corporation M1695 K8 Northbridge [PCI Express
and HyperTransport]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [40] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=4 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=8bit
DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 1.05
		Link Frequency 0: 800MHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+
800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE+ OFE+ EOCFE+ RFE+ CRCFE+ SERRFE- CF+
RE- PNFE+ ONFE+ EOCNFE+ RNFE- CRCNFE+ SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [5c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [68] HyperTransport: UnitID Clumping
	Capabilities: [74] HyperTransport: Interrupt Discovery and Configuration
	Capabilities: [7c] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000

00:01.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00
[Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fa400000-fa4fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0
<2us, L1 <32us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [7c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [88] HyperTransport: Revision ID: 1.05
	Kernel driver in use: pcieport

00:02.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00
[Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fa500000-fa5fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x2, ASPM L0s L1, Latency L0
<2us, L1 <32us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [7c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [88] HyperTransport: Revision ID: 1.05
	Kernel driver in use: pcieport

00:03.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00
[Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR+ <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fa600000-fa6fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [48] MSI: Enable- Count=1/2 Maskable- 64bit+
		Address: 00000000fee00000  Data: 0000
	Capabilities: [58] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x2, ASPM L0s L1, Latency L0
<2us, L1 <32us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd Off, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [7c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [88] HyperTransport: Revision ID: 1.05
	Kernel driver in use: pcieport

00:04.0 Host bridge: ALi Corporation M1689 K8 Northbridge [Super K8 Single Chip]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at <ignored> (32-bit, prefetchable)
	Capabilities: [40] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=4 UnitCnt=1 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=8bit DwFcOut- LWI=16bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.04
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
	Capabilities: [60] HyperTransport: Interrupt Discovery and Configuration
	Capabilities: [80] AGP version 3.0
		Status: RQ=28 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
	Kernel driver in use: agpgart-amd64

00:05.0 PCI bridge: ALi Corporation AGP8X Controller (prog-if 00
[Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fa700000-fe7fffff
	Prefetchable memory behind bridge: b7f00000-d7efffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:06.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge (prog-if
01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
	I/O behind bridge: 0000b000-0000cfff
	Memory behind bridge: fe800000-feafffff
	Prefetchable memory behind bridge: 80000000-800fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:07.0 ISA bridge: ALi Corporation M1563 HyperTransport South Bridge (rev 70)
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 6000ns max)
	Kernel driver in use: ali1563_smbus

00:07.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:08.0 Multimedia audio controller: ALi Corporation M5455 PCI AC-Link
Controller Audio Device (rev 20)
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (16000ns min), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at e800 [size=256]
	Region 1: Memory at febff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: snd_intel8x0

00:11.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated
ethernet. (rev 40)
	Subsystem: ASRock Incorporation Device 5263
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (5000ns min, 10000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at e400 [size=256]
	Region 1: Memory at febfec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uli526x

00:12.0 IDE interface: ALi Corporation M5229 IDE (rev c7) (prog-if 8a
[Master SecP PriP])
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard IDE (PATA)
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ff00 [size=16]
	Kernel driver in use: ALI15x3_IDE

00:12.1 IDE interface: ALi Corporation ULi 5289 SATA (rev 10) (prog-if
8f [Master SecP SecO PriP PriO])
	Subsystem: ASRock Incorporation Device 5289
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at ec00 [size=8]
	Region 1: I/O ports at e080 [size=4]
	Region 2: I/O ports at e000 [size=8]
	Region 3: I/O ports at dc00 [size=4]
	Region 4: I/O ports at d880 [size=16]
	Kernel driver in use: sata_uli

00:13.0 USB controller: ALi Corporation USB 1.1 Controller (rev 03)
(prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 32 (20000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at febfd000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.1 USB controller: ALi Corporation USB 1.1 Controller (rev 03)
(prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 32 (20000ns max), Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at febfc000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB controller: ALi Corporation USB 1.1 Controller (rev 03)
(prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 32 (20000ns max), Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at febfb000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.3 USB controller: ALi Corporation USB 2.0 Controller (rev 01)
(prog-if 20 [EHCI])
	Subsystem: ASRock Incorporation ASRock 939Dual-SATA2 Motherboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at febfe800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=0090
	Kernel driver in use: ehci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
IsocEn- LSEn- ExtCTL- 64b-
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

03:00.0 SATA controller: JMicron Technology Corp. JMB360 AHCI
Controller (prog-if 01 [AHCI 1.0])
	Subsystem: ASRock Incorporation Device 0360
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 35
	Region 0: I/O ports at ac00 [size=8]
	Region 1: I/O ports at a880 [size=4]
	Region 2: I/O ports at a800 [size=8]
	Region 3: I/O ports at a480 [size=4]
	Region 4: I/O ports at a400 [size=16]
	Region 5: Memory at fa6fe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0
unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Kernel driver in use: ahci

04:00.0 VGA compatible controller: nVidia Corporation NV44A [GeForce
6200] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: Chaintech Computer Co. Ltd Device 1974
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1250ns min, 250ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 2: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
	Expansion ROM at fe7e0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [44] AGP version 3.0
		Status: RQ=256 Iso- ArqSz=0 Cal=3 SBA+ ITACoh- GART64- HTrans-
64bit- FW+ AGP3+ Rate=x4,x8
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

05:05.0 RAID bus controller: Silicon Image, Inc. SiI 3114
[SATALink/SATARaid] Serial ATA Controller (rev 02)
	Subsystem: Silicon Image, Inc. Device 7114
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at c880 [size=4]
	Region 2: I/O ports at c800 [size=8]
	Region 3: I/O ports at c480 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Region 5: Memory at feaffc00 (32-bit, non-prefetchable) [size=1K]
	Expansion ROM at fea00000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: sata_sil

05:06.0 Mass storage controller: Silicon Image, Inc. PCI0680 Ultra
ATA-133 Host Controller (rev 02)
	Subsystem: Silicon Image, Inc. SiI 0680 ATA/133 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at c080 [size=8]
	Region 1: I/O ports at c000 [size=4]
	Region 2: I/O ports at bc00 [size=8]
	Region 3: I/O ports at b880 [size=4]
	Region 4: I/O ports at b800 [size=16]
	Region 5: Memory at feaff800 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at fe980000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: SiI_IDE

05:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
Gigabit Ethernet (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL8169/8110 Family PCI
Gigabit Ethernet NIC
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at b400 [size=256]
	Region 1: Memory at feaff400 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at 80000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: r8169

bminton:/usr/local/src/linux-3.1.6# cat /proc/scsi/scsi
cat: /proc/scsi/scsi: No such file or directory
bminton:/usr/local/src/linux-3.1.6# lsscsi
[0:0:0:0]    disk    ATA      ST3400832AS      3.03  /dev/sda
[1:0:0:0]    disk    Y-E DATA CF Card Reader   3.02  /dev/sdb
[1:0:0:1]    disk    Y-E DATA SM Card Reader   3.02  /dev/sdc
[1:0:0:2]    disk    Y-E DATA MS Card Reader   3.02  /dev/sdd
[1:0:0:3]    disk    Y-E DATA SD Card Reader   3.02  /dev/sde
[2:0:0:0]    disk    Generic- Multi-Card       1.00  /dev/sdf
[5:0:0:0]    disk    ATA      ST31500341AS     SD1B  /dev/sdg
[6:0:0:0]    disk    ATA      ST31500341AS     SD1B  /dev/sdh
[7:0:0:0]    cd/dvd  ATAPI    iHAS124   Y      BL0V  /dev/scd0
