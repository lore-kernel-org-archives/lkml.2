Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab0KCXSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:18:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44455 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0KCXSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:18:12 -0400
Date: Wed, 3 Nov 2010 16:16:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, axboe@kernel.dk
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
Message-Id: <20101103161638.ddc75ace.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[  303.127418] calling  floppy_module_init+0x0/0x93 [floppy] @ 5726
[  303.134577] ------------[ cut here ]------------
[  303.139329] WARNING: at /local/linsrc/lnx-2637-rc1/lib/list_debug.c:26 __list_add+0x4d/0xa5()
[  303.148248] Hardware name: OptiPlex GX620               
[  303.153682] list_add corruption. next->prev should be prev (ffffffff81ae5e50), but was 6b6b6b6b6b6b6b6b. (next=ffff88006c908590).
[  303.165678] Modules linked in: floppy(+) ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ppdev ac97_bus snd_seq snd_seq_device led_class snd_pcm iTCO_wdt snd_timer usbmouse iTCO_vendor_support usbkbd snd usbhid tg3 hid sg dcdbas sr_mod soundcore rtc_cmos pcspkr i2c_i801 cdrom parport_pc rng_core evdev snd_page_alloc shpchp rtc_core parport rtc_lib mac_hid pci_hotplug 8250_pnp unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class!
  ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[  303.269866] Pid: 5726, comm: modprobe Not tainted 2.6.37-rc1 #10
[  303.275973] Call Trace:
[  303.278775]  [<ffffffff8107e1ed>] warn_slowpath_common+0xc6/0xf3
Nov  3 16:13:19 [  303.284885]  [<ffffffff812d3582>] ? __percpu_counter_init+0x9e/0xdf
control kernel: [  303.292959]  [<ffffffff8107e30a>] warn_slowpath_fmt+0x5b/0x6b
[  303.127418] c[  303.299754]  [<ffffffff812cf38b>] __list_add+0x4d/0xa5
alling  floppy_m[  303.306249]  [<ffffffff812d359f>] __percpu_counter_init+0xbb/0xdf
odule_init+0x0/0[  303.314093]  [<ffffffff8117c577>] bdi_init+0x13f/0x1c2
x93 [floppy] @ 5[  303.320270]  [<ffffffffa0bdb3bb>] ? do_fd_request+0x0/0x111 [floppy]
726
Nov  3 16:13[  303.328429]  [<ffffffffa0bdb3bb>] ? do_fd_request+0x0/0x111 [floppy]
:19 control kern[  303.335791]  [<ffffffff812a7444>] blk_alloc_queue_node+0x8f/0x220
el: [  303.13457[  303.343257]  [<ffffffff812a773b>] blk_init_queue_node+0x30/0x90
7] ------------[[  303.350874]  [<ffffffff812a77b3>] blk_init_queue+0x18/0x21
 cut here ]-----[  303.357447]  [<ffffffffa0bf29da>] floppy_init+0x95/0x7c0 [floppy]
