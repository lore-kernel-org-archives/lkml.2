Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0LJOHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:07:19 -0500
Received: from kuber.nabble.com ([216.139.236.158]:56437 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0LJOHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:07:17 -0500
Message-ID: <30426415.post@talk.nabble.com>
Date: Fri, 10 Dec 2010 06:07:16 -0800 (PST)
From: kerby2000 <lukin.s.v@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc8] kernel BUG at mm/slub.c:2969!
In-Reply-To: <4B82E9FC.2020708@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: lukin.s.v@gmail.com
References: <4B82E9FC.2020708@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just installed Debian squeeze
and I'm getting very similar error. Any clues what it might be? And how to
solve it

[ 9595.087256] ------------[ cut here ]------------
[ 9595.087261] kernel BUG at
/build/buildd-linux-2.6_2.6.32-28-amd64-EUJiNq/linux-2.6-2.6.32/debian/build/source_amd64_non                                  
e/mm/slub.c:2969!
[ 9595.087263] invalid opcode: 0000 [#1] SMP
[ 9595.087266] last sysfs file:
/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/0000:03:00.0/0000:04:00.0/host0/target0:                                  
0:0/0:0:0:0/block/sda/sda3/uevent
[ 9595.087269] CPU 3
[ 9595.087270] Modules linked in: cpufreq_conservative cpufreq_powersave
cpufreq_userspace cpufreq_stats parport_pc ppdev                                   
lp parport sco bridge stp bnep l2cap bluetooth rfkill binfmt_misc fuse ext3
jbd loop radeon ttm drm_kms_helper drm i2c_alg                                  
o_bit i2c_i801 i5400_edac rng_core edac_core i2c_core ioatdma shpchp
pci_hotplug i5k_amb processor evdev pcspkr container                                   
psmouse button serio_raw ext4 mbcache jbd2 crc16 sd_mod crc_t10dif sg sr_mod
cdrom ata_generic ata_piix 3w_9xxx uhci_hcd e                                  
hci_hcd libata usbcore nls_base thermal thermal_sys igb dca floppy scsi_mod
[last unloaded: scsi_wait_scan]
[ 9595.087313] Pid: 2097, comm: udisks-daemon Not tainted 2.6.32-5-amd64 #1
X7DWU
[ 9595.087315] RIP: 0010:[<ffffffff810e6e5f>]  [<ffffffff810e6e5f>]
kfree+0x55/0xcb
[ 9595.087324] RSP: 0018:ffff88012e6a5a48  EFLAGS: 00010246
[ 9595.087325] RAX: 0200000000080000 RBX: ffff88012ce73330 RCX:
00000000002a0008
[ 9595.087327] RDX: ffff88012ce73300 RSI: ffffea00041e5040 RDI:
ffffea0003800000
[ 9595.087329] RBP: ffff880100000000 R08: 0000000000000000 R09:
ffffffff81451930
[ 9595.087331] R10: ffff8800055901b0 R11: ffffffff810b56db R12:
ffffffffa00d06db
[ 9595.087333] R13: 0000000000000001 R14: ffff880100000000 R15:
ffff88012f680020
[ 9595.087335] FS:  00007f54a81617a0(0000) GS:ffff880005580000(0000)
knlGS:0000000000000000
[ 9595.087337] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9595.087339] CR2: 00007fb285e57390 CR3: 000000012e6d9000 CR4:
00000000000006e0
[ 9595.087341] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 9595.087343] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 9595.087345] Process udisks-daemon (pid: 2097, threadinfo
ffff88012e6a4000, task ffff88012d8c7810)
[ 9595.087347] Stack:
[ 9595.087348]  ffff88012ce73330 ffff88012ce73300 0000000000000000
ffffffffa00d06db
[ 9595.087351] <0> 0000000000000296 ffff88012e6a5a98 ffff88012e6a5ef8
ffffffff810678b3
[ 9595.087354] <0> ffff88012e6a5b88 ffffffff812faaf6 ffff88011f479a99
0000000000000000
[ 9595.087357] Call Trace:
[ 9595.087363]  [<ffffffffa00d06db>] ? sr_media_change+0x253/0x27a [sr_mod]
[ 9595.087368]  [<ffffffff810678b3>] ? hrtimer_cancel+0xc/0x16
[ 9595.087373]  [<ffffffff812faaf6>] ? schedule_hrtimeout_range+0xd5/0x112
[ 9595.087378]  [<ffffffffa0026074>] ? media_changed+0x42/0x74 [cdrom]
[ 9595.087383]  [<ffffffff811115c2>] ? check_disk_change+0x22/0x53
[ 9595.087387]  [<ffffffffa002a84c>] ? cdrom_open+0x8d2/0x962 [cdrom]
[ 9595.087391]  [<ffffffff810fb8ee>] ? do_sys_poll+0x316/0x391
[ 9595.087393]  [<ffffffff810fc59b>] ? __pollwait+0x0/0xd6
[ 9595.087396]  [<ffffffff810fc671>] ? pollwake+0x0/0x5b
[ 9595.087399]  [<ffffffff810fc671>] ? pollwake+0x0/0x5b
[ 9595.087403]  [<ffffffff8118f05b>] ? kobject_get+0x12/0x17
[ 9595.087406]  [<ffffffff81183e6c>] ? get_disk+0x95/0xb4
[ 9595.087411]  [<ffffffff81221e84>] ? kobj_lookup+0x169/0x1a1
[ 9595.087413]  [<ffffffff8118f05b>] ? kobject_get+0x12/0x17
[ 9595.087417]  [<ffffffffa00d0464>] ? sr_block_open+0x86/0x9f [sr_mod]
[ 9595.087420]  [<ffffffff811122d3>] ? __blkdev_get+0xc6/0x342
[ 9595.087423]  [<ffffffff81112556>] ? blkdev_open+0x0/0x96
[ 9595.087426]  [<ffffffff811125bd>] ? blkdev_open+0x67/0x96
[ 9595.087429]  [<ffffffff810ecfae>] ? __dentry_open+0x19d/0x2bf
[ 9595.087432]  [<ffffffff810f87a7>] ? do_filp_open+0x4e4/0x94b
[ 9595.087436]  [<ffffffffa0027ecd>] ? cdrom_release+0x1ae/0x1fe [cdrom]
[ 9595.087439]  [<ffffffff810e4323>] ? get_partial_node+0x15/0x85
[ 9595.087444]  [<ffffffff81097866>] ? rcu_start_gp+0x197/0x1c0
[ 9595.087446]  [<ffffffff810f8c76>] ? getname+0x23/0x1a0
[ 9595.087450]  [<ffffffff811017d9>] ? alloc_fd+0x67/0x10c
[ 9595.087453]  [<ffffffff810ecd3f>] ? do_sys_open+0x55/0xfc
[ 9595.087456]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[ 9595.087458] Code: 83 c3 08 48 83 3b 00 eb ec 48 83 fd 10 0f 86 89 00 00
00 48 89 ef e8 b9 e8 ff ff 48 89 c7 48 8b 00 84                                   
c0 78 13 66 a9 00 c0 75 04 <0f> 0b eb fe 5b 5d 41 5c e9 fc 56 fd ff 48 8b 4c
24 18 4c 8b 4f
[ 9595.087481] RIP  [<ffffffff810e6e5f>] kfree+0x55/0xcb
[ 9595.087484]  RSP <ffff88012e6a5a48>
[ 9595.087486] ---[ end trace 59edb4d61eb57101 ]---




