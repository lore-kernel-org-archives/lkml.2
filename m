Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2E1Qg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:36:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39636 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2E1Qg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:36:26 -0400
MIME-Version: 1.0
Date: Mon, 28 May 2012 10:36:25 -0600
Message-ID: <CAKB0YR_XLA5Nz=4gC8ezJHGBL4WezOWHqxs1RSm9F9w6Qt_qYA@mail.gmail.com>
Subject: Oops on Linux 3.3.7-1 (Arch x64)
From: Meteor Ekce <meteor.ekce@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I have received an Oops message on a new install of arch linux
on kernel 3.3.7-1 (the latest in Arch repositories currently). Here is
the relevant output from my /var/log/everything.log file.

I am running an AMD Athlon 64 X2 4800+ on an Asus A8N-E (socket 939)
motherboard with chipset NForce4 and BIOS revision 1013. The video
card is a RADEON X300 128MB PCI-E using the open source xf86-video-ati
(radeon) drivers. I had actually been having regular crashes up to two
times a day before and decided to replace an PATA hard drive and move
everything to a PCIe SATA controller (Rocket 620) hoping it was just a
hardware problem as I've heard that's sometimes common with these
motherboards. So I'm using two hard drives, one SSD for the OS and one
older HDD for data, both on SATA on this PCIe controller. I also have
an older Oops message from April 30th that I had planned on sending in
but decided not to in case it turned out to be fixed by this hardware
(I also changed window managers from KDE+compiz). I will append the
April 30th Oops message below the one I had last night.

As far as what was happening when the Oops occurred. I am running
XFCE4 with Compiz. I had left amarok playing music while I slept as
well as a java based pyborg bot that I host for an irc chatroom. I
also had apache, mysql, synergyc, and proftp daemons running, but they
should've been completely inactive at the time at the crash (except
for mysql as I have amarok store it's database in there). If there is
anything I'm missing please let me know and I will provide it.

Thank you for your time.

May 28 05:18:47 localhost kernel: [114353.931982] BUG: unable to
handle kernel paging request at ffff8800f747dee0
May 28 05:18:47 localhost kernel: [114353.932046] IP:
[<ffffffffa01fa375>] ext4_mb_good_group+0x65/0x130 [ext4]
May 28 05:18:47 localhost kernel: [114353.932112] PGD 1806063 PUD 0
May 28 05:18:47 localhost kernel: [114353.932137] Oops: 0000 [#1] PREEMPT SMP
May 28 05:18:47 localhost kernel: [114353.932170] CPU 1
May 28 05:18:47 localhost kernel: [114353.932184] Modules linked in:
fuse ppdev radeon i2c_algo_bit drm_kms_helper ttm drm edac_mce_amd
edac_core psmouse pcspkr serio_raw k8temp forcedeth snd_intel8x0
usb_storage snd_ac97_codec uas snd_pcm joydev snd_page_alloc evdev
snd_timer snd soundcore ac97_bus i2c_nforce2 i2c_core thermal fan
parport_pc parport button processor asus_atk0110 ext4 crc16 jbd2
mbcache hid_logitech ff_memless usbhid hid sr_mod cdrom pata_amd
ohci_hcd pata_acpi sata_nv ata_generic ehci_hcd usbcore usb_common
floppy sd_mod ahci libahci libata scsi_mod
May 28 05:18:47 localhost kernel: [114353.932576]
May 28 05:18:47 localhost kernel: [114353.932589] Pid: 1513, comm:
java Not tainted 3.3.7-1-ARCH #1 System manufacturer System Product
Name/A8N-E
May 28 05:18:47 localhost kernel: [114353.932657] RIP:
0010:[<ffffffffa01fa375>]  [<ffffffffa01fa375>]
ext4_mb_good_group+0x65/0x130 [ext4]
May 28 05:18:47 localhost kernel: [114353.932725] RSP:
0018:ffff880021eb15e8  EFLAGS: 00010293
May 28 05:18:47 localhost kernel: [114353.932760] RAX:
ffff8800b7b17000 RBX: ffff8800f747dee0 RCX: 000000000000003e
May 28 05:18:47 localhost kernel: [114353.932807] RDX:
0000000000000001 RSI: 000000000000004e RDI: ffff8800b99d7400
May 28 05:18:47 localhost kernel: [114353.932853] RBP:
ffff880021eb1618 R08: ffff8800b99d5c00 R09: ffff8800b74ccdd0
May 28 05:18:47 localhost kernel: [114353.932901] R10:
ffff880021eb1694 R11: 0000000000100000 R12: 0000000000001f4e
May 28 05:18:47 localhost kernel: [114353.932948] R13:
ffff8800b74ccdd0 R14: 0000000000000000 R15: 000000000000287d
May 28 05:18:47 localhost kernel: [114353.932995] FS:
00007fdeb7fff700(0000) GS:ffff8800bfd00000(0000)
knlGS:0000000000000000
May 28 05:18:47 localhost kernel: [114353.933048] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
May 28 05:18:47 localhost kernel: [114353.933086] CR2:
ffff8800f747dee0 CR3: 000000007dc77000 CR4: 00000000000006e0
May 28 05:18:47 localhost kernel: [114353.933133] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 28 05:18:47 localhost kernel: [114353.933180] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 28 05:18:47 localhost kernel: [114353.933227] Process java (pid:
1513, threadinfo ffff880021eb0000, task ffff88007ddb2800)
May 28 05:18:47 localhost kernel: [114353.933279] Stack:
May 28 05:18:47 localhost kernel: [114353.933294]  ffff88000cacd280
ffff8800b74ccdd0 ffff8800b74ccdd0 0000000000001173
May 28 05:18:47 localhost kernel: [114353.933349]  0000000000001f4e
ffff8800b99d7400 ffff880021eb16c8 ffffffffa01fc5cb
May 28 05:18:47 localhost kernel: [114353.933403]  ffff8800b99d7400
ffff880021eb17d0 0000287d21eb1668 ffff8800b99d5c00
May 28 05:18:47 localhost kernel: [114353.933457] Call Trace:
May 28 05:18:47 localhost kernel: [114353.933482]
[<ffffffffa01fc5cb>] ext4_mb_regular_allocator+0x19b/0x420 [ext4]
May 28 05:18:47 localhost kernel: [114353.933536]
[<ffffffffa01fe245>] ext4_mb_new_blocks+0x455/0x600 [ext4]
May 28 05:18:47 localhost kernel: [114353.933585]
[<ffffffffa0203aa8>] ext4_alloc_branch+0x528/0x670 [ext4]
May 28 05:18:47 localhost kernel: [114353.933632]
[<ffffffff811289d9>] ? zone_statistics+0x99/0xc0
May 28 05:18:47 localhost kernel: [114353.933675]
[<ffffffffa020406f>] ext4_ind_map_blocks+0x32f/0x770 [ext4]
May 28 05:18:47 localhost kernel: [114353.933725]
[<ffffffffa01c8071>] ext4_map_blocks+0xe1/0x240 [ext4]
May 28 05:18:47 localhost kernel: [114353.933770]
[<ffffffffa01ca336>] _ext4_get_block+0xa6/0x160 [ext4]
May 28 05:18:47 localhost kernel: [114353.933816]
[<ffffffffa01ca456>] ext4_get_block+0x16/0x20 [ext4]
May 28 05:18:47 localhost kernel: [114353.933859]
[<ffffffff8119eb9f>] __block_write_begin+0x1bf/0x590
May 28 05:18:47 localhost kernel: [114353.933904]
[<ffffffffa01ca440>] ? noalloc_get_block_write+0x30/0x30 [ext4]
May 28 05:18:47 localhost kernel: [114353.933955]
[<ffffffffa01c9415>] ext4_write_begin+0x165/0x390 [ext4]
May 28 05:18:47 localhost kernel: [114353.934000]
[<ffffffff81109c74>] generic_file_buffered_write+0x124/0x2b0
May 28 05:18:47 localhost kernel: [114353.934047]
[<ffffffff81055296>] ? current_fs_time+0x16/0x60
May 28 05:18:47 localhost kernel: [114353.934087]
[<ffffffff8110b77a>] __generic_file_aio_write+0x22a/0x440
May 28 05:18:47 localhost kernel: [114353.934132]
[<ffffffff8145cd4e>] ? __mutex_lock_slowpath+0x27e/0x370
May 28 05:18:47 localhost kernel: [114353.934176]
[<ffffffff8110ba01>] generic_file_aio_write+0x71/0xe0
May 28 05:18:47 localhost kernel: [114353.934221]
[<ffffffffa01c2f3f>] ext4_file_write+0xaf/0x260 [ext4]
May 28 05:18:47 localhost kernel: [114353.934265]
[<ffffffff8108611f>] ? __dequeue_entity+0x2f/0x50
May 28 05:18:47 localhost kernel: [114353.934306]
[<ffffffff8116bc8e>] do_sync_write+0xde/0x120
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff8107d859>] ? finish_task_switch+0x49/0xd0
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff811f52cc>] ? security_file_permission+0x2c/0xb0
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff8116c24d>] ? rw_verify_area+0x2d/0xf0
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff8116c281>] ? rw_verify_area+0x61/0xf0
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff8116c598>] vfs_write+0xa8/0x180
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff8116c8da>] sys_write+0x4a/0xa0
May 28 05:18:47 localhost kernel: [114353.935245]
[<ffffffff81460069>] system_call_fastpath+0x16/0x1b
May 28 05:18:47 localhost kernel: [114353.935245] Code: 38 45 8b b0 30
03 00 00 d3 e8 48 83 ee 01 89 c1 49 8b 80 78 02 00 00 44 21 e6 83 fa
03 48 8b 04 c8 48 8b 1c f0 0f 87 be 00 00 00 <48> 8b 03 a8 01 0f 85 9b
00 00 00 8b 43 14 8b 4b 18 85 c0 74 56
May 28 05:18:47 localhost kernel: [114353.935245] RIP
[<ffffffffa01fa375>] ext4_mb_good_group+0x65/0x130 [ext4]
May 28 05:18:47 localhost kernel: [114353.935245]  RSP <ffff880021eb15e8>
May 28 05:18:47 localhost kernel: [114353.935245] CR2: ffff8800f747dee0
May 28 05:18:47 localhost kernel: [114353.935245] ---[ end trace
f460756cfa1c3332 ]---
May 28 05:19:27 localhost kernel: [114393.191921] radeon 0000:01:00.0:
GPU lockup CP stall for more than 10013msec
May 28 05:19:27 localhost kernel: [114393.191927] GPU lockup (waiting
for 0x00B279B1 last fence id 0x00B279AE)
May 28 05:19:27 localhost kernel: [114393.354300] radeon: wait for
empty RBBM fifo failed ! Bad things might happen.
May 28 05:19:27 localhost kernel: [114393.515838] Failed to wait GUI
idle while programming pipes. Bad things might happen.
May 28 05:19:27 localhost kernel: [114393.516877] radeon 0000:01:00.0:
(r300_asic_reset:415) RBBM_STATUS=0x8001C100
May 28 05:19:28 localhost kernel: [114394.021921] radeon 0000:01:00.0:
(r300_asic_reset:434) RBBM_STATUS=0x8001C100
May 28 05:19:28 localhost kernel: [114394.522940] radeon 0000:01:00.0:
(r300_asic_reset:446) RBBM_STATUS=0x8000C100
May 28 05:19:28 localhost kernel: [114394.522972] radeon 0000:01:00.0:
GPU reset succeed
May 28 05:19:28 localhost kernel: [114394.522974] radeon 0000:01:00.0:
GPU reset succeed
May 28 05:19:28 localhost kernel: [114394.522978] radeon 0000:01:00.0:
ffff8800b9205400 unpin not necessary
May 28 05:19:28 localhost kernel: [114394.522988] radeon 0000:01:00.0:
(r300_asic_reset:415) RBBM_STATUS=0x8000C100
May 28 05:19:29 localhost kernel: [114395.028023] radeon 0000:01:00.0:
(r300_asic_reset:434) RBBM_STATUS=0x8000C100



