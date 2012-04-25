Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2DYOoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:44:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42150 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2DYOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:44:08 -0400
Message-ID: <1335365016.6263.28.camel@ierdnac-hp>
Subject: bluetooth oops
From: Andrei Popa <andrei.popa@i-neo.ro>
Reply-To: andrei.popa@i-neo.ro
To: linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 17:43:36 +0300
Organization: INEOSOFT
Content-Type: multipart/signed; micalg="sha512";
	protocol="application/x-pkcs7-signature";
	boundary="=-oUPBUS1E/TMyYaEW/hOc"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oUPBUS1E/TMyYaEW/hOc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


I was using kernel (Linux hp 3.3.3-pf-c236 #1 SMP PREEMPT Mon Apr 23
21:09:50 EEST 2012 x86_64 Intel(R) Core(TM) i3 CPU M 380 @ 2.53GHz
GenuineIntel GNU/Linux) with pf patchset and when I was pairing a
bluettoth phone with the computer it oopses:


BUG: unable to handle kernel paging request at 0000000100000000
IP: [<ffffffff817a42f5>] _raw_spin_lock_irqsave+0x25/0x50
PGD 0=20
Oops: 0002 [#1] PREEMPT SMP=20
CPU 2=20
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]

Pid: 15651, comm: bluetoothd Not tainted 3.3.3-pf-c236 #1
Hewlett-Packard HP ProBook 4320s/1423
RIP: 0010:[<ffffffff817a42f5>]  [<ffffffff817a42f5>]
_raw_spin_lock_irqsave+0x25/0x50
RSP: 0000:ffff8801f1143d10  EFLAGS: 00010002
RAX: 0000000000000100 RBX: 0000000100000000 RCX: 000000000000006d
RDX: 0000000000000206 RSI: ffff8801f1143d50 RDI: 0000000100000000
RBP: ffff8801f2ba08f0 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: 0000000000000000 R12: ffff8801f1143d50
R13: 0000000100000000 R14: 00007fff2cfa5880 R15: 00007fa7c6e08760
FS:  00007fa7c6db5700(0000) GS:ffff88023bc80000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000100000000 CR3: 000000010868a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bluetoothd (pid: 15651, threadinfo ffff8801f1142000, task
ffff88022a8eed70)
Stack:
ffffffff8107e3b3 0000000000000000 ffff8801f2ba08d8 0000000000000000
ffff8801f1143db0 ffff8801ef429570 ffffffff8107e82f ffff8801f1143d68
ffffffff8174abe0 ffffffff819b715b ffff8801f2ba0800 0000000000000000
atkbd serio0: Unknown key released (translated set 2, code 0xf8 on
isa0060/serio0).
atkbd serio0: Use 'setkeycodes e078 <keycode>' to make it known.
Call Trace:
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
Code: 66 0f 1f 44 00 00 9c 58 66 66 90 66 90 48 89 c2 fa 66 66 90 66 66
90 65 48 8b 04 25 88 b9 00 00 ff 80 44 e0 ff ff b8 00 01 00 00 <f0> 66
0f c1 07 0f b6 cc 38 c1 74 10 0f 1f 80 00 00 00 00 f3 90=20
RIP  [<ffffffff817a42f5>] _raw_spin_lock_irqsave+0x25/0x50
RSP <ffff8801f1143d10>
CR2: 0000000100000000
---[ end trace 16b3e5bd5fa3e8df ]---
note: bluetoothd[15651] exited with preempt_count 1
BUG: scheduling while atomic: bluetoothd/15651/0x10000002
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
Pid: 15651, comm: bluetoothd Tainted: G      D      3.3.3-pf-c236 #1
Call Trace:
[<ffffffff817a34df>] ? __schedule+0x63f/0x700
[<ffffffff81462612>] ? intel_crtc_load_lut+0x82/0xa0
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff81097b4d>] ? __cond_resched+0x1d/0x30
[<ffffffff817a361f>] ? _cond_resched+0x2f/0x40
[<ffffffff811114e7>] ? munlock_vma_pages_range+0x77/0xa0
[<ffffffff811148bd>] ? exit_mmap+0xfd/0x120
[<ffffffff8137fc30>] ? __get_user_8+0x20/0x23
[<ffffffff810c8beb>] ? exit_robust_list+0x8b/0x170
[<ffffffff8106faa9>] ? mmput+0x49/0x130
[<ffffffff81074562>] ? exit_mm+0xf2/0x110
[<ffffffff817a473b>] ? _raw_spin_unlock_irq+0xb/0x40
[<ffffffff81076343>] ? do_exit+0x683/0x880
[<ffffffff81038cab>] ? oops_end+0x7b/0xb0
[<ffffffff8105bd02>] ? no_context+0x122/0x2e0
[<ffffffff8105c6bc>] ? do_page_fault+0x2bc/0x430
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff8137e1b5>] ? string.clone.4+0x35/0xc0
[<ffffffff81093fdd>] ? up+0xd/0x40
[<ffffffff81072b0f>] ? console_unlock+0x1cf/0x240
[<ffffffff817a4d35>] ? page_fault+0x25/0x30
[<ffffffff817a42f5>] ? _raw_spin_lock_irqsave+0x25/0x50
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: bluetoothd/15651/0x00000002
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
Pid: 15651, comm: bluetoothd Tainted: G      D      3.3.3-pf-c236 #1
Call Trace:
[<ffffffff817a34df>] ? __schedule+0x63f/0x700
[<ffffffff813752af>] ? idr_remove+0x12f/0x1e0
[<ffffffff81096553>] ? __wake_up+0x43/0x70
[<ffffffff8116ff7d>] ? inotify_remove_from_idr+0x9d/0x210
[<ffffffff817a1f6b>] ? __mutex_lock_slowpath+0xfb/0x190
[<ffffffff810e1520>] ? synchronize_rcu_bh+0x40/0x40
[<ffffffff817a1daa>] ? mutex_lock+0x1a/0x40
[<ffffffff81093ccc>] ? __synchronize_srcu+0x2c/0xc0
[<ffffffff8116dec1>] ? fsnotify_put_group+0x21/0x40
[<ffffffff8116fa88>] ? inotify_release+0x18/0x20
[<ffffffff8113662d>] ? fput+0xdd/0x220
[<ffffffff811328df>] ? filp_close+0x5f/0x90
[<ffffffff81075b4d>] ? put_files_struct+0xbd/0x140
[<ffffffff81076360>] ? do_exit+0x6a0/0x880
[<ffffffff81038cab>] ? oops_end+0x7b/0xb0
[<ffffffff8105bd02>] ? no_context+0x122/0x2e0
[<ffffffff8105c6bc>] ? do_page_fault+0x2bc/0x430
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff8137e1b5>] ? string.clone.4+0x35/0xc0
[<ffffffff81093fdd>] ? up+0xd/0x40
[<ffffffff81072b0f>] ? console_unlock+0x1cf/0x240
[<ffffffff817a4d35>] ? page_fault+0x25/0x30
[<ffffffff817a42f5>] ? _raw_spin_lock_irqsave+0x25/0x50
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: bluetoothd/15651/0x00000002
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
Pid: 15651, comm: bluetoothd Tainted: G      D      3.3.3-pf-c236 #1
Call Trace:
[<ffffffff817a34df>] ? __schedule+0x63f/0x700
[<ffffffff81034365>] ? __switch_to+0x195/0x430
[<ffffffff8109d418>] ? update_cfs_shares+0x1b8/0x1c0
[<ffffffff81097046>] ? finish_task_switch+0x46/0xd0
[<ffffffff817a316b>] ? __schedule+0x2cb/0x700
[<ffffffff817a1a55>] ? schedule_timeout+0x1c5/0x220
[<ffffffff813752af>] ? idr_remove+0x12f/0x1e0
[<ffffffff817a2d0d>] ? wait_for_common+0xdd/0x190
[<ffffffff8109ab10>] ? try_to_wake_up+0x280/0x280
[<ffffffff817a1fb7>] ? __mutex_lock_slowpath+0x147/0x190
[<ffffffff810e2b00>] ? call_rcu_bh+0x20/0x20
[<ffffffff810e1520>] ? synchronize_rcu_bh+0x40/0x40
[<ffffffff8108b997>] ? wait_rcu_gp+0x47/0x60
[<ffffffff8108b9b0>] ? wait_rcu_gp+0x60/0x60
[<ffffffff810e0101>] ? show_interrupts+0x231/0x300
[<ffffffff817a1daa>] ? mutex_lock+0x1a/0x40
[<ffffffff81093d03>] ? __synchronize_srcu+0x63/0xc0
[<ffffffff8116dec1>] ? fsnotify_put_group+0x21/0x40
[<ffffffff8116fa88>] ? inotify_release+0x18/0x20
[<ffffffff8113662d>] ? fput+0xdd/0x220
[<ffffffff811328df>] ? filp_close+0x5f/0x90
[<ffffffff81075b4d>] ? put_files_struct+0xbd/0x140
[<ffffffff81076360>] ? do_exit+0x6a0/0x880
[<ffffffff81038cab>] ? oops_end+0x7b/0xb0
[<ffffffff8105bd02>] ? no_context+0x122/0x2e0
[<ffffffff8105c6bc>] ? do_page_fault+0x2bc/0x430
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff8137e1b5>] ? string.clone.4+0x35/0xc0
[<ffffffff81093fdd>] ? up+0xd/0x40
[<ffffffff81072b0f>] ? console_unlock+0x1cf/0x240
[<ffffffff817a4d35>] ? page_fault+0x25/0x30
[<ffffffff817a42f5>] ? _raw_spin_lock_irqsave+0x25/0x50
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: bluetoothd/15651/0x00000002
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
Pid: 15651, comm: bluetoothd Tainted: G      D      3.3.3-pf-c236 #1
Call Trace:
[<ffffffff817a34df>] ? __schedule+0x63f/0x700
[<ffffffff81034365>] ? __switch_to+0x195/0x430
[<ffffffff8109d418>] ? update_cfs_shares+0x1b8/0x1c0
[<ffffffff81097046>] ? finish_task_switch+0x46/0xd0
[<ffffffff817a316b>] ? __schedule+0x2cb/0x700
[<ffffffff817a1a55>] ? schedule_timeout+0x1c5/0x220
[<ffffffff813752af>] ? idr_remove+0x12f/0x1e0
[<ffffffff817a2d0d>] ? wait_for_common+0xdd/0x190
[<ffffffff8109ab10>] ? try_to_wake_up+0x280/0x280
[<ffffffff817a1fb7>] ? __mutex_lock_slowpath+0x147/0x190
[<ffffffff810e2b00>] ? call_rcu_bh+0x20/0x20
[<ffffffff810e1520>] ? synchronize_rcu_bh+0x40/0x40
[<ffffffff8108b997>] ? wait_rcu_gp+0x47/0x60
[<ffffffff8108b9b0>] ? wait_rcu_gp+0x60/0x60
[<ffffffff810e0101>] ? show_interrupts+0x231/0x300
[<ffffffff817a1daa>] ? mutex_lock+0x1a/0x40
[<ffffffff81093d17>] ? __synchronize_srcu+0x77/0xc0
[<ffffffff8116dec1>] ? fsnotify_put_group+0x21/0x40
[<ffffffff8116fa88>] ? inotify_release+0x18/0x20
[<ffffffff8113662d>] ? fput+0xdd/0x220
[<ffffffff811328df>] ? filp_close+0x5f/0x90
[<ffffffff81075b4d>] ? put_files_struct+0xbd/0x140
[<ffffffff81076360>] ? do_exit+0x6a0/0x880
[<ffffffff81038cab>] ? oops_end+0x7b/0xb0
[<ffffffff8105bd02>] ? no_context+0x122/0x2e0
[<ffffffff8105c6bc>] ? do_page_fault+0x2bc/0x430
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff8137e1b5>] ? string.clone.4+0x35/0xc0
[<ffffffff81093fdd>] ? up+0xd/0x40
[<ffffffff81072b0f>] ? console_unlock+0x1cf/0x240
[<ffffffff817a4d35>] ? page_fault+0x25/0x30
[<ffffffff817a42f5>] ? _raw_spin_lock_irqsave+0x25/0x50
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: bluetoothd/15651/0x00000002
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
Pid: 15651, comm: bluetoothd Tainted: G      D      3.3.3-pf-c236 #1
Call Trace:
[<ffffffff817a34df>] ? __schedule+0x63f/0x700
[<ffffffff81034365>] ? __switch_to+0x195/0x430
[<ffffffff8109d418>] ? update_cfs_shares+0x1b8/0x1c0
[<ffffffff81097046>] ? finish_task_switch+0x46/0xd0
[<ffffffff817a316b>] ? __schedule+0x2cb/0x700
[<ffffffff817a1a55>] ? schedule_timeout+0x1c5/0x220
[<ffffffff813752af>] ? idr_remove+0x12f/0x1e0
[<ffffffff817a2d0d>] ? wait_for_common+0xdd/0x190
[<ffffffff8109ab10>] ? try_to_wake_up+0x280/0x280
[<ffffffff817a1fb7>] ? __mutex_lock_slowpath+0x147/0x190
[<ffffffff810e2b00>] ? call_rcu_bh+0x20/0x20
[<ffffffff810e1520>] ? synchronize_rcu_bh+0x40/0x40
[<ffffffff8108b997>] ? wait_rcu_gp+0x47/0x60
[<ffffffff8108b9b0>] ? wait_rcu_gp+0x60/0x60
[<ffffffff81090101>] ? arm_timer+0x21/0x130
[<ffffffff81093d4b>] ? __synchronize_srcu+0xab/0xc0
[<ffffffff8116dec1>] ? fsnotify_put_group+0x21/0x40
[<ffffffff8116fa88>] ? inotify_release+0x18/0x20
[<ffffffff8113662d>] ? fput+0xdd/0x220
[<ffffffff811328df>] ? filp_close+0x5f/0x90
[<ffffffff81075b4d>] ? put_files_struct+0xbd/0x140
[<ffffffff81076360>] ? do_exit+0x6a0/0x880
[<ffffffff81038cab>] ? oops_end+0x7b/0xb0
[<ffffffff8105bd02>] ? no_context+0x122/0x2e0
[<ffffffff8105c6bc>] ? do_page_fault+0x2bc/0x430
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff8137e1b5>] ? string.clone.4+0x35/0xc0
[<ffffffff81093fdd>] ? up+0xd/0x40
[<ffffffff81072b0f>] ? console_unlock+0x1cf/0x240
[<ffffffff817a4d35>] ? page_fault+0x25/0x30
[<ffffffff817a42f5>] ? _raw_spin_lock_irqsave+0x25/0x50
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: bluetoothd/15651/0x10000002
Modules linked in: r8169 rt2800pci eeprom_93cx6 rt2x00pci rt2800lib
rt2x00lib mac80211 psmouse cfg80211 [last unloaded: r8169]
Pid: 15651, comm: bluetoothd Tainted: G      D      3.3.3-pf-c236 #1
Call Trace:
[<ffffffff817a34df>] ? __schedule+0x63f/0x700
[<ffffffff8114a99e>] ? dput+0x1e/0x1a0
[<ffffffff811366b2>] ? fput+0x162/0x220
[<ffffffff81097b4d>] ? __cond_resched+0x1d/0x30
[<ffffffff817a361f>] ? _cond_resched+0x2f/0x40
[<ffffffff81075b52>] ? put_files_struct+0xc2/0x140
[<ffffffff81076360>] ? do_exit+0x6a0/0x880
[<ffffffff81038cab>] ? oops_end+0x7b/0xb0
[<ffffffff8105bd02>] ? no_context+0x122/0x2e0
[<ffffffff8105c6bc>] ? do_page_fault+0x2bc/0x430
[<ffffffff8137f097>] ? vsnprintf+0x367/0x640
[<ffffffff8137e1b5>] ? string.clone.4+0x35/0xc0
[<ffffffff81093fdd>] ? up+0xd/0x40
[<ffffffff81072b0f>] ? console_unlock+0x1cf/0x240
[<ffffffff817a4d35>] ? page_fault+0x25/0x30
[<ffffffff817a42f5>] ? _raw_spin_lock_irqsave+0x25/0x50
[<ffffffff8107e3b3>] ? lock_timer_base.clone.28+0x33/0x70
[<ffffffff8107e82f>] ? del_timer+0x1f/0x80
[<ffffffff8174abe0>] ? hci_conn_del_sysfs+0x60/0xa0
[<ffffffff8173ebd0>] ? hci_conn_del+0x20/0x220
[<ffffffff8173ee40>] ? hci_conn_hash_flush+0x70/0xd0
[<ffffffff8173b1f5>] ? hci_dev_do_close+0xb5/0x2e0
[<ffffffff8173bd2b>] ? hci_dev_close+0x2b/0x70
[<ffffffff81749aa9>] ? hci_sock_ioctl+0x199/0x3d0
[<ffffffff8162aeb9>] ? sock_do_ioctl+0x29/0x60
[<ffffffff8162b1e0>] ? sock_ioctl+0x70/0x2b0
[<ffffffff811460c6>] ? do_vfs_ioctl+0x96/0x500
[<ffffffff81134da1>] ? vfs_read+0x151/0x180
[<ffffffff81146579>] ? sys_ioctl+0x49/0x80
[<ffffffff817a52b9>] ? system_call_fastpath+0x16/0x1b
usb 2-1.6: USB disconnect, device number 10

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.3.3-pf Kernel Configuration
#
CONFIG_64BIT=3Dy
# CONFIG_X86_32 is not set
CONFIG_X86_64=3Dy
CONFIG_X86=3Dy
CONFIG_INSTRUCTION_DECODER=3Dy
CONFIG_OUTPUT_FORMAT=3D"elf64-x86-64"
CONFIG_ARCH_DEFCONFIG=3D"arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_ARCH_CLOCKSOURCE_DATA=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_LATENCYTOP_SUPPORT=3Dy
CONFIG_MMU=3Dy
CONFIG_NEED_DMA_MAP_STATE=3Dy
CONFIG_NEED_SG_DMA_LENGTH=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=3Dy
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_GENERIC_TIME_VSYSCALL=3Dy
CONFIG_ARCH_HAS_CPU_RELAX=3Dy
CONFIG_ARCH_HAS_DEFAULT_IDLE=3Dy
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=3Dy
CONFIG_HAVE_SETUP_PER_CPU_AREA=3Dy
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=3Dy
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=3Dy
CONFIG_ARCH_HIBERNATION_POSSIBLE=3Dy
CONFIG_ARCH_SUSPEND_POSSIBLE=3Dy
CONFIG_ZONE_DMA32=3Dy
CONFIG_AUDIT_ARCH=3Dy
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=3Dy
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=3Dy
CONFIG_X86_64_SMP=3Dy
CONFIG_X86_HT=3Dy
CONFIG_ARCH_HWEIGHT_CFLAGS=3D"-fcall-saved-rdi -fcall-saved-rsi
-fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
-fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=3Dy
CONFIG_IRQ_WORK=3Dy