-------
Nov  3 1[  303.365279]  [<ffffffff81017b19>] ? read_tsc+0x17/0x29
6:13:19 control [  303.371436]  [<ffffffffa0bf3105>] ? floppy_module_init+0x0/0x93 [floppy]
kernel: [  303.1[  303.379517]  [<ffffffffa0bf318d>] floppy_module_init+0x88/0x93 [floppy]
39329] WARNING: [  303.387890]  [<ffffffffa0bf3105>] ? floppy_module_init+0x0/0x93 [floppy]
at /local/linsrc[  303.395650]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1ef
/lnx-2637-rc1/li[  303.403068]  [<ffffffff810d52f3>] sys_init_module+0xe1/0x2a5
b/list_debug.c:2[  303.409709]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
6 __list_add+0x4Nov  3 16:13:19 control kernel: [  303.419712] ---[ end trace e26c2a9ce976be75 ]---
cd usbcore nls_base i915 drm_kms_helper intel_ag[  303.429812] Floppy drive(s):p button intel_g fd0 is 1.44Mtt video thermal
_sys hwmon output [last unloaded: mperf]
Nov  3 16:13:19 control kernel: [  303.269866] Pid: 5726, comm: modprobe Not tainted 2.6.37-rc1 #10
Nov  3 16:13:19 control kernel: [  303.275973] Call Trace:
Nov  3 16:13:19 control kernel: [  303.278775]  [<ffffffff8107e1ed>] warn_slowpath_common+0xc6/0xf3
Nov  3 16:13:19 control kernel: [  3

[  306.480304] floppy0: no floppy controllers found
Nov  3 16:13:22 [  306.488160] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[  306.492030] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1.3/devnum
[  306.492030] CPU 0 
[  306.492030] Modules linked in: floppy(+) ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ppdev ac97_bus snd_seq snd_seq_device led_class snd_pcm iTCO_wdt snd_timer usbmouse iTCO_vendor_support usbkbd snd usbhid tg3 hid sg dcdbas sr_mod soundcore rtc_cmos pcspkr i2c_i801 cdrom parport_pc rng_core evdev snd_page_alloc shpchp rtc_core parport rtc_lib mac_hid pci_hotplug 8250_pnp unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class!
  ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[  306.626211] 
[  306.626211] Pid: 5726, comm: modprobe Tainted: G        W   2.6.37-rc1 #10 0HH807/OptiPlex GX620               
[  306.626211] RIP: 0010:[<ffffffff810c309f>]  [<ffffffff810c309f>] __lock_acquire+0xd8/0x4e8
[  306.626211] RSP: 0018:ffff88006d38dd48  EFLAGS: 00010002
[  306.626211] RAX: 0000000000000006 RBX: 6b6b6b6b6b6b6d13 RCX: 0000000000000000
[  306.626211] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6d13
[  306.626211] RBP: ffff88006d38dda8 R08: 0000000000000001 R09: 0000000000000001
[  306.626211] R10: ffffffff81812d48 R11: ffff88006d38de78 R12: 0000000000000000
[  306.626211] R13: ffff88006cb13000 R14: 0000000000000000 R15: 0000000000000000
[  306.626211] FS:  00007f248ff436f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[  306.626211] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  306.626211] CR2: 000000000064b000 CR3: 000000006c976000 CR4: 00000000000006f0
[  306.626211] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  306.626211] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  306.626211] Process modprobe (pid: 5726, threadinfo ffff88006d38c000, task ffff88006cb13000)
[  306.626211] Stack:
[  306.783845]  0000000000000202 ffffffff812b10c2 ffff88006d38dd88 ffffffff811b2af3
[  306.787082]  ffff88006d24ca88 000000006d24ca88 ffff88006d38dd88 0000000000000000
[  306.787082]  ffff88006cb13000 ffffffff81092650 0000000000000001 0000000000000000
[  306.787082] Call Trace:
[  306.787082]  [<ffffffff812b10c2>] ? disk_release+0x97/0xa3
[  306.787082]  [<ffffffff811b2af3>] ? __slab_free+0x1b9/0x1d6
[  306.787082]  [<ffffffff81092650>] ? del_timer_sync+0x50/0x15c
[  306.787082]  [<ffffffff810c35af>] lock_acquire+0x100/0x150
[  306.787082]  [<ffffffff81092650>] ? del_timer_sync+0x50/0x15c
[  306.787082]  [<ffffffff81092694>] del_timer_sync+0x94/0x15c
[  306.874354]  [<ffffffff81092650>] ? del_timer_sync+0x50/0x15c
[  306.874354]  [<ffffffff812a763f>] blk_sync_queue+0x24/0x55
[  306.874354]  [<ffffffff812a7692>] blk_cleanup_queue+0x22/0x9b
[  306.874354]  [<ffffffffa0bf30e1>] floppy_init+0x79c/0x7c0 [floppy]
[  306.874354]  [<ffffffff81017b19>] ? read_tsc+0x17/0x29
[  306.874354]  [<ffffffffa0bf3105>] ? floppy_module_init+0x0/0x93 [floppy]
[  306.874354]  [<ffffffffa0bf318d>] floppy_module_init+0x88/0x93 [floppy]
[  306.874354]  [<ffffffffa0bf3105>] ? floppy_module_init+0x0/0x93 [floppy]
[  306.940576]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1ef
[  306.943732]  [<ffffffff810d52f3>] sys_init_module+0xe1/0x2a5
[  306.943732]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[  306.943732] Code: 05 4f 15 72 01 e8 9c b1 fb ff 48 ff 05 4b 15 72 01 48 ff 05 4c 15 72 01 48 ff 05 55 15 72 01 e9 e3 03 00 00 48 ff 05 41 15 72 01 <48> 81 3b 40 34 0b 82 75 07 48 ff 05 41 15 72 01 83 fe 01 77 13 
[  306.982675] RIP  [<ffffffff810c309f>] __lock_acquire+0xd8/0x4e8
[  306.982675]  RSP <ffff88006d38dd48>
[  306.982675] ---[ end trace e26c2a9ce976be76 ]---
Nov  3 16:13:22 control kernel: Nov  3 16:13:22 Nov  3 16:13:22 control kernel: [  306.492030] CPU 0 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