-----------------------Here is the April 30th Oops message I got
before I changed hardware and reinstalled the OS.


Apr 30 21:20:00 localhost kernel: [95333.785977] PGD 1806063 PUD 0
Apr 30 21:20:00 localhost kernel: [95333.786003] Oops: 0000 [#1] PREEMPT SMP
Apr 30 21:20:00 localhost kernel: [95333.786034] CPU 1
Apr 30 21:20:00 localhost kernel: [95333.786049] Modules linked in:
nf_conntrack_ftp xt_helper ipt_REJECT xt_tcpudp nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables
x_tables fuse snd_intel8x0 snd_ac97_codec usb_storage joydev uas
snd_pcm snd_page_alloc snd_timer snd soundcore ac97_bus radeon pcspkr
k8temp forcedeth edac_mce_amd ppdev edac_core i2c_algo_bit
drm_kms_helper ttm psmouse i2c_nforce2 parport_pc parport drm
processor evdev floppy asus_atk0110 serio_raw i2c_core fan thermal
button ext4 crc16 jbd2 mbcache sr_mod cdrom hid_logitech ff_memless
usbhid hid sd_mod pata_amd pata_acpi ata_generic ohci_hcd sata_nv
libata scsi_mod ehci_hcd usbcore usb_common
Apr 30 21:20:00 localhost kernel: [95333.786524]
Apr 30 21:20:00 localhost kernel: [95333.786537] Pid: 2001, comm: java
Not tainted 3.3.3-1-ARCH #1 System manufacturer System Product
Name/A8N-E
Apr 30 21:20:00 localhost kernel: [95333.786605] RIP:
0010:[<ffffffffa01d79f0>]  [<ffffffffa01d79f0>]
ext4_da_invalidatepage+0x80/0x2c0 [ext4]
Apr 30 21:20:00 localhost kernel: [95333.786673] RSP:
0018:ffff880006f73c78  EFLAGS: 00010246
Apr 30 21:20:00 localhost kernel: [95333.786708] RAX: ffff8800f4524a90
RBX: ffff8800290b6450 RCX: 0000000000000034
Apr 30 21:20:00 localhost kernel: [95333.786754] RDX: 0000000000000000
RSI: ffff8800f4524a90 RDI: 0000000000000000
Apr 30 21:20:00 localhost kernel: [95333.786800] RBP: ffff880006f73ce8
R08: 0000000000000000 R09: a80009e39a000000
Apr 30 21:20:00 localhost kernel: [95333.786846] R10: 57ffe01c6878e680
R11: 0000000000000042 R12: ffff8800290b65a0
Apr 30 21:20:00 localhost kernel: [95333.786892] R13: ffffea0002c930c0
R14: ffff8800b8df7c00 R15: 0000000000002b9e
Apr 30 21:20:00 localhost kernel: [95333.786939] FS:
00007f8af56ad700(0000) GS:ffff8800bfd00000(0000)
knlGS:00000000f74a66c0
Apr 30 21:20:00 localhost kernel: [95333.786992] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Apr 30 21:20:00 localhost kernel: [95333.787029] CR2: ffff8800f4524ab0
CR3: 0000000086aa9000 CR4: 00000000000006e0
Apr 30 21:20:00 localhost kernel: [95333.787076] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Apr 30 21:20:00 localhost kernel: [95333.787122] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 30 21:20:00 localhost kernel: [95333.787144] Process java (pid:
2001, threadinfo ffff880006f72000, task ffff8800b3e5b800)
Apr 30 21:20:00 localhost kernel: [95333.787144] Stack:
Apr 30 21:20:00 localhost kernel: [95333.787144]  ffff8800290b65a0
ffffea000278e680 ffff8800290b65b8 0000000000000000
Apr 30 21:20:00 localhost kernel: [95333.787144]  0000000000000007
0000000000002b9d ffff880006f73cb8 ffffffff81166713
Apr 30 21:20:00 localhost kernel: [95333.787144]  ffff880006f73ce8
ffffea0002c930c0 ffff8800290b65a0 ffff8800290b65a0
Apr 30 21:20:00 localhost kernel: [95333.787144] Call Trace:
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff81166713>]
? mem_cgroup_uncharge_cache_page+0x13/0x20
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff811186f1>]
truncate_inode_page+0x91/0xb0
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff81118861>]
truncate_inode_pages_range+0x151/0x4a0
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff81118bc5>]
truncate_inode_pages+0x15/0x20
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffffa01dd498>]
ext4_evict_inode+0x148/0x4f0 [ext4]
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff81186960>]
evict+0xb0/0x1b0
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff81186f35>]
iput+0x105/0x210
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff8117bf24>]
do_unlinkat+0x154/0x1d0
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff8116c70c>]
? sys_write+0x7c/0xa0
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff8117cb06>]
sys_unlink+0x16/0x20
Apr 30 21:20:00 localhost kernel: [95333.787144]  [<ffffffff8145ff29>]
system_call_fastpath+0x16/0x1b
Apr 30 21:20:00 localhost kernel: [95333.787144] Code: 8b 18 48 8b 43
28 4c 8b b0 10 03 00 00 48 8b 07 f6 c4 08 0f 84 48 02 00 00 48 8b 77
30 4c 8b 45 a8 31 d2 31 ff 48 89 f0 0f 1f 00 <8b> 48 20 01 d1 49 39 d0
77 15 48 8b 10 80 e6 02 74 0d 83 c7 01
Apr 30 21:20:00 localhost kernel: [95333.787144]  RSP <ffff880006f73c78>
Apr 30 21:20:00 localhost kernel: [95333.787144] CR2: ffff8800f4524ab0
Apr 30 21:20:00 localhost kernel: [95333.787144] ---[ end trace
26472fecec845d53 ]---