#
# General setup
#
# CONFIG_SCHED_BFS is not set
CONFIG_EXPERIMENTAL=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_CROSS_COMPILE=3D""
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=3Dy
CONFIG_HAVE_KERNEL_BZIP2=3Dy
CONFIG_HAVE_KERNEL_LZMA=3Dy
CONFIG_HAVE_KERNEL_XZ=3Dy
CONFIG_HAVE_KERNEL_LZO=3Dy
CONFIG_KERNEL_GZIP=3Dy
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME=3D"(none)"
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
CONFIG_FHANDLE=3Dy
CONFIG_TASKSTATS=3Dy
CONFIG_TASK_DELAY_ACCT=3Dy
CONFIG_TASK_XACCT=3Dy
CONFIG_TASK_IO_ACCOUNTING=3Dy
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=3Dy

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_HAVE_SPARSE_IRQ=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_GENERIC_IRQ_SHOW=3Dy
CONFIG_GENERIC_PENDING_IRQ=3Dy
CONFIG_IRQ_FORCED_THREADING=3Dy
CONFIG_SPARSE_IRQ=3Dy

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=3Dy
CONFIG_PREEMPT_RCU=3Dy
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=3D32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=3Dy
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=3Dy
CONFIG_RCU_BOOST_PRIO=3D1
CONFIG_RCU_BOOST_DELAY=3D500
CONFIG_IKCONFIG=3Dy
CONFIG_IKCONFIG_PROC=3Dy
CONFIG_LOG_BUF_SHIFT=3D15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=3Dy
CONFIG_CGROUPS=3Dy
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=3Dy
CONFIG_FAIR_GROUP_SCHED=3Dy
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=3Dy
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=3Dy
CONFIG_UTS_NS=3Dy
CONFIG_IPC_NS=3Dy
CONFIG_USER_NS=3Dy
CONFIG_PID_NS=3Dy
CONFIG_NET_NS=3Dy
CONFIG_SCHED_AUTOGROUP=3Dy
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
CONFIG_RD_GZIP=3Dy
CONFIG_RD_BZIP2=3Dy
CONFIG_RD_LZMA=3Dy
CONFIG_RD_XZ=3Dy
CONFIG_RD_LZO=3Dy
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_ANON_INODES=3Dy
# CONFIG_EXPERT is not set
CONFIG_UID16=3Dy
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=3Dy
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_PCSPKR_PLATFORM=3Dy
CONFIG_HAVE_PCSPKR_PLATFORM=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_TIMERFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_AIO=3Dy
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=3Dy

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=3Dy
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_PCI_QUIRKS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=3Dy
CONFIG_OPROFILE_NMI_TIMER=3Dy
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=3Dy
CONFIG_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_IOREMAP_PROT=3Dy
CONFIG_HAVE_KPROBES=3Dy
CONFIG_HAVE_KRETPROBES=3Dy
CONFIG_HAVE_OPTPROBES=3Dy
CONFIG_HAVE_ARCH_TRACEHOOK=3Dy
CONFIG_HAVE_DMA_ATTRS=3Dy
CONFIG_USE_GENERIC_SMP_HELPERS=3Dy
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=3Dy
CONFIG_HAVE_DMA_API_DEBUG=3Dy
CONFIG_HAVE_HW_BREAKPOINT=3Dy
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=3Dy
CONFIG_HAVE_USER_RETURN_NOTIFIER=3Dy
CONFIG_HAVE_PERF_EVENTS_NMI=3Dy
CONFIG_HAVE_ARCH_JUMP_LABEL=3Dy
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=3Dy
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=3Dy
CONFIG_HAVE_CMPXCHG_LOCAL=3Dy
CONFIG_HAVE_CMPXCHG_DOUBLE=3Dy

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=3Dy
CONFIG_RT_MUTEXES=3Dy
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_FORCE_LOAD=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
CONFIG_MODULE_SRCVERSION_ALL=3Dy
CONFIG_STOP_MACHINE=3Dy
CONFIG_BLOCK=3Dy
CONFIG_BLK_DEV_BSG=3Dy
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=3Dy
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=3Dy

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
CONFIG_CFQ_GROUP_IOSCHED=3Dy
CONFIG_IOSCHED_BFQ=3Dy
CONFIG_CGROUP_BFQIO=3Dy
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_BFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"
CONFIG_PREEMPT_NOTIFIERS=3Dy
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=3Dy
CONFIG_FREEZER=3Dy

