Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0KCVJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:09:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62758 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0KCVJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:09:36 -0400
Date: Wed, 3 Nov 2010 14:08:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Miller <mike.miller@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        iss_storagedev@hp.com
Subject: Re: Linux 2.6.37-rc1 (cciss: remove_proc_entry warning)
Message-Id: <20101103140852.30b285d4.randy.dunlap@oracle.com>
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



[  109.073624] ------------[ cut here ]------------
[  109.078814] WARNING: at /local/linsrc/lnx-2637-rc1/fs/proc/generic.c:816 remove_proc_entry+0x156/0x35e()
Nov  3 12:58:45 [  109.088567] Hardware name: OptiPlex GX620               
control kernel: [  109.095824] name 'driver/cciss'
[  109.073624] -[  109.100141] Modules linked in:-----------[ cut cciss(-) here ]--------- ipt_MASQUERADE---
Nov  3 12:58 iptable_nat:45 control kern nf_natel: [  109.07881 af_packet4] WARNING: at / nfsdlocal/linsrc/lnx lockd-2637-rc1/fs/pro nfs_aclc/generic.c:816  auth_rpcgssremove_proc_entr exportfsy+0x156/0x35e()
 scoNov  3 12:58:45  bridgecontrol kernel:  stp[  109.088567] H llcardware name: Op bneptiPlex GX620     l2cap           
Nov  crc16 3 12:58:45 cont bluetoothrol kernel: [  1 rfkill09.095824] name  sunrpc'driver/cciss'
 ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 p4_clockmod freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput joydev mousedev ppdev snd_intel8x0 snd_ac97_codec usbkbd ac97_bus snd_seq usbmouse snd_seq_device usbhid snd_pcm led_class hid snd_timer iTCO_wdt tg3 dcdbas iTCO_vendor_support snd sr_mod i2c_i801 sg pcspkr rtc_cmos parport_pc cdrom rtc_core evdev shpchp soundcore rng_core rtc_lib parport 8250_pnp snd_page_alloc pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[  109.164277] Pid: 3463, comm: rmmod Not tainted 2.6.37-rc1 #7
[  109.164280] Call Trace:
[  109.164292]  [<ffffffff8107eb8d>] warn_slowpath_common+0xc6/0xf3
[  109.164299]  [<ffffffff8107ecaa>] warn_slowpath_fmt+0x5b/0x6b
[  109.164307]  [<ffffffff8155175b>] ? _raw_spin_unlock+0x40/0x4b
[  109.164313]  [<ffffffff8123dd1e>] remove_proc_entry+0x156/0x35e
[  109.164320]  [<ffffffff812cd91b>] ? do_raw_spin_unlock+0xff/0x10f
[  109.164327]  [<ffffffff8113823d>] ? trace_hardirqs_on+0x10/0x4a
[  109.164333]  [<ffffffff8155162d>] ? _raw_spin_unlock_irq+0x4c/0x7b
[  109.164339]  [<ffffffff8154d4d1>] ? wait_for_common+0x145/0x15e
[  109.164345]  [<ffffffff81075337>] ? default_wake_function+0x0/0x22
[  109.164357]  [<ffffffffa0615a8f>] cciss_cleanup+0xa9/0xc7 [cciss]
[  109.164365]  [<ffffffff810d3cb0>] sys_delete_module+0x2d6/0x368
[  109.164371]  [<ffffffff8155036b>] ? lockdep_sys_exit_thunk+0x35/0x67
[  109.164377]  [<ffffffff810fdfaf>] ? audit_syscall_entry+0x172/0x1a5
[  109.164383]  [<ffffffff815502f5>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  109.164389]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
[  109.164394] ---[ end trace 88e8568246ed0b1d ]---



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
