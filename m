Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1HWSKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:10:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1HWSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:10:07 -0400
Message-ID: <4E53ECEF.7040109@kernel.org>
Date: Tue, 23 Aug 2011 11:09:51 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [KORG] Panics on master backend
X-Enigmail-Version: 1.1.2
Content-Type: multipart/mixed;
 boundary="------------020807040808090501040802"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 23 Aug 2011 11:09:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020807040808090501040802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Morning,

Hera, the master backend machine, has experienced a couple of kernel
panics, one yesterday and one just now today.  I'm attaching the output
from the serial console for both of these.  I'm running a stock
3.1.0-rc2+ running from 93ee7a9340d64f20295aacc3fb6a22b759323280, which
should be the tag for 3.1-rc2.

The lights out device isn't reporting anything out of the ordinary, no
bus errors or memory errors on the box, so while I wouldn't rule that
out, there's not enough data currently to call out the repair tech to
start replacing things.

Anyway, thought I'd let everyone know what's been going on.

- - John 'Warthog9' Hawley
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk5T7OkACgkQ/E3kyWU9didSIQCeNSUL6peMczlgowgHLYGYBHWk
+tAAn3xOShpB58Xjrup4/zyHBTqRAucK
=QvFN
-----END PGP SIGNATURE-----

--------------020807040808090501040802
Content-Type: text/plain;
 name="hera.2011aug22.panic"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hera.2011aug22.panic"

20110822.log:Aug 22 03:13:33 console1 port05  RXDATA: [10780.415059] CE: hpet increased min_delta_ns to 20113 nsec
20110823.log:Aug 23 02:50:54 console1 port05  RXDATA: [95603.710373] CE: hpet increased min_delta_ns to 30169 nsec
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.546556] ------------[ cut here ]------------
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.551315] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.559221] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.563617] Watchdog detected hard LOCKUP on cpu 0
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.568364] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.603809] Pid: 2416, comm: flush-8:0 Not tainted 3.1.0-rc2+ #2
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.609994] Call Trace:
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.612549]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.619333]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.625220]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.631897]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.638309]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.643845]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.650693]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.656755]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.663115]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.669439]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.675499]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.682173]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.687472]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.692481]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.697165]  [<ffffffff8103c509>] ? cpu_relax+0xb/0xd
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.702389]  <<EOE>>  <IRQ>  [<ffffffff81049469>] try_to_wake_up+0x89/0x1ca
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.709536]  [<ffffffff810495d3>] ? wake_up_process+0x15/0x17
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.715422]  [<ffffffff810495bc>] default_wake_function+0x12/0x14
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.721659]  [<ffffffff8103d165>] __wake_up_common+0x4e/0x84
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.727489]  [<ffffffffa0177066>] ? _xfs_buf_ioend+0x2f/0x36 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.733852]  [<ffffffff810428b0>] complete+0x3f/0x52
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.738985]  [<ffffffffa0177017>] xfs_buf_ioend+0xc2/0xe2 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.745079]  [<ffffffffa0177066>] _xfs_buf_ioend+0x2f/0x36 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.751259]  [<ffffffffa017727a>] xfs_buf_bio_end_io+0x2a/0x37 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.757758]  [<ffffffff8114f684>] bio_endio+0x2d/0x2f
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.762945]  [<ffffffff81229cd1>] req_bio_endio.clone.31+0x9e/0xa7
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.772811]  [<ffffffff81229e6b>] blk_update_request+0x191/0x32e
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.782563]  [<ffffffff8122a029>] blk_update_bidi_request+0x21/0x6d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.792529]  [<ffffffff8122a180>] blk_end_bidi_request+0x1f/0x5d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.802230]  [<ffffffff8122a1f8>] blk_end_request+0x10/0x12
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.811446]  [<ffffffff81313300>] scsi_io_completion+0x1e2/0x4d8
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.821002]  [<ffffffff814d47e7>] ? _raw_spin_unlock_irqrestore+0x17/0x19
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.831405]  [<ffffffff8130bf80>] scsi_finish_command+0xe8/0xf1
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.840948]  [<ffffffff8131305f>] scsi_softirq_done+0x109/0x112
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.850485]  [<ffffffff8122e3c8>] blk_done_softirq+0x73/0x87
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.859729]  [<ffffffff8105757a>] __do_softirq+0xc9/0x1b6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.868705]  [<ffffffff81014e01>] ? paravirt_read_tsc+0x9/0xd
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.878093]  [<ffffffff814dd2ac>] call_softirq+0x1c/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.887025]  [<ffffffff81010c5e>] do_softirq+0x46/0x84
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.895767]  [<ffffffff81057849>] irq_exit+0x52/0xaf
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.904246]  [<ffffffff814ddc21>] smp_apic_timer_interrupt+0x7c/0x8a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.914171]  [<ffffffff814dbb1e>] apic_timer_interrupt+0x6e/0x80
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.923618]  <EOI>  [<ffffffff81080526>] ? arch_local_irq_restore+0x6/0xd
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.933756]  [<ffffffff814d47e7>] _raw_spin_unlock_irqrestore+0x17/0x19
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.943630]  [<ffffffffa00446c4>] hpsa_scsi_queue_command+0x2f9/0x319 [hpsa]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.953851]  [<ffffffff8130c9bb>] scsi_dispatch_cmd+0x18c/0x251
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.962917]  [<ffffffff81312d70>] scsi_request_fn+0x3cd/0x3f9
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.971781]  [<ffffffff81225214>] __blk_run_queue+0x1b/0x1d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.980439]  [<ffffffff8123b637>] cfq_insert_request+0x4cf/0x504
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.989469]  [<ffffffff812248d4>] __elv_add_request+0x19c/0x1e7
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.998481]  [<ffffffff8122a934>] blk_flush_plug_list+0x166/0x19b
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.007670]  [<ffffffff814d2ce4>] schedule+0x2a3/0x6dc
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.015903]  [<ffffffff814d35e1>] schedule_timeout+0x36/0xe3
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.024644]  [<ffffffff81228a4d>] ? submit_bio+0xe0/0xff
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.032972]  [<ffffffff8115064e>] ? bio_alloc_bioset+0x4d/0xc4
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.041868]  [<ffffffff81040084>] ? need_resched+0x23/0x2d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.050400]  [<ffffffff814d33b7>] wait_for_common+0x9a/0xef
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.059015]  [<ffffffff810495aa>] ? try_to_wake_up+0x1ca/0x1ca
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.067925]  [<ffffffffa0177464>] ? _xfs_buf_read+0x43/0x48 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.077050]  [<ffffffffa016fc98>] ? xfs_trans_read_buf+0x1df/0x31c [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.086775]  [<ffffffff814d34c4>] wait_for_completion+0x1d/0x1f
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.095822]  [<ffffffffa01773d3>] xfs_buf_iowait+0x43/0x91 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.104964]  [<ffffffffa0177464>] _xfs_buf_read+0x43/0x48 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.113940]  [<ffffffffa01774ed>] xfs_buf_read+0x84/0xcd [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.122800]  [<ffffffffa016fc98>] xfs_trans_read_buf+0x1df/0x31c [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.132355]  [<ffffffffa0146385>] xfs_btree_read_buf_block.clone.22+0x4f/0xa7 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.143044]  [<ffffffffa0173b19>] ? kmem_zone_alloc+0x3d/0x87 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.152365]  [<ffffffffa0146461>] xfs_btree_lookup_get_block+0x84/0xac [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.162459]  [<ffffffffa0149408>] xfs_btree_lookup+0x12b/0x3dc [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.171911]  [<ffffffffa0173b87>] ? kmem_zone_zalloc+0x24/0x35 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.181371]  [<ffffffffa0137331>] ? xfs_allocbt_init_cursor+0x3e/0xa7 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.191368]  [<ffffffffa0133fe9>] xfs_alloc_lookup_ge.clone.3+0x1d/0x1f [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.201594]  [<ffffffffa0135b18>] xfs_alloc_ag_vextent_near+0x76/0x94f [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.211727]  [<ffffffffa0136424>] xfs_alloc_ag_vextent+0x33/0xcd [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.221327]  [<ffffffffa0136c5c>] xfs_alloc_vextent+0x2ad/0x478 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.230842]  [<ffffffffa014101a>] xfs_bmap_btalloc+0x35d/0x50a [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.240288]  [<ffffffffa01411d5>] xfs_bmap_alloc+0xe/0x10 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.249333]  [<ffffffffa0143342>] xfs_bmapi+0x6d7/0xd5d [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.258164]  [<ffffffff814d3309>] ? _cond_resched+0xe/0x22
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.266721]  [<ffffffff811158b1>] ? slab_pre_alloc_hook.clone.37+0x1a/0x1e
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.276626]  [<ffffffff8104009c>] ? should_resched+0xe/0x2e
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.285264]  [<ffffffffa016e41b>] ? xfs_trans_add_item+0x50/0x5c [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.294920]  [<ffffffffa015f893>] xfs_iomap_write_allocate+0x1c5/0x2d2 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.305074]  [<ffffffffa0174a48>] xfs_map_blocks+0x161/0x1fa [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.314364]  [<ffffffffa01754f8>] xfs_vm_writepage+0x219/0x3f0 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.323796]  [<ffffffff810e15c0>] __writepage+0x17/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.332147]  [<ffffffff810e1c8d>] write_cache_pages+0x26a/0x3d1
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.341156]  [<ffffffff810e15a9>] ? set_page_dirty+0x60/0x60
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.349892]  [<ffffffff810e1e39>] generic_writepages+0x45/0x5c
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.358846]  [<ffffffffa01748c4>] xfs_vm_writepages+0x4d/0x56 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.368206]  [<ffffffff810e2c6f>] do_writepages+0x21/0x2a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.376634]  [<ffffffff81146b9e>] writeback_single_inode+0x113/0x2c7
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.386011]  [<ffffffff81147057>] writeback_sb_inodes+0x174/0x215
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.395106]  [<ffffffff81147424>] __writeback_inodes_wb+0x78/0xb9
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.404153]  [<ffffffff8114758a>] wb_writeback+0x125/0x23d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.412596]  [<ffffffff8113b949>] ? get_nr_inodes_unused+0x48/0x60
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.421829]  [<ffffffff81147d9f>] wb_do_writeback+0x148/0x1b6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.430633]  [<ffffffff81147e88>] bdi_writeback_thread+0x7b/0x21b
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.439736]  [<ffffffff81147e0d>] ? wb_do_writeback+0x1b6/0x1b6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.448701]  [<ffffffff8106ceea>] kthread+0x82/0x8a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.456626]  [<ffffffff814dd1b4>] kernel_thread_helper+0x4/0x10
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.465568]  [<ffffffff8106ce68>] ? kthread_worker_fn+0x14b/0x14b
20110823.log:Aug 23 16:49:54 console1 port05  RXDATA: [145814.474730]  [<ffffffff814dd1b0>] ? gs_change+0x13/0x13
20110823.log:Aug 23 16:49:54 console1 port05  RXDATA: [145814.482982] ---[ end trace 178d61af15d42cc2 ]---
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.435131] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.442748] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.453549] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.460868] Watchdog detected hard LOCKUP on cpu 6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.465611] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.516885] Pid: 4637, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.527236] Call Trace:
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.533157]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.543400]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.552738]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.562919]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.572741]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.581677]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.591968]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.601453]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.611233]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.621081]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.630639]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.640778]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.649522]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.657990]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.666118]  <<EOE>> 
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.668323] ---[ end trace 178d61af15d42cc3 ]---
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.966143] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.974282] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.985645] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.993499] Watchdog detected hard LOCKUP on cpu 13
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.998330] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.052268] Pid: 26054, comm: httpd Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.062907] Call Trace:
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.069369]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.080124]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.089968]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.100696]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.111161]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.120711]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.131583]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.141669]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.152070]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.162431]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.172528]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.183238]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.192547]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.201515]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.210053]  <<EOE>> 
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.212260] ---[ end trace 178d61af15d42cc4 ]---
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.348076] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.356596] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.368111] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.376094] Watchdog detected hard LOCKUP on cpu 1
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.380837] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.434971] Pid: 2364, comm: auth Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.445462] Call Trace:
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.451981]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.462703]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.472547]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.483173]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.493591]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.503092]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.513867]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.523903]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.534217]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.544597]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.554718]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.565462]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.574767]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.583758]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.592339]  <<EOE>> 
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.594546] ---[ end trace 178d61af15d42cc5 ]---
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.350314] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.358745] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.370298] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.378327] Watchdog detected hard LOCKUP on cpu 9
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.383071] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.437130] Pid: 4628, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.448026] Call Trace:
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.454490]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.465266]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.475146]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.485786]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.496165]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.505627]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.516467]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.526554]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.536832]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.547173]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.557240]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.567986]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.577342]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.586384]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.595006]  <<EOE>> 
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.597213] ---[ end trace 178d61af15d42cc6 ]---
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.613819] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.622298] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.633903] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.641902] Watchdog detected hard LOCKUP on cpu 12
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.646746] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.700809] Pid: 4668, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.711709] Call Trace:
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.718203]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.728984]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.738884]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.749526]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.759873]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.769387]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.780257]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.790308]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.800678]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.811023]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.821111]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.831866]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.841201]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.850246]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.858886]  <<EOE>> 
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.861090] ---[ end trace 178d61af15d42cc7 ]---
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.406589] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.415077] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.426688] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.434688] Watchdog detected hard LOCKUP on cpu 15
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.439520] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.493547] Pid: 2688, comm: httpd Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.504178] Call Trace:
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.510705]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.521472]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.531320]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.541953]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.552290]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.561838]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.572706]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.582703]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.593018]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.603323]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.613443]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.624188]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.633495]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.642526]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.651151]  <<EOE>> 
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.653358] ---[ end trace 178d61af15d42cc8 ]---
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.767570] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.776089] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.787597] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.795582] Watchdog detected hard LOCKUP on cpu 7
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.800326] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.854416] Pid: 4702, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.865218] Call Trace:
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.871705]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.882390]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.892196]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.902839]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.913265]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.922816]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.933641]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.943681]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.953957]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.964338]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.974418]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.985160]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.994468]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146960.003416]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146960.012002]  <<EOE>> 
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146960.014209] ---[ end trace 178d61af15d42cc9 ]---
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.305541] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.313978] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.325543] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.333586] Watchdog detected hard LOCKUP on cpu 11
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.338417] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.392613] Pid: 4700, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.403474] Call Trace:
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.409979]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.420731]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.430557]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.441175]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.451580]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.461150]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.472038]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.482147]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.492487]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.502805]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.512946]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.523717]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.533054]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.542117]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.550772]  <<EOE>> 
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.552978] ---[ end trace 178d61af15d42cca ]---
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.786384] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.794886] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.806426] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.814443] Watchdog detected hard LOCKUP on cpu 5
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.819187] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.873347] Pid: 27, comm: ksoftirqd/5 Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.884341] Call Trace:
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.890853]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.901651]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.911481]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.922149]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.932599]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.942180]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.953074]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.963140]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.973485]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.983837]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.993984]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.004755]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.014132]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.023151]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.031765]  [<ffffffff81014ed6>] ? read_tsc+0x1/0x19
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.040890]  <<EOE>>  [<ffffffff81074a97>] ? timekeeping_get_ns+0x1a/0x39
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.051713]  [<ffffffff81075021>] ktime_get+0x5e/0x99
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.060663]  [<ffffffff8107ac5a>] tick_dev_program_event+0x25/0xf5
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.070717]  [<ffffffff8107ad49>] tick_program_event+0x1f/0x21
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.080320]  [<ffffffff81070ba7>] hrtimer_interrupt+0x109/0x197
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.089955]  [<ffffffff81070c6c>] __hrtimer_peek_ahead_timers+0x37/0x39
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.100214]  [<ffffffff81070c8e>] hrtimer_peek_ahead_timers+0x20/0x2b
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.110276]  [<ffffffff81070ca7>] run_hrtimer_softirq+0xe/0x10
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.119704]  [<ffffffff8105757a>] __do_softirq+0xc9/0x1b6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.128685]  [<ffffffff810576e6>] run_ksoftirqd+0x7f/0x11d
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.137729]  [<ffffffff81057667>] ? __do_softirq+0x1b6/0x1b6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.146935]  [<ffffffff8106ceea>] kthread+0x82/0x8a
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.155339]  [<ffffffff814dd1b4>] kernel_thread_helper+0x4/0x10
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.164789]  [<ffffffff8106ce68>] ? kthread_worker_fn+0x14b/0x14b
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.174457]  [<ffffffff814dd1b0>] ? gs_change+0x13/0x13
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.183250] ---[ end trace 178d61af15d42ccb ]---
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.550621] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.558776] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.570148] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.578075] Watchdog detected hard LOCKUP on cpu 10
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.582909] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.637003] Pid: 4748, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.647881] Call Trace:
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.654404]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.665083]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.674792]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.685126]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.695122]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.704170]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.714595]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.724228]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.734054]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.743834]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.753384]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.763504]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.772219]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.780653]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.788715]  <<EOE>> 
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.790929] ---[ end trace 178d61af15d42ccc ]---
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.073402] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.081577] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.092881] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.100795] Watchdog detected hard LOCKUP on cpu 8
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.105539] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.159535] Pid: 4771, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.170342] Call Trace:
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.176836]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.187614]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.197432]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.208087]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.218528]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.228120]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.239044]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.249149]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.259519]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.269847]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.280005]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.290770]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.300078]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.309090]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.317691]  <<EOE>> 
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.319897] ---[ end trace 178d61af15d42ccd ]---
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.894083] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.902532] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.914153] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.922169] Watchdog detected hard LOCKUP on cpu 14
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.927001] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.981078] Pid: 4682, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.991987] Call Trace:
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.998492]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.009284]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.019198]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.029862]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.040266]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.049796]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.060684]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.070789]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.081132]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.091495]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.101578]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.112311]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.121687]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.130701]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.139308]  <<EOE>> 
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.141531] ---[ end trace 178d61af15d42cce ]---
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.268508] ------------[ cut here ]------------
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.276969] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.288552] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.296523] Watchdog detected hard LOCKUP on cpu 3
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.301268] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.355381] Pid: 4676, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.366256] Call Trace:
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.372770]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.383527]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.393450]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.404162]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.414568]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.424058]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.434863]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.444979]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.455327]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.465736]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.475799]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.486525]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.495855]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.504844]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.513420]  <<EOE>> 
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.515626] ---[ end trace 178d61af15d42ccf ]---
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.906597] ------------[ cut here ]------------
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.915046] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.926669] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.934685] Watchdog detected hard LOCKUP on cpu 2
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.939430] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.993555] Pid: 1993, comm: automount Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.004553] Call Trace:
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.011107]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.021906]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.031829]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.042491]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.052898]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.062390]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.073239]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.083355]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.093659]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.104023]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.114092]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.124866]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.134251]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.143269]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.151885]  [<ffffffff8107ecc3>] ? sys_futex+0x91/0x146
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.161324]  <<EOE>>  [<ffffffff814db042>] system_call_fastpath+0x16/0x1b
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.172157] ---[ end trace 178d61af15d42cd0 ]---
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.624844] ------------[ cut here ]------------
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.633296] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.644875] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.652917] Watchdog detected hard LOCKUP on cpu 4
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.657661] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.711976] Pid: 4752, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.722945] Call Trace:
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.729548]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.740391]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.750360]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.761078]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.771529]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.781156]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.792097]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.802280]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.812696]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.823116]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.833328]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.844157]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.853550]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.862626]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.871332]  <<EOE>> 
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.873537] ---[ end trace 178d61af15d42cd1 ]---
20110823.log:Aug 23 17:18:30 console1 port05  RXDATA: [147526.880360] NMI: PCI system error (SERR) for reason a1 on CPU 0.
20110823.log:Aug 23 17:18:30 console1 port05  RXDATA: [147526.890196] Dazed and confused, but trying to continue
20110823.log:Aug 23 17:18:40 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DCD -> 0  
20110823.log:Aug 23 17:18:40 console1 port05  SIGNAL: DCD=off