#
# Processor type and features
#
CONFIG_ZONE_DMA=3Dy
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=3Dy
CONFIG_SMP=3Dy
CONFIG_X86_MPPARSE=3Dy
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=3Dy
CONFIG_SCHED_OMIT_FRAME_POINTER=3Dy
CONFIG_PARAVIRT_GUEST=3Dy
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=3Dy
CONFIG_KVM_GUEST=3Dy
CONFIG_PARAVIRT=3Dy
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=3Dy
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=3Dy
CONFIG_MEMTEST=3Dy
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=3Dy
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=3D6
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D6
CONFIG_X86_XADD=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_P6_NOP=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMPXCHG64=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D64
CONFIG_X86_DEBUGCTLMSR=3Dy
CONFIG_CPU_SUP_INTEL=3Dy
CONFIG_CPU_SUP_AMD=3Dy
CONFIG_CPU_SUP_CENTAUR=3Dy
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
CONFIG_DMI=3Dy
CONFIG_GART_IOMMU=3Dy
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=3Dy
CONFIG_IOMMU_HELPER=3Dy
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=3D8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=3Dy
CONFIG_IRQ_TIME_ACCOUNTING=3Dy
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=3Dy
CONFIG_PREEMPT_COUNT=3Dy
CONFIG_X86_LOCAL_APIC=3Dy
CONFIG_X86_IO_APIC=3Dy
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=3Dy
CONFIG_X86_MCE_INTEL=3Dy
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=3Dy
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=3Dy
# CONFIG_I8K is not set
CONFIG_MICROCODE=3Dy
CONFIG_MICROCODE_INTEL=3Dy
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dy
CONFIG_X86_CPUID=3Dy
CONFIG_ARCH_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ARCH_DMA_ADDR_T_64BIT=3Dy
CONFIG_DIRECT_GBPAGES=3Dy
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_DEFAULT=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_PROC_KCORE_TEXT=3Dy
CONFIG_ILLEGAL_POINTER_VALUE=3D0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_SPARSEMEM_MANUAL=3Dy
CONFIG_SPARSEMEM=3Dy
CONFIG_HAVE_MEMORY_PRESENT=3Dy
CONFIG_SPARSEMEM_EXTREME=3Dy
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy
CONFIG_HAVE_MEMBLOCK=3Dy
CONFIG_HAVE_MEMBLOCK_NODE_MAP=3Dy
CONFIG_ARCH_DISCARD_MEMBLOCK=3Dy
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=3Dy
CONFIG_SPLIT_PTLOCK_CPUS=3D4
CONFIG_COMPACTION=3Dy
CONFIG_MIGRATION=3Dy
CONFIG_PHYS_ADDR_T_64BIT=3Dy
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_VIRT_TO_BUS=3Dy
CONFIG_MMU_NOTIFIER=3Dy
CONFIG_KSM=3Dy
CONFIG_DEFAULT_MMAP_MIN_ADDR=3D4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=3Dy
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=3Dy
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=3Dy
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=3Dy
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=3D64
CONFIG_MTRR=3Dy
CONFIG_MTRR_SANITIZER=3Dy
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=3D0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=3D1
CONFIG_X86_PAT=3Dy
CONFIG_ARCH_USES_PG_UNCACHED=3Dy
CONFIG_ARCH_RANDOM=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
CONFIG_CC_STACKPROTECTOR=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250_NODEFAULT is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=3Dy
# CONFIG_HZ_1500 is not set
# CONFIG_HZ_2000 is not set
# CONFIG_HZ_3000 is not set
# CONFIG_HZ_4000 is not set
# CONFIG_HZ_5000 is not set
# CONFIG_HZ_7500 is not set
# CONFIG_HZ_10000 is not set
CONFIG_HZ=3D1000
CONFIG_SCHED_HRTICK=3Dy
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=3D0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x1000000
CONFIG_HOTPLUG_CPU=3Dy
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=3Dy

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_SUSPEND_FREEZER=3Dy
CONFIG_HIBERNATE_CALLBACKS=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D"/dev/sda5"
CONFIG_TOI_CORE=3Dy