mangoo wrote:
> 
> I just tried how 2.6.33-rc8 works here, and it doesn't like my hardware
> very much.
> 
> If you need more info, let me know.
> 
> [  115.623583] ------------[ cut here ]------------
> [  115.623586] kernel BUG at mm/slub.c:2969!
> [  115.623588] invalid opcode: 0000 [#1] SMP 
> [  115.623590] last sysfs file:
> /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
> [  115.623592] CPU 2 
> [  115.623594] Pid: 1707, comm: hald-addon-stor Not tainted
> 2.6.33-desktop-0.rc8.1mnb #1 DX58SO/        
> [  115.623596] RIP: 0010:[<ffffffff8111dca3>]  [<ffffffff8111dca3>]
> kfree+0x133/0x140
> [  115.623602] RSP: 0018:ffff8802354a3a58  EFLAGS: 00010246
> [  115.623604] RAX: 0200000000100068 RBX: ffffffffa0089318 RCX:
> 0000000000000001
> [  115.623605] RDX: 0000000001000000 RSI: ffffea0007000000 RDI:
> ffff880200000000
> [  115.623606] RBP: ffff8802354a3a78 R08: 0000000000000000 R09:
> 0000000000000000
> [  115.623608] R10: 0000000000000000 R11: ffff880008c55808 R12:
> ffff880200000000
> [  115.623609] R13: ffff880200000000 R14: 0000000000000010 R15:
> 00000000000000dd
> [  115.623611] FS:  00007f9dd5897700(0000) GS:ffff880008c40000(0000)
> knlGS:0000000000000000
> [  115.623613] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  115.623614] CR2: 00007fff3b2fb718 CR3: 000000023543b000 CR4:
> 00000000000006e0
> [  115.623616] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  115.623617] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  115.623619] Process hald-addon-stor (pid: 1707, threadinfo
> ffff8802354a2000, task ffff880235482ce0)
> [  115.623620] Stack:
> [  115.623621]  ffff88023d61ce40 ffff88023d61ce40 ffff88023d61ce70
> ffff880200000000
> [  115.623623] <0> ffff8802354a3b18 ffffffffa0089318 0000000000000001
> 0000000000000000
> [  115.623626] <0> 0000000000000000 ffff8802354a2000 0000000000000000
> 0000000000000001
> [  115.623628] Call Trace:
> [  115.623633]  [<ffffffffa0089318>] sr_media_change+0x138/0x300 [sr_mod]
> [  115.623638]  [<ffffffff813b8d8d>] ? __reacquire_kernel_lock+0x4d/0x80
> [  115.623641]  [<ffffffff812ba820>] media_changed+0x70/0xc0
> [  115.623643]  [<ffffffff812ba8a7>] cdrom_media_changed+0x37/0x40
> [  115.623646]  [<ffffffffa00883e9>] sr_block_media_changed+0x19/0x20
> [sr_mod]
> [  115.623650]  [<ffffffff811564a3>] check_disk_change+0x33/0x70
> [  115.623653]  [<ffffffff812bd4f8>] cdrom_open+0x248/0x600
> [  115.623655]  [<ffffffff811f00fa>] ? kobject_get+0x1a/0x30
> [  115.623658]  [<ffffffff81157dc0>] ? blkdev_open+0x0/0xc0
> [  115.623661]  [<ffffffff811e15fd>] ? get_disk+0x7d/0xf0
> [  115.623663]  [<ffffffff811f00fa>] ? kobject_get+0x1a/0x30
> [  115.623665]  [<ffffffffa00885a9>] sr_block_open+0x79/0xd0 [sr_mod]
> [  115.623669]  [<ffffffff812a3d49>] ? get_device+0x19/0x20
> [  115.623671]  [<ffffffff81157a61>] __blkdev_get+0xa1/0x3e0
> [  115.623673]  [<ffffffff81157dc0>] ? blkdev_open+0x0/0xc0
> [  115.623674]  [<ffffffff81157db0>] blkdev_get+0x10/0x20
> [  115.623676]  [<ffffffff81157e31>] blkdev_open+0x71/0xc0
> [  115.623679]  [<ffffffff811267ea>] __dentry_open+0x10a/0x350
> [  115.623682]  [<ffffffff811b85df>] ? security_inode_permission+0x1f/0x30
> [  115.623685]  [<ffffffff81126b44>] nameidata_to_filp+0x54/0x70
> [  115.623687]  [<ffffffff81136ba0>] do_filp_open+0x950/0xd60
> [  115.623690]  [<ffffffff812a3dc7>] ? put_device+0x17/0x20
> [  115.623696]  [<ffffffffa012d124>] ? scsi_device_put+0x44/0x60
> [scsi_mod]
> [  115.623699]  [<ffffffff811414a3>] ? alloc_fd+0x53/0x140
> [  115.623701]  [<ffffffff81126599>] do_sys_open+0x69/0x140
> [  115.623703]  [<ffffffff811266b0>] sys_open+0x20/0x30
> [  115.623706]  [<ffffffff8100a002>] system_call_fastpath+0x16/0x1b
> [  115.623707] Code: c4 c7 57 00 4d 85 ed 0f 84 1b ff ff ff 49 8b 45 00 49
> 83 c5 08 4c 89 e6 48 89 df ff d0 49 8b 45 00 48 85 c0 75 eb e9 fd fe ff ff
> <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f 44 00 
> [  115.623725] RIP  [<ffffffff8111dca3>] kfree+0x133/0x140
> [  115.623728]  RSP <ffff8802354a3a58>
> [  115.623730] ---[ end trace 638cfe9483a8fb12 ]---
> 
> 
> 
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://old.nabble.com/-2.6.33-rc8--kernel-BUG-at-mm-slub.c%3A2969%21-tp27693913p30426415.html
Sent from the linux-kernel mailing list archive at Nabble.com.