--------------020807040808090501040802
Content-Type: text/plain;
 name="hera.2011aug23.panic"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hera.2011aug23.panic"

20110822.log:Aug 22 03:13:33 console1 port05  RXDATA: [10780.415059] CE: hpet increased min_delta_ns to 20113 nsec
20110823.log:Aug 23 02:50:54 console1 port05  RXDATA: [95603.710373] CE: hpet increased min_delta_ns to 30169 nsec
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.546556] ------------[ cut here ]------------
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.551315] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.559221] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.563617] Watchdog detected hard LOCKUP on cpu 0
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.568364] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.603809] Pid: 2416, comm: flush-8:0 Not tainted 3.1.0-rc2+ #2
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.609994] Call Trace:
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.612549]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.619333]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.625220]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.631897]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.638309]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.643845]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.650693]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.656755]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.663115]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.669439]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.675499]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.682173]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.687472]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.692481]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.697165]  [<ffffffff8103c509>] ? cpu_relax+0xb/0xd
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.702389]  <<EOE>>  <IRQ>  [<ffffffff81049469>] try_to_wake_up+0x89/0x1ca
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.709536]  [<ffffffff810495d3>] ? wake_up_process+0x15/0x17
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.715422]  [<ffffffff810495bc>] default_wake_function+0x12/0x14
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.721659]  [<ffffffff8103d165>] __wake_up_common+0x4e/0x84
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.727489]  [<ffffffffa0177066>] ? _xfs_buf_ioend+0x2f/0x36 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.733852]  [<ffffffff810428b0>] complete+0x3f/0x52
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.738985]  [<ffffffffa0177017>] xfs_buf_ioend+0xc2/0xe2 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.745079]  [<ffffffffa0177066>] _xfs_buf_ioend+0x2f/0x36 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.751259]  [<ffffffffa017727a>] xfs_buf_bio_end_io+0x2a/0x37 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.757758]  [<ffffffff8114f684>] bio_endio+0x2d/0x2f
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.762945]  [<ffffffff81229cd1>] req_bio_endio.clone.31+0x9e/0xa7
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.772811]  [<ffffffff81229e6b>] blk_update_request+0x191/0x32e
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.782563]  [<ffffffff8122a029>] blk_update_bidi_request+0x21/0x6d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.792529]  [<ffffffff8122a180>] blk_end_bidi_request+0x1f/0x5d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.802230]  [<ffffffff8122a1f8>] blk_end_request+0x10/0x12
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.811446]  [<ffffffff81313300>] scsi_io_completion+0x1e2/0x4d8
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.821002]  [<ffffffff814d47e7>] ? _raw_spin_unlock_irqrestore+0x17/0x19
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.831405]  [<ffffffff8130bf80>] scsi_finish_command+0xe8/0xf1
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.840948]  [<ffffffff8131305f>] scsi_softirq_done+0x109/0x112
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.850485]  [<ffffffff8122e3c8>] blk_done_softirq+0x73/0x87
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.859729]  [<ffffffff8105757a>] __do_softirq+0xc9/0x1b6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.868705]  [<ffffffff81014e01>] ? paravirt_read_tsc+0x9/0xd
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.878093]  [<ffffffff814dd2ac>] call_softirq+0x1c/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.887025]  [<ffffffff81010c5e>] do_softirq+0x46/0x84
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.895767]  [<ffffffff81057849>] irq_exit+0x52/0xaf
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.904246]  [<ffffffff814ddc21>] smp_apic_timer_interrupt+0x7c/0x8a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.914171]  [<ffffffff814dbb1e>] apic_timer_interrupt+0x6e/0x80
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.923618]  <EOI>  [<ffffffff81080526>] ? arch_local_irq_restore+0x6/0xd
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.933756]  [<ffffffff814d47e7>] _raw_spin_unlock_irqrestore+0x17/0x19
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.943630]  [<ffffffffa00446c4>] hpsa_scsi_queue_command+0x2f9/0x319 [hpsa]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.953851]  [<ffffffff8130c9bb>] scsi_dispatch_cmd+0x18c/0x251
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.962917]  [<ffffffff81312d70>] scsi_request_fn+0x3cd/0x3f9
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.971781]  [<ffffffff81225214>] __blk_run_queue+0x1b/0x1d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.980439]  [<ffffffff8123b637>] cfq_insert_request+0x4cf/0x504
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.989469]  [<ffffffff812248d4>] __elv_add_request+0x19c/0x1e7
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145813.998481]  [<ffffffff8122a934>] blk_flush_plug_list+0x166/0x19b
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.007670]  [<ffffffff814d2ce4>] schedule+0x2a3/0x6dc
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.015903]  [<ffffffff814d35e1>] schedule_timeout+0x36/0xe3
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.024644]  [<ffffffff81228a4d>] ? submit_bio+0xe0/0xff
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.032972]  [<ffffffff8115064e>] ? bio_alloc_bioset+0x4d/0xc4
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.041868]  [<ffffffff81040084>] ? need_resched+0x23/0x2d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.050400]  [<ffffffff814d33b7>] wait_for_common+0x9a/0xef
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.059015]  [<ffffffff810495aa>] ? try_to_wake_up+0x1ca/0x1ca
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.067925]  [<ffffffffa0177464>] ? _xfs_buf_read+0x43/0x48 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.077050]  [<ffffffffa016fc98>] ? xfs_trans_read_buf+0x1df/0x31c [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.086775]  [<ffffffff814d34c4>] wait_for_completion+0x1d/0x1f
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.095822]  [<ffffffffa01773d3>] xfs_buf_iowait+0x43/0x91 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.104964]  [<ffffffffa0177464>] _xfs_buf_read+0x43/0x48 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.113940]  [<ffffffffa01774ed>] xfs_buf_read+0x84/0xcd [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.122800]  [<ffffffffa016fc98>] xfs_trans_read_buf+0x1df/0x31c [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.132355]  [<ffffffffa0146385>] xfs_btree_read_buf_block.clone.22+0x4f/0xa7 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.143044]  [<ffffffffa0173b19>] ? kmem_zone_alloc+0x3d/0x87 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.152365]  [<ffffffffa0146461>] xfs_btree_lookup_get_block+0x84/0xac [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.162459]  [<ffffffffa0149408>] xfs_btree_lookup+0x12b/0x3dc [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.171911]  [<ffffffffa0173b87>] ? kmem_zone_zalloc+0x24/0x35 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.181371]  [<ffffffffa0137331>] ? xfs_allocbt_init_cursor+0x3e/0xa7 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.191368]  [<ffffffffa0133fe9>] xfs_alloc_lookup_ge.clone.3+0x1d/0x1f [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.201594]  [<ffffffffa0135b18>] xfs_alloc_ag_vextent_near+0x76/0x94f [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.211727]  [<ffffffffa0136424>] xfs_alloc_ag_vextent+0x33/0xcd [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.221327]  [<ffffffffa0136c5c>] xfs_alloc_vextent+0x2ad/0x478 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.230842]  [<ffffffffa014101a>] xfs_bmap_btalloc+0x35d/0x50a [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.240288]  [<ffffffffa01411d5>] xfs_bmap_alloc+0xe/0x10 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.249333]  [<ffffffffa0143342>] xfs_bmapi+0x6d7/0xd5d [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.258164]  [<ffffffff814d3309>] ? _cond_resched+0xe/0x22
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.266721]  [<ffffffff811158b1>] ? slab_pre_alloc_hook.clone.37+0x1a/0x1e
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.276626]  [<ffffffff8104009c>] ? should_resched+0xe/0x2e
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.285264]  [<ffffffffa016e41b>] ? xfs_trans_add_item+0x50/0x5c [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.294920]  [<ffffffffa015f893>] xfs_iomap_write_allocate+0x1c5/0x2d2 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.305074]  [<ffffffffa0174a48>] xfs_map_blocks+0x161/0x1fa [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.314364]  [<ffffffffa01754f8>] xfs_vm_writepage+0x219/0x3f0 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.323796]  [<ffffffff810e15c0>] __writepage+0x17/0x30
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.332147]  [<ffffffff810e1c8d>] write_cache_pages+0x26a/0x3d1
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.341156]  [<ffffffff810e15a9>] ? set_page_dirty+0x60/0x60
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.349892]  [<ffffffff810e1e39>] generic_writepages+0x45/0x5c
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.358846]  [<ffffffffa01748c4>] xfs_vm_writepages+0x4d/0x56 [xfs]
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.368206]  [<ffffffff810e2c6f>] do_writepages+0x21/0x2a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.376634]  [<ffffffff81146b9e>] writeback_single_inode+0x113/0x2c7
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.386011]  [<ffffffff81147057>] writeback_sb_inodes+0x174/0x215
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.395106]  [<ffffffff81147424>] __writeback_inodes_wb+0x78/0xb9
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.404153]  [<ffffffff8114758a>] wb_writeback+0x125/0x23d
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.412596]  [<ffffffff8113b949>] ? get_nr_inodes_unused+0x48/0x60
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.421829]  [<ffffffff81147d9f>] wb_do_writeback+0x148/0x1b6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.430633]  [<ffffffff81147e88>] bdi_writeback_thread+0x7b/0x21b
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.439736]  [<ffffffff81147e0d>] ? wb_do_writeback+0x1b6/0x1b6
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.448701]  [<ffffffff8106ceea>] kthread+0x82/0x8a
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.456626]  [<ffffffff814dd1b4>] kernel_thread_helper+0x4/0x10
20110823.log:Aug 23 16:49:53 console1 port05  RXDATA: [145814.465568]  [<ffffffff8106ce68>] ? kthread_worker_fn+0x14b/0x14b
20110823.log:Aug 23 16:49:54 console1 port05  RXDATA: [145814.474730]  [<ffffffff814dd1b0>] ? gs_change+0x13/0x13
20110823.log:Aug 23 16:49:54 console1 port05  RXDATA: [145814.482982] ---[ end trace 178d61af15d42cc2 ]---
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.435131] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.442748] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.453549] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.460868] Watchdog detected hard LOCKUP on cpu 6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.465611] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.516885] Pid: 4637, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.527236] Call Trace:
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.533157]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.543400]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.552738]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.562919]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.572741]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.581677]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.591968]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.601453]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.611233]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.621081]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.630639]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.640778]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.649522]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.657990]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.666118]  <<EOE>> 
20110823.log:Aug 23 17:08:00 console1 port05  RXDATA: [146898.668323] ---[ end trace 178d61af15d42cc3 ]---
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.966143] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.974282] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.985645] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.993499] Watchdog detected hard LOCKUP on cpu 13
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146909.998330] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.052268] Pid: 26054, comm: httpd Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.062907] Call Trace:
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.069369]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.080124]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.089968]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.100696]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.111161]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.120711]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.131583]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.141669]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.152070]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.162431]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.172528]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.183238]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.192547]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.201515]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.210053]  <<EOE>> 
20110823.log:Aug 23 17:08:12 console1 port05  RXDATA: [146910.212260] ---[ end trace 178d61af15d42cc4 ]---
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.348076] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.356596] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.368111] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.376094] Watchdog detected hard LOCKUP on cpu 1
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.380837] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.434971] Pid: 2364, comm: auth Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.445462] Call Trace:
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.451981]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.462703]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.472547]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.483173]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.493591]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.503092]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.513867]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.523903]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.534217]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.544597]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.554718]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.565462]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.574767]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.583758]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.592339]  <<EOE>> 
20110823.log:Aug 23 17:08:22 console1 port05  RXDATA: [146920.594546] ---[ end trace 178d61af15d42cc5 ]---
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.350314] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.358745] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.370298] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.378327] Watchdog detected hard LOCKUP on cpu 9
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.383071] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.437130] Pid: 4628, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.448026] Call Trace:
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.454490]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.465266]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.475146]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.485786]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.496165]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.505627]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.516467]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.526554]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.536832]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.547173]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.557240]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.567986]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.577342]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.586384]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.595006]  <<EOE>> 
20110823.log:Aug 23 17:08:32 console1 port05  RXDATA: [146930.597213] ---[ end trace 178d61af15d42cc6 ]---
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.613819] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.622298] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.633903] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.641902] Watchdog detected hard LOCKUP on cpu 12
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.646746] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.700809] Pid: 4668, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.711709] Call Trace:
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.718203]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.728984]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:42 console1 port05  RXDATA: [146940.738884]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.749526]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.759873]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.769387]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.780257]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.790308]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.800678]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.811023]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.821111]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.831866]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.841201]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.850246]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.858886]  <<EOE>> 
20110823.log:Aug 23 17:08:43 console1 port05  RXDATA: [146940.861090] ---[ end trace 178d61af15d42cc7 ]---
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.406589] ------------[ cut here ]------------
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.415077] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.426688] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.434688] Watchdog detected hard LOCKUP on cpu 15
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.439520] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.493547] Pid: 2688, comm: httpd Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.504178] Call Trace:
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.510705]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.521472]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.531320]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.541953]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.552290]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.561838]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.572706]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.582703]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.593018]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.603323]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.613443]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.624188]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.633495]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.642526]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.651151]  <<EOE>> 
20110823.log:Aug 23 17:08:52 console1 port05  RXDATA: [146950.653358] ---[ end trace 178d61af15d42cc8 ]---
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.767570] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.776089] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.787597] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.795582] Watchdog detected hard LOCKUP on cpu 7
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.800326] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.854416] Pid: 4702, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.865218] Call Trace:
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.871705]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.882390]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.892196]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.902839]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.913265]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.922816]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.933641]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.943681]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.953957]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.964338]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.974418]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.985160]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146959.994468]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146960.003416]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146960.012002]  <<EOE>> 
20110823.log:Aug 23 17:09:02 console1 port05  RXDATA: [146960.014209] ---[ end trace 178d61af15d42cc9 ]---
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.305541] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.313978] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.325543] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.333586] Watchdog detected hard LOCKUP on cpu 11
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.338417] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.392613] Pid: 4700, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.403474] Call Trace:
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.409979]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.420731]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.430557]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.441175]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.451580]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.461150]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.472038]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.482147]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.492487]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.502805]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.512946]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.523717]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.533054]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.542117]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.550772]  <<EOE>> 
20110823.log:Aug 23 17:09:11 console1 port05  RXDATA: [146969.552978] ---[ end trace 178d61af15d42cca ]---
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.786384] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.794886] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.806426] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.814443] Watchdog detected hard LOCKUP on cpu 5
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.819187] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.873347] Pid: 27, comm: ksoftirqd/5 Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.884341] Call Trace:
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.890853]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.901651]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.911481]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.922149]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.932599]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.942180]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.953074]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.963140]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.973485]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.983837]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146978.993984]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.004755]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.014132]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.023151]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.031765]  [<ffffffff81014ed6>] ? read_tsc+0x1/0x19
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.040890]  <<EOE>>  [<ffffffff81074a97>] ? timekeeping_get_ns+0x1a/0x39
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.051713]  [<ffffffff81075021>] ktime_get+0x5e/0x99
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.060663]  [<ffffffff8107ac5a>] tick_dev_program_event+0x25/0xf5
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.070717]  [<ffffffff8107ad49>] tick_program_event+0x1f/0x21
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.080320]  [<ffffffff81070ba7>] hrtimer_interrupt+0x109/0x197
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.089955]  [<ffffffff81070c6c>] __hrtimer_peek_ahead_timers+0x37/0x39
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.100214]  [<ffffffff81070c8e>] hrtimer_peek_ahead_timers+0x20/0x2b
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.110276]  [<ffffffff81070ca7>] run_hrtimer_softirq+0xe/0x10
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.119704]  [<ffffffff8105757a>] __do_softirq+0xc9/0x1b6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.128685]  [<ffffffff810576e6>] run_ksoftirqd+0x7f/0x11d
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.137729]  [<ffffffff81057667>] ? __do_softirq+0x1b6/0x1b6
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.146935]  [<ffffffff8106ceea>] kthread+0x82/0x8a
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.155339]  [<ffffffff814dd1b4>] kernel_thread_helper+0x4/0x10
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.164789]  [<ffffffff8106ce68>] ? kthread_worker_fn+0x14b/0x14b
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.174457]  [<ffffffff814dd1b0>] ? gs_change+0x13/0x13
20110823.log:Aug 23 17:09:21 console1 port05  RXDATA: [146979.183250] ---[ end trace 178d61af15d42ccb ]---
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.550621] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.558776] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.570148] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.578075] Watchdog detected hard LOCKUP on cpu 10
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.582909] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:30 console1 port05  RXDATA: [146988.637003] Pid: 4748, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.647881] Call Trace:
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.654404]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.665083]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.674792]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.685126]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.695122]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.704170]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.714595]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.724228]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.734054]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.743834]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.753384]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.763504]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.772219]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.780653]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.788715]  <<EOE>> 
20110823.log:Aug 23 17:09:31 console1 port05  RXDATA: [146988.790929] ---[ end trace 178d61af15d42ccc ]---
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.073402] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.081577] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.092881] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.100795] Watchdog detected hard LOCKUP on cpu 8
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.105539] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.159535] Pid: 4771, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.170342] Call Trace:
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.176836]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.187614]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.197432]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.208087]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.218528]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.228120]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.239044]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.249149]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.259519]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.269847]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.280005]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.290770]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.300078]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.309090]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.317691]  <<EOE>> 
20110823.log:Aug 23 17:09:45 console1 port05  RXDATA: [147003.319897] ---[ end trace 178d61af15d42ccd ]---
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.894083] ------------[ cut here ]------------
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.902532] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.914153] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.922169] Watchdog detected hard LOCKUP on cpu 14
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.927001] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.981078] Pid: 4682, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.991987] Call Trace:
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147014.998492]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.009284]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.019198]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.029862]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.040266]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.049796]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.060684]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.070789]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.081132]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.091495]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.101578]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.112311]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.121687]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.130701]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.139308]  <<EOE>> 
20110823.log:Aug 23 17:09:57 console1 port05  RXDATA: [147015.141531] ---[ end trace 178d61af15d42cce ]---
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.268508] ------------[ cut here ]------------
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.276969] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.288552] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.296523] Watchdog detected hard LOCKUP on cpu 3
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.301268] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.355381] Pid: 4676, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.366256] Call Trace:
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.372770]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.383527]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.393450]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.404162]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.414568]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.424058]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.434863]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.444979]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.455327]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.465736]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.475799]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.486525]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.495855]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.504844]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.513420]  <<EOE>> 
20110823.log:Aug 23 17:10:06 console1 port05  RXDATA: [147024.515626] ---[ end trace 178d61af15d42ccf ]---
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.906597] ------------[ cut here ]------------
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.915046] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.926669] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.934685] Watchdog detected hard LOCKUP on cpu 2
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.939430] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147033.993555] Pid: 1993, comm: automount Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.004553] Call Trace:
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.011107]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.021906]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.031829]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.042491]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.052898]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.062390]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.073239]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.083355]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.093659]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.104023]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.114092]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.124866]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.134251]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.143269]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.151885]  [<ffffffff8107ecc3>] ? sys_futex+0x91/0x146
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.161324]  <<EOE>>  [<ffffffff814db042>] system_call_fastpath+0x16/0x1b
20110823.log:Aug 23 17:10:16 console1 port05  RXDATA: [147034.172157] ---[ end trace 178d61af15d42cd0 ]---
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.624844] ------------[ cut here ]------------
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.633296] WARNING: at kernel/watchdog.c:241 watchdog_overflow_callback+0x9b/0xa6()
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.644875] Hardware name: ProLiant DL380 G6
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.652917] Watchdog detected hard LOCKUP on cpu 4
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.657661] Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase ipmi_devintf autofs4 8021q garp stp llc ipt_LOG iptable_mangle uinput ipmi_si pcspkr hpilo ipmi_msghandler hpwdt iTCO_wdt iTCO_vendor_support i7core_edac edac_core acpi_power_meter bnx2 serio_raw microcode xfs hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.711976] Pid: 4752, comm: sendmail Tainted: G        W   3.1.0-rc2+ #2
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.722945] Call Trace:
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.729548]  <NMI>  [<ffffffff81051667>] warn_slowpath_common+0x85/0x9d
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.740391]  [<ffffffff81051722>] warn_slowpath_fmt+0x46/0x48
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.750360]  [<ffffffff810aa330>] watchdog_overflow_callback+0x9b/0xa6
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.761078]  [<ffffffff810d4b12>] __perf_event_overflow+0x100/0x182
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.771529]  [<ffffffff81072703>] ? local_clock+0x27/0x2f
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.781156]  [<ffffffff810d2eef>] ? perf_event_update_userpage+0x11/0xa5
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.792097]  [<ffffffff810d51a0>] perf_event_overflow+0x14/0x16
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.802280]  [<ffffffff8101f673>] intel_pmu_handle_irq+0x387/0x3e6
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.812696]  [<ffffffff814d5e86>] perf_event_nmi_handler+0x46/0x91
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.823116]  [<ffffffff814d7b4f>] notifier_call_chain+0x37/0x63
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.833328]  [<ffffffff814d7ba7>] atomic_notifier_call_chain+0x18/0x1a
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.844157]  [<ffffffff814d7bd7>] notify_die+0x2e/0x30
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.853550]  [<ffffffff814d5421>] do_nmi+0x6f/0x218
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.862626]  [<ffffffff814d5130>] nmi+0x20/0x30
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.871332]  <<EOE>> 
20110823.log:Aug 23 17:10:34 console1 port05  RXDATA: [147051.873537] ---[ end trace 178d61af15d42cd1 ]---
20110823.log:Aug 23 17:18:30 console1 port05  RXDATA: [147526.880360] NMI: PCI system error (SERR) for reason a1 on CPU 0.
20110823.log:Aug 23 17:18:30 console1 port05  RXDATA: [147526.890196] Dazed and confused, but trying to continue
20110823.log:Aug 23 17:18:40 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DCD -> 0  
20110823.log:Aug 23 17:18:40 console1 port05  SIGNAL: DCD=off
20110823.log:Aug 23 17:18:40 console1 portmanager[1635]: INFO     portmanager - /dev/port05: CTS -> 0  
20110823.log:Aug 23 17:18:40 console1 port05  SIGNAL: CTS=off
20110823.log:Aug 23 17:18:40 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DSR -> 0  
20110823.log:Aug 23 17:18:40 console1 port05  SIGNAL: DSR=off
20110823.log:Aug 23 17:19:46 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DCD -> 1  
20110823.log:Aug 23 17:19:46 console1 port05  SIGNAL: DCD=on
20110823.log:Aug 23 17:19:46 console1 portmanager[1635]: INFO     portmanager - /dev/port05: CTS -> 1  
20110823.log:Aug 23 17:19:46 console1 port05  SIGNAL: CTS=on
20110823.log:Aug 23 17:19:46 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DSR -> 1  
20110823.log:Aug 23 17:19:46 console1 port05  SIGNAL: DSR=on
20110823.log:Aug 23 17:19:47 console1 port05  RXDATA: ^@^@^@^@^@^@^@^@^@^@^@^@^@^@
20110823.log:Aug 23 17:19:48 console1 port05  RXDATA: %E0%E0^@%E0%E0%E0%E0%E0%E0%E0^@^@%E0%E0
20110823.log:Aug 23 17:19:49 console1 port05  RXDATA: %FC~%80%FC|%8E^\%FCp%F0%FC%FE
20110823.log:Aug 23 17:19:50 console1 port05  RXDATA: %9E`%9Ef%F3^L%9E
20110823.log:Aug 23 17:19:51 console1 port05  RXDATA: ^[[5n
20110823.log:Aug 23 17:21:11 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:11 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:12 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:13 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:14 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:15 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:16 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:17 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:18 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:19 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:19 console1 port05  RXDATA: ^[[H^[[J
20110823.log:Aug 23 17:21:19 console1 port05  RXDATA: Press any key to enter the menu
20110823.log:Aug 23 17:21:20 console1 port05  RXDATA: Booting Boot system as if hera (master) in 4 seconds...
20110823.log:Aug 23 17:21:21 console1 port05  RXDATA: Booting Boot system as if hera (master) in 3 seconds...
20110823.log:Aug 23 17:21:22 console1 port05  RXDATA: Booting Boot system as if hera (master) in 2 seconds...
20110823.log:Aug 23 17:21:23 console1 port05  RXDATA: Booting Boot system as if hera (master) in 1 seconds...
20110823.log:Aug 23 17:21:24 console1 port05  RXDATA: Booting Boot system as if hera (master) in 0 seconds...
20110823.log:Aug 23 17:21:24 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:25 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:26 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:27 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:28 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:29 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:30 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:31 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:32 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:33 console1 port05  RXDATA: Press any key to continue.
20110823.log:Aug 23 17:21:33 console1 port05  RXDATA: ^[[H^[[J
20110823.log:Aug 23 17:21:33 console1 port05  RXDATA: Press any key to enter the menu
20110823.log:Aug 23 17:21:34 console1 port05  RXDATA: Booting Fedora (3.1.0-rc2+) in 4 seconds...
20110823.log:Aug 23 17:21:35 console1 port05  RXDATA: Booting Fedora (3.1.0-rc2+) in 3 seconds...
20110823.log:Aug 23 17:21:36 console1 port05  RXDATA: Booting Fedora (3.1.0-rc2+) in 2 seconds...
20110823.log:Aug 23 17:21:37 console1 port05  RXDATA: Booting Fedora (3.1.0-rc2+) in 1 seconds...
20110823.log:Aug 23 17:21:38 console1 port05  RXDATA: Booting Fedora (3.1.0-rc2+) in 0 seconds...
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Initializing cgroup subsys cpuset
20110823.log:Aug 23 17:21:41 console1 portmanager[1635]: INFO     portmanager - /dev/port05: CTS -> 0  
20110823.log:Aug 23 17:21:41 console1 port05  SIGNAL: CTS=off
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Initializing cgroup subsys cpu
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Linux version 3.1.0-rc2+ (root@odin2.kernel.org) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #2 SMP Wed Aug 17 22:36:03 UTC 2011
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Command line: ro root=LABEL=rootfs1 consoleblank=0 console=tty0 console=ttyS0,115200n8 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us intel_iommu=off
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] BIOS-provided physical RAM map:
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000df62f000 (usable)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 00000000df62f000 - 00000000df63c000 (ACPI data)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 00000000df63c000 - 00000000df63d000 (usable)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 00000000df63d000 - 00000000e4000000 (reserved)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fee10000 (reserved)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]  BIOS-e820: 0000000100000000 - 000000081ffff000 (usable)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] NX (Execute Disable) protection: active
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] DMI 2.6 present.
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] No AGP bridge found
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] last_pfn = 0x81ffff max_arch_pfn = 0x400000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] last_pfn = 0xdf63d max_arch_pfn = 0x400000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] init_memory_mapping: 0000000000000000-00000000df63d000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] init_memory_mapping: 0000000100000000-000000081ffff000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] RAMDISK: 30efa000 - 37ff0000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: XSDT 00000000df630040 000BC (v01 HP     ProLiant 00000002   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: FACP 00000000df630140 000F4 (v03 HP     ProLiant 00000002   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32, using default 16 (20110623/tbfadt-610)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI Warning: Invalid length for Pm2ControlBlock: 32, using default 8 (20110623/tbfadt-610)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: DSDT 00000000df630240 02005 (v01 HP         DSDT 00000001 INTL 20030228)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: FACS 00000000df62f100 00040
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SPCR 00000000df62f140 00050 (v01 HP     SPCRRBSU 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: MCFG 00000000df62f1c0 0003C (v01 HP     ProLiant 00000001      00000000)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: HPET 00000000df62f200 00038 (v01 HP     ProLiant 00000002   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: FFFF 00000000df62f240 00064 (v02 HP     ProLiant 00000002   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SPMI 00000000df62f2c0 00040 (v05 HP     ProLiant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: ERST 00000000df62f300 001D0 (v01 HP     ProLiant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: APIC 00000000df62f500 0015E (v01 HP     ProLiant 00000002      00000000)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SRAT 00000000df62f680 00570 (v01 HP     Proliant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: FFFF 00000000df62fc00 00176 (v01 HP     ProLiant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: BERT 00000000df62fd80 00030 (v01 HP     ProLiant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: HEST 00000000df62fdc0 000BC (v01 HP     ProLiant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: DMAR 00000000df62fe80 00134 (v01 HP     ProLiant 00000001   %D2? 0000162E)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SSDT 00000000df632280 00125 (v03     HP  CRSPCI0 00000002   HP 00000001)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SSDT 00000000df6323c0 00255 (v03     HP  riser1a 00000002 INTL 20061109)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SSDT 00000000df632640 0025D (v03     HP  riser2a 00000002 INTL 20061109)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SSDT 00000000df6328c0 003BB (v01     HP      pcc 00000001 INTL 20090625)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SSDT 00000000df632c80 00377 (v01     HP     pmab 00000001 INTL 20090625)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: SSDT 00000000df633000 02B64 (v01  INTEL PPM RCM  00000001 INTL 20061109)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x10 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x11 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x12 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x13 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x14 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x15 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x16 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: PXM 1 -> APIC 0x17 -> Node 1
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: Node 0 PXM 0 0-e0000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: Node 0 PXM 0 100000000-420000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SRAT: Node 1 PXM 1 420000000-820000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] NUMA: Node 0 [0,e0000000) + [100000000,420000000) -> [0,420000000)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Initmem setup node 0 0000000000000000-0000000420000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]   NODE_DATA [000000041ffec000 - 000000041fffffff]
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Initmem setup node 1 0000000420000000-000000081ffff000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]   NODE_DATA [000000081ffc8000 - 000000081ffdbfff]
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Zone PFN ranges:
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]   DMA      0x00000010 -> 0x00001000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]   DMA32    0x00001000 -> 0x00100000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]   Normal   0x00100000 -> 0x0081ffff
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Movable zone start PFN for each node
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] early_node_map[5] active PFN ranges
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]     0: 0x00000010 -> 0x0000009f
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]     0: 0x00000100 -> 0x000df62f
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]     0: 0x000df63c -> 0x000df63d
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]     0: 0x00100000 -> 0x00420000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000]     1: 0x00420000 -> 0x0081ffff
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: PM-Timer IO Port: 0x908
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Using ACPI (MADT) for SMP configuration information
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SMP: Allowing 32 CPUs, 16 hotplug CPUs
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000df62f000 - 00000000df63c000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000df63d000 - 00000000e4000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fee10000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ff800000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Booting paravirtualized kernel on bare hardware
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:32 nr_node_ids:2
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88040fc00000 s81472 r8192 d20928 u131072
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 8252857
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Policy zone: Normal
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Kernel command line: ro root=LABEL=rootfs1 consoleblank=0 console=tty0 console=ttyS0,115200n8 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us intel_iommu=off
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Intel-IOMMU: disabled
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Checking aperture...
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] No AGP bridge found
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Memory: 32819696k/34078716k available (4991k kernel code, 534788k absent, 724232k reserved, 6671k data, 956k init)
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=2
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Hierarchical RCU implementation.
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] NR_IRQS:33024 nr_irqs:1344 16
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Extended CMOS year: 2000
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] Console: colour VGA+ 80x25
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] console [tty0] enabled
20110823.log:Aug 23 17:21:41 console1 port05  RXDATA: [    0.000000] console [ttyS0] enabled
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.000000] allocated 268435456 bytes of page_cgroup
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.000000] Fast TSC calibration using PIT
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.001000] Detected 2666.658 MHz processor.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.000008] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.31 BogoMIPS (lpj=2666658)
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.011313] pid_max: default: 32768 minimum: 301
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.016327] Security Framework initialized
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.020767] SELinux:  Initializing.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.027904] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.042938] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.053539] Mount-cache hash table entries: 256
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.058638] Initializing cgroup subsys cpuacct
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.063431] Initializing cgroup subsys memory
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.068158] Initializing cgroup subsys devices
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.072945] Initializing cgroup subsys freezer
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.077728] Initializing cgroup subsys net_cls
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.082514] Initializing cgroup subsys blkio
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.087134] Initializing cgroup subsys perf_event
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.092219] CPU: Physical Processor ID: 0
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.096472] CPU: Processor Core ID: 0
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.100480] mce: CPU supports 9 MCE banks
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.104839] CPU0: Thermal monitoring enabled (TM1)
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.109973] using mwait in idle threads.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.114505] ACPI: Core revision 20110623
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.121708] ftrace: allocating 26240 entries in 103 pages
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.134165] DMAR: Host address width 39
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.138339] DMAR: DRHD base: 0x000000e7ffe000 flags: 0x1
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.143996] IOMMU 0: reg_base_addr e7ffe000 ver 1:0 cap c90780106f0462 ecap f0207e
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.152206] DMAR: RMRR base: 0x000000df7fc000 end: 0x000000df7fdfff
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.158815] DMAR: RMRR base: 0x000000df7f5000 end: 0x000000df7fafff
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.165395] DMAR: RMRR base: 0x000000df63e000 end: 0x000000df63ffff
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.172005] DMAR: ATSR flags: 0x0
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.175760] IOAPIC id 8 under DRHD base  0xe7ffe000 IOMMU 0
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.181666] IOAPIC id 0 under DRHD base  0xe7ffe000 IOMMU 0
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.187724] Enabled Interrupt-remapping
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.191898] Switched APIC routing to physical flat.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.197580] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.213926] CPU0: Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz stepping 05
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.323209] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Broken BIOS detected, complain to your hardware vendor.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.336986] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is 330)
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.345358] Intel PMU driver.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.348655] ... version:                3
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.352996] ... bit width:              48
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.357423] ... generic registers:      4
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.361761] ... value mask:             0000ffffffffffff
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.367408] ... max period:             000000007fffffff
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.373015] ... fixed-purpose events:   3
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.377356] ... event mask:             000000070000000f
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.383729] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.389731] Booting Node   1, Processors  #1
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.485288] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.491284]  Ok.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.493453] Booting Node   0, Processors  #2
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.589303] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.595310]  Ok.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.597477] Booting Node   1, Processors  #3
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.693255] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.699235]  Ok.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.701405] Booting Node   0, Processors  #4
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.797204] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.803228]  Ok.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.805389] Booting Node   1, Processors  #5
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.901232] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:42 console1 port05  RXDATA: [    0.907222]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    0.909328] Booting Node   0, Processors  #6
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.005182] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.011196]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.013278] Booting Node   1, Processors  #7
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.109205] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.115187]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.117270] Booting Node   0, Processors  #8
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.213173] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.219185]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.221267] Booting Node   1, Processors  #9
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.317131] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.323118]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.325200] Booting Node   0, Processors  #10
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.421145] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.427162]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.429273] Booting Node   1, Processors  #11
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.525112] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.531088]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.533233] Booting Node   0, Processors  #12
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.629071] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.635094]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.637269] Booting Node   1, Processors  #13
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.733083] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.739067]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.741239] Booting Node   0, Processors  #14
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.837090] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.843100]  Ok.
20110823.log:Aug 23 17:21:43 console1 port05  RXDATA: [    1.845266] Booting Node   1, Processors  #15
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.941107] NMI watchdog enabled, takes one hw-pmu counter.
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.947035] Brought up 16 CPUs
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.950427] Total of 16 processors activated (85321.79 BogoMIPS).
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.967728] devtmpfs: initialized
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.977207] RTC time: 17:21:44, date: 08/23/11
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.981968] NET: Registered protocol family 16
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.986914] ACPI: bus type pci registered
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    1.991325] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.001273] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.013819] PCI: Using configuration type 1 for base access
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.019738] PCI: HP ProLiant DL380 detected, enabling pci=bfsort.
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.027765] bio: create slab <bio-0> at 0
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.032224] ACPI: Added _OSI(Module Device)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.036745] ACPI: Added _OSI(Processor Device)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.041528] ACPI: Added _OSI(3.0 _SCP Extensions)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.046573] ACPI: Added _OSI(Processor Aggregator Device)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.053029] ACPI Error: Field [CDW3] at 96 exceeds Buffer [NULL] size 64 (bits) (20110623/dsopcode-236)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.063158] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff880805c22f28), AE_AML_BUFFER_LIMIT (20110623/psparse-536)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.079076] ACPI: Interpreter enabled
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.083071] ACPI: (supports S0 S4 S5)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.087198] ACPI: Using IOAPIC for interrupt routing
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.095997] ACPI: No dock devices found.
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.100260] HEST: Table parsing has been initialized.
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.105650] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.115445] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-19])
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.122001] pci_root PNP0A08:00: host bridge window [mem 0xe7000000-0xfbffffff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.129953] pci_root PNP0A08:00: host bridge window [io  0x1000-0x6fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.136907] pci_root PNP0A08:00: host bridge window [io  0x0000-0x03af]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.143863] pci_root PNP0A08:00: host bridge window [io  0x03e0-0x0cf7]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.150819] pci_root PNP0A08:00: host bridge window [io  0x0d00-0x0fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.157776] pci_root PNP0A08:00: host bridge window [mem 0xfed00000-0xfed03fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.165716] pci_root PNP0A08:00: host bridge window [mem 0xfed00000-0xfed44fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.173625] pci_root PNP0A08:00: host bridge window [io  0x03b0-0x03bb]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.180579] pci_root PNP0A08:00: host bridge window [io  0x03c0-0x03df]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.187541] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.195483] pci_root PNP0A08:00: host bridge window expanded to [mem 0xfed00000-0xfed44fff]; [mem 0xfed00000-0xfed44fff] ignored
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.210933] pci 0000:00:01.0: PCI bridge to [bus 04-04]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.216537] pci 0000:00:02.0: PCI bridge to [bus 05-05]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.223938] pci 0000:00:03.0: PCI bridge to [bus 10-12]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.229540] pci 0000:00:04.0: PCI bridge to [bus 13-13]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.235137] pci 0000:00:05.0: PCI bridge to [bus 14-16]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.240736] pci 0000:00:06.0: PCI bridge to [bus 17-19]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.246335] pci 0000:00:07.0: PCI bridge to [bus 0d-0f]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.251937] pci 0000:00:08.0: PCI bridge to [bus 0a-0c]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.258940] pci 0000:00:09.0: PCI bridge to [bus 07-09]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.264539] pci 0000:00:0a.0: PCI bridge to [bus 06-06]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.271951] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.278953] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.285141] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.293225]  pci0000:00: Requesting ACPI _OSC control (0x1d)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.299229]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.308400] ACPI _OSC control for PCIe not granted, disabling ASPM
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.319382] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *7 10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.325760] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 *11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.332227] ACPI: PCI Interrupt Link [LNKC] (IRQs *5 7 10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.338612] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.344994] ACPI: PCI Interrupt Link [LNKE] (IRQs *5 7 10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.351381] ACPI: PCI Interrupt Link [LNKF] (IRQs 5 7 *10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.357755] ACPI: PCI Interrupt Link [LNKG] (IRQs 5 7 *10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.371163] ACPI: PCI Interrupt Link [LNKH] (IRQs 5 *7 10 11)
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.377635] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.386367] vgaarb: loaded
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.389406] vgaarb: bridge control possible 0000:01:03.0
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.395124] SCSI subsystem initialized
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.399294] usbcore: registered new interface driver usbfs
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.405128] usbcore: registered new interface driver hub
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.410805] usbcore: registered new device driver usb
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.416269] PCI: Using ACPI for IRQ routing
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.421751] PCI: Discovered peer bus 3e
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.426737] PCI: Discovered peer bus 3f
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.431991] NetLabel: Initializing
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.435724] NetLabel:  domain hash size = 128
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.440420] NetLabel:  protocols = UNLABELED CIPSOv4
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.445730] NetLabel:  unlabeled traffic allowed by default
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.451642] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.459033] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.464727] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.485107] Switching to clocksource hpet
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.489958] Switched to NOHz mode on CPU #9
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.489967] Switched to NOHz mode on CPU #0
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.489973] Switched to NOHz mode on CPU #11
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.489977] Switched to NOHz mode on CPU #13
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.489989] Switched to NOHz mode on CPU #1
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.489994] Switched to NOHz mode on CPU #3
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490002] Switched to NOHz mode on CPU #5
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490007] Switched to NOHz mode on CPU #7
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490031] Switched to NOHz mode on CPU #12
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490034] Switched to NOHz mode on CPU #15
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490037] Switched to NOHz mode on CPU #4
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490043] Switched to NOHz mode on CPU #6
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490062] Switched to NOHz mode on CPU #8
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490070] Switched to NOHz mode on CPU #10
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490080] Switched to NOHz mode on CPU #14
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.490093] Switched to NOHz mode on CPU #2
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497174] pnp: PnP ACPI init
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497184] ACPI: bus type pnp registered
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497548] system 00:01: [io  0x0408-0x040f] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497550] system 00:01: [io  0x04d0-0x04d1] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497552] system 00:01: [io  0x0700-0x071f] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497554] system 00:01: [io  0x0880-0x08ff] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497556] system 00:01: [io  0x0900-0x097f] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497557] system 00:01: [io  0x0c80-0x0c83] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497559] system 00:01: [io  0x0cd4-0x0cd7] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497561] system 00:01: [io  0x0f50-0x0f58] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497563] system 00:01: [io  0x0ca0-0x0ca1] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497565] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497567] system 00:01: [io  0x02f8-0x02ff] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497569] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497571] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.497573] system 00:01: [mem 0xe7ffe000-0xe7ffffff] has been reserved
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.498324] pnp: PnP ACPI: found 11 devices
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.498325] ACPI: ACPI bus type pnp unregistered
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506035] pci 0000:00:01.0: BAR 15: assigned [mem 0xe7000000-0xe70fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506037] pci 0000:00:03.0: BAR 15: assigned [mem 0xe7100000-0xe71fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506039] pci 0000:00:09.0: BAR 15: assigned [mem 0xe7200000-0xe72fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506042] pci 0000:00:1c.0: BAR 15: assigned [mem 0xe7300000-0xe73fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506044] pci 0000:00:1c.2: BAR 15: assigned [mem 0xe7400000-0xe74fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506046] pci 0000:04:00.0: BAR 6: assigned [mem 0xe7000000-0xe707ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506048] pci 0000:00:01.0: PCI bridge to [bus 04-04]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506050] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506053] pci 0000:00:01.0:   bridge window [mem 0xfab00000-0xfaffffff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506056] pci 0000:00:01.0:   bridge window [mem 0xe7000000-0xe70fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506060] pci 0000:00:02.0: PCI bridge to [bus 05-05]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506067] pci 0000:10:00.0: BAR 6: assigned [mem 0xe7100000-0xe717ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506069] pci 0000:00:03.0: PCI bridge to [bus 10-12]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506071] pci 0000:00:03.0:   bridge window [io  0x6000-0x6fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506074] pci 0000:00:03.0:   bridge window [mem 0xfbb00000-0xfbffffff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506077] pci 0000:00:03.0:   bridge window [mem 0xe7100000-0xe71fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506081] pci 0000:00:04.0: PCI bridge to [bus 13-13]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506087] pci 0000:00:05.0: PCI bridge to [bus 14-16]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506094] pci 0000:00:06.0: PCI bridge to [bus 17-19]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506101] pci 0000:00:07.0: PCI bridge to [bus 0d-0f]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506107] pci 0000:00:08.0: PCI bridge to [bus 0a-0c]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506114] pci 0000:07:00.0: BAR 6: assigned [mem 0xe7200000-0xe727ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506116] pci 0000:00:09.0: PCI bridge to [bus 07-09]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506118] pci 0000:00:09.0:   bridge window [io  0x5000-0x5fff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506121] pci 0000:00:09.0:   bridge window [mem 0xfb300000-0xfb7fffff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506124] pci 0000:00:09.0:   bridge window [mem 0xe7200000-0xe72fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506128] pci 0000:00:0a.0: PCI bridge to [bus 06-06]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506135] pci 0000:02:00.0: BAR 6: assigned [mem 0xe7300000-0xe730ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506137] pci 0000:02:00.1: BAR 6: assigned [mem 0xe7310000-0xe731ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506138] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506144] pci 0000:00:1c.0:   bridge window [mem 0xf2000000-0xf5ffffff]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506148] pci 0000:00:1c.0:   bridge window [mem 0xe7300000-0xe73fffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506154] pci 0000:03:00.0: BAR 6: assigned [mem 0xe7400000-0xe740ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506156] pci 0000:03:00.1: BAR 6: assigned [mem 0xe7410000-0xe741ffff pref]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506157] pci 0000:00:1c.2: PCI bridge to [bus 03-03]
20110823.log:Aug 23 17:21:44 console1 port05  RXDATA: [    2.506163] pci 0000:00:1c.2:   bridge window [mem 0xf6000000-0xf9ffffff]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506166] pci 0000:00:1c.2:   bridge window [mem 0xe7400000-0xe74fffff pref]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506173] pci 0000:01:03.0: BAR 6: assigned [mem 0xf1e00000-0xf1e1ffff pref]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506175] pci 0000:01:04.2: BAR 6: assigned [mem 0xf1e20000-0xf1e2ffff pref]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506177] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506179] pci 0000:00:1e.0:   bridge window [io  0x2000-0x3fff]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506183] pci 0000:00:1e.0:   bridge window [mem 0xf1e00000-0xf1ffffff]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506187] pci 0000:00:1e.0:   bridge window [mem 0xe8000000-0xefffffff 64bit pref]
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506256] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506265] pci 0000:00:1c.2: PCI INT C -> GSI 16 (level, low) -> IRQ 16
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506374] NET: Registered protocol family 2
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.506769] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.507971] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.509419] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.509581] TCP: Hash tables configured (established 524288 bind 65536)
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.509583] TCP reno registered
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.509629] UDP hash table entries: 16384 (order: 7, 524288 bytes)
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.509763] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.509994] NET: Registered protocol family 1
20110823.log:Aug 23 17:21:45 console1 port05  RXDATA: [    2.513567] Trying to unpack rootfs image as initramfs...
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.523460] Freeing initrd memory: 115672k freed
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.549063] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.555757] Placing 64MB software IO TLB between ffff8800db629000 - ffff8800df629000
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.563949] software IO TLB at phys 0xdb629000 - 0xdf629000
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.572324] audit: initializing netlink socket (disabled)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.577977] type=2000 audit(1314120104.474:1): initialized
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.655866] HugeTLB registered 2 MB page size, pre-allocated 0 pages
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.767712] VFS: Disk quotas dquot_6.5.2
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.771945] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.779106] msgmni has been set to 32768
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.783766] alg: No test for stdrng (krng)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.788129] NET: Registered protocol family 38
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.792862] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.800749] io scheduler noop registered
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.804915] io scheduler deadline registered
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.809466] io scheduler cfq registered (default)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.815060] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.820899] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.827750] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.835043] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.842896] ACPI: Power Button [PWRF]
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.848577] thermal LNXTHERM:00: registered as thermal_zone0
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.854478] ACPI: Thermal Zone [THM0] (8 C)
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.858937] ERST: Failed to get Error Log Address Range.
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.873855] GHES: Failed to enable APEI firmware first mode.
20110823.log:Aug 23 17:21:46 console1 port05  RXDATA: [    4.879845] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
20110823.log:Aug 23 17:21:47 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DCD -> 0  
20110823.log:Aug 23 17:21:47 console1 port05  SIGNAL: DCD=off
20110823.log:Aug 23 17:21:47 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DSR -> 0  
20110823.log:Aug 23 17:21:47 console1 port05  SIGNAL: DSR=off
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: %FF[    5.150940] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
20110823.log:Aug 23 17:21:47 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DCD -> 1  
20110823.log:Aug 23 17:21:47 console1 port05  SIGNAL: DCD=on
20110823.log:Aug 23 17:21:47 console1 portmanager[1635]: INFO     portmanager - /dev/port05: DSR -> 1  
20110823.log:Aug 23 17:21:47 console1 port05  SIGNAL: DSR=on
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.421944] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.449754] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.464156] Non-volatile memory driver v1.3
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.468588] Linux agpgart interface v0.103
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.475338] brd: module loaded
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.479665] loop: module loaded
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.483275] Fixed MDIO Bus: probed
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.487007] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.493819] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.501233] ehci_hcd 0000:00:1d.7: EHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.506826] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.514731] ehci_hcd 0000:00:1d.7: debug port 1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.523416] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf1df0000
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.538794] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.544806] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.551840] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.559518] usb usb1: Product: EHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.571212] usb usb1: Manufacturer: Linux 3.1.0-rc2+ ehci_hcd
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.577203] usb usb1: SerialNumber: 0000:00:1d.7
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.582070] Refined TSC clocksource calibration: 2666.761 MHz.
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588173] Switching to clocksource tsc
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588360] hub 1-0:1.0: USB hub found
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588366] hub 1-0:1.0: 8 ports detected
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588524] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588548] uhci_hcd: USB Universal Host Controller Interface driver
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588583] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588594] uhci_hcd 0000:00:1d.0: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588670] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588706] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001000
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588754] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588758] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588761] usb usb2: Product: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588763] usb usb2: Manufacturer: Linux 3.1.0-rc2+ uhci_hcd
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588765] usb usb2: SerialNumber: 0000:00:1d.0
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588909] hub 2-0:1.0: USB hub found
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.588915] hub 2-0:1.0: 2 ports detected
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589049] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589061] uhci_hcd 0000:00:1d.1: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589128] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589171] uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001020
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589211] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589215] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589217] usb usb3: Product: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589220] usb usb3: Manufacturer: Linux 3.1.0-rc2+ uhci_hcd
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589222] usb usb3: SerialNumber: 0000:00:1d.1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589353] hub 3-0:1.0: USB hub found
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589358] hub 3-0:1.0: 2 ports detected
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589488] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589499] uhci_hcd 0000:00:1d.2: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589562] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589607] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001040
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589646] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589649] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589652] usb usb4: Product: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589654] usb usb4: Manufacturer: Linux 3.1.0-rc2+ uhci_hcd
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589657] usb usb4: SerialNumber: 0000:00:1d.2
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589805] hub 4-0:1.0: USB hub found
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589810] hub 4-0:1.0: 2 ports detected
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589923] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.589934] uhci_hcd 0000:00:1d.3: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590000] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590032] uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001060
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590075] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590079] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590081] usb usb5: Product: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590084] usb usb5: Manufacturer: Linux 3.1.0-rc2+ uhci_hcd
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590086] usb usb5: SerialNumber: 0000:00:1d.3
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590212] hub 5-0:1.0: USB hub found
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590217] hub 5-0:1.0: 2 ports detected
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590338] uhci_hcd 0000:01:04.4: PCI INT B -> GSI 22 (level, low) -> IRQ 22
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590346] uhci_hcd 0000:01:04.4: UHCI Host Controller
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590419] uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 6
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.590437] uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
20110823.log:Aug 23 17:21:47 console1 port05  RXDATA: [    5.591082] uhci_hcd 0000:01:04.4: irq 22, io base 0x00003800
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591176] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591179] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591181] usb usb6: Product: UHCI Host Controller
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591184] usb usb6: Manufacturer: Linux 3.1.0-rc2+ uhci_hcd
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591186] usb usb6: SerialNumber: 0000:01:04.4
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591319] hub 6-0:1.0: USB hub found
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591324] hub 6-0:1.0: 2 ports detected
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591490] usbcore: registered new interface driver usbserial
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591501] USB Serial support registered for generic
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591521] usbcore: registered new interface driver usbserial_generic
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591523] usbserial: USB Serial Driver core
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.591578] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842007] serio: i8042 KBD port at 0x60,0x64 irq 1
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842075] mousedev: PS/2 mouse device common for all mice
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842205] rtc_cmos 00:0a: RTC can wake from S4
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842332] rtc_cmos 00:0a: rtc core: registered rtc_cmos as rtc0
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842361] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842450] device-mapper: uevent: version 1.0.3
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842528] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.842946] cpuidle: using governor ladder
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    5.892833] usb 6-1: new full speed USB device number 2 using uhci_hcd
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.034942] cpuidle: using governor menu
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.039751] EFI Variables Facility v0.08 2004-May-17
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.045136] usbcore: registered new interface driver usbhid
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.050949] usbhid: USB HID core driver
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.055094] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.061754] ip_tables: (C) 2000-2006 Netfilter Core Team
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.067771] TCP cubic registered
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.071245] Initializing XFRM netlink socket
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.075997] NET: Registered protocol family 10
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.081039] Mobile IPv6
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.083747] NET: Registered protocol family 17
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.088451] Registering the dns_resolver key type
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.093617] registered taskstats version 1
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.157245]   Magic number: 7:367:391
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.161168] hub 3-0:1.0: hash matches
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.165089] thermal cooling_device6: hash matches
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.169138] usb 6-1: New USB device found, idVendor=03f0, idProduct=1027
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.169142] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.169146] usb 6-1: Product: Virtual Keyboard
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.169148] usb 6-1: Manufacturer: HP
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.193548] rtc_cmos 00:0a: setting system clock to 2011-08-23 17:21:48 UTC (1314120108)
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.203018] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.0/input/input1
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.205685] Initializing network drop monitor service
20110823.log:Aug 23 17:21:48 console1 portmanager[1635]: INFO     portmanager - /dev/port05: CTS -> 1  
20110823.log:Aug 23 17:21:48 console1 port05  SIGNAL: CTS=on
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.219656] generic-usb 0003:03F0:1027.0001: input,hidraw0: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.236242] Freeing unused kernel memory: 956k freed
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.239662] input: HP Virtual Keyboard as /devices/pci0000:00/0000:00:1e.0/0000:01:04.4/usb6/6-1/6-1:1.1/input/input2
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.239902] generic-usb 0003:03F0:1027.0002: input,hidraw1: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.264959] Write protecting the kernel read-only data: 10240k
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.279123] Freeing unused kernel memory: 1136k freed
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.291836] Freeing unused kernel memory: 1560k freed
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.314507] dracut: dracut-006-6.fc14
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.335978] udev[141]: starting version 161
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.362395] [drm] Initialized drm 1.1.0 20060810
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.394951] [drm] radeon defaulting to kernel modesetting.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.400682] [drm] radeon kernel modesetting enabled.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.406080] radeon 0000:01:03.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.413661] [drm] initializing kernel modesetting (RV100 0x1002:0x515E 0x103C:0x31FB).
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.422268] [drm] register mmio base: 0xF1FF0000
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.427138] [drm] register mmio size: 65536
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.431697] radeon 0000:01:03.0: VRAM: 128M 0x00000000E8000000 - 0x00000000EFFFFFFF (64M used)
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.440762] radeon 0000:01:03.0: GTT: 512M 0x00000000C8000000 - 0x00000000E7FFFFFF
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.448833] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.455685] [drm] Driver supports precise vblank timestamp query.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.462062] [drm] radeon: irq initialized.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.472076] [drm] Detected VRAM RAM=128M, BAR=128M
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.477115] [drm] RAM width 16bits DDR
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.481362] [TTM] Zone  kernel: Available graphics memory: 16469510 kiB.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.488305] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.495153] [TTM] Initializing pool allocator.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.499862] [drm] radeon: 64M of VRAM memory ready
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.504953] [drm] radeon: 512M of GTT memory ready.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.510139] [drm] GART: num cpu pages 131072, num gpu pages 131072
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.537606] radeon 0000:01:03.0: WB enabled
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.542061] [drm] Loading R100 Microcode
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.548241] [drm] radeon: ring at 0x00000000C8001000
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.553612] [drm] ring test succeeded in 3 usecs
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.558749] [drm] radeon: ib pool ready.
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.564941] [drm] ib test succeeded in 0 usecs
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.569959] [drm] Radeon Display Connectors
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.574381] [drm] Connector 0:
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.577678] [drm]   VGA
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.580363] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.586605] [drm]   Encoders:
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.589813] [drm]     CRT1: INTERNAL_DAC1
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.594106] [drm] Connector 1:
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.597399] [drm]   VGA
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.600101] [drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.606343] [drm]   Encoders:
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.609548] [drm]     CRT2: INTERNAL_DAC2
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.624450] [drm] Radeon display connector VGA-1: No monitor connected or invalid EDID
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.642899] [drm] Radeon display connector VGA-2: No monitor connected or invalid EDID
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.716928] [drm] fb mappable at 0xE8040000
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.721793] [drm] vram apper at 0xE8000000
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.726146] [drm] size 786432
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.729374] [drm] fb depth is 8
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.732769] [drm]    pitch is 1024
20110823.log:Aug 23 17:21:48 console1 port05  RXDATA: [    6.736667] fbcon: radeondrmfb (fb0) is primary device
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    6.903230] Console: switching to colour frame buffer device 128x48
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    6.917349] fb0: radeondrmfb frame buffer device
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    6.922055] drm: registered panic notifier
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    6.926200] [drm] Initialized radeon 2.11.0 20080528 for 0000:01:03.0 on minor 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    6.959664] dracut: Starting plymouth daemon
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    6.997823] HP HPSA Driver (v 2.0.2-1)
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.001673] hpsa 0000:04:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.008626] hpsa 0000:04:00.0: MSIX
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.032088] hpsa 0000:04:00.0: hpsa0: <0x323a> at IRQ 67 using DAC
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.059488] scsi0 : hpsa
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.062508] hpsa 0000:07:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.069617] hpsa 0000:07:00.0: MSIX
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.074066] hpsa 0000:04:00.0: RAID              device c0b3t0l0 added.
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.081285] scsi 0:3:0:0: RAID              HP       P410i            3.00 PQ: 0 ANSI: 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.089801] scsi 0:3:0:0: Attached scsi generic sg0 type 12
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.095573] hpsa 0000:07:00.0: hpsa1: <0x323a> at IRQ 71 using DAC
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.123142] scsi1 : hpsa
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.125955] hpsa 0000:10:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.133085] hpsa 0000:10:00.0: MSIX
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.137197] hpsa 0000:07:00.0: Direct-Access     device c1b0t0l0 added.
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.143886] hpsa 0000:07:00.0: RAID              device c1b3t0l0 added.
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.150884] hpsa 0000:10:00.0: hpsa2: <0x323a> at IRQ 75 using DAC
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.157460] scsi 1:0:0:0: Direct-Access     HP       LOGICAL VOLUME   3.00 PQ: 0 ANSI: 5
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.166051] scsi 1:3:0:0: RAID              HP       P812             3.00 PQ: 0 ANSI: 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.177965] sd 1:0:0:0: Attached scsi generic sg1 type 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.178028] scsi2 : hpsa
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.192854] sd 1:0:0:0: [sda] 5858718812 512-byte logical blocks: (2.99 TB/2.72 TiB)
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.193154] scsi 1:3:0:0: Attached scsi generic sg2 type 12
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.196426] hpsa 0000:10:00.0: Direct-Access     device c2b0t0l0 added.
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.196429] hpsa 0000:10:00.0: Direct-Access     device c2b0t1l0 added.
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.196433] hpsa 0000:10:00.0: RAID              device c2b3t0l0 added.
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.197104] scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   3.00 PQ: 0 ANSI: 5
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.197534] scsi 2:0:1:0: Direct-Access     HP       LOGICAL VOLUME   3.00 PQ: 0 ANSI: 5
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.198251] scsi 2:3:0:0: RAID              HP       P812             3.00 PQ: 0 ANSI: 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.198492] sd 2:0:0:0: Attached scsi generic sg3 type 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.198806] sd 2:0:0:0: [sdb] 286677120 512-byte logical blocks: (146 GB/136 GiB)
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.198953] sd 2:0:1:0: Attached scsi generic sg4 type 0
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.199182] sd 2:0:1:0: [sdc] 1146733360 512-byte logical blocks: (587 GB/546 GiB)
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.199323] scsi 2:3:0:0: Attached scsi generic sg5 type 12
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.199672] sd 2:0:0:0: [sdb] Write Protect is off
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.200051] sd 2:0:1:0: [sdc] Write Protect is off
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.200219] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.200338] sd 2:0:1:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.201610]  sdb: sdb1 sdb2 sdb3
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.214033]  sdc: sdc1 sdc2 sdc3
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.383388] sd 1:0:0:0: [sda] Write Protect is off
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.392198] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.392497] sd 2:0:0:0: [sdb] Attached SCSI disk
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.392705] sd 2:0:1:0: [sdc] Attached SCSI disk
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.462452]  sda: sda1 sda2
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.470562] sd 1:0:0:0: [sda] Attached SCSI disk
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.661915] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.675578] SGI XFS Quota Management subsystem
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.686675] XFS (sdc3): Mounting Filesystem
20110823.log:Aug 23 17:21:49 console1 port05  RXDATA: [    7.773029] XFS (sdc3): Starting recovery (logdev: internal)
20110823.log:Aug 23 17:21:50 console1 port05  RXDATA: [    8.396585] XFS (sdc3): Ending recovery (logdev: internal)
20110823.log:Aug 23 17:21:50 console1 port05  RXDATA: [    8.440569] dracut: Remounting /dev/disk/by-label/rootfs1 with -o noatime,ro
20110823.log:Aug 23 17:21:50 console1 port05  RXDATA: [    8.460069] XFS (sdc3): Mounting Filesystem
20110823.log:Aug 23 17:21:50 console1 port05  RXDATA: [    8.516368] XFS (sdc3): Starting recovery (logdev: internal)
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    8.955868] XFS (sdc3): Ending recovery (logdev: internal)
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    8.970705] dracut: Mounted root filesystem /dev/sdc3
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    9.046192] dracut: Loading SELinux policy
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    9.212777] SELinux:  Disabled at runtime.
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    9.222183] type=1404 audit(1314120111.527:2): selinux=0 auid=4294967295 ses=4294967295
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    9.313016] dracut: /sbin/load_policy: Can't load policy: No such file or directory
20110823.log:Aug 23 17:21:51 console1 port05  RXDATA: [    9.464866] dracut: Switching root
20110823.log:Aug 23 17:21:52 console1 port05  RXDATA: [   10.858881] udev[467]: starting version 161
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.648116] microcode: CPU0 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.740694] EDAC MC: Ver: 2.1.0
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.819337] microcode: CPU1 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.830966] microcode: CPU2 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.834774] iTCO_vendor_support: vendor-support=0
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.845351] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.859886] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.861622] microcode: CPU3 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.863315] microcode: CPU4 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.864855] microcode: CPU5 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:53 console1 port05  RXDATA: [   11.866215] microcode: CPU6 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.867618] microcode: CPU7 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.869345] microcode: CPU8 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.870768] microcode: CPU9 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.872237] microcode: CPU10 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.873844] microcode: CPU11 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.875327] microcode: CPU12 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.876868] microcode: CPU13 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.878373] microcode: CPU14 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.879830] microcode: CPU15 sig=0x106a5, pf=0x1, revision=0x11
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   11.881484] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.048860] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core #1': DEV 0000:3e:03.0
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.061075] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:3e:03.0' (POLLED)
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.080436] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:3f:03.0
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.080990] power_meter ACPI000D:00: Found ACPI power meter.
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.081025] power_meter ACPI000D:00: Ignoring unsafe software power cap!
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.112916] EDAC PCI1: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:3f:03.0' (POLLED)
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.132789] EDAC i7core: Driver loaded.
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.190755] input: PC Speaker as /devices/platform/pcspkr/input/input3
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.356736] ipmi message handler version 39.2
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.383278] hpilo 0000:01:04.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.411748] IPMI System Interface driver.
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.420422] ipmi_si 0000:01:04.6: probing via PCI
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.425345] ipmi_si 0000:01:04.6: PCI INT A -> GSI 21 (level, low) -> IRQ 21
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.440855] ipmi_si 0000:01:04.6: [mem 0xf1ef0000-0xf1ef00ff] regsize 1 spacing 1 irq 21
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.453050] ipmi_si: Adding PCI-specified kcs state machine
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.462901] ipmi_si: probing via ACPI
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.469639] hpwdt 0000:01:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.480901] ipmi_si 00:02: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.491313] ipmi_si: Adding ACPI-specified kcs state machine
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.500632] ipmi_si: probing via SMBIOS
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.508014] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.517377] ipmi_si: Adding SMBIOS-specified kcs state machine
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.517423] hpwdt 0000:01:04.0: HP Watchdog Timer Driver: NMI decoding initialized, allow kernel dump: OFF (default = 0/OFF), priority: LAST (default = 0/LAST).
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.517793] hpwdt 0000:01:04.0: HP Watchdog Timer Driver: 1.3.0, timer margin: 30 seconds (nowayout=0).
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.561270]  duplicate interface
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.568279] ipmi_si: probing via SPMI
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.575658] ipmi_si: SPMI: io 0xca2 regsize 2 spacing 2 irq 0
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.585141] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.596525] ipmi_si: Trying PCI-specified kcs state machine at mem address 0xf1ef0000, slave address 0x0, irq 21
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.613738] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v2.1.11 (July 20, 2011)
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.626430] bnx2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.671364] ipmi_si 0000:01:04.6: Using irq 21
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.757211] ipmi_si 0000:01:04.6: Found new BMC (man_id: 0x00000b, prod_id: 0x0000, dev_id: 0x11)
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.770585] ipmi_si 0000:01:04.6: IPMI kcs interface initialized
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.853619] bnx2 0000:02:00.0: eth0: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem f4000000, IRQ 16, node addr 78:e7:d1:90:12:4c
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.876359] bnx2 0000:02:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
20110823.log:Aug 23 17:21:54 console1 port05  RXDATA: [   12.885136] CE: hpet increased min_delta_ns to 20113 nsec
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   12.902652] bnx2 0000:02:00.1: eth1: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem f2000000, IRQ 17, node addr 78:e7:d1:90:12:4e
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   12.926122] bnx2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   12.943432] bnx2 0000:03:00.0: eth2: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem f8000000, IRQ 18, node addr 78:e7:d1:90:12:50
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   12.967879] bnx2 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   12.984085] bnx2 0000:03:00.1: eth3: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem f6000000, IRQ 19, node addr 78:e7:d1:90:12:52
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   13.807000] kjournald starting.  Commit interval 5 seconds
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   13.807085] EXT3-fs (sdb2): using internal journal
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   13.807089] EXT3-fs (sdb2): recovery complete
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   13.807150] EXT3-fs (sdb2): mounted filesystem with ordered data mode
20110823.log:Aug 23 17:21:55 console1 port05  RXDATA: [   13.847720] XFS (sdb3): Mounting Filesystem
20110823.log:Aug 23 17:21:56 console1 port05  RXDATA: [   13.913643] XFS (sdb3): Starting recovery (logdev: internal)
20110823.log:Aug 23 17:21:56 console1 port05  RXDATA: [   14.350364] XFS (sdb3): Ending recovery (logdev: internal)
20110823.log:Aug 23 17:21:56 console1 port05  RXDATA: [   14.376525] XFS (sda1): Mounting Filesystem
20110823.log:Aug 23 17:21:56 console1 port05  RXDATA: [   14.470266] XFS (sda1): Starting recovery (logdev: internal)
20110823.log:Aug 23 17:21:57 console1 port05  RXDATA: [   15.354479] XFS (sda1): Ending recovery (logdev: internal)
20110823.log:Aug 23 17:21:58 console1 port05  RXDATA: [   16.245701] Adding 67111916k swap on /dev/sdc2.  Priority:-1 extents:1 across:67111916k 
20110823.log:Aug 23 17:21:59 console1 port05  RXDATA: [   17.428280] bnx2 0000:02:00.0: eth0: using MSIX
20110823.log:Aug 23 17:21:59 console1 port05  RXDATA: [   17.438996] ADDRCONF(NETDEV_UP): eth0: link is not ready
20110823.log:Aug 23 17:22:01 console1 port05  RXDATA: [   19.765272] bnx2 0000:02:00.1: eth1: using MSIX
20110823.log:Aug 23 17:22:01 console1 port05  RXDATA: [   19.775094] ADDRCONF(NETDEV_UP): eth1: link is not ready
20110823.log:Aug 23 17:22:02 console1 port05  RXDATA: [   20.705512] bnx2 0000:02:00.0: eth0: NIC Copper Link is Up, 1000 Mbps full duplex
20110823.log:Aug 23 17:22:02 console1 port05  RXDATA: [   20.718923] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
20110823.log:Aug 23 17:22:04 console1 port05  RXDATA: [   22.051261] 8021q: 802.1Q VLAN Support v1.8
20110823.log:Aug 23 17:22:04 console1 port05  RXDATA: [   22.099697] ADDRCONF(NETDEV_UP): eth1.1: link is not ready
20110823.log:Aug 23 17:22:05 console1 port05  RXDATA: [   23.039332] bnx2 0000:02:00.1: eth1: NIC Copper Link is Up, 1000 Mbps full duplex
20110823.log:Aug 23 17:22:05 console1 port05  RXDATA: [   23.052601] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
20110823.log:Aug 23 17:22:05 console1 port05  RXDATA: [   23.064017] ADDRCONF(NETDEV_CHANGE): eth1.1: link becomes ready
20110823.log:Aug 23 17:22:16 console1 port05  RXDATA: [   34.788424] sshd (2143): /proc/2143/oom_adj is deprecated, please use /proc/2143/oom_score_adj instead.
20110823.log:Aug 23 17:22:42 console1 port05  RXDATA: [   60.042256] hpsmhd[2648]: segfault at 700001c4f ip 00007f6182196490 sp 00007fff67259a08 error 4 in libc-2.13.so[7f6182076000+191000]
20110823.log:Aug 23 17:22:44 console1 port05  RXDATA: [   62.222136] ipmi device interface
20110823.log:Aug 23 17:22:47 console1 port05  RXDATA: [   65.728715] Fusion MPT base driver 3.04.19
20110823.log:Aug 23 17:22:47 console1 port05  RXDATA: [   65.736621] Copyright (c) 1999-2008 LSI Corporation
20110823.log:Aug 23 17:22:47 console1 port05  RXDATA: [   65.763800] Fusion MPT misc device (ioctl) driver 3.04.19
20110823.log:Aug 23 17:22:47 console1 port05  RXDATA: [   65.773190] mptctl: Registered with Fusion MPT base driver
20110823.log:Aug 23 17:22:47 console1 port05  RXDATA: [   65.782338] mptctl: /dev/mptctl @ (major,minor=10,220)
20110823.log:Aug 23 17:22:52 console1 port05  RXDATA: [   70.626511] Program Xnest tried to access /dev/mem between 0->8000000.
20110823.log:Aug 23 17:22:53 console1 port05  RXDATA: [   71.610908] Xnest[4485]: segfault at 7f51210dfaa8 ip 000000000040c544 sp 00007fffdadb5970 error 6 in .p-2.5f[400000+15000]
20110823.log:Aug 23 17:22:54 console1 port05  RXDATA: Fedora release 14 (Laughlin)
20110823.log:Aug 23 17:22:54 console1 port05  RXDATA: Kernel 3.1.0-rc2+ on an x86_64 (/dev/ttyS0)
20110823.log:Aug 23 17:22:55 console1 port05  RXDATA: hera.kernel.org login: 
20110823.log:Aug 23 17:25:01 console1 port05  RXDATA: [  199.131185] RPC: Registered named UNIX socket transport module.
20110823.log:Aug 23 17:25:01 console1 port05  RXDATA: [  199.137232] RPC: Registered udp transport module.
20110823.log:Aug 23 17:25:01 console1 port05  RXDATA: [  199.142071] RPC: Registered tcp transport module.
20110823.log:Aug 23 17:25:01 console1 port05  RXDATA: [  199.146892] RPC: Registered tcp NFSv4.1 backchannel transport module.
20110823.log:Aug 23 17:25:01 console1 port05  RXDATA: [  199.294996] FS-Cache: Loaded
20110823.log:Aug 23 17:25:01 console1 port05  RXDATA: [  199.412615] FS-Cache: Netfs 'nfs' registered for caching
20110823.log:Aug 23 17:32:53 console1 port05  RXDATA: [  671.825094] init: tty (/dev/tty1) main process ended, respawning

--------------020807040808090501040802
Content-Type: application/octet-stream;
 name="hera.2011aug22.panic.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="hera.2011aug22.panic.sig"

iEYEABECAAYFAk5T7O4ACgkQ/E3kyWU9die69ACeIktikTBefdRPcK07XF20BL+lYwYAn0eE
f6QRHj8QtpKmZVcaZcgbqtje
--------------020807040808090501040802
Content-Type: application/octet-stream;
 name="hera.2011aug23.panic.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="hera.2011aug23.panic.sig"

iEYEABECAAYFAk5T7O8ACgkQ/E3kyWU9difXugCbBdRAQhtMGZky7Z6Wobs98W+KTwUAn0Vh
BjERn7zf0aTchVsRc9SdVLwV
--------------020807040808090501040802--