#
# Image Storage (you need at least one allocator)
#
# CONFIG_TOI_FILE is not set
CONFIG_TOI_SWAP=3Dy

#
# General Options
#
CONFIG_TOI_CRYPTO=3Dy
CONFIG_TOI_USERUI=3Dy
CONFIG_TOI_USERUI_DEFAULT_PATH=3D"/sbin/tuxoniceui_text"
CONFIG_TOI_DEFAULT_IMAGE_SIZE_LIMIT=3D-2
# CONFIG_TOI_KEEP_IMAGE is not set
# CONFIG_TOI_REPLACE_SWSUSP is not set
# CONFIG_TOI_IGNORE_LATE_INITCALL is not set
CONFIG_TOI_DEFAULT_WAIT=3D25
CONFIG_TOI_DEFAULT_EXTRA_PAGES_ALLOWANCE=3D2000
# CONFIG_TOI_CHECKSUM is not set
CONFIG_TOI=3Dy
CONFIG_TOI_ZRAM_SUPPORT=3Dy
CONFIG_PM_SLEEP=3Dy
CONFIG_PM_SLEEP_SMP=3Dy
CONFIG_PM_RUNTIME=3Dy
CONFIG_PM=3Dy
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
CONFIG_ACPI_PROCFS=3Dy
CONFIG_ACPI_PROCFS_POWER=3Dy
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=3Dy
CONFIG_ACPI_AC=3Dy
CONFIG_ACPI_BATTERY=3Dy
CONFIG_ACPI_BUTTON=3Dy
CONFIG_ACPI_VIDEO=3Dy
CONFIG_ACPI_FAN=3Dy
CONFIG_ACPI_DOCK=3Dy
CONFIG_ACPI_PROCESSOR=3Dy
CONFIG_ACPI_HOTPLUG_CPU=3Dy
CONFIG_ACPI_PROCESSOR_AGGREGATOR=3Dy
CONFIG_ACPI_THERMAL=3Dy
CONFIG_ACPI_CUSTOM_DSDT_FILE=3D""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=3D0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=3Dy
CONFIG_X86_PM_TIMER=3Dy
CONFIG_ACPI_CONTAINER=3Dy
CONFIG_ACPI_SBS=3Dy
CONFIG_ACPI_HED=3Dy
CONFIG_ACPI_APEI=3Dy
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
CONFIG_CPU_FREQ_STAT=3Dy
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=3Dy
CONFIG_X86_ACPI_CPUFREQ=3Dy
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=3Dy
CONFIG_X86_P4_CLOCKMOD=3Dy

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=3Dy
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy
CONFIG_INTEL_IDLE=3Dy

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=3Dy
CONFIG_I7300_IDLE=3Dy

