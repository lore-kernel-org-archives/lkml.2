Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2DNLJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:09:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:57267 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2DNLJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:09:14 -0400
Message-ID: <1333973547.1367.3.camel@localhost.localdomain>
Subject: [iwlwifi] 3.3.1 - BUG: unable to handle kernel NULL pointer
 dereference
From: Thomas Meyer <thomas@m3y3r.de>
To: ilw@linux.intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Apr 2012 14:12:27 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abrt_version:   2.0.7
cmdline:        BOOT_IMAGE=/vmlinuz-3.3.1 root=/dev/sda2 rootfstype=ext4 rootflags=data=writeback ro quiet rhgb
comment:        rmmod iwlwifi && modprobe iwlwifi
kernel:         3.3.1
reason:         BUG: unable to handle kernel NULL pointer dereference at           (null)
time:           Mo 09 Apr 2012 14:08:10 CEST

backtrace:
:BUG: unable to handle kernel NULL pointer dereference at           (null)
:IP: [<ffffffffa0376c05>] iwl_calib_free_results+0x15/0x70 [iwlwifi]
:PGD 13370d067 PUD 11c29f067 PMD 0 
:Oops: 0000 [#1] 
:CPU 0 
:Modules linked in: iwlwifi(+) vfat fat snd_usb_audio snd_usbmidi_lib snd_rawmidi sctp fuse nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6table_filter ip6_tables btusb arc4 uvcvideo videobuf2_core videodev v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops usb_storage bluetooth acer_wmi mac80211 cfg80211 acerhdf sparse_keymap pcspkr snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc rfkill atl1c wmi joydev virtio_net virtio virtio_ring kvm_intel kvm uinput ipv6 [last unloaded: iwlwifi]
:Pid: 9629, comm: modprobe Tainted: G        W    3.3.1 #3 Acer Aspire 1810T/JM11-MS
:RIP: 0010:[<ffffffffa0376c05>]  [<ffffffffa0376c05>] iwl_calib_free_results+0x15/0x70 [iwlwifi]
:RSP: 0018:ffff88011373bb98  EFLAGS: 00010296
:RAX: ffffffffa038c6c0 RBX: ffff880133748000 RCX: 0000000000000005
:RDX: 0000000000000000 RSI: 0000000000089dc1 RDI: ffff880133748000
:RBP: ffff88011373bba8 R08: 0000000000000000 R09: 0000000000000000
:R10: 000000000000000a R11: 0000000000000000 R12: ffff8801337480b0
:R13: 00000000fffffffe R14: ffffffffa038c6c0 R15: ffff880133750500
:FS:  0000000000000000(0000) GS:ffffffff81648000(0063) knlGS:00000000f77d46c0
:CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
:CR2: 0000000000000000 CR3: 000000011e20e000 CR4: 00000000000406f0
:DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
:DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
:Process modprobe (pid: 9629, threadinfo ffff88011373a000, task ffff88001e449290)
:Stack:
: ffff880133748000 00000000ffffffff ffff88011373bbe8 ffffffffa03851b5
: ffffffffa038c6c0 ffff880133751b40 ffff880133748000 ffff880133751b40
: 00000000ffffffff 00000000fffffffe ffff88011373bc28 ffffffffa036c24f
:Call Trace:
: [<ffffffffa03851b5>] iwl_trans_pcie_free+0x15/0x1b0 [iwlwifi]
: [<ffffffffa036c24f>] iwl_probe+0x1df/0x910 [iwlwifi]
: [<ffffffffa0383c60>] iwl_pci_probe+0x2a0/0x380 [iwlwifi]
: [<ffffffff8120160f>] pci_device_probe+0xaf/0x130
: [<ffffffff812f66b4>] driver_probe_device+0x74/0x1a0
: [<ffffffff812f687b>] __driver_attach+0x9b/0xa0
: [<ffffffff812f67e0>] ? driver_probe_device+0x1a0/0x1a0
: [<ffffffff812f4f8e>] bus_for_each_dev+0x4e/0x80
: [<ffffffff812f6389>] driver_attach+0x19/0x20
: [<ffffffff812f6010>] bus_add_driver+0x1a0/0x270
: [<ffffffffa039c000>] ? 0xffffffffa039bfff
: [<ffffffff812f6d81>] driver_register+0x71/0x140
: [<ffffffff810cd4c7>] ? kmem_cache_alloc+0x97/0xc0
: [<ffffffffa039c000>] ? 0xffffffffa039bfff
: [<ffffffff81201397>] __pci_register_driver+0x47/0xc0
: [<ffffffffa01e5137>] ? ieee80211_rate_control_register+0xd7/0x110 [mac80211]
: [<ffffffffa0383de3>] iwl_pci_register_driver+0x23/0x50 [iwlwifi]
: [<ffffffffa039c045>] iwl_init+0x45/0x1000 [iwlwifi]
: [<ffffffff810001c9>] do_one_initcall+0x39/0x160
: [<ffffffff81068fd2>] sys_init_module+0x3a2/0x1bb0
: [<ffffffff8149d40e>] sysenter_dispatch+0x7/0x1a
:Code: 5b 31 c0 41 5c 41 5d 41 5e 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 53 4c 8d a7 b0 00 00 00 48 8b 97 b0 00 00 00 <48> 8b 02 4c 39 e2 48 89 d7 48 89 c3 75 0b eb 3c 0f 1f 00 48 89 
:RIP  [<ffffffffa0376c05>] iwl_calib_free_results+0x15/0x70 [iwlwifi]
: RSP <ffff88011373bb98>

END:

