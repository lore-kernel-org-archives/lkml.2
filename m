Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab1DWEnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 00:43:13 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:42780 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1DWEnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 00:43:11 -0400
Message-ID: <4DB258DC.1050204@xs4all.nl>
Date: Sat, 23 Apr 2011 06:43:08 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 BUG?
References: <4DB05C13.2080708@xs4all.nl>
In-Reply-To: <4DB05C13.2080708@xs4all.nl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-21 18:32, Udo van den Heuvel wrote:
> What can be said about the BUG logging below?
> Cause?  (hw/sw)
> Known?

More:

Apr 23 03:59:38 recorder kernel: BUG: unable to handle kernel paging
request at ffffffffffffff7f
Apr 23 03:59:38 recorder kernel: IP: [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
Apr 23 03:59:38 recorder kernel: PGD 14d4067 PUD 14d5067 PMD 0
Apr 23 03:59:38 recorder kernel: Oops: 0002 [#1] PREEMPT SMP
Apr 23 03:59:38 recorder kernel: last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Apr 23 03:59:38 recorder kernel: CPU 0
Apr 23 03:59:38 recorder kernel: Modules linked in: eeprom f71882fg
sunrpc cpufreq_ondemand powernow_k8 mperf binfmt_misc snd_hda_codec_hdmi
snd_hda_codec_realtek budget_av saa7146_vv videodev videobuf_dma_sg
videobuf_core tua6100 snd_hda_intel budget_core saa7146 ttpci_eeprom
dvb_pll tda10021 tda10023 snd_hda_codec tda8261 tda1004x stb0899 stv0299
sg dvb_core snd_seq i2c_piix4 k10temp evdev snd_seq_device fan thermal
button snd_pcm snd_timer snd snd_page_alloc processor usbhid hid sr_mod
ata_generic ehci_hcd ohci_hcd radeon fbcon font bitblit softcursor ttm
drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect [last unloaded:
scsi_wait_scan]
Apr 23 03:59:38 recorder kernel:
Apr 23 03:59:38 recorder kernel: Pid: 386, comm: kswapd0 Not tainted
2.6.38.3 #4 Unknow Unknow/RS780-SB700
Apr 23 03:59:38 recorder kernel: RIP: 0010:[<ffffffff810c90e2>]
[<ffffffff810c90e2>] __destroy_inode+0x62/0x90
Apr 23 03:59:38 recorder kernel: RSP: 0018:ffff88012e01dce0  EFLAGS:
00010282
Apr 23 03:59:38 recorder kernel: RAX: ffffffffffffff7e RBX:
ffff880008d67170 RCX: 0000000000007540
Apr 23 03:59:38 recorder kernel: RDX: 0000000000000003 RSI:
ffff880008d671b8 RDI: ffffffffffffff7f
Apr 23 03:59:38 recorder kernel: RBP: ffff880008d671e8 R08:
ffd929907d906e03 R09: ffff880008d67458
Apr 23 03:59:38 recorder kernel: R10: 0000000000000000 R11:
ffffea0001c1d650 R12: ffff88012e01dd20
Apr 23 03:59:38 recorder kernel: R13: 0000000000000080 R14:
ffff88012e01dd20 R15: 0000000000000058
Apr 23 03:59:38 recorder kernel: FS:  00007f6b24d95700(0000)
GS:ffff8800bfc00000(0000) knlGS:0000000000000000
Apr 23 03:59:38 recorder kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Apr 23 03:59:38 recorder kernel: CR2: ffffffffffffff7f CR3:
0000000120e43000 CR4: 00000000000006f0
Apr 23 03:59:38 recorder kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 23 03:59:38 recorder kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 23 03:59:38 recorder kernel: Process kswapd0 (pid: 386, threadinfo
ffff88012e01c000, task ffff88012fcd6c30)
Apr 23 03:59:38 recorder kernel: Stack:
Apr 23 03:59:38 recorder kernel: ffff880008d67170 ffffffff810c9123
ffff880008d67170 ffffffff810c921c
Apr 23 03:59:38 recorder kernel: 0000000000000080 ffff880008d558a0
ffff880008d55918 ffffffff810c9648
Apr 23 03:59:38 recorder kernel: ffff880008d69958 ffff880008d0a600
0000000000000032 ffffffff814e6440
Apr 23 03:59:38 recorder kernel: Call Trace:
Apr 23 03:59:38 recorder kernel: [<ffffffff810c9123>] ?
destroy_inode+0x13/0x50
Apr 23 03:59:38 recorder kernel: [<ffffffff810c921c>] ?
dispose_list+0xbc/0xd0
Apr 23 03:59:38 recorder kernel: [<ffffffff810c9648>] ?
shrink_icache_memory+0x1a8/0x320
Apr 23 03:59:38 recorder kernel: [<ffffffff81084fdc>] ?
shrink_slab+0x10c/0x170
Apr 23 03:59:38 recorder kernel: [<ffffffff81087036>] ? kswapd+0x2f6/0x7c0
Apr 23 03:59:38 recorder kernel: [<ffffffff81086d40>] ? kswapd+0x0/0x7c0
Apr 23 03:59:38 recorder kernel: [<ffffffff81086d40>] ? kswapd+0x0/0x7c0
Apr 23 03:59:38 recorder kernel: [<ffffffff8104dff6>] ? kthread+0x96/0xa0
Apr 23 03:59:38 recorder kernel: [<ffffffff810030d4>] ?
kernel_thread_helper+0x4/0x10
Apr 23 03:59:38 recorder kernel: [<ffffffff8104df60>] ? kthread+0x0/0xa0
Apr 23 03:59:38 recorder kernel: [<ffffffff810030d0>] ?
kernel_thread_helper+0x0/0x10
Apr 23 03:59:38 recorder kernel: Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff
74 0a f0 ff 0f 0f 94 c0 84 c0 75 32 65 ff 0c 25 8c e8 00 00 5b c3 48 85
ff 0f 1f 44 00 00 74 cc <f0> ff 0f 0f 94 c0 84 c0 66 0f 1f 44 00 00 74
bc e8 b9 fc fd ff
Apr 23 03:59:38 recorder kernel: RIP  [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
Apr 23 03:59:38 recorder kernel: RSP <ffff88012e01dce0>
Apr 23 03:59:38 recorder kernel: CR2: ffffffffffffff7f
Apr 23 03:59:38 recorder kernel: ---[ end trace 0da428fc68ffa305 ]---


and:


Apr 23 04:13:48 recorder kernel: BUG: unable to handle kernel paging
request at ffffffffffffff7f
Apr 23 04:13:48 recorder kernel: IP: [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
Apr 23 04:13:48 recorder kernel: PGD 14d4067 PUD 14d5067 PMD 0
Apr 23 04:13:48 recorder kernel: Oops: 0002 [#2] PREEMPT SMP
Apr 23 04:13:48 recorder kernel: last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Apr 23 04:13:48 recorder kernel: CPU 0
Apr 23 04:13:48 recorder kernel: Modules linked in: eeprom f71882fg
sunrpc cpufreq_ondemand powernow_k8 mperf binfmt_misc snd_hda_codec_hdmi
snd_hda_codec_realtek budget_av saa7146_vv videodev videobuf_dma_sg
videobuf_core tua6100 snd_hda_intel budget_core saa7146 ttpci_eeprom
dvb_pll tda10021 tda10023 snd_hda_codec tda8261 tda1004x stb0899 stv0299
sg dvb_core snd_seq i2c_piix4 k10temp evdev snd_seq_device fan thermal
button snd_pcm snd_timer snd snd_page_alloc processor usbhid hid sr_mod
ata_generic ehci_hcd ohci_hcd radeon fbcon font bitblit softcursor ttm
drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect [last unloaded:
scsi_wait_scan]
Apr 23 04:13:48 recorder kernel:
Apr 23 04:13:48 recorder kernel: Pid: 387, comm: khugepaged Tainted: G
    D     2.6.38.3 #4 Unknow Unknow/RS780-SB700
Apr 23 04:13:48 recorder kernel: RIP: 0010:[<ffffffff810c90e2>]
[<ffffffff810c90e2>] __destroy_inode+0x62/0x90
Apr 23 04:13:48 recorder kernel: RSP: 0018:ffff88012e01fa70  EFLAGS:
00010282
Apr 23 04:13:48 recorder kernel: RAX: ffffffffffffff7e RBX:
ffff8800024ef130 RCX: 0000000000003540
Apr 23 04:13:48 recorder kernel: RDX: 0000000000000003 RSI:
ffff8800024ef178 RDI: ffffffffffffff7f
Apr 23 04:13:48 recorder kernel: RBP: ffff8800024ef1a8 R08:
ffdfb10f1bb05e03 R09: ffff8800024ef418
Apr 23 04:13:48 recorder kernel: R10: 000000000000038b R11:
0000000000000001 R12: ffff88012e01fab0
Apr 23 04:13:48 recorder kernel: R13: 0000000000000080 R14:
ffff88012e01fab0 R15: 0000000000000000
Apr 23 04:13:48 recorder kernel: FS:  00007f6b2affd700(0000)
GS:ffff8800bfc00000(0000) knlGS:0000000000000000
Apr 23 04:13:48 recorder kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Apr 23 04:13:48 recorder kernel: CR2: ffffffffffffff7f CR3:
0000000120e43000 CR4: 00000000000006f0
Apr 23 04:13:48 recorder kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 23 04:13:48 recorder kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 23 04:13:48 recorder kernel: Process khugepaged (pid: 387,
threadinfo ffff88012e01e000, task ffff88012fe6e6a0)
Apr 23 04:13:48 recorder kernel: Stack:
Apr 23 04:13:48 recorder kernel: ffff8800024ef130 ffffffff810c9123
ffff8800024ef130 ffffffff810c921c
Apr 23 04:13:48 recorder kernel: 0000000000000080 ffff88000786fc78
ffff88000786fcf0 ffffffff810c9648
Apr 23 04:13:48 recorder kernel: ffff880002519c30 ffff880009639cf0
0000000000000032 ffffffff814e6440
Apr 23 04:13:48 recorder kernel: Call Trace:
Apr 23 04:13:48 recorder kernel: [<ffffffff810c9123>] ?
destroy_inode+0x13/0x50
Apr 23 04:13:48 recorder kernel: [<ffffffff810c921c>] ?
dispose_list+0xbc/0xd0
Apr 23 04:13:48 recorder kernel: [<ffffffff810c9648>] ?
shrink_icache_memory+0x1a8/0x320
Apr 23 04:13:48 recorder kernel: [<ffffffff81084fdc>] ?
shrink_slab+0x10c/0x170
Apr 23 04:13:48 recorder kernel: [<ffffffff810876fe>] ?
try_to_free_pages+0x1fe/0x3a0
Apr 23 04:13:48 recorder kernel: [<ffffffff81080355>] ?
__alloc_pages_nodemask+0x435/0x7e0
Apr 23 04:13:48 recorder kernel: [<ffffffff810abe91>] ?
khugepaged_alloc_hugepage+0x51/0xe0
Apr 23 04:13:48 recorder kernel: [<ffffffff810ac387>] ?
khugepaged+0xa7/0xee0
Apr 23 04:13:48 recorder kernel: [<ffffffff8104e490>] ?
autoremove_wake_function+0x0/0x30
Apr 23 04:13:48 recorder kernel: [<ffffffff810ac2e0>] ? khugepaged+0x0/0xee0
Apr 23 04:13:48 recorder kernel: [<ffffffff810ac2e0>] ? khugepaged+0x0/0xee0
Apr 23 04:13:48 recorder kernel: [<ffffffff8104dff6>] ? kthread+0x96/0xa0
Apr 23 04:13:48 recorder kernel: [<ffffffff810030d4>] ?
kernel_thread_helper+0x4/0x10
Apr 23 04:13:48 recorder kernel: [<ffffffff8104df60>] ? kthread+0x0/0xa0
Apr 23 04:13:48 recorder kernel: [<ffffffff810030d0>] ?
kernel_thread_helper+0x0/0x10
Apr 23 04:13:48 recorder kernel: Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff
74 0a f0 ff 0f 0f 94 c0 84 c0 75 32 65 ff 0c 25 8c e8 00 00 5b c3 48 85
ff 0f 1f 44 00 00 74 cc <f0> ff 0f 0f 94 c0 84 c0 66 0f 1f 44 00 00 74
bc e8 b9 fc fd ff
Apr 23 04:13:48 recorder kernel: RIP  [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
Apr 23 04:13:48 recorder kernel: RSP <ffff88012e01fa70>
Apr 23 04:13:48 recorder kernel: CR2: ffffffffffffff7f
Apr 23 04:13:48 recorder kernel: ---[ end trace 0da428fc68ffa306 ]---

and:


Apr 23 04:13:48 recorder kernel: saa7146 (0) vpeirq: used 1 times >80%
of buffer (156604 bytes now)
Apr 23 04:18:57 recorder kernel: BUG: unable to handle kernel paging
request at ffffffffffffff7f
Apr 23 04:18:57 recorder kernel: IP: [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
Apr 23 04:18:57 recorder kernel: PGD 14d4067 PUD 14d5067 PMD 0
Apr 23 04:18:57 recorder kernel: Oops: 0002 [#3] PREEMPT SMP
Apr 23 04:18:57 recorder kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:05.0/0000:03:00.0/irq
Apr 23 04:18:57 recorder kernel: CPU 0
Apr 23 04:18:57 recorder kernel: Modules linked in: eeprom f71882fg
sunrpc cpufreq_ondemand powernow_k8 mperf binfmt_misc snd_hda_codec_hdmi
snd_hda_codec_realtek budget_av saa7146_vv videodev videobuf_dma_sg
videobuf_core tua6100 snd_hda_intel budget_core saa7146 ttpci_eeprom
dvb_pll tda10021 tda10023 snd_hda_codec tda8261 tda1004x stb0899 stv0299
sg dvb_core snd_seq i2c_piix4 k10temp evdev snd_seq_device fan thermal
button snd_pcm snd_timer snd snd_page_alloc processor usbhid hid sr_mod
ata_generic ehci_hcd ohci_hcd radeon fbcon font bitblit softcursor ttm
drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect [last unloaded:
scsi_wait_scan]
Apr 23 04:18:57 recorder kernel:
Apr 23 04:18:57 recorder kernel: Pid: 21876, comm: mythbackend Tainted:
G      D     2.6.38.3 #4 Unknow Unknow/RS780-SB700
Apr 23 04:18:57 recorder kernel: RIP: 0010:[<ffffffff810c90e2>]
[<ffffffff810c90e2>] __destroy_inode+0x62/0x90
Apr 23 04:18:57 recorder kernel: RSP: 0018:ffff8800077cd858  EFLAGS:
00010282
Apr 23 04:18:57 recorder kernel: RAX: ffffffffffffff7e RBX:
ffff880008d6b0f0 RCX: 0000000000007540
Apr 23 04:18:57 recorder kernel: RDX: 0000000000000003 RSI:
ffff880008d6b138 RDI: ffffffffffffff7f
Apr 23 04:18:57 recorder kernel: RBP: ffff880008d6b168 R08:
ffd92950fda04e03 R09: ffff880008d6b3d8
Apr 23 04:18:57 recorder kernel: R10: 000000000000038b R11:
0000000000000001 R12: ffff8800077cd898
Apr 23 04:18:57 recorder kernel: R13: 0000000000000080 R14:
ffff8800077cd898 R15: 0000000000000000
Apr 23 04:18:57 recorder kernel: FS:  00007f6b2b7fe700(0000)
GS:ffff8800bfc00000(0000) knlGS:0000000000000000
Apr 23 04:18:57 recorder kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Apr 23 04:18:57 recorder kernel: CR2: ffffffffffffff7f CR3:
0000000120e43000 CR4: 00000000000006f0
Apr 23 04:18:57 recorder kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 23 04:18:57 recorder kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 23 04:18:57 recorder kernel: Process mythbackend (pid: 21876,
threadinfo ffff8800077cc000, task ffff88012b83e860)
Apr 23 04:18:57 recorder kernel: Stack:
Apr 23 04:18:57 recorder kernel: ffff880008d6b0f0 ffffffff810c9123
ffff880008d6b0f0 ffffffff810c921c
Apr 23 04:18:57 recorder kernel: 0000000000000080 ffff8800025d3570
ffff8800025d3580 ffffffff810c9648
Apr 23 04:18:57 recorder kernel: ffff880008d6cc70 ffff880004219958
0000000000000032 ffffffff814e6440
Apr 23 04:18:57 recorder kernel: Call Trace:
Apr 23 04:18:57 recorder kernel: [<ffffffff810c9123>] ?
destroy_inode+0x13/0x50
Apr 23 04:18:57 recorder kernel: [<ffffffff810c921c>] ?
dispose_list+0xbc/0xd0
Apr 23 04:18:57 recorder kernel: [<ffffffff810c9648>] ?
shrink_icache_memory+0x1a8/0x320
Apr 23 04:18:57 recorder kernel: [<ffffffff81084fdc>] ?
shrink_slab+0x10c/0x170
Apr 23 04:18:57 recorder kernel: [<ffffffff810876fe>] ?
try_to_free_pages+0x1fe/0x3a0
Apr 23 04:18:57 recorder kernel: [<ffffffff81080355>] ?
__alloc_pages_nodemask+0x435/0x7e0
Apr 23 04:18:57 recorder kernel: [<ffffffff81079445>] ?
find_get_page+0x75/0xb0
Apr 23 04:18:57 recorder kernel: [<ffffffff81079a38>] ?
grab_cache_page_write_begin+0x68/0xd0
Apr 23 04:18:57 recorder kernel: [<ffffffff810dd66c>] ?
nobh_write_begin+0x4c/0x440
Apr 23 04:18:57 recorder kernel: [<ffffffff810da5c8>] ?
__set_page_dirty+0x68/0xd0
Apr 23 04:18:57 recorder kernel: [<ffffffff810d9c87>] ?
free_buffer_head+0x47/0x80
Apr 23 04:18:57 recorder kernel: [<ffffffff81174b40>] ?
jfs_write_begin+0x40/0x80
Apr 23 04:18:57 recorder kernel: [<ffffffff81174c00>] ?
jfs_get_block+0x0/0x250
Apr 23 04:18:57 recorder kernel: [<ffffffff81078cdc>] ?
generic_file_buffered_write+0x10c/0x280
Apr 23 04:18:57 recorder kernel: [<ffffffff8119489b>] ?
jfs_getxattr+0x3b/0x80
Apr 23 04:18:57 recorder kernel: [<ffffffff8107a561>] ?
__generic_file_aio_write+0x211/0x400
Apr 23 04:18:57 recorder kernel: [<ffffffff8105dd07>] ?
futex_wake+0xf7/0x110
Apr 23 04:18:57 recorder kernel: [<ffffffff8107a7b0>] ?
generic_file_aio_write+0x60/0xd0
Apr 23 04:18:57 recorder kernel: [<ffffffff810b094f>] ?
do_sync_write+0xbf/0x100
Apr 23 04:18:57 recorder kernel: [<ffffffff810b094f>] ?
do_sync_write+0xbf/0x100
Apr 23 04:18:57 recorder kernel: [<ffffffff8139d90e>] ?
common_interrupt+0xe/0x13
Apr 23 04:18:57 recorder kernel: [<ffffffff8139d90e>] ?
common_interrupt+0xe/0x13
Apr 23 04:18:57 recorder kernel: [<ffffffff811a4944>] ?
security_file_permission+0x24/0xc0
Apr 23 04:18:57 recorder kernel: [<ffffffff810b1086>] ? vfs_write+0xc6/0x170
Apr 23 04:18:57 recorder kernel: [<ffffffff810b136e>] ? sys_write+0x4e/0x90
Apr 23 04:18:57 recorder kernel: [<ffffffff8100237b>] ?
system_call_fastpath+0x16/0x1b
Apr 23 04:18:57 recorder kernel: Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff
74 0a f0 ff 0f 0f 94 c0 84 c0 75 32 65 ff 0c 25 8c e8 00 00 5b c3 48 85
ff 0f 1f 44 00 00 74 cc <f0> ff 0f 0f 94 c0 84 c0 66 0f 1f 44 00 00 74
bc e8 b9 fc fd ff
Apr 23 04:18:57 recorder kernel: RIP  [<ffffffff810c90e2>]
__destroy_inode+0x62/0x90
Apr 23 04:18:57 recorder kernel: RSP <ffff8800077cd858>
Apr 23 04:18:57 recorder kernel: CR2: ffffffffffffff7f
Apr 23 04:18:57 recorder kernel: ---[ end trace 0da428fc68ffa307 ]---