#
# Bus options (PCI etc.)
#
CONFIG_PCI=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=3Dy
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=3Dy
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=3Dy
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=3Dy
CONFIG_ARCH_SUPPORTS_MSI=3Dy
CONFIG_PCI_MSI=3Dy
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=3Dy
CONFIG_PCI_LABEL=3Dy
CONFIG_ISA_DMA_API=3Dy
CONFIG_AMD_NB=3Dy
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=3Dy
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_ACPI=3Dy
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_COMPAT_BINFMT_ELF=3Dy
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=3Dy
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=3Dy
CONFIG_IA32_EMULATION=3Dy
CONFIG_IA32_AOUT=3Dy
CONFIG_COMPAT=3Dy
CONFIG_COMPAT_FOR_U64_ALIGNMENT=3Dy
CONFIG_SYSVIPC_COMPAT=3Dy
CONFIG_KEYS_COMPAT=3Dy
CONFIG_HAVE_TEXT_POKE_SMP=3Dy
CONFIG_NET=3Dy
CONFIG_COMPAT_NETLINK_MESSAGES=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dy
CONFIG_UNIX=3Dy
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dy
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=3Dy
CONFIG_NET_KEY=3Dy
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=3Dy
CONFIG_NET_IPGRE_DEMUX=3Dy
CONFIG_NET_IPGRE=3Dy
CONFIG_NET_IPGRE_BROADCAST=3Dy
CONFIG_IP_MROUTE=3Dy
CONFIG_IP_PIMSM_V1=3Dy
CONFIG_IP_PIMSM_V2=3Dy
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=3Dy
CONFIG_INET_ESP=3Dy
CONFIG_INET_IPCOMP=3Dy
CONFIG_INET_XFRM_TUNNEL=3Dy
CONFIG_INET_TUNNEL=3Dy
CONFIG_INET_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET_XFRM_MODE_BEET=3Dy
CONFIG_INET_LRO=3Dy
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=3Dy
CONFIG_IPV6_PRIVACY=3Dy
CONFIG_IPV6_ROUTER_PREF=3Dy
CONFIG_IPV6_ROUTE_INFO=3Dy
CONFIG_IPV6_OPTIMISTIC_DAD=3Dy
CONFIG_INET6_AH=3Dy
CONFIG_INET6_ESP=3Dy
CONFIG_INET6_IPCOMP=3Dy
CONFIG_IPV6_MIP6=3Dy
CONFIG_INET6_XFRM_TUNNEL=3Dy
CONFIG_INET6_TUNNEL=3Dy
CONFIG_INET6_XFRM_MODE_TRANSPORT=3Dy
CONFIG_INET6_XFRM_MODE_TUNNEL=3Dy
CONFIG_INET6_XFRM_MODE_BEET=3Dy
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=3Dy
CONFIG_IPV6_SIT=3Dy
CONFIG_IPV6_SIT_6RD=3Dy
CONFIG_IPV6_NDISC_NODETYPE=3Dy
CONFIG_IPV6_TUNNEL=3Dy
CONFIG_IPV6_MULTIPLE_TABLES=3Dy
CONFIG_IPV6_SUBTREES=3Dy
CONFIG_IPV6_MROUTE=3Dy
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IPV6_PIMSM_V2=3Dy
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=3Dy
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dy

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=3Dy
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=3Dy
CONFIG_NETFILTER_NETLINK_LOG=3Dy
CONFIG_NF_CONNTRACK=3Dy
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=3Dy
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=3Dy
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=3Dy

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=3Dy
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
# CONFIG_NETFILTER_XT_TARGET_IMQ is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=3Dy
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=3Dy
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=3Dy
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=3Dy
# CONFIG_NETFILTER_XT_MATCH_LAYER7 is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=3Dy
CONFIG_NF_CONNTRACK_IPV4=3Dy
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=3Dy
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_RPFILTER is not set
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=3Dy
CONFIG_IP_NF_TARGET_REJECT=3Dy
CONFIG_IP_NF_TARGET_LOG=3Dy
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=3Dy
CONFIG_NF_NAT_NEEDED=3Dy
CONFIG_IP_NF_TARGET_MASQUERADE=3Dy
CONFIG_IP_NF_TARGET_NETMAP=3Dy
CONFIG_IP_NF_TARGET_REDIRECT=3Dy
CONFIG_NF_NAT_FTP=3Dy
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=3Dy
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=3Dy
CONFIG_BRIDGE=3Dy
CONFIG_BRIDGE_IGMP_SNOOPING=3Dy
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=3Dy
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=3Dy
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=3Dy
CONFIG_RFS_ACCEL=3Dy
CONFIG_XPS=3Dy
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=3Dy
CONFIG_HAVE_BPF_JIT=3Dy
CONFIG_BPF_JIT=3Dy

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=3Dy
CONFIG_BT_RFCOMM=3Dy
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dy
CONFIG_BT_BNEP_MC_FILTER=3Dy
CONFIG_BT_BNEP_PROTO_FILTER=3Dy
CONFIG_BT_HIDP=3Dy

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=3Dy
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=3Dy
CONFIG_WIRELESS=3Dy
CONFIG_WEXT_CORE=3Dy
CONFIG_WEXT_PROC=3Dy
CONFIG_CFG80211=3Dm
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=3Dy
CONFIG_WIRELESS_EXT_SYSFS=3Dy
CONFIG_LIB80211=3Dy
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=3Dm
CONFIG_MAC80211_HAS_RC=3Dy
CONFIG_MAC80211_RC_MINSTREL=3Dy
CONFIG_MAC80211_RC_MINSTREL_HT=3Dy
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=3Dy
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=3Dy
CONFIG_RFKILL_LEDS=3Dy
CONFIG_RFKILL_INPUT=3Dy
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D""
CONFIG_DEVTMPFS=3Dy
CONFIG_DEVTMPFS_MOUNT=3Dy
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=3Dy
CONFIG_FIRMWARE_IN_KERNEL=3Dy
CONFIG_EXTRA_FIRMWARE=3D"rt2860.bin"
CONFIG_EXTRA_FIRMWARE_DIR=3D"firmware"
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_CONNECTOR=3Dy
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=3Dy
CONFIG_PNP_DEBUG_MESSAGES=3Dy

#
# Protocols
#
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dy
CONFIG_BLK_DEV_LOOP_MIN_COUNT=3D8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=3Dy
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=3Dy
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=3Dm
# CONFIG_CB710_CORE is not set
# CONFIG_IWMC3200TOP is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=3Dy

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=3Dy
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=3Dy
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dy
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dy
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dy
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dy
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=3Dy
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=3Dy
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=3Dy
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=3Dy
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=3Dy
CONFIG_SATA_PMP=3Dy

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=3Dy
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=3Dy

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=3Dy

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=3Dy
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=3Dy
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dy
CONFIG_MD_AUTODETECT=3Dy
CONFIG_MD_LINEAR=3Dy
CONFIG_MD_RAID0=3Dy
CONFIG_MD_RAID1=3Dy
CONFIG_MD_RAID10=3Dy
CONFIG_MD_RAID456=3Dy
CONFIG_MULTICORE_RAID456=3Dy
CONFIG_MD_MULTIPATH=3Dy
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=3Dy
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=3Dy
CONFIG_DM_PERSISTENT_DATA=3Dy
CONFIG_DM_CRYPT=3Dy
CONFIG_DM_SNAPSHOT=3Dy
CONFIG_DM_THIN_PROVISIONING=3Dy
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_DEBUG_SPACE_MAPS is not set
CONFIG_DM_MIRROR=3Dy
CONFIG_DM_RAID=3Dy
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=3Dy
CONFIG_DM_MULTIPATH_QL=3Dy
CONFIG_DM_MULTIPATH_ST=3Dy
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
CONFIG_NET_CORE=3Dy
# CONFIG_BONDING is not set
CONFIG_DUMMY=3Dy
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=3Dy
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_IMQ is not set
CONFIG_TUN=3Dy
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_ETHERNET=3Dy
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=3Dy
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=3Dm
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=3Dy

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=3Dy
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_PPP=3Dy
CONFIG_PPP_BSDCOMP=3Dy
CONFIG_PPP_DEFLATE=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_MPPE=3Dy
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=3Dy
# CONFIG_PPTP is not set
CONFIG_PPP_ASYNC=3Dy
CONFIG_PPP_SYNC_TTY=3Dy
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dy
# CONFIG_TR is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_HSO=3Dy
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=3Dy
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMFMAC is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWM is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_RT2X00=3Dm
# CONFIG_RT2400PCI is not set
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=3Dm
CONFIG_RT2800PCI_RT33XX=3Dy
CONFIG_RT2800PCI_RT35XX=3Dy
# CONFIG_RT2800PCI_RT53XX is not set
# CONFIG_RT2500USB is not set
# CONFIG_RT73USB is not set
# CONFIG_RT2800USB is not set
CONFIG_RT2800_LIB=3Dm
CONFIG_RT2X00_LIB_PCI=3Dm
CONFIG_RT2X00_LIB=3Dm
CONFIG_RT2X00_LIB_FIRMWARE=3Dy
CONFIG_RT2X00_LIB_CRYPTO=3Dy
CONFIG_RT2X00_LIB_LEDS=3Dy
CONFIG_RT2X00_DEBUG=3Dy
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set
# CONFIG_MWIFIEX is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=3Dy
CONFIG_INPUT_SPARSEKMAP=3Dy

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D800
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=3Dy
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
CONFIG_MOUSE_PS2_ALPS=3Dy
CONFIG_MOUSE_PS2_LOGIPS2PP=3Dy
CONFIG_MOUSE_PS2_SYNAPTICS=3Dy
CONFIG_MOUSE_PS2_LIFEBOOK=3Dy
CONFIG_MOUSE_PS2_TRACKPOINT=3Dy
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=3Dy
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_CONSOLE_TRANSLATIONS=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_VT_CONSOLE_SLEEP=3Dy
CONFIG_HW_CONSOLE=3Dy
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=3Dy
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=3Dy

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=3Dy
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=3Dy
CONFIG_RTC=3Dy
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=3Dy
CONFIG_HPET_MMAP=3Dy
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
# CONFIG_RAMOOPS is not set
CONFIG_I2C=3Dy
CONFIG_I2C_BOARDINFO=3Dy
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dy
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=3Dy
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dy
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_HWMON=3Dy
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=3Dy
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=3Dy
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=3Dy
CONFIG_THERMAL_HWMON=3Dy
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=3Dy

