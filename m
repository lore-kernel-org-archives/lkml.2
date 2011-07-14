Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1GNOuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:50:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45088 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1GNOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:50:30 -0400
Date: Thu, 14 Jul 2011 17:49:46 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: INFO: possible circular locking dependency detected
Message-ID: <20110714144946.GA3354@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

[ 4172.371094] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 4172.371097] [ INFO: possible circular locking dependency detected ]
[ 4172.371103] 3.0.0-rc7-dbg-00565-g6b31efc #644
[ 4172.371105] -------------------------------------------------------
[ 4172.371108] make/11702 is trying to acquire lock:
[ 4172.371111]  (rcu_node_level_0){..-...}, at: [<ffffffff810a55e2>] __rcu_=
read_unlock+0xb9/0x217
[ 4172.371123]=20
[ 4172.371123] but task is already holding lock:
[ 4172.371125]  (&p->pi_lock){-.-.-.}, at: [<ffffffff8103775e>] try_to_wake=
_up+0x29/0x28b
[ 4172.371135]=20
[ 4172.371135] which lock already depends on the new lock.
[ 4172.371136]=20
[ 4172.371138]=20
[ 4172.371138] the existing dependency chain (in reverse order) is:
[ 4172.371141]=20
[ 4172.371141] -> #2 (&p->pi_lock){-.-.-.}:
[ 4172.371146]        [<ffffffff810717f6>] lock_acquire+0x138/0x1ac
[ 4172.371153]        [<ffffffff8147cdfe>] _raw_spin_lock_irqsave+0x4e/0x60
[ 4172.371159]        [<ffffffff8103775e>] try_to_wake_up+0x29/0x28b
[ 4172.371163]        [<ffffffff810379cd>] default_wake_function+0xd/0xf
[ 4172.371167]        [<ffffffff8105d7ad>] autoremove_wake_function+0xf/0x33
[ 4172.371173]        [<ffffffff81028d6b>] __wake_up_common+0x48/0x7e
[ 4172.371179]        [<ffffffff8102b4f4>] __wake_up+0x34/0x48
[ 4172.371183]        [<ffffffff810a54ef>] rcu_report_exp_rnp.isra.24+0x4a/=
0x84
[ 4172.371187]        [<ffffffff810a56de>] __rcu_read_unlock+0x1b5/0x217
[ 4172.371191]        [<ffffffff8105a2cd>] get_pid_task+0x71/0x7e
[ 4172.371195]        [<ffffffff811571b8>] proc_single_show+0x36/0x7c
[ 4172.371201]        [<ffffffff81124e59>] seq_read+0x17b/0x362
[ 4172.371208]        [<ffffffff81107ff1>] vfs_read+0xaa/0x13a
[ 4172.371213]        [<ffffffff811080c6>] sys_read+0x45/0x6c
[ 4172.371217]        [<ffffffff81483792>] system_call_fastpath+0x16/0x1b
[ 4172.371223]=20
[ 4172.371223] -> #1 (sync_rcu_preempt_exp_wq.lock){......}:
[ 4172.371228]        [<ffffffff810717f6>] lock_acquire+0x138/0x1ac
[ 4172.371232]        [<ffffffff8147cdfe>] _raw_spin_lock_irqsave+0x4e/0x60
[ 4172.371236]        [<ffffffff8102b4dd>] __wake_up+0x1d/0x48
[ 4172.371240]        [<ffffffff810a54ef>] rcu_report_exp_rnp.isra.24+0x4a/=
0x84
[ 4172.371244]        [<ffffffff810a56de>] __rcu_read_unlock+0x1b5/0x217
[ 4172.371248]        [<ffffffff8105a2cd>] get_pid_task+0x71/0x7e
[ 4172.371251]        [<ffffffff811571b8>] proc_single_show+0x36/0x7c
[ 4172.371255]        [<ffffffff81124e59>] seq_read+0x17b/0x362
[ 4172.371259]        [<ffffffff81107ff1>] vfs_read+0xaa/0x13a
[ 4172.371263]        [<ffffffff811080c6>] sys_read+0x45/0x6c
[ 4172.371266]        [<ffffffff81483792>] system_call_fastpath+0x16/0x1b
[ 4172.371270]=20
[ 4172.371270] -> #0 (rcu_node_level_0){..-...}:
[ 4172.371275]        [<ffffffff81070bd7>] __lock_acquire+0xffa/0x1661
[ 4172.371279]        [<ffffffff810717f6>] lock_acquire+0x138/0x1ac
[ 4172.371283]        [<ffffffff8147cd0e>] _raw_spin_lock+0x36/0x45
[ 4172.371286]        [<ffffffff810a55e2>] __rcu_read_unlock+0xb9/0x217
[ 4172.371290]        [<ffffffff81038ccc>] select_task_rq_fair+0xa51/0xa99
[ 4172.371294]        [<ffffffff81037888>] try_to_wake_up+0x153/0x28b
[ 4172.371298]        [<ffffffff810379df>] wake_up_process+0x10/0x12
[ 4172.371302]        [<ffffffff81056581>] wake_up_worker+0x1f/0x21
[ 4172.371306]        [<ffffffff810572c0>] insert_work+0x63/0x67
[ 4172.371309]        [<ffffffff8105803b>] __queue_work+0x3bd/0x46a
[ 4172.371313]        [<ffffffff810581a9>] delayed_work_timer_fn+0x25/0x2a
[ 4172.371316]        [<ffffffff8104c8ae>] run_timer_softirq+0x2dc/0x510
[ 4172.371321]        [<ffffffff8104528c>] __do_softirq+0x134/0x2ff
[ 4172.371327]        [<ffffffff8148469c>] call_softirq+0x1c/0x30
[ 4172.371331]        [<ffffffff8100316f>] do_softirq+0x46/0x9f
[ 4172.371336]        [<ffffffff810456ad>] irq_exit+0x4e/0xa0
[ 4172.371339]        [<ffffffff8101895a>] smp_apic_timer_interrupt+0x85/0x=
93
[ 4172.371343]        [<ffffffff814841d3>] apic_timer_interrupt+0x13/0x20
[ 4172.371347]        [<ffffffff81204e96>] do_msgsnd+0x399/0x40e
[ 4172.371352]        [<ffffffff81204f53>] sys_msgsnd+0x48/0x4f
[ 4172.371355]        [<ffffffff81483792>] system_call_fastpath+0x16/0x1b
[ 4172.371360]=20
[ 4172.371360] other info that might help us debug this:
[ 4172.371361]=20
[ 4172.371363] Chain exists of:
[ 4172.371363]   rcu_node_level_0 --> sync_rcu_preempt_exp_wq.lock --> &p->=
pi_lock
[ 4172.371370]=20
[ 4172.371371]  Possible unsafe locking scenario:
[ 4172.371372]=20
[ 4172.371374]        CPU0                    CPU1
[ 4172.371375]        ----                    ----
[ 4172.371377]   lock(&p->pi_lock);
[ 4172.371380]                                lock(sync_rcu_preempt_exp_wq.=
lock);
[ 4172.371384]                                lock(&p->pi_lock);
[ 4172.371387]   lock(rcu_node_level_0);
[ 4172.371390]=20
[ 4172.371390]  *** DEADLOCK ***
[ 4172.371391]=20
[ 4172.371393] 3 locks held by make/11702:
[ 4172.371395]  #0:  (&(&dbs_info->work)->timer){+.-...}, at: [<ffffffff810=
4c79f>] run_timer_softirq+0x1cd/0x510
[ 4172.371402]  #1:  (&(&gcwq->lock)->rlock){-.-...}, at: [<ffffffff81057e5=
5>] __queue_work+0x1d7/0x46a
[ 4172.371409]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff8103775e>] try_to=
_wake_up+0x29/0x28b
[ 4172.371415]=20
[ 4172.371416] stack backtrace:
[ 4172.371419] Pid: 11702, comm: make Not tainted 3.0.0-rc7-dbg-00565-g6b31=
efc #644
[ 4172.371421] Call Trace:
[ 4172.371423]  <IRQ>  [<ffffffff8147361c>] print_circular_bug+0x293/0x2a4
[ 4172.371431]  [<ffffffff81070bd7>] __lock_acquire+0xffa/0x1661
[ 4172.371436]  [<ffffffff81038400>] ? select_task_rq_fair+0x185/0xa99
[ 4172.371440]  [<ffffffff810a55e2>] ? __rcu_read_unlock+0xb9/0x217
[ 4172.371444]  [<ffffffff810717f6>] lock_acquire+0x138/0x1ac
[ 4172.371448]  [<ffffffff810a55e2>] ? __rcu_read_unlock+0xb9/0x217
[ 4172.371453]  [<ffffffff8147cd0e>] _raw_spin_lock+0x36/0x45
[ 4172.371456]  [<ffffffff810a55e2>] ? __rcu_read_unlock+0xb9/0x217
[ 4172.371460]  [<ffffffff810a55e2>] __rcu_read_unlock+0xb9/0x217
[ 4172.371464]  [<ffffffff81038ccc>] select_task_rq_fair+0xa51/0xa99
[ 4172.371468]  [<ffffffff810388d1>] ? select_task_rq_fair+0x656/0xa99
[ 4172.371471]  [<ffffffff8103775e>] ? try_to_wake_up+0x29/0x28b
[ 4172.371475]  [<ffffffff8103775e>] ? try_to_wake_up+0x29/0x28b
[ 4172.371482]  [<ffffffff81246c1d>] ? do_raw_spin_lock+0x6b/0x122
[ 4172.371486]  [<ffffffff81037888>] try_to_wake_up+0x153/0x28b
[ 4172.371489]  [<ffffffff81246c1d>] ? do_raw_spin_lock+0x6b/0x122
[ 4172.371493]  [<ffffffff810379df>] wake_up_process+0x10/0x12
[ 4172.371497]  [<ffffffff81056581>] wake_up_worker+0x1f/0x21
[ 4172.371500]  [<ffffffff810572c0>] insert_work+0x63/0x67
[ 4172.371503]  [<ffffffff8105803b>] __queue_work+0x3bd/0x46a
[ 4172.371507]  [<ffffffff8104c79f>] ? run_timer_softirq+0x1cd/0x510
[ 4172.371511]  [<ffffffff810581a9>] delayed_work_timer_fn+0x25/0x2a
[ 4172.371514]  [<ffffffff8104c8ae>] run_timer_softirq+0x2dc/0x510
[ 4172.371518]  [<ffffffff8104c79f>] ? run_timer_softirq+0x1cd/0x510
[ 4172.371521]  [<ffffffff81058184>] ? schedule_work+0x15/0x15
[ 4172.371525]  [<ffffffff8104528c>] __do_softirq+0x134/0x2ff
[ 4172.371530]  [<ffffffff8106b9a1>] ? tick_program_event+0x1a/0x1c
[ 4172.371534]  [<ffffffff8148469c>] call_softirq+0x1c/0x30
[ 4172.371538]  [<ffffffff8100316f>] do_softirq+0x46/0x9f
[ 4172.371541]  [<ffffffff810456ad>] irq_exit+0x4e/0xa0
[ 4172.371545]  [<ffffffff8101895a>] smp_apic_timer_interrupt+0x85/0x93
[ 4172.371549]  [<ffffffff814841d3>] apic_timer_interrupt+0x13/0x20
[ 4172.371551]  <EOI>  [<ffffffff81071fca>] ? trace_hardirqs_on_caller+0x10=
d/0x131
[ 4172.371559]  [<ffffffff810a5578>] ? __rcu_read_unlock+0x4f/0x217
[ 4172.371563]  [<ffffffff81204e96>] do_msgsnd+0x399/0x40e
[ 4172.371567]  [<ffffffff81204f53>] sys_msgsnd+0x48/0x4f
[ 4172.371571]  [<ffffffff81483792>] system_call_fastpath+0x16/0x1b



	Sergey

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk4fAgoACgkQfKHnntdSXjRflwQAqTEB6K+7GMUcYecv07xvC19n
k62FDgDLbRoa0KcVcU74dmGYSbckw1xbakYaWteTVr8e5o8GfcE1qUwTFp5FGI+r
a6IGxS2f9c6UWJtHJKe/Fgj4ALvbKB5YI2cPDXKY7eSl+KJGMtNkspcTpdRsKnTD
JmmAn9PDl2K33xuvCs8=
=6/ML
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
