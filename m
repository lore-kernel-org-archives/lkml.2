Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab0KDTuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:50:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60508 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0KDTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:50:48 -0400
Date: Thu, 4 Nov 2010 12:49:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <minyard@acm.org>, openipmi-developer@lists.sourceforge.net
Subject: ipmi module(s) load fault (2.6.37-rc1)
Message-Id: <20101104124957.0631003c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[  228.457676] calling  ipmi_init_msghandler_mod+0x0/0x1b [ipmi_msghandler] @ 4896
[  228.465489] ipmi message handler version 39.2
Nov  4 09:20:02 [  228.470962] initcall ipmi_init_msghandler_mod+0x0/0x1b [ipmi_msghandler] returned 0 after 5617 usecs
control kernel: Nov  4 09:20:02 [  228.518378] calling  init_ipmi_si+0x0/0x4cd [ipmi_si] @ 4896
[  228.524442] IPMI System Interface driver.
[  228.529502] ipmi_si: Adding default-specified kcs state machine
[  228.535545] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[  228.545718] ipmi_si: Interface detection failed
Nov  4 09:20:02 control kernel: [  228.518378] calling  init_ipmi_si+0x0/0x4cd [ipmi_si] @ 4896
Nov  4 09:20:02 control kernel: [  228.524442] IPMI System Interface driver.
Nov  4 09:20:02 control kernel: [  228.529502] ipmi_si: Adding default-specified kcs state machine
Nov  4 09:20:02 control kernel: [  228.535545] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq [  228.587064] ipmi_si: Adding default-specified smic state machine
[  228.594378] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
Nov  4 09:20:02 [  228.604666] ipmi_si: Interface detection failed
control kernel: [  228.587064] ipmi_si: Adding default-specified smic state machine
Nov  4 09:20:02 Nov  4 09:20:02 control kernel: [  228.628232] ipmi_si: Adding default-specified bt state machine
[  228.634248] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[  228.644310] ipmi_si: Interface detection failed
Nov  4 09:20:02 control kernel: [  228.628232] ipmi_si: Adding default-specified bt state machine
Nov  4 09:20:02 control kernel[  228.662073] ipmi_si: Unable to find any System Interface(s)
[  228.667893] initcall init_ipmi_si+0x0/0x4cd [ipmi_si] returned -19 after 140310 usecs
Nov  4 09:20:02 control kernel: [  228.662073] ipmi_si: Unable to find any System Interface(s)
N
[  230.770048] calling  init_ipmi_si+0x0/0x4cd [ipmi_si] @ 4937
[  230.776143] IPMI System Interface driver.
Nov  4 09:20:04 [  230.780979] BUG: unable to handle kernel paging request at ffffffffa0bfb690
[  230.784231] IP: [<ffffffff813f46c9>] put_driver+0x10/0x22
[  230.784231] PGD 1a18067 PUD 1a1c063 PMD 6ef68067 PTE 0
[  230.78Nov  4 09:20:044231] Oopcontrol kernel:s: 0000 [#1] [  230.776143] IPMI System Interface driver.
SMP DEBUG_PAGEALLOC
[  230.784231] last sysfs file: /sys/module/ipmi_msghandler/initstate
[  230.784231] CPU 0 
[  230.784231] Modules linked in: ipmi_si(+) ipmi_msghandler ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetooth rfkill sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ac97_bus ppdev snd_seq snd_seq_device usbkbd snd_pcm led_class usbmouse snd_timer usbhid iTCO_wdt hid tg3 sr_mod snd sg iTCO_vendor_support cdrom dcdbas i2c_i801 pcspkr soundcore rtc_cmos parport_pc rng_core snd_page_alloc rtc_core shpchp evdev rtc_lib parport 8250_pnp pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_co!
 re firmware_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[  230.784231] 
[  230.784231] Pid: 4937, comm: modprobe Not tainted 2.6.37-rc1 #12 0HH807/OptiPlex GX620               
[  230.784231] RIP: 0010:[<ffffffff813f46c9>]  [<ffffffff813f46c9>] put_driver+0x10/0x22
[  230.784231] RSP: 0018:ffff88006c631e98  EFLAGS: 00010202
[  230.784231] RAX: ffffffffa0bfb630 RBX: ffffffffa0c14630 RCX: ffff88007c617d60
[  230.784231] RDX: 00000000000d000c RSI: 00000035bb9dd0b6 RDI: ffffffffa0bfb630
[  230.784231] RBP: ffff88006c631e98 R08: 0000000000000000 R09: 0000000000000000
[  230.784231] R10: 0000000000000000 R11: ffffffff812babff R12: ffffffffa0c10794
[  230.784231] R13: 0000000000000000 R14: 00000035bb509239 R15: 0000000000000000
[  230.784231] FS:  00007fd54c3f96f0(0000) GS:ffff88007c600000(0000) knlGS:0000000000000000
[  230.784231] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  230.784231] CR2: ffffffffa0bfb690 CR3: 000000006c6dc000 CR4: 00000000000006f0
[  230.784231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  230.784231] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  230.784231] Process modprobe (pid: 4937, threadinfo ffff88006c630000, task ffff88006ed83000)
[  230.784231] Stack:
[  230.784231]  ffff88006c631ec8 ffffffff813f479b 0000000000000000 ffffffffa0c10794
[  230.784231]  0000000000000000 00000035bb509239 ffff88006c631ed8 ffffffff81378d31
[  230.784231]  ffff88006c631f18 ffffffffa0c10938 ffff88006c631f18 ffffffff810b5e5e
[  230.784231] Call Trace:
[  230.784231]  [<ffffffff813f479b>] driver_register+0xc0/0x1b2
[  230.784231]  [<ffffffffa0c10794>] ? init_ipmi_si+0x0/0x4cd [ipmi_si]
[  230.784231]  [<ffffffff81378d31>] pnp_register_driver+0x28/0x31
[  230.784231]  [<ffffffffa0c10938>] init_ipmi_si+0x1a4/0x4cd [ipmi_si]
[  230.784231]  [<ffffffff810b5e5e>] ? ktime_get+0x88/0xde
[  230.784231]  [<ffffffffa0c10794>] ? init_ipmi_si+0x0/0x4cd [ipmi_si]
[  230.784231]  [<ffffffff810020a6>] do_one_initcall+0x6c/0x1ef
[  230.784231]  [<ffffffff810d529f>] sys_init_module+0xe1/0x2a5
[  230.784231]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[  230.784231] Code: 85 f6 75 d9 48 89 df e8 72 de ff ff 48 ff 05 d7 64 66 01 58 5b 41 5c 41 5d c9 c3 55 48 89 e5 0f 1f 44 00 00 48 ff 05 c7 64 66 01 <48> 8b 7f 60 e8 7a 6a ec ff 48 ff 05 bf 64 66 01 c9 c3 55 48 89 
[  230.784231] RIP  [<ffffffff813f46c9>] put_driver+0x10/0x22
[  230.784231]  RSP <ffff88006c631e98>
[  230.784231] CR2: ffffffffa0bfb690
[  230.784231] ---[ end trace 6a1684b9c1fe5ba3 ]---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