#
# Sonics Silicon Backplane
#
CONFIG_SSB=3Dy
CONFIG_SSB_SPROM=3Dy
CONFIG_SSB_PCIHOST_POSSIBLE=3Dy
CONFIG_SSB_PCIHOST=3Dy
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=3Dy
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=3Dy
CONFIG_SSB_DRIVER_PCICORE=3Dy
CONFIG_BCMA_POSSIBLE=3Dy

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=3Dy
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=3Dy
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=3Dy
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=3Dy
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=3Dy
CONFIG_VGA_ARB_MAX_GPUS=3D16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=3Dy
CONFIG_DRM_KMS_HELPER=3Dy
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I915=3Dy
CONFIG_DRM_I915_KMS=3Dy
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_STUB_POULSBO=3Dy
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=3Dy
CONFIG_FB=3Dy
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=3Dy
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
CONFIG_LCD_CLASS_DEVICE=3Dy
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dy
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
# CONFIG_LOGO is not set
CONFIG_SOUND=3Dy
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=3Dy
CONFIG_SND_TIMER=3Dy
CONFIG_SND_PCM=3Dy
CONFIG_SND_SEQUENCER=3Dy
# CONFIG_SND_SEQ_DUMMY is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_RTCTIMER=3Dy
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=3Dy
CONFIG_SND_DYNAMIC_MINORS=3Dy
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=3Dy
CONFIG_SND_KCTL_JACK=3Dy
CONFIG_SND_DMA_SGBUF=3Dy
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_AC97_CODEC=3Dy
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=3Dy
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=3Dy
CONFIG_SND_HDA_PREALLOC_SIZE=3D64
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=3Dy
# CONFIG_SND_HDA_ENABLE_REALTEK_QUIRKS is not set
CONFIG_SND_HDA_CODEC_ANALOG=3Dy
CONFIG_SND_HDA_CODEC_SIGMATEL=3Dy
CONFIG_SND_HDA_CODEC_VIA=3Dy
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
CONFIG_SND_HDA_CODEC_CONEXANT=3Dy
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
CONFIG_SND_HDA_CODEC_CMEDIA=3Dy
CONFIG_SND_HDA_CODEC_SI3054=3Dy
CONFIG_SND_HDA_GENERIC=3Dy
CONFIG_SND_HDA_POWER_SAVE=3Dy
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3D0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=3Dy
CONFIG_SND_INTEL8X0M=3Dy
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dy
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dy
CONFIG_HID_BATTERY_STRENGTH=3Dy
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dy
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=3Dy
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=3Dy
CONFIG_HID_BELKIN=3Dy
CONFIG_HID_CHERRY=3Dy
CONFIG_HID_CHICONY=3Dy
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=3Dy
CONFIG_HID_DRAGONRISE=3Dy
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=3Dy
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=3Dy
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=3Dy
CONFIG_HID_TWINHAN=3Dy
CONFIG_HID_KENSINGTON=3Dy
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=3Dy
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=3Dy
CONFIG_HID_MONTEREY=3Dy
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=3Dy
CONFIG_HID_ORTEK=3Dy
CONFIG_HID_PANTHERLORD=3Dy
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=3Dy
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAMSUNG=3Dy
CONFIG_HID_SONY=3Dy
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=3Dy
CONFIG_HID_GREENASIA=3Dy
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=3Dy
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=3Dy
CONFIG_HID_THRUSTMASTER=3Dy
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=3Dy
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=3Dy
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_COMMON=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB_ARCH_HAS_XHCI=3Dy
CONFIG_USB=3Dy
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=3Dy
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=3Dy
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_EHCI_MV is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=3Dy
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
CONFIG_USB_UHCI_HCD=3Dm
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=3Dy
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=3Dm
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dm
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=3Dm
CONFIG_USB_SERIAL_OPTION=3Dm
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=3Dy
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=3Dy
CONFIG_MMC_BLOCK_MINORS=3D8
CONFIG_MMC_BLOCK_BOUNCE=3Dy
CONFIG_SDIO_UART=3Dy
CONFIG_MMC_TEST=3Dy

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=3Dy
CONFIG_MMC_SDHCI_PCI=3Dy
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_PLTFM=3Dy
CONFIG_MMC_WBSD=3Dy
CONFIG_MMC_TIFM_SD=3Dy
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=3Dy
CONFIG_LEDS_CLASS=3Dy

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=3Dy

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=3Dy
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=3Dy
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=3Dy

#
# DMA Clients
#
CONFIG_NET_DMA=3Dy
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=3Dy
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=3Dy
CONFIG_VIRTIO_RING=3Dy

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=3Dy
CONFIG_VIRTIO_BALLOON=3Dy
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=3Dy
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_R8187SE is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_R8712U is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
# CONFIG_IDE_PHISON is not set
# CONFIG_LINE6_USB is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_USB_SERIAL_QUATECH_USB2 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
CONFIG_XVMALLOC=3Dy
CONFIG_ZRAM=3Dy
# CONFIG_ZRAM_DEBUG is not set
# CONFIG_ZCACHE is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_X86_PLATFORM_DEVICES=3Dy
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=3Dy
CONFIG_HP_WMI=3Dy
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=3Dy
# CONFIG_MSI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=3Dy
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=3Dy
CONFIG_I8253_LOCK=3Dy
CONFIG_CLKBLD_I8253=3Dy
CONFIG_IOMMU_SUPPORT=3Dy
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dy
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dy
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=3Dy
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=3Dy
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=3Dy
CONFIG_JBD2=3Dy
CONFIG_FS_MBCACHE=3Dy
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=3Dy
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
CONFIG_EXPORTFS=3Dy
CONFIG_FILE_LOCKING=3Dy
CONFIG_FSNOTIFY=3Dy
CONFIG_DNOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
CONFIG_FANOTIFY=3Dy
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=3Dy
CONFIG_FUSE_FS=3Dy
CONFIG_CUSE=3Dy

