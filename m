Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2GAWvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 18:51:47 -0400
Received: from delay-2d.bbox.fr ([194.158.122.62]:51373 "EHLO delay-2d.bbox.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2GAWvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 18:51:45 -0400
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2012 18:51:45 EDT
Message-ID: <1341181567.8112.8.camel@k2000.jpp.fr>
Subject: Crash with BTRFS disk needing fcsk
From: JP P <jp.pozzi@bbox.fr>
Reply-To: jp.pozzi@izzop.net
To: linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 00:26:07 +0200
Content-Type: multipart/mixed; boundary="=-pfFYrY1pUUjlIJiB2fdU"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pfFYrY1pUUjlIJiB2fdU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

I get some crash with my system:
CPU :	AMD905e
RAM : 	16GB
Mother card MSI MS-7577/790FX-GD70(MS-7577) 
Kernel :	3.4.4	self compiled, the command line is :
22:21:53 k2000 kernel: [    0.000000] Linux version 3.4.4 (jpp@k2000)
(gcc version 4.7.1 (Debian 4.7.1-2) ) #1 SMP Thu Jun 28 00:58:21 CEST
2012
Jul  1 22:21:53 k2000 kernel: [    0.000000] Command line:
BOOT_IMAGE=/vmlinuz-3.4.4 root=/dev/sda2 ro transparent_hugepage=always



I get two or three crashes and eery time the main BTRFS file system
wihch I am using as HOME get carshed and needs repair.
For the last crash, a short time ago, I get some kernel traces which are
joined to this mail.

Regards

JP P



--=-pfFYrY1pUUjlIJiB2fdU
Content-Disposition: attachment; filename="err_2012_07_01_01.txt"
Content-Type: text/plain; name="err_2012_07_01_01.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

22:21:53 k2000 kernel: [    0.000000] Linux version 3.4.4 (jpp@k2000) (gcc version 4.7.1 (Debian 4.7.1-2) ) #1 SMP Thu Jun 28 00:58:21 CEST 2012
Jul  1 22:21:53 k2000 kernel: [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.4.4 root=/dev/sda2 ro transparent_hugepage=always

...........


Jul  1 23:38:05 k2000 kernel: [  108.220923] ------------[ cut here ]------------
Jul  1 23:38:05 k2000 kernel: [  108.221829] WARNING: at fs/btrfs/free-space-cache.c:1887 btrfs_remove_free_space+0x311/0x330 [btrfs]()
Jul  1 23:38:05 k2000 kernel: [  108.222713] Hardware name: MS-7577
Jul  1 23:38:05 k2000 kernel: [  108.223615] Modules linked in: ext4 jbd2 loop firewire_sbp2 kvm_amd kvm snd_hda_codec_realtek bridge stp llc psmouse serio_raw joydev evdev edac_mce_amd i2c_piix4 edac_core k10temp pcspkr powernow_k8 mperf snd_hda_intel snd_hda_codec nouveau video mxm_wmi ttm drm_kms_helper power_supply wmi processor button btrfs zlib_deflate thermal fan thermal_sys ata_generic usbhid hid ohci_hcd pata_atiixp sd_mod ehci_hcd firewire_ohci usbcore usb_common firewire_core crc_itu_t pata_jmicron pata_marvell [last unloaded: scsi_wait_scan]
Jul  1 23:38:05 k2000 kernel: [  108.226694] Pid: 2773, comm: mount Not tainted 3.4.4 #1
Jul  1 23:38:05 k2000 kernel: [  108.227667] Call Trace:
Jul  1 23:38:05 k2000 kernel: [  108.228644]  [<ffffffff8103449a>] warn_slowpath_common+0x7a/0xb0
Jul  1 23:38:05 k2000 kernel: [  108.229610]  [<ffffffff810344e5>] warn_slowpath_null+0x15/0x20
Jul  1 23:38:05 k2000 kernel: [  108.230585]  [<ffffffffa01aeb51>] btrfs_remove_free_space+0x311/0x330 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.231560]  [<ffffffff81053fc0>] ? abort_exclusive_wait+0xb0/0xb0
Jul  1 23:38:05 k2000 kernel: [  108.232548]  [<ffffffffa0161ea7>] btrfs_alloc_logged_file_extent+0x1b7/0x1d0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.233530]  [<ffffffffa014f9f5>] ? btrfs_free_path+0x25/0x30 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.234526]  [<ffffffffa01a97fe>] replay_one_extent+0x5ae/0x610 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.235510]  [<ffffffff8111fafd>] ? iput+0xfd/0x200
Jul  1 23:38:05 k2000 kernel: [  108.236529]  [<ffffffffa01969db>] ? read_extent_buffer+0xbb/0x110 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.237533]  [<ffffffffa01aa02b>] replay_one_buffer+0x26b/0x340 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.238534]  [<ffffffffa019549d>] ? alloc_extent_buffer+0x8d/0x510 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.239549]  [<ffffffffa01a7992>] walk_down_log_tree+0x1f2/0x3b0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.240569]  [<ffffffffa01a7be5>] walk_log_tree+0x95/0x1e0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.241569]  [<ffffffffa01aba7b>] btrfs_recover_log_trees+0x20b/0x390 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.242574]  [<ffffffffa01a9dc0>] ? replay_one_dir_item+0xe0/0xe0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.243587]  [<ffffffffa016f78d>] open_ctree+0x14dd/0x1ab0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.244586]  [<ffffffff811cfb2a>] ? disk_name+0xaa/0xb0
Jul  1 23:38:05 k2000 kernel: [  108.245595]  [<ffffffffa014d6de>] btrfs_mount+0x5be/0x690 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.246600]  [<ffffffff810dd7fb>] ? pcpu_alloc+0x86b/0x970
Jul  1 23:38:05 k2000 kernel: [  108.247617]  [<ffffffff8110a61b>] mount_fs+0x1b/0xd0
Jul  1 23:38:05 k2000 kernel: [  108.248626]  [<ffffffff81122e47>] vfs_kern_mount+0x67/0xf0
Jul  1 23:38:05 k2000 kernel: [  108.249636]  [<ffffffff811232cf>] do_kern_mount+0x4f/0x100
Jul  1 23:38:05 k2000 kernel: [  108.250647]  [<ffffffff81124b9e>] do_mount+0x2ee/0x850
Jul  1 23:38:05 k2000 kernel: [  108.251673]  [<ffffffff810d86a3>] ? strndup_user+0x53/0x70
Jul  1 23:38:05 k2000 kernel: [  108.251680]  [<ffffffff81125228>] sys_mount+0x88/0xd0
Jul  1 23:38:05 k2000 kernel: [  108.251689]  [<ffffffff814495a2>] system_call_fastpath+0x16/0x1b
Jul  1 23:38:05 k2000 kernel: [  108.251696] ---[ end trace c8c4e52dd49965c4 ]---
Jul  1 23:38:05 k2000 kernel: [  108.251750] ------------[ cut here ]------------
Jul  1 23:38:05 k2000 kernel: [  108.251757] kernel BUG at fs/btrfs/extent-tree.c:6107!
Jul  1 23:38:05 k2000 kernel: [  108.251763] invalid opcode: 0000 [#1] SMP 
Jul  1 23:38:05 k2000 kernel: [  108.251768] CPU 0 
Jul  1 23:38:05 k2000 kernel: [  108.251771] Modules linked in: ext4 jbd2 loop firewire_sbp2 kvm_amd kvm snd_hda_codec_realtek bridge stp llc psmouse serio_raw joydev evdev edac_mce_amd i2c_piix4 edac_core k10temp pcspkr powernow_k8 mperf snd_hda_intel snd_hda_codec nouveau video mxm_wmi ttm drm_kms_helper power_supply wmi processor button btrfs zlib_deflate thermal fan thermal_sys ata_generic usbhid hid ohci_hcd pata_atiixp sd_mod ehci_hcd firewire_ohci usbcore usb_common firewire_core crc_itu_t pata_jmicron pata_marvell [last unloaded: scsi_wait_scan]
Jul  1 23:38:05 k2000 kernel: [  108.251823] 
Jul  1 23:38:05 k2000 kernel: [  108.251828] Pid: 2773, comm: mount Tainted: G        W    3.4.4 #1 MICRO-STAR INTERNATIONAL CO.,LTD MS-7577/790FX-GD70(MS-7577)
Jul  1 23:38:05 k2000 kernel: [  108.251838] RIP: 0010:[<ffffffffa0161eaf>]  [<ffffffffa0161eaf>] btrfs_alloc_logged_file_extent+0x1bf/0x1d0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.251887] RSP: 0018:ffff880433439778  EFLAGS: 00010282
Jul  1 23:38:05 k2000 kernel: [  108.251892] RAX: 00000000ffffffea RBX: ffff880434249b00 RCX: 00000000000000a5
Jul  1 23:38:05 k2000 kernel: [  108.251896] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000009
Jul  1 23:38:05 k2000 kernel: [  108.251900] RBP: ffff8804334397f8 R08: 000000000000000a R09: 0000000000000000
Jul  1 23:38:05 k2000 kernel: [  108.251904] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8804334398b3
Jul  1 23:38:05 k2000 kernel: [  108.251909] R13: 0000000000000000 R14: 00000002772a2000 R15: ffff8804335e3c00
Jul  1 23:38:05 k2000 kernel: [  108.251914] FS:  00007f84716527e0(0000) GS:ffff880447c00000(0000) knlGS:0000000000000000
Jul  1 23:38:05 k2000 kernel: [  108.251919] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul  1 23:38:05 k2000 kernel: [  108.251923] CR2: 000000000061c500 CR3: 00000004330f6000 CR4: 00000000000007f0
Jul  1 23:38:05 k2000 kernel: [  108.251927] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  1 23:38:05 k2000 kernel: [  108.251931] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  1 23:38:05 k2000 kernel: [  108.251937] Process mount (pid: 2773, threadinfo ffff880433438000, task ffff880431910000)
Jul  1 23:38:05 k2000 kernel: [  108.251940] Stack:
Jul  1 23:38:05 k2000 kernel: [  108.251943]  0000000000000001 000000000001c000 ffff8804334397a8 ffffffffa014f9f5
Jul  1 23:38:05 k2000 kernel: [  108.251949]  0000000000000000 000000000014fd55 0000000000000005 ffff88042244d000
Jul  1 23:38:05 k2000 kernel: [  108.251955]  000000000001c000 00ff8804316ca810 a800000002772a20 ffff8804335e3c00
Jul  1 23:38:05 k2000 kernel: [  108.251961] Call Trace:
Jul  1 23:38:05 k2000 kernel: [  108.251985]  [<ffffffffa014f9f5>] ? btrfs_free_path+0x25/0x30 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252014]  [<ffffffffa01a97fe>] replay_one_extent+0x5ae/0x610 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252024]  [<ffffffff8111fafd>] ? iput+0xfd/0x200
Jul  1 23:38:05 k2000 kernel: [  108.252053]  [<ffffffffa01969db>] ? read_extent_buffer+0xbb/0x110 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252080]  [<ffffffffa01aa02b>] replay_one_buffer+0x26b/0x340 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252107]  [<ffffffffa019549d>] ? alloc_extent_buffer+0x8d/0x510 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252134]  [<ffffffffa01a7992>] walk_down_log_tree+0x1f2/0x3b0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252160]  [<ffffffffa01a7be5>] walk_log_tree+0x95/0x1e0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252187]  [<ffffffffa01aba7b>] btrfs_recover_log_trees+0x20b/0x390 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252213]  [<ffffffffa01a9dc0>] ? replay_one_dir_item+0xe0/0xe0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252241]  [<ffffffffa016f78d>] open_ctree+0x14dd/0x1ab0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252251]  [<ffffffff811cfb2a>] ? disk_name+0xaa/0xb0
Jul  1 23:38:05 k2000 kernel: [  108.252272]  [<ffffffffa014d6de>] btrfs_mount+0x5be/0x690 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252281]  [<ffffffff810dd7fb>] ? pcpu_alloc+0x86b/0x970
Jul  1 23:38:05 k2000 kernel: [  108.252290]  [<ffffffff8110a61b>] mount_fs+0x1b/0xd0
Jul  1 23:38:05 k2000 kernel: [  108.252298]  [<ffffffff81122e47>] vfs_kern_mount+0x67/0xf0
Jul  1 23:38:05 k2000 kernel: [  108.252305]  [<ffffffff811232cf>] do_kern_mount+0x4f/0x100
Jul  1 23:38:05 k2000 kernel: [  108.252312]  [<ffffffff81124b9e>] do_mount+0x2ee/0x850
Jul  1 23:38:05 k2000 kernel: [  108.252318]  [<ffffffff810d86a3>] ? strndup_user+0x53/0x70
Jul  1 23:38:05 k2000 kernel: [  108.252324]  [<ffffffff81125228>] sys_mount+0x88/0xd0
Jul  1 23:38:05 k2000 kernel: [  108.252332]  [<ffffffff814495a2>] system_call_fastpath+0x16/0x1b
Jul  1 23:38:05 k2000 kernel: [  108.252335] Code: 0b 0f 1f 00 48 8d bb 80 00 00 00 e8 3c 69 ff ff 85 c0 74 1d 48 8b 55 c0 4c 89 f6 48 89 df e8 99 c9 04 00 85 c0 0f 84 2c ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 1f 80 00 00 00 00 55 48 89 e5 
Jul  1 23:38:05 k2000 kernel: [  108.252377] RIP  [<ffffffffa0161eaf>] btrfs_alloc_logged_file_extent+0x1bf/0x1d0 [btrfs]
Jul  1 23:38:05 k2000 kernel: [  108.252401]  RSP <ffff880433439778>
Jul  1 23:38:05 k2000 kernel: [  108.252406] ---[ end trace c8c4e52dd49965c5 ]---


--=-pfFYrY1pUUjlIJiB2fdU--

