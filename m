Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0KCXS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:18:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45889 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0KCXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:18:56 -0400
Date: Wed, 3 Nov 2010 16:18:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (libipw remove_proc_entry warning)
Message-Id: <20101103161837.fad11d79.randy.dunlap@oracle.com>
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


Nov  3 16:03:11 control kernel: [   74.701367]     (5170000[   74.846676] calling  libipw_init+0x0/0xe4 [libipw] @ 2992
[   74.852356] libipw: 802.11 data/management/control stack, git-1.1.13
[   74.858790] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   74.866977] initcall libipw_init+0x0/0xe4 [libipw] returned 0 after 14318 usecs
Nov  3 16:03:11 control kernel: [   74.846676] calling  libipw_iNov  3 16:03:11 control kernel: [   74.852356] libipw: 802.11 data/management/control stack, git-1.1.13
Nov  3 16:03:11 control kernel: [   74.858790] libipw: C


[   78.273409] ------------[ cut here ]------------
[   78.278210] WARNING: at /local/linsrc/lnx-2637-rc1/fs/proc/generic.c:816 remove_proc_entry+0x156/0x35e()
Nov  3 16:03:14 [   78.288314] Hardware name: OptiPlex GX620               
control kernel: [   78.294870] name 'libipw'
[   78.298520] Modules linked in: libipw(-) lib80211 cfg80211 ipt_MASQUERADE iptable_nat nf_nat af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp llc bnep l2cap crc16 bluetoothNov  3 16:03:14  rfkillcontrol kernel:  sunrpc[   78.278210] W ipt_REJECTARNING: at /loca nf_conntrack_ipv4l/linsrc/lnx-263 nf_defrag_ipv47-rc1/fs/proc/ge iptable_filterneric.c:816 remo ip_tablesve_proc_entry+0x ip6t_REJECT156/0x35e()
Nov  xt_tcpudp 3 16:03:14 cont nf_conntrack_ipv6rol kernel: [    nf_defrag_ipv678.288314] Hardw xt_stateare name: OptiPl nf_conntrackex GX620         ip6table_filter       
Nov  3 1 ip6_tables6:03:14 control  x_tableskernel: [   78.2 ipv694870] name 'lib p4_clockmodipw'
 freq_table speedstep_lib binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod kvm uinput mousedev joydev snd_intel8x0 snd_ac97_codec ac97_bus ppdev snd_seq snd_seq_device usbmouse snd_pcm led_class usbkbd snd_timer usbhid iTCO_wdt hid snd iTCO_vendor_support tg3 sr_mod dcdbas cdrom soundcore i2c_i801 rtc_cmos sg pcspkr rng_core parport_pc snd_page_alloc rtc_core shpchp evdev rtc_lib parport 8250_pnp pci_hotplug mac_hid unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base i915 drm_kms_helper intel_agp button intel_gtt video thermal_sys hwmon output [last unloaded: mperf]
[   78.429364] Pid: 3067, comm: rmmod Not tainted 2.6.37-rc1 #10
[   78.435209] Call Trace:
[   78.437982]  [<ffffffff8107e1ed>] warn_slowpath_common+0xc6/0xf3
[   78.444119]  [<ffffffff8107e30a>] warn_slowpath_fmt+0x5b/0x6b
[   78.449973]  [<ffffffff81550dbb>] ? _raw_spin_unlock+0x40/0x4b
[   78.456247]  [<ffffffff8123d37e>] remove_proc_entry+0x156/0x35e
Nov  3 16:03:14 [   78.462289]  [<ffffffff81017d29>] ? native_sched_clock+0x3b/0x6d
control kernel: [   78.470047]  [<ffffffff810b067f>] ? sched_clock_cpu+0x147/0x160
[   78.298520] M[   78.477041]  [<ffffffff81137479>] ? trace_hardirqs_off+0x10/0x4a
odules linked in: libipw(-) lib80211 cfg80211 ip[   78.487138]  [<ffffffff810b0742>] ? local_clock+0xaa/0xf4
t_MASQUERADE iptable_nat nf_nat [   78.496297]  [<ffffffff810c0ab9>] ? lock_release_holdtime+0x41/0x177
Nov  3 16:03:14 [   78.505725]  [<ffffffff810c3a1b>] ? lock_release_nested+0xfb/0x133
Nov  3 16:03:14 [   78.514477]  [<ffffffffa0c39cad>] libipw_exit+0x49/0x5d [libipw]
Nov  3 16:03:14 [   78.523311]  [<ffffffff810d3310>] sys_delete_module+0x2d6/0x368
[   78.531755]  [<ffffffff8154f9cb>] ? lockdep_sys_exit_thunk+0x35/0x67
Nov  3 16:03:14 Nov  3 16:03:14 [   78.540954]  [<ffffffff810fd60f>] ? audit_syscall_entry+0x172/0x1a5
Nov  3 16:03:14 [   78.550029]  [<ffffffff8154f955>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Nov  3 16:03:14 [   78.559196]  [<ffffffff8100ea72>] system_call_fastpath+0x16/0x1b
Nov  3 16:03:14 [   78.567700] ---[ end trace b9ae9f3ab8d89ea5 ]---


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