#
# Caches
#
CONFIG_FSCACHE=3Dy
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dy
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dy
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dy
CONFIG_MSDOS_FS=3Dy
CONFIG_VFAT_FS=3Dy
CONFIG_FAT_DEFAULT_CODEPAGE=3D437
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dy
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_PROC_PAGE_MONITOR=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=3Dy
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=3Dy
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=3Dy
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=3Dy
CONFIG_LOCKD_V4=3Dy
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dy
CONFIG_SUNRPC_GSS=3Dy
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=3Dy
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"iso8859-1"
CONFIG_NLS_CODEPAGE_437=3Dy
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=3Dy
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=3D4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=3D1024
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=3Dy
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=3Dy
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=3Dy
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=3D60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=3Dy
CONFIG_HAVE_FUNCTION_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=3Dy
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=3Dy
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=3Dy
CONFIG_HAVE_DYNAMIC_FTRACE=3Dy
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=3Dy
CONFIG_HAVE_SYSCALL_TRACEPOINTS=3Dy
CONFIG_HAVE_C_RECORDMCOUNT=3Dy
CONFIG_TRACING_SUPPORT=3Dy
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=3Dy
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=3Dy
# CONFIG_KMEMCHECK is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=3Dy
CONFIG_EARLY_PRINTK=3Dy
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=3Dy
CONFIG_IO_DELAY_TYPE_0X80=3D0
CONFIG_IO_DELAY_TYPE_0XED=3D1
CONFIG_IO_DELAY_TYPE_UDELAY=3D2
CONFIG_IO_DELAY_TYPE_NONE=3D3
CONFIG_IO_DELAY_0X80=3Dy
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=3D0
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_ENCRYPTED_KEYS=3Dy
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=3Dy
CONFIG_DEFAULT_SECURITY=3D""
CONFIG_XOR_BLOCKS=3Dy
CONFIG_ASYNC_CORE=3Dy
CONFIG_ASYNC_MEMCPY=3Dy
CONFIG_ASYNC_XOR=3Dy
CONFIG_ASYNC_PQ=3Dy
CONFIG_ASYNC_RAID6_RECOV=3Dy
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=3Dy
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=3Dy
CONFIG_CRYPTO=3Dy

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=3Dy
CONFIG_CRYPTO_ALGAPI=3Dy
CONFIG_CRYPTO_ALGAPI2=3Dy
CONFIG_CRYPTO_AEAD=3Dy
CONFIG_CRYPTO_AEAD2=3Dy
CONFIG_CRYPTO_BLKCIPHER=3Dy
CONFIG_CRYPTO_BLKCIPHER2=3Dy
CONFIG_CRYPTO_HASH=3Dy
CONFIG_CRYPTO_HASH2=3Dy
CONFIG_CRYPTO_RNG=3Dy
CONFIG_CRYPTO_RNG2=3Dy
CONFIG_CRYPTO_PCOMP=3Dy
CONFIG_CRYPTO_PCOMP2=3Dy
CONFIG_CRYPTO_MANAGER=3Dy
CONFIG_CRYPTO_MANAGER2=3Dy
CONFIG_CRYPTO_USER=3Dy
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_NULL=3Dy
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=3Dy
CONFIG_CRYPTO_CRYPTD=3Dy
CONFIG_CRYPTO_AUTHENC=3Dy
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=3Dy
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=3Dy
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=3Dy
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=3Dy
CONFIG_CRYPTO_CRC32C_INTEL=3Dy
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=3Dy
CONFIG_CRYPTO_MD5=3Dy
CONFIG_CRYPTO_MICHAEL_MIC=3Dy
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=3Dy
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=3Dy
CONFIG_CRYPTO_SHA512=3Dy
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=3Dy
CONFIG_CRYPTO_AES_X86_64=3Dy
CONFIG_CRYPTO_AES_NI_INTEL=3Dy
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=3Dy
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=3Dy
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=3Dy
CONFIG_CRYPTO_TWOFISH_COMMON=3Dy
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=3Dy
CONFIG_CRYPTO_ZLIB=3Dy
CONFIG_CRYPTO_LZO=3Dy
CONFIG_CRYPTO_LZF=3Dy

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=3Dy
CONFIG_CRYPTO_USER_API=3Dy
CONFIG_CRYPTO_USER_API_HASH=3Dy
CONFIG_CRYPTO_USER_API_SKCIPHER=3Dy
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=3Dy
CONFIG_HAVE_KVM_IRQCHIP=3Dy
CONFIG_HAVE_KVM_EVENTFD=3Dy
CONFIG_KVM_APIC_ARCHITECTURE=3Dy
CONFIG_KVM_MMIO=3Dy
CONFIG_KVM_ASYNC_PF=3Dy
CONFIG_VIRTUALIZATION=3Dy
CONFIG_KVM=3Dy
CONFIG_KVM_INTEL=3Dy
# CONFIG_KVM_AMD is not set
CONFIG_VHOST_NET=3Dy
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=3Dy
CONFIG_BITREVERSE=3Dy
CONFIG_GENERIC_FIND_FIRST_BIT=3Dy
CONFIG_GENERIC_PCI_IOMAP=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_CRC_CCITT=3Dy
CONFIG_CRC16=3Dy
CONFIG_CRC_T10DIF=3Dy
CONFIG_CRC_ITU_T=3Dy
CONFIG_CRC32=3Dy
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=3Dy
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=3Dy
CONFIG_ZLIB_DEFLATE=3Dy
CONFIG_LZO_COMPRESS=3Dy
CONFIG_LZO_DECOMPRESS=3Dy
CONFIG_XZ_DEC=3Dy
CONFIG_XZ_DEC_X86=3Dy
CONFIG_XZ_DEC_POWERPC=3Dy
CONFIG_XZ_DEC_IA64=3Dy
CONFIG_XZ_DEC_ARM=3Dy
CONFIG_XZ_DEC_ARMTHUMB=3Dy
CONFIG_XZ_DEC_SPARC=3Dy
CONFIG_XZ_DEC_BCJ=3Dy
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=3Dy
CONFIG_DECOMPRESS_BZIP2=3Dy
CONFIG_DECOMPRESS_LZMA=3Dy
CONFIG_DECOMPRESS_XZ=3Dy
CONFIG_DECOMPRESS_LZO=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_CPU_RMAP=3Dy
CONFIG_DQL=3Dy
CONFIG_NLATTR=3Dy
CONFIG_AVERAGE=3Dy
# CONFIG_CORDIC is not set

--=20
Andrei Popa
NOC Manager - Nextgen Communications
0760 683 280


--=20
Andrei Popa
(+4) 0741.57.80.90

