Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1DXK0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 06:26:45 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:59144 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab1DXK0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 06:26:43 -0400
Message-ID: <4DB3FAE0.5040008@xs4all.nl>
Date: Sun, 24 Apr 2011 12:26:40 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38.3 BUG?
References: <4DB05C13.2080708@xs4all.nl> <4DB258DC.1050204@xs4all.nl>
In-Reply-To: <4DB258DC.1050204@xs4all.nl>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More:

Apr 24 05:24:09 recorder kernel: BUG: unable to handle kernel paging
request at ffffffffffffff7f
Apr 24 05:24:09 recorder kernel: IP: [<ffffffff810c90c2>]
__destroy_inode+0x62/0x90
Apr 24 05:24:09 recorder kernel: PGD 14d6067 PUD 14d7067 PMD 0
Apr 24 05:24:09 recorder kernel: Oops: 0002 [#1] PREEMPT SMP
Apr 24 05:24:09 recorder kernel: last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Apr 24 05:24:09 recorder kernel: CPU 1
Apr 24 05:24:09 recorder kernel: Modules linked in: eeprom f71882fg
sunrpc cpufreq_ondemand powernow_k8 mperf binfmt_misc snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec budget_av saa714
6_vv videodev snd_seq snd_seq_device snd_pcm videobuf_dma_sg processor
videobuf_core tua6100 budget_core saa7146 sg ttpci_eeprom thermal button
fan snd_timer dvb_pll tda10021 tda10023 tda8261 tda1004x stb089
9 stv0299 dvb_core snd snd_page_alloc k10temp evdev i2c_piix4 usbhid hid
ata_generic ehci_hcd ohci_hcd sr_mod radeon fbcon font bitblit
softcursor ttm drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect [last u
nloaded: scsi_wait_scan]
Apr 24 05:24:09 recorder kernel:
Apr 24 05:24:09 recorder kernel: Pid: 386, comm: kswapd0 Not tainted
2.6.38.4 #5 Unknow Unknow/RS780-SB700
Apr 24 05:24:09 recorder kernel: RIP: 0010:[<ffffffff810c90c2>]
[<ffffffff810c90c2>] __destroy_inode+0x62/0x90
Apr 24 05:24:09 recorder kernel: RSP: 0018:ffff88012e039ce0  EFLAGS:
00010282
Apr 24 05:24:09 recorder kernel: RAX: ffffffffffffff7e RBX:
ffff88000f43a1b0 RCX: 0000000000003538
Apr 24 05:24:09 recorder kernel: RDX: 0000000000000003 RSI:
ffff88000f43a1f8 RDI: ffffffffffffff7f
Apr 24 05:24:09 recorder kernel: RBP: ffff88000f43a228 R08:
ffd2bc61d8dc7e03 R09: ffff88000f43abc8
Apr 24 05:24:09 recorder kernel: R10: 0000000000000006 R11:
ffffea00022b0750 R12: ffff88012e039d20
Apr 24 05:24:09 recorder kernel: R13: 0000000000000080 R14:
ffff88012e039d20 R15: 000000000000002b
Apr 24 05:24:09 recorder kernel: FS:  00007f6879597700(0000)
GS:ffff8800bfd00000(0000) knlGS:0000000000000000
Apr 24 05:24:09 recorder kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Apr 24 05:24:09 recorder kernel: CR2: ffffffffffffff7f CR3:
0000000122d20000 CR4: 00000000000006e0
Apr 24 05:24:09 recorder kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 24 05:24:09 recorder kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 24 05:24:09 recorder kernel: Process kswapd0 (pid: 386, threadinfo
ffff88012e038000, task ffff88012fdaf810)
Apr 24 05:24:09 recorder kernel: Stack:
Apr 24 05:24:09 recorder kernel: ffff88000f43a1b0 ffffffff810c9103
ffff88000f43a1b0 ffffffff810c91fc
Apr 24 05:24:09 recorder kernel: 0000000000000080 ffff88000f438860
ffff88000f4388d8 ffffffff810c9628
Apr 24 05:24:09 recorder kernel: ffff88000f43b600 ffff88000f791580
0000000000000032 ffffffff814e8440
Apr 24 05:24:09 recorder kernel: Call Trace:
Apr 24 05:24:09 recorder kernel: [<ffffffff810c9103>] ?
destroy_inode+0x13/0x50
Apr 24 05:24:09 recorder kernel: [<ffffffff810c91fc>] ?
dispose_list+0xbc/0xd0
Apr 24 05:24:09 recorder kernel: [<ffffffff810c9628>] ?
shrink_icache_memory+0x1a8/0x320
Apr 24 05:24:09 recorder kernel: [<ffffffff8108500c>] ?
shrink_slab+0x10c/0x170
Apr 24 05:24:09 recorder kernel: [<ffffffff81087066>] ? kswapd+0x2f6/0x7c0
Apr 24 05:24:09 recorder kernel: [<ffffffff81086d70>] ? kswapd+0x0/0x7c0
Apr 24 05:24:09 recorder kernel: [<ffffffff81086d70>] ? kswapd+0x0/0x7c0
Apr 24 05:24:09 recorder kernel: [<ffffffff8104e076>] ? kthread+0x96/0xa0
Apr 24 05:24:09 recorder kernel: [<ffffffff810030d4>] ?
kernel_thread_helper+0x4/0x10
Apr 24 05:24:09 recorder kernel: [<ffffffff8104dfe0>] ? kthread+0x0/0xa0
Apr 24 05:24:09 recorder kernel: [<ffffffff810030d0>] ?
kernel_thread_helper+0x0/0x10
Apr 24 05:24:09 recorder kernel: Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff
74 0a f0 ff 0f 0f 94 c0 84 c0 75 32 65 ff 0c 25 8c e8 00 00 5b c3 48 85
ff 0f 1f 44 00 00 74 cc <f0> ff 0f 0f 94 c0 84 c0 66 0f 1f 44 0
0 00 74 bc e8 b9 fc fd ff
Apr 24 05:24:09 recorder kernel: RIP  [<ffffffff810c90c2>]
__destroy_inode+0x62/0x90
Apr 24 05:24:09 recorder kernel: RSP <ffff88012e039ce0>
Apr 24 05:24:09 recorder kernel: CR2: ffffffffffffff7f
Apr 24 05:24:09 recorder kernel: ---[ end trace 0154ac39bc65e05a ]---


and


Apr 24 05:24:33 recorder abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Apr 24 05:24:33 recorder abrtd: Directory 'kerneloops-1303615473-2631-1'
creation detected
Apr 24 05:24:34 recorder abrtd: New crash
/var/spool/abrt/kerneloops-1303615473-2631-1, processing
Apr 24 05:24:34 recorder abrtd:
RunApp('/var/spool/abrt/kerneloops-1303615473-2631-1','test x"`cat
component`" = x"xorg-x11-server-Xorg" && cp /var/log/Xorg.0.log .')

Apr 24 05:52:48 recorder kernel: BUG: unable to handle kernel paging
request at ffffffffffffff7f
Apr 24 05:52:48 recorder kernel: IP: [<ffffffff810c90c2>]
__destroy_inode+0x62/0x90
Apr 24 05:52:48 recorder kernel: PGD 14d6067 PUD 14d7067 PMD 0
Apr 24 05:52:48 recorder kernel: Oops: 0002 [#2] PREEMPT SMP
Apr 24 05:52:48 recorder kernel: last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
Apr 24 05:52:48 recorder kernel: CPU 1
Apr 24 05:52:48 recorder kernel: Modules linked in: eeprom f71882fg
sunrpc cpufreq_ondemand powernow_k8 mperf binfmt_misc snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec budget_av saa7146_vv
videodev snd_seq snd_seq_device snd_pcm videobuf_dma_sg processor
videobuf_core tua6100 budget_core saa7146 sg ttpci_eeprom thermal button
fan snd_timer dvb_pll tda10021 tda10023 tda8261 tda1004x stb0899 stv0299
dvb_core snd snd_page_alloc k10temp evdev i2c_piix4 usbhid hid
ata_generic ehci_hcd ohci_hcd sr_mod radeon fbcon font bitblit
softcursor ttm drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect [last
unloaded: scsi_wait_scan]
Apr 24 05:52:48 recorder kernel:
Apr 24 05:52:48 recorder kernel: Pid: 5670, comm: mythbackend Tainted: G
     D     2.6.38.4 #5 Unknow Unknow/RS780-SB700
Apr 24 05:52:48 recorder kernel: RIP: 0010:[<ffffffff810c90c2>]
[<ffffffff810c90c2>] __destroy_inode+0x62/0x90
Apr 24 05:52:48 recorder kernel: RSP: 0018:ffff880003f75858  EFLAGS:
00010282
Apr 24 05:52:48 recorder kernel: RAX: ffffffffffffff7e RBX:
ffff88000e6e3130 RCX: 0000000000003538
Apr 24 05:52:48 recorder kernel: RDX: 0000000000000003 RSI:
ffff88000e6e3178 RDI: ffffffffffffff7f
Apr 24 05:52:48 recorder kernel: RBP: ffff88000e6e31a8 R08:
ffd391d223805e03 R09: ffff88000e6e3418
Apr 24 05:52:48 recorder kernel: R10: 0000000000000487 R11:
0000000000000001 R12: ffff880003f75898
Apr 24 05:52:48 recorder kernel: R13: 0000000000000080 R14:
ffff880003f75898 R15: 0000000000000000
Apr 24 05:52:48 recorder kernel: FS:  00007f6879597700(0000)
GS:ffff8800bfd00000(0000) knlGS:0000000000000000
Apr 24 05:52:48 recorder kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Apr 24 05:52:48 recorder kernel: CR2: ffffffffffffff7f CR3:
0000000122d20000 CR4: 00000000000006e0
Apr 24 05:52:48 recorder kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 24 05:52:48 recorder kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 24 05:52:48 recorder kernel: Process mythbackend (pid: 5670,
threadinfo ffff880003f74000, task ffff88012d82a920)
Apr 24 05:52:48 recorder kernel: Stack:
Apr 24 05:52:48 recorder kernel: ffff88000e6e3130 ffffffff810c9103
ffff88000e6e3130 ffffffff810c91fc
Apr 24 05:52:48 recorder kernel: 0000000000000080 ffff88000e6d64f0
ffff88000e6d6500 ffffffff810c9628
Apr 24 05:52:48 recorder kernel: ffff88000e6e4cb0 ffff88000e6c5540
0000000000000032 ffffffff814e8440
Apr 24 05:52:48 recorder kernel: Call Trace:
Apr 24 05:52:48 recorder kernel: [<ffffffff810c9103>] ?
destroy_inode+0x13/0x50
Apr 24 05:52:48 recorder kernel: [<ffffffff810c91fc>] ?
dispose_list+0xbc/0xd0
Apr 24 05:52:48 recorder kernel: [<ffffffff810c9628>] ?
shrink_icache_memory+0x1a8/0x320
Apr 24 05:52:48 recorder kernel: [<ffffffff8108500c>] ?
shrink_slab+0x10c/0x170
Apr 24 05:52:48 recorder kernel: [<ffffffff8108772e>] ?
try_to_free_pages+0x1fe/0x370
Apr 24 05:52:48 recorder kernel: [<ffffffff81080385>] ?
__alloc_pages_nodemask+0x435/0x7e0
Apr 24 05:52:48 recorder kernel: [<ffffffff810794c5>] ?
find_get_page+0x75/0xb0
Apr 24 05:52:48 recorder kernel: [<ffffffff81079ab8>] ?
grab_cache_page_write_begin+0x68/0xd0
Apr 24 05:52:48 recorder kernel: [<ffffffff810dd64c>] ?
nobh_write_begin+0x4c/0x440
Apr 24 05:52:48 recorder kernel: [<ffffffff810da5a8>] ?
__set_page_dirty+0x68/0xd0
Apr 24 05:52:48 recorder kernel: [<ffffffff810d9c67>] ?
free_buffer_head+0x47/0x80
Apr 24 05:52:48 recorder kernel: [<ffffffff81174b10>] ?
jfs_write_begin+0x40/0x80
Apr 24 05:52:48 recorder kernel: [<ffffffff81174bd0>] ?
jfs_get_block+0x0/0x250
Apr 24 05:52:48 recorder kernel: [<ffffffff81078d5c>] ?
generic_file_buffered_write+0x10c/0x280
Apr 24 05:52:48 recorder kernel: [<ffffffff8119486b>] ?
jfs_getxattr+0x3b/0x80
Apr 24 05:52:48 recorder kernel: [<ffffffff8107a5e1>] ?
__generic_file_aio_write+0x211/0x400
Apr 24 05:52:48 recorder kernel: [<ffffffff8105dd87>] ?
futex_wake+0xf7/0x110
Apr 24 05:52:48 recorder kernel: [<ffffffff8107a830>] ?
generic_file_aio_write+0x60/0xd0
Apr 24 05:52:48 recorder kernel: [<ffffffff810b08ff>] ?
do_sync_write+0xbf/0x100
Apr 24 05:52:48 recorder kernel: [<ffffffff811a4914>] ?
security_file_permission+0x24/0xc0
Apr 24 05:52:48 recorder kernel: [<ffffffff810b1036>] ? vfs_write+0xc6/0x170
Apr 24 05:52:48 recorder kernel: [<ffffffff810b131e>] ? sys_write+0x4e/0x90
Apr 24 05:52:48 recorder kernel: [<ffffffff8100237b>] ?
system_call_fastpath+0x16/0x1b
Apr 24 05:52:48 recorder kernel: Code: 47 ff 48 83 f8 fd 77 0f 48 85 ff
74 0a f0 ff 0f 0f 94 c0 84 c0 75 32 65 ff 0c 25 8c e8 00 00 5b c3 48 85
ff 0f 1f 44 00 00 74 cc <f0> ff 0f 0f 94 c0 84 c0 66 0f 1f 44 00 00 74
bc e8 b9 fc fd ff
Apr 24 05:52:48 recorder kernel: RIP  [<ffffffff810c90c2>]
__destroy_inode+0x62/0x90
Apr 24 05:52:48 recorder kernel: RSP <ffff880003f75858>
Apr 24 05:52:48 recorder kernel: CR2: ffffffffffffff7f
Apr 24 05:52:48 recorder kernel: ---[ end trace 0154ac39bc65e05b ]---
Apr 24 05:54:33 recorder abrt: Kerneloops: Reported 1 kernel oopses to Abrt
Apr 24 05:54:33 recorder abrtd: Directory 'kerneloops-1303617273-2631-1'
creation detected
Apr 24 05:54:33 recorder abrtd: New crash
/var/spool/abrt/kerneloops-1303617273-2631-1, processing
Apr 24 05:54:33 recorder abrtd:
RunApp('/var/spool/abrt/kerneloops-1303617273-2631-1','test x"`cat
component`" = x"xorg-x11-server-Xorg" && cp /var/log/Xorg.0.log .')

What is the suspected cause? Hardware, software?


Kind regards,
Udo