--=-oUPBUS1E/TMyYaEW/hOc
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCDu0w
ggSdMIIDhaADAgECAhA0PekrrCc0/4/LNJT7zHBUMA0GCSqGSIb3DQEBBQUAMG8xCzAJBgNVBAYT
AlNFMRQwEgYDVQQKEwtBZGRUcnVzdCBBQjEmMCQGA1UECxMdQWRkVHJ1c3QgRXh0ZXJuYWwgVFRQ
IE5ldHdvcmsxIjAgBgNVBAMTGUFkZFRydXN0IEV4dGVybmFsIENBIFJvb3QwHhcNMDUwNjA3MDgw
OTEwWhcNMjAwNTMwMTA0ODM4WjCBrjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlVUMRcwFQYDVQQH
Ew5TYWx0IExha2UgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJUUlVTVCBOZXR3b3JrMSEwHwYDVQQL
ExhodHRwOi8vd3d3LnVzZXJ0cnVzdC5jb20xNjA0BgNVBAMTLVVUTi1VU0VSRmlyc3QtQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBFbWFpbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
ALI5haTyfatBO2JGN67NwWB1vDll+UoaR6K5zEjMapjVTTUZuaRC5c5J4oovHnzSMQfHTrSDZJ0u
KdWiZMSFvYVRNXmkTmiQexx6pJKoF/KYFfKTzMmkMpW7DE8wvZigC4vlbhuiRvp4vKJvq1lepS/P
ytptqi/rrKGzaqq3Lmc1i3nhHmmI4uZGzaCl6r4LznY6eg6b6vzaJ1s9cx8i5khhxkzzabGoLhu2
1DEgLLyCio6kDqXXiUP8FlqvHXHXEVnauocNr/rz4cLwpMVnjNbWVDreCqS6A3ezZcj9HtN0YqoY
ymiTHqGFfvVHZcv4TVcodNI0/zC27vZiMBSMLOsCAwEAAaOB9DCB8TAfBgNVHSMEGDAWgBStvZh6
NLQm9/rEJlTvA73gJMtUGjAdBgNVHQ4EFgQUiYJnfcSdJnAAS7RQSHzePa4Ebn0wDgYDVR0PAQH/
BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3
oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDA1
BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJ
KoZIhvcNAQEFBQADggEBAAG8nONjKLDzMQHC33vdYqABnSMxD5ySc1NR6h9M+tafxMovZ354Mw90
FrmRh5H1iib6ZHAA2B75CwRiUIeTgdTa9SPbNLuFVrRwNG54gzcehRzFERWSX4cXvaxq/fHC0cyJ
X7F88D5R8jXzfOxgmGs6K+Dv37N9huu1G/Vb7KJ8mBPXAFC50S1z3gN4dOEFhTFey5q5nZTGuZQ3
dXLcRPtn6PD6JR5Sp9ol6UfgoMc8oE6xCjb7d0if75eK+7T+45QUqIO8XC0/0mBxYO7CcYIM6Yg2
49ogtKOgbKqWS7iAjnXKSQf2OxS639wF2Z/b4LLmTaB4JufnLW5/X8YeiBUwggUaMIIEAqADAgEC
AhBtGeqnGU9qMyLmIjJ6qnHeMA0GCSqGSIb3DQEBBQUAMIGuMQswCQYDVQQGEwJVUzELMAkGA1UE
CBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5l
dHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVT
RVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMB4XDTExMDQyODAwMDAwMFoX
DTIwMDUzMDEwNDgzOFowgZMxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0
ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQD
EzBDT01PRE8gQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCShIRbS1eY1F4vi6ThQMijU1hfZmXxMk73nzJ9VdB4
TFW3QpTg+SdxB8XGaaS5MsTxQBqQzCdWYn8XtXFpruUgG+TLY15gyqJB9mrho/+43x9IbWVDjCou
K2M4d9+xF6zC2oIC1tQyatRnbyATj1w1+uVUgK/YcQodNwoCUFNslR2pEBS0mZVZEjH/CaLSTNxS
297iQAFbSGjdxUq04O0kHzqvcV8H46y/FDuwJXFoPfQP1hdYRhWBPGiLi4MPbXohV+Y0sNsyfuNK
4aVScmQmkU6lkg//4LFg/RpvaFGZY40ai6XMQpubfSJj06mg/M6ekN9EGfRcWzW6FvOnm//BAgMB
AAGjggFLMIIBRzAfBgNVHSMEGDAWgBSJgmd9xJ0mcABLtFBIfN49rgRufTAdBgNVHQ4EFgQUehNO
AHRbxnhjZCfBL+KgW7x5xXswDgYDVR0PAQH/BAQDAgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYD
VR0gBAowCDAGBgRVHSAAMFgGA1UdHwRRME8wTaBLoEmGR2h0dHA6Ly9jcmwudXNlcnRydXN0LmNv
bS9VVE4tVVNFUkZpcnN0LUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3JsMHQGCCsGAQUF
BwEBBGgwZjA9BggrBgEFBQcwAoYxaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VUTkFkZFRydXN0
Q2xpZW50X0NBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkq
hkiG9w0BAQUFAAOCAQEAhda+eFdVbTN/RFL+QtUGqAEDgIr7DbL9Sr/2r0FJ9RtaxdKtG3NuPukm
fOZMmMEwKN/L+0I8oSU+CnXW0D05hmbRoZu1TZtvryhsHa/l6nRaqNqxwPF1ei+eupN5yv7ikR5W
dLL4jdPgQ3Ib7Y/9YDkgR/uLrzplSDyYPaUlv73vYOBJ5RbI6z9Dg/Dg7g3B080zX5vQvWBqszv+
+tTJOjwf7Zv/m0kzvkIpOYPuM2kugp1FTahp2oAbHj3SGl18R5mlmwhtEpmG1l1XBxunML5LSUS4
kH7K0Xk467Qz+qA6XSZYnmFVGLQh1ZnV4ENAQjC+6qXnlNKw/vN1+X9u5zCCBSowggQSoAMCAQIC
EQCC1iLWCNlC//08NoDW0yDKMA0GCSqGSIb3DQEBBQUAMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UE
CBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2Vj
dXJlIEVtYWlsIENBMB4XDTExMDczMDAwMDAwMFoXDTEyMDcyOTIzNTk1OVowJTEjMCEGCSqGSIb3
DQEJARYUYW5kcmVpLnBvcGFAaS1uZW8ucm8wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQDC7/8Wo7gDAqT2EkXadu9fEj4lW88MRYTy3axwSw8xnKZjAEK7opewFhj+a5VgXwS5yTSfbBl1
8wwSoApW2trvCZeUHJvQ0XTXJvfEzCjz8vJkqUu/3qNBLkxWQGq/7ZIDF7oi8fUi8qUQJutfMl9O
qfjscSAhCsbBy/Z2y3cijVVSkOJSpe7YTfO8FeOEGOR0xf2AiZ2K/4kJHNRB94L6Np7AgzAWaK/I
7kRVjnaR2ToltdvwVEwpCyLAIwdhb/M7HfpiB4pdx3zUagnF3deK+2/DpbqxkBVzIb/Jl9tC8qA5
kqcxtRBqGBQsQyj9ixaAXuxnozgl/hYulf2fcMLRAgMBAAGjggHkMIIB4DAfBgNVHSMEGDAWgBR6
E04AdFvGeGNkJ8Ev4qBbvHnFezAdBgNVHQ4EFgQUNOswJ18cdPpt45Hjk7cuY+8mZIcwDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsGAQUF
BwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBXBgNVHR8EUDBOMEygSqBIhkZodHRw
Oi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVt
YWlsQ0EuY3JsMIGIBggrBgEFBQcBAQR8MHowUgYIKwYBBQUHMAKGRmh0dHA6Ly9jcnQuY29tb2Rv
Y2EuY29tL0NPTU9ET0NsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAfBgNVHREEGDAWgRRhbmRyZWkucG9w
YUBpLW5lby5ybzANBgkqhkiG9w0BAQUFAAOCAQEAO7mdp0TD7EDtK8g3pBvTLB6RyFeN9kuskL9y
V7LSd3XMRM6nFQXDXY44mTMBKfMqIxzWdO8TNvkuBDeUsRS2XpgoHmaVYXrYOZbtTHsbDjYvOOG4
PtTqF3gvUooC3a7TylM3TdIAm4I3DFKxDDh3uJGh7d+G1tgjC0iCEh/xquZLpj/B3Mahp8QWODWb
u6Nzql/2ar8cz66JGjEjrOcSTB+zKVN6YY8o1JscMYsjKe1g4Dq0kq3NkFpSvgBzerdT7Au5haLY
+vw6WZwhMPjLdWRqd8Lk5vB0PGNOU1HpoQhsE8Wd0dr5t8S3lTnWmlHy4G6+H1XmwSkm8RxHEjAt
DzGCAmEwggJdAgEBMIGpMIGTMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UE
AxMwQ09NT0RPIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAgtYi
1gjZQv/9PDaA1tMgyjANBglghkgBZQMEAgMFAKCBiTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xMjA0MjUxNDQzMzZaME8GCSqGSIb3DQEJBDFCBECElnDkVsOBgkRM
GRJiBID7yfgefeNyewaibt5d7DR+OtSm6tRI3PIOj6UWvu5HznxtbZiS2pc+3NPrLbYQ9SVXMA0G
CSqGSIb3DQEBAQUABIIBAFR4nQDIgVQZ8GqAWkBvdmsGbJEuHBVFgDp16w3C+eWOgmChwcOnAFl5
wt7D98omePdmxSN5TcJ9wpodFU2f0FJcoQzmf5oB8oma3OqCYXJ9OYwShc6c9QpvRym9d2ZuWknG
/5vv0c22EshibmLgCyUE0KbsrVNXPDcrd7IoH4yVxoXvLPcrlF547M/u/mdszeeB02JpWB0OAQvO
GB2EzsNCzxte5RrV2I5upTbJROJhGGc6QNUNyuH5I4dTqPPaWMRtelbdz6am2Cwsp6lJG7vPYTU4
feU8OqQdDujYFL4Xtw6C34QqHTs6asF12jJr6WS35VgKeMxv9+MFZxs/+4AAAAAAAAA=


--=-oUPBUS1E/TMyYaEW/hOc--

