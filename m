Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1FORye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:54:34 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:43858 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1FORyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:54:32 -0400
Message-ID: <4DF8F1D0.7000907@corp.free.fr>
Date: Wed, 15 Jun 2011 19:54:24 +0200
From: Yohan <ytordjman@corp.free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel panic on java mail server
Content-Type: multipart/mixed;
 boundary="------------080303030300050101050100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080303030300050101050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have a stange kernel panic on a zimbra mail server (mysqld + server in 
java)... when the java process starts the system freeze...
This is the first time that i have that kind of problem over 70 same 
kind servers.

The hardware has been changed 3 times (2 times on AMD server, 1 time on 
Intel server).

I join the traces on the intel platform, Tyan S7012 MB,  1 CPU Intel 
E5645, 48GB RAM, kernels 2.6.32.41 and 2.6.39.1 without debugging 
enabled and the output with the 2.6.32.41 with debugging enabled.

It was tested on 2.6.32.41 / 2.6.35.13 / 2.6.38.4 / 2.6.38.8 / 
2.6.39.1.... same thing.

Thanks for helping.
Yohan


--------------080303030300050101050100
Content-Type: text/plain;
 name="2.6.39.1.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="2.6.39.1.txt"

﻿[  180.154239] general protection fault: 0000 [#1] SMP
[  180.247372] last sysfs file: /sys/devices/system/machinecheck/machinecheck0/trigger
[  180.373040] CPU 6
[  180.430767] Pid: 4636, comm: mysqld Not tainted 2.6.39.1-zimbraI #1 empty empty/S7012
[  180.559863] RIP: 0010:[<ffffffff8107e873>]  [<ffffffff8107e873>] free_pcppages_bulk+0x2c3/0x380
[  180.699707] RSP: 0000:ffff880c0a0d5958  EFLAGS: 00010002
[  180.798726] RAX: 2e74736f682e7367 RBX: 0000000000000002 RCX: ffffea00297498a0
[  180.919653] RDX: ffffea00297c49d0 RSI: ffff880c3fffbe88 RDI: ffffea00297c49a8
[  181.040598] RBP: ffff880c0a0d59a8 R08: 0000000000000000 R09: 00000000000005e2
[  181.161760] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880c3fffbe00
[  181.283022] R13: ffff880c3f2d21d8 R14: 0000000000000019 R15: 0000000000000002
[  181.404549] FS:  0000000000000000(0000) GS:ffff880c3f2c0000(0000) knlGS:0000000000000000
[  181.538463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  181.644584] CR2: 00000000005297e0 CR3: 0000000001475000 CR4: 00000000000006e0
[  181.767912] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  181.891518] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  182.015193] Process mysqld (pid: 4636, threadinfo ffff880c0a0d4000, task ffff880c0e5cef40)
[  182.153504] Stack:
[  182.216759]  2e74736f682e7367 7473675f3d656d67 e0726f20656d616e 0000000000000002
[  182.346623]  000000196f207373 657672657320736f 30757465730a2e72 657384d0736f6834
[  182.477249]  302e73676e697474 696d64413d747275 2c6f158d6f43206e 0a3a74726f50206b
[  182.608362] Call Trace:
[  182.679209] Code: 50 68 4b 8d 04 80 49 8d 04 40 49 83 84 c4 b8 00 00 00 01 83 6d d4 01 0f 84 88 00 00 00 41 83 ee 01 0f 84 a6 fd ff ff 48 8b 45 b0
[  182.844257]  39 00 0f 85 c4 fd ff ff 0f 1f 40 00 e9 90 fd ff ff 4d 63 da
[  183.017325] RIP  [<ffffffff8107e873>] free_pcppages_bulk+0x2c3/0x380
[  183.137398]  RSP <ffff880c0a0d5958>
[  183.222984] ---[ end trace 786e33d9c56c26b4 ]---
[  183.222986] java: Corrupted page table at address 32c671428
[  183.222988] PGD c0a13e067 PUD 2065970b65636557 BAD
[  183.222994] Bad pagetable: 0009 [#2] SMP
[  183.222995] last sysfs file: /sys/devices/system/machinecheck/machinecheck0/trigger
[  183.222997] CPU 0
[  183.222999] Pid: 4629, comm: java Tainted: G      D     2.6.39.1-zimbraI #1 empty empty/S7012
[  183.223002] RIP: 0010:[<ffffffff81032f86>]  [<ffffffff81032f86>] task_tick_fair+0x36/0xf0
[  183.223006] RSP: 0018:ffff880c3f203ea8  EFLAGS: 00010086
[  183.223008] RAX: 0000000075636f69 RBX: ffff880c0baf37a0 RCX: 00000000fffdc9b7
[  183.223010] RDX: 0000000000000000 RSI: ffff880c0baf37a0 RDI: ffff880c3f2110c0
[  183.223012] RBP: ffff880c3f203ed8 R08: 0000000000000800 R09: 0000000000000005
[  183.223013] R10: 0000000000000000 R11: 0000000000000004 R12: 00000000000110c0
[  183.223015] R13: 00000000000110c0 R14: ffff880c0baf37d8 R15: 0000000000000000
[  183.223018] FS:  000000004034d950(0063) GS:ffff880c3f200000(0000) knlGS:0000000000000000
[  183.223020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  183.223021] CR2: ffff9f0b65636b18 CR3: 0000000c0bb4b000 CR4: 00000000000006f0
[  183.223023] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  183.223025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  183.223027] Process java (pid: 4629, threadinfo ffff880c0a20e000, task ffff880c0baf37a0)
[  183.223028] Stack:
[  183.223029]  ffffffff815bc1a0 ffff880c3f2110c0 0000000000000010 00000000000110c0
[  183.223032]  ffff880c0baf37a0 0000000000000000 ffff880c3f203f18 ffffffff81031252
[  183.223034]  0000000000000000 0000000000000000 0000000000000000 ffff880c0baf37a0
[  183.223037] Call Trace:
[  183.223038]  <IRQ>
[  183.223042]  [<ffffffff81031252>] scheduler_tick+0x162/0x230
[  183.223047]  [<ffffffff81046e97>] update_process_times+0x67/0x80
[  183.223050]  [<ffffffff81060327>] tick_periodic+0x27/0x70
[  183.223053]  [<ffffffff81060391>] tick_handle_periodic+0x21/0x80
[  183.223057]  [<ffffffff8101a4f6>] smp_apic_timer_interrupt+0x66/0xa0
[  183.223060]  [<ffffffff81373253>] apic_timer_interrupt+0x13/0x20
[  183.223062]  <EOI>
[  183.223066]  [<ffffffff811b20eb>] ? memcpy+0xb/0x120
[  183.223070] Code: f0 49 89 f6 48 89 5d d8 49 83 c6 38 4c 89 65 e0 4c 89 6d e8 4c 89 7d f8 48 89 f3 74 79 48 8b 46 08 49 c7 c4 c0 10 01 00 8b 40 18 <4c> 03 24 c5 e0 98 4b 81 4d 8d 6c 24 68 4c 89 ef e8 d5 ed ff ff
[  183.223086] RIP  [<ffffffff81032f86>] task_tick_fair+0x36/0xf0
[  183.223089]  RSP <ffff880c3f203ea8>
[  183.223090] ---[ end trace 786e33d9c56c26b5 ]---
[  183.223092] Kernel panic - not syncing: Fatal exception in interrupt
[  183.223094] Pid: 4629, comm: java Tainted: G      D     2.6.39.1-zimbraI #1
[  183.223095] Call Trace:
[  183.223096]  <IRQ>  [<ffffffff8103b14a>] panic+0xba/0x1e0
[  183.223102]  [<ffffffff810041a6>] ? show_registers+0x86/0x280
[  183.223105]  [<ffffffff8103c6eb>] ? kmsg_dump+0x4b/0x100
[  183.223109]  [<ffffffff81058886>] ? down_trylock+0x36/0x50
[  183.223112]  [<ffffffff8100500f>] oops_end+0x9f/0xb0
[  183.223116]  [<ffffffff81026bb4>] pgtable_bad+0x94/0xb0
[  183.223118]  [<ffffffff81027784>] do_page_fault+0x2f4/0x450
[  183.223121]  [<ffffffff812f358a>] ? __kfree_skb+0x3a/0xa0
[  183.223123]  [<ffffffff812f3609>] ? consume_skb+0x19/0x40
[  183.223128]  [<ffffffff812fc205>] ? dev_kfree_skb_any+0x35/0x40
[  183.223132]  [<ffffffff8126b112>] ? igb_poll+0x8d2/0xd30
[  183.223135]  [<ffffffff811a9fc7>] ? kobject_put+0x27/0x60
[  183.223140]  [<ffffffff8123d0c2>] ? put_device+0x12/0x20
[  183.223144]  [<ffffffff8137251f>] page_fault+0x1f/0x30
[  183.223147]  [<ffffffff81032f86>] ? task_tick_fair+0x36/0xf0
[  183.223149]  [<ffffffff81031252>] scheduler_tick+0x162/0x230
[  183.223152]  [<ffffffff81046e97>] update_process_times+0x67/0x80
[  183.223155]  [<ffffffff81060327>] tick_periodic+0x27/0x70
[  183.223157]  [<ffffffff81060391>] tick_handle_periodic+0x21/0x80
[  183.223159]  [<ffffffff8101a4f6>] smp_apic_timer_interrupt+0x66/0xa0
[  183.223162]  [<ffffffff81373253>] apic_timer_interrupt+0x13/0x20
[  183.223163]  <EOI>  [<ffffffff811b20eb>] ? memcpy+0xb/0x120
[  190.682307] Kernel panic - not syncing: Fatal exception in interrupt
[  190.798751] Pid: 4636, comm: mysqld Tainted: G      D     2.6.39.1-zimbraI #1
[  190.924945] Call Trace:
[  190.994578]  [<ffffffff8103b14a>] panic+0xba/0x1e0
[  191.092143]  [<ffffffff8103c6eb>] ? kmsg_dump+0x4b/0x100
[  191.195554]  [<ffffffff8100500f>] oops_end+0x9f/0xb0
[  191.294317]  [<ffffffff81005116>] die+0x56/0x90
[  191.387021]  [<ffffffff81002782>] do_general_protection+0x152/0x160
[  191.500374]  [<ffffffff813724ef>] general_protection+0x1f/0x30
[  191.608294]  [<ffffffff8107e873>] ? free_pcppages_bulk+0x2c3/0x380

--------------080303030300050101050100
Content-Type: text/plain;
 name="2.6.32.41.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="2.6.32.41.txt"

﻿[  261.993172] BUG: soft lockup - CPU#3 stuck for 61s! [syslogd:2418]
[  262.109164] BUG: soft lockup - CPU#11 stuck for 61s! [cron:4555]
[  262.221917] BUG: soft lockup - CPU#8 stuck for 61s! [java:4458]
[  262.332433] BUG: soft lockup - CPU#2 stuck for 61s! [flush-9:1:2356]
[  262.446477] BUG: soft lockup - CPU#10 stuck for 61s! [munin-node:4554]
[  264.140716] BUG: soft lockup - CPU#0 stuck for 61s! [java:4486]
[  264.246744] BUG: soft lockup - CPU#6 stuck for 61s! [sync_supers:148]
[  264.358389] BUG: soft lockup - CPU#9 stuck for 61s! [mysqld:3000]
[  281.127736] BUG: spinlock lockup on CPU#10, munin-node/4554, ffffffff814ae0c0
[  287.057652] BUG: spinlock lockup on CPU#8, java/4458, ffffffff814ae0c0
[  290.221802] BUG: spinlock lockup on CPU#6, sync_supers/148, ffffffff814ae0c0
[  291.878297] BUG: spinlock lockup on CPU#3, syslogd/2418, ffffffff814ae0c0
[  293.198109] BUG: spinlock lockup on CPU#2, flush-9:1/2356, ffffffff814ae0c0
[  294.429820] BUG: spinlock lockup on CPU#9, mysqld/3000, ffffffff814ae0c0
[  302.842471] BUG: spinlock lockup on CPU#11, cron/4555, ffffffff814ae0c0
[  334.077742] BUG: spinlock lockup on CPU#7, sshd/4556, ffffffff814ae0c0
[  345.346860] BUG: spinlock lockup on CPU#4, mdadm/2560, ffffffff814ae0c0
[  375.919077] BUG: spinlock lockup on CPU#5, cron/4557, ffffffff814ae0c0
[  379.232633] INFO: task java:4439 blocked for more than 120 seconds.
[  379.344135] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  379.475150] INFO: task java:4457 blocked for more than 120 seconds.
[  379.588143] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  379.720604] INFO: task java:4461 blocked for more than 120 seconds.
[  379.834390] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  379.967781] INFO: task java:4485 blocked for more than 120 seconds.
[  380.082147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  380.216339] INFO: task java:4508 blocked for more than 120 seconds.
[  380.332092] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  380.467907] INFO: task java:4513 blocked for more than 120 seconds.
[  380.585320] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  380.722442] INFO: task java:4514 blocked for more than 120 seconds.
[  380.841406] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  380.980238] INFO: task java:4515 blocked for more than 120 seconds.
[  381.100689] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  381.240764] INFO: task java:4516 blocked for more than 120 seconds.
[  381.361822] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  381.502291] INFO: task java:4517 blocked for more than 120 seconds.
[  381.624433] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

--------------080303030300050101050100
Content-Type: text/plain;
 name="2.6.32.41d.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="2.6.32.41d.txt"

﻿[ 1528.346126] BUG: unable to handle kernel NULL pointer dereference at 0000000000000026
[ 1528.477707] IP: [<ffffffff81056298>] hrtimer_run_queues+0x128/0x210
[ 1528.590822] PGD c38b78067 PUD 0
[ 1528.667288] Thread overran stack, or stack corrupted
[ 1528.764395] Oops: 0000 [#1] SMP
[ 1528.840863] last sysfs file: /sys/devices/virtual/block/md1/md/mismatch_cnt
[ 1528.962815] CPU 2
[ 1529.025583] Pid: 1514, comm:  Not tainted 2.6.32.41-zimbraI #1 empty
[ 1529.141162] RIP: 0010:[<ffffffff81056298>]  [<ffffffff81056298>] hrtimer_run_queues+0x128/0x210
[ 1529.286085] RSP: 0018:ffff880052643ea8  EFLAGS: 00010002
[ 1529.390732] RAX: ffff880c34831728 RBX: 0000000000000000 RCX: ffffffffb2072bdd
[ 1529.517860] RDX: 0000000000000038 RSI: 0000000022795c7a RDI: ffff88005264ce00
[ 1529.645131] RBP: ffff880052643f08 R08: 0000000000000001 R09: 0000000000000002
[ 1529.773096] R10: ffff880c38725fd8 R11: 0000000000000001 R12: ffff880c34831728
[ 1529.900970] R13: ffff880c3630c920 R14: 0000000000000026 R15: ffff88005264ce00
[ 1530.029136] FS:  00007fb9e34ea6e0(0000) GS:ffff880052640000(0000) knlGS:0000000000000000
[ 1530.169664] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1530.282344] CR2: 0000000000000026 CR3: 0000000c3677b000 CR4: 00000000000006e0
[ 1530.412026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1530.541058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1530.669764] Process  (pid: 1514, threadinfo ffff880c360f7b80, task ffff880c3630c920)
[ 1530.806400] Stack:
[ 1530.874307]  ffffffff8106a060 0000000000000038 000000004df8da13 0000000022795c7a
[ 1530.962336] <0> 000000004df8da13 0000000022795c7a 0000000000000046 0000000000000000
[ 1531.099922] <0> 0000000000000002 ffff880c3630c920 0000000000000000 ffff880c36966180
[ 1531.284610] Call Trace:
[ 1531.359372]  <IRQ>
[ 1531.430254]  [<ffffffff8106a060>] ? __rcu_process_callbacks+0x80/0x320
[ 1531.555186]  [<ffffffff81048dd9>] run_local_timers+0x9/0x20
[ 1531.668331]  [<ffffffff81048e27>] update_process_times+0x37/0x70
[ 1531.787615]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1531.898111]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1532.015833]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1532.137969]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1532.255831]  <EOI>
[ 1532.279106] Code: 00 48 8b 58 18 4a 39 5c 3a 38 49 89 c4 7f 17 e9 8a 00 00 00 48 8b 50 18 49 89 c4 48 8b 45 a8 4a 39 54 38 38 7e 78 4d 8b 74 24 30 <4d> 8b 2e 9c 58 f6 c4 02 0f 85 89 00 00 00 31 c9 ba 02 00 00 00
[ 1532.657167] RIP  [<ffffffff81056298>] hrtimer_run_queues+0x128/0x210
[ 1532.780880]  RSP <ffff880052643ea8>
[ 1532.870474] CR2: 0000000000000026
[ 1533.096616] ---[ end trace e16f43a7fa6f9a78 ]---
[ 1533.096619] general protection fault: 0000 [#2] SMP
[ 1533.096623] last sysfs file: /sys/devices/virtual/block/md1/md/mismatch_cnt
[ 1533.096625] CPU 0
[ 1533.096628] Pid: 9093, comm: java Tainted: G      D    2.6.32.41-zimbraI #1 empty
[ 1533.096630] RIP: 0010:[<ffffffff810562bd>]  [<ffffffff810562bd>] hrtimer_run_queues+0x14d/0x210
[ 1533.096636] RSP: 0018:ffff880052603ea8  EFLAGS: 00010097
[ 1533.096638] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1533.096640] RDX: 0000000000000000 RSI: ffffffff810b4f00 RDI: ffff880c3637d968
[ 1533.096642] RBP: ffff880052603f08 R08: 00000000ffffffff R09: ffffffffffdb6030
[ 1533.096645] R10: 00000000164799e8 R11: fffffffffff7d54a R12: ffff880c3637d968
[ 1533.096647] R13: 20ec8348e5894855 R14: ffffffff810b4ef0 R15: ffff88005260ce00
[ 1533.096650] FS:  0000000041ef2950(0063) GS:ffff880052600000(0000) knlGS:0000000000000000
[ 1533.096652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1533.096654] CR2: 00007fb8e53f7000 CR3: 0000000c3677b000 CR4: 00000000000006f0
[ 1533.096656] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1533.096659] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1533.096661] Process java (pid: 9093, threadinfo ffff880c38640000, task ffff880c385b5a00)
[ 1533.096663] Stack:
[ 1533.096664]  ffffffff8106a060 0000000000000038 000000004df8da13 0000000022d4e764
[ 1533.096667] <0> 000000004df8da13 0000000022d4e764 ffff880052603f08 0000000000000000
[ 1533.096670] <0> 0000000000000000 ffff880c385b5a00 0000000000001000 ffff880bd9cd4000
[ 1533.096673] Call Trace:
[ 1533.096674]  <IRQ>
[ 1533.096678]  [<ffffffff8106a060>] ? __rcu_process_callbacks+0x80/0x320
[ 1533.096682]  [<ffffffff81048dd9>] run_local_timers+0x9/0x20
[ 1533.096684]  [<ffffffff81048e27>] update_process_times+0x37/0x70
[ 1533.096688]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1533.096691]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1533.096694]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1533.096697]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1533.096699]  <EOI>
[ 1533.096703]  [<ffffffff8119882b>] ? memcpy_c+0xb/0x20
[ 1533.096706]  [<ffffffff81198931>] ? memmove+0x41/0x50
[ 1533.096710]  [<ffffffff8110f547>] ? leaf_copy_items_entirely+0x147/0x230
[ 1533.096714]  [<ffffffff81110ce6>] ? leaf_move_items+0x366/0x370
[ 1533.096717]  [<ffffffff81110d1d>] ? leaf_shift_right+0x2d/0x70
[ 1533.096720]  [<ffffffff810fd924>] ? do_balance+0x15d4/0x2580
[ 1533.096723]  [<ffffffff81053362>] ? bit_waitqueue+0x12/0xd0
[ 1533.096726]  [<ffffffff81053488>] ? wake_up_bit+0x28/0x40
[ 1533.096731]  [<ffffffff810c9152>] ? unlock_buffer+0x12/0x20
[ 1533.096735]  [<ffffffff8110716b>] ? clear_all_dirty_bits+0xb/0x10
[ 1533.096738]  [<ffffffff81109e24>] ? fix_nodes+0x434/0x8d0
[ 1533.096741]  [<ffffffff81113d5b>] ? reiserfs_delete_solid_item+0x1ab/0x300
[ 1533.096745]  [<ffffffff811156a8>] ? reiserfs_delete_object+0x58/0x80
[ 1533.096748]  [<ffffffff81101612>] ? reiserfs_delete_inode+0xa2/0xe0
[ 1533.096752]  [<ffffffff810b96fb>] ? iput+0x2b/0x70
[ 1533.096755]  [<ffffffff81101570>] ? reiserfs_delete_inode+0x0/0xe0
[ 1533.096758]  [<ffffffff810ba3e5>] ? generic_delete_inode+0x85/0x120
[ 1533.096761]  [<ffffffff810ba498>] ? generic_drop_inode+0x18/0x70
[ 1533.096763]  [<ffffffff810b972d>] ? iput+0x5d/0x70
[ 1533.096767]  [<ffffffff810b1723>] ? do_unlinkat+0x113/0x1b0
[ 1533.096771]  [<ffffffff8102ad24>] ? do_page_fault+0x144/0x260
[ 1533.096775]  [<ffffffff810b17d1>] ? sys_unlink+0x11/0x20
[ 1533.096777]  [<ffffffff8100b1eb>] ? system_call_fastpath+0x16/0x1b
[ 1533.096779] Code: 78 4d 8b 74 24 30 4d 8b 2e 9c 58 f6 c4 02 0f 85 89 00 00 00 31 c9 ba 02 00 00 00 4c 89 f6 4c 89 e7 e8 28 fc ff ff 49 8b 44 24 28 <41> fe 45 00 4c 89 e7 ff d0 4c 89 ef 89 c3 e8 b0 e1 2e 00 85 db
[ 1533.096798] RIP  [<ffffffff810562bd>] hrtimer_run_queues+0x14d/0x210
[ 1533.096801]  RSP <ffff880052603ea8>
[ 1533.096803] ---[ end trace e16f43a7fa6f9a79 ]---
[ 1533.096805] ------------[ cut here ]------------
[ 1533.096808] Kernel panic - not syncing: Fatal exception in interrupt
[ 1533.096811] kernel BUG at kernel/sched.c:1165!
[ 1533.096814] Pid: 9093, comm: java Tainted: G      D    2.6.32.41-zimbraI #1
[ 1533.096817] invalid opcode: 0000 [#3] Call Trace:
[ 1533.096820] SMP  <IRQ>
[ 1533.096822] last sysfs file: /sys/devices/virtual/block/md1/md/mismatch_cnt
[ 1533.096826]  [<ffffffff8103ef40>] panic+0xa0/0x170
[ 1533.096828] CPU 3
[ 1533.096832]  [<ffffffff8100e536>] ? show_registers+0x86/0x260
[ 1533.096835] Pid: 2538, comm: munin-node Tainted: G      D    2.6.32.41-zimbraI #1 empty
[ 1533.096838] RIP: 0010:[<ffffffff81035541>]  [<ffffffff81056e66>] ? down_trylock+0x36/0x50
[ 1533.096846]  [<ffffffff81035541>] resched_task+0x61/0x70
[ 1533.096848] RSP: 0000:ffff880052663e88  EFLAGS: 00010046
[ 1533.096851]  [<ffffffff8103f91f>] ? console_unblank+0x1f/0x80
[ 1533.096854] RAX: 000000000000006c RBX: ffff880c38782760 RCX: ffff880c38640000
[ 1533.096857] RDX: 0000000000006c6c RSI: 0000000000000400 RDI: ffff880c385b5a00
[ 1533.096861]  [<ffffffff8103ebde>] ? print_oops_end_marker+0x1e/0x20
[ 1533.096864] RBP: ffff880052663e88 R08: 0000000000000001 R09: 0000000000000010
[ 1533.096867] R10: 0000000000000000 R11: 0000000000030001 R12: ffff880052610dc0
[ 1533.096870]  [<ffffffff8100f33f>] oops_end+0x9f/0xb0
[ 1533.096873] R13: ffff880052610e18 R14: ffff880c38782798 R15: 0000000000988372
[ 1533.096876] FS:  00007f668eaf76e0(0000) GS:ffff880052660000(0000) knlGS:0000000000000000
[ 1533.096879]  [<ffffffff8100f446>] die+0x56/0x90
[ 1533.096882] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1533.096884] CR2: 0000000000000000 CR3: 0000000c37011000 CR4: 00000000000006e0
[ 1533.096888]  [<ffffffff810b4ef0>] ? __pollwait+0x0/0x100
[ 1533.096890] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1533.096893] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1533.096896]  [<ffffffff8100c858>] do_general_protection+0x148/0x150
[ 1533.096900] Process munin-node (pid: 2538, threadinfo ffff880c36382000, task ffff880c38782760)
[ 1533.096902] Stack:
[ 1533.096906]  [<ffffffff8134486f>] general_protection+0x1f/0x30
[ 1533.096908]  ffff880052663ec8 ffffffff81035c0d [<ffffffff810b4ef0>] ? __pollwait+0x0/0x100
[ 1533.096913]  ffff880c36383fd8 0000000000000003 [<ffffffff810b4f00>] ? __pollwait+0x10/0x100
[ 1533.096918]
[ 1533.096918] <0> 00000163d8e3d4a3 [<ffffffff810562bd>] ? hrtimer_run_queues+0x14d/0x210
[ 1533.096924]  ffff880052670dc0 0000000000010dc0 [<ffffffff810562b8>] ? hrtimer_run_queues+0x148/0x210
[ 1533.096929]  ffff880c38782760
[ 1533.096931] <0> [<ffffffff8106a060>] ? __rcu_process_callbacks+0x80/0x320
[ 1533.096935]  ffff880052663f18 ffffffff8103b013 [<ffffffff81048dd9>] run_local_timers+0x9/0x20
[ 1533.096940]  0000000000000003 0000000000000003 [<ffffffff81048e27>] update_process_times+0x37/0x70
[ 1533.096945]
[ 1533.096947] Call Trace:
[ 1533.096949]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1533.096951]  <IRQ>
[ 1533.096954]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1533.096958]  [<ffffffff81035c0d>] task_tick_fair+0xdd/0xf0
[ 1533.096962]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1533.096966]  [<ffffffff8103b013>] scheduler_tick+0x123/0x180
[ 1533.096969]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1533.096973]  [<ffffffff81048e3b>] update_process_times+0x4b/0x70
[ 1533.096975]  <EOI>
[ 1533.096978]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1533.096981]  [<ffffffff8119882b>] ? memcpy_c+0xb/0x20
[ 1533.096985]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1533.096988]  [<ffffffff81198931>] ? memmove+0x41/0x50
[ 1533.096992]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1533.096996]  [<ffffffff8110f547>] ? leaf_copy_items_entirely+0x147/0x230
[ 1533.097000]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1533.097002]  <EOI>  [<ffffffff81110ce6>] ? leaf_move_items+0x366/0x370
[ 1533.097008]  [<ffffffff813446ef>] ? lock_kernel+0x2f/0x40
[ 1533.097012]  [<ffffffff81110d1d>] ? leaf_shift_right+0x2d/0x70
[ 1533.097016]  [<ffffffff8104c760>] ? __dequeue_signal+0x110/0x160
[ 1533.097020]  [<ffffffff810fd924>] ? do_balance+0x15d4/0x2580
[ 1533.097023]  [<ffffffff81049962>] ? recalc_sigpending+0x12/0x30
[ 1533.097027]  [<ffffffff81053362>] ? bit_waitqueue+0x12/0xd0
[ 1533.097030]  [<ffffffff8104ccc5>] ? get_signal_to_deliver+0x185/0x340
[ 1533.097034]  [<ffffffff81053488>] ? wake_up_bit+0x28/0x40
[ 1533.097038]  [<ffffffff8100a8e4>] ? do_notify_resume+0xb4/0x7d0
[ 1533.097041]  [<ffffffff810c9152>] ? unlock_buffer+0x12/0x20
[ 1533.097045]  [<ffffffff8102aa3f>] ? __bad_area_nosemaphore+0xbf/0x1c0
[ 1533.097049]  [<ffffffff8110716b>] ? clear_all_dirty_bits+0xb/0x10
[ 1533.097054]  [<ffffffff81070000>] ? destroy_compound_page+0x70/0xb0
[ 1533.097058]  [<ffffffff81109e24>] ? fix_nodes+0x434/0x8d0
[ 1533.097061]  [<ffffffff810727d8>] ? __free_pages+0x18/0x30
[ 1533.097065]  [<ffffffff81113d5b>] ? reiserfs_delete_solid_item+0x1ab/0x300
[ 1533.097068]  [<ffffffff8102ab8f>] ? __bad_area+0x4f/0x70
[ 1533.097071]  [<ffffffff811156a8>] ? reiserfs_delete_object+0x58/0x80
[ 1533.097075]  [<ffffffff8102abce>] ? bad_area+0xe/0x10
[ 1533.097078]  [<ffffffff81101612>] ? reiserfs_delete_inode+0xa2/0xe0
[ 1533.097082]  [<ffffffff8102ad94>] ? do_page_fault+0x1b4/0x260
[ 1533.097085]  [<ffffffff810b96fb>] ? iput+0x2b/0x70
[ 1533.097088]  [<ffffffff8100bb5a>] ? retint_signal+0x3d/0x83
[ 1533.097092]  [<ffffffff81101570>] ? reiserfs_delete_inode+0x0/0xe0
[ 1533.097094] Code: 18  [<ffffffff810ba3e5>] ? generic_delete_inode+0x85/0x120
[ 1533.097099] 65 8b  [<ffffffff810ba498>] ? generic_drop_inode+0x18/0x70
[ 1533.097104] 04 25  [<ffffffff810b972d>] ? iput+0x5d/0x70
[ 1533.097108] 50 b8  [<ffffffff810b1723>] ? do_unlinkat+0x113/0x1b0
[ 1533.097113] 00 00  [<ffffffff8102ad24>] ? do_page_fault+0x144/0x260
[ 1533.097117] 39 c2  [<ffffffff810b17d1>] ? sys_unlink+0x11/0x20
[ 1533.097122] 74 0d  [<ffffffff8100b1eb>] ? system_call_fastpath+0x16/0x1b
[ 1533.097127] 0f ae f0 48 8b 47 08 f6 40 14 04 74 02 c9 c3 89 d7 ff 15 26 7b 40 00 c9 0f 1f 44 00 00 c3 <0f> 0b eb fe 66 66 2e 0f 1f 84 00 00 00 00 00 55 4c 8b 8f 88 07
[ 1533.097137] RIP  [<ffffffff81035541>] resched_task+0x61/0x70
[ 1533.097140]  RSP <ffff880052663e88>
[ 1533.097141] ---[ end trace e16f43a7fa6f9a7a ]---
[ 1533.097143] general protection fault: 0000 [#4]
[ 1533.097146] Kernel panic - not syncing: Fatal exception in interrupt
[ 1533.097148] SMP Pid: 2538, comm: munin-node Tainted: G      D    2.6.32.41-zimbraI #1
[ 1533.097152]
[ 1533.097153] Call Trace:
[ 1533.097154] last sysfs file: /sys/devices/virtual/block/md1/md/mismatch_cnt
[ 1533.097157]  <IRQ> CPU 8
[ 1533.097161]  [<ffffffff8103ef40>] panic+0xa0/0x170
[ 1533.097163] Pid: 0, comm: swapper Tainted: G      D    2.6.32.41-zimbraI #1 empty
[ 1533.097167] RIP: 0010:[<ffffffff810562bd>]  [<ffffffff8100e536>] ? show_registers+0x86/0x260
[ 1533.097174]  [<ffffffff810562bd>] hrtimer_run_queues+0x14d/0x210
[ 1533.097177] RSP: 0018:ffff880052703ea8  EFLAGS: 00010097
[ 1533.097181]  [<ffffffff81056e66>] ? down_trylock+0x36/0x50
[ 1533.097183] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1533.097187] RDX: 0000000000000000 RSI: ffffffff810b4f00 RDI: ffff880c36375968
[ 1533.097191]  [<ffffffff8103f91f>] ? console_unblank+0x1f/0x80
[ 1533.097193] RBP: ffff880052703f08 R08: 00000000ffffffff R09: 0000000000000000
[ 1533.097196] R10: 0000000000000000 R11: 00000000ffffffff R12: ffff880c36375968
[ 1533.097200]  [<ffffffff8103ebde>] ? print_oops_end_marker+0x1e/0x20
[ 1533.097203] R13: 20ec8348e5894855 R14: ffffffff810b4ef0 R15: ffff88005270ce00
[ 1533.097206] FS:  0000000000000000(0000) GS:ffff880052700000(0000) knlGS:0000000000000000
[ 1533.097211]  [<ffffffff8100f33f>] oops_end+0x9f/0xb0
[ 1533.097213] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[ 1533.097216] CR2: 0000000000000000 CR3: 0000000c3677b000 CR4: 00000000000006e0
[ 1533.097220]  [<ffffffff8100f446>] die+0x56/0x90
[ 1533.097222] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1533.097226] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1533.097229]  [<ffffffff8100c4c0>] do_trap+0x130/0x150
[ 1533.097232] Process swapper (pid: 0, threadinfo ffff880c39d5a000, task ffff880c39d41c20)
[ 1533.097235] Stack:
[ 1533.097237]  [<ffffffff8100cb10>] do_invalid_op+0x90/0xb0
[ 1533.097239]  ffffffff8106a060 0000000000000038 [<ffffffff81035541>] ? resched_task+0x61/0x70
[ 1533.097244]  000000004df8da13 0000000022d4e764 [<ffffffff81034070>] ? __enqueue_entity+0x80/0x90
[ 1533.097250]
[ 1533.097251] <0> 000000004df8da13 [<ffffffff81035f23>] ? enqueue_task_fair+0x103/0x140
[ 1533.097256]  0000000022d4e764 0000000000000046 [<ffffffff8100be95>] invalid_op+0x15/0x20
[ 1533.097260]  0000000000000000
[ 1533.097262] <0> [<ffffffff81035541>] ? resched_task+0x61/0x70
[ 1533.097266]  0000000000000008 ffff880c39d41c20 [<ffffffff81035c0d>] task_tick_fair+0xdd/0xf0
[ 1533.097271]  0000000000000000 0000000000000000 [<ffffffff8103b013>] scheduler_tick+0x123/0x180
[ 1533.097276]
[ 1533.097277] Call Trace:
[ 1533.097280]  [<ffffffff81048e3b>] update_process_times+0x4b/0x70
[ 1533.097282]  <IRQ>
[ 1533.097285]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1533.097289]  [<ffffffff8106a060>] ? __rcu_process_callbacks+0x80/0x320
[ 1533.097293]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1533.097296]  [<ffffffff81048dd9>] run_local_timers+0x9/0x20
[ 1533.097300]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1533.097303]  [<ffffffff81048e27>] update_process_times+0x37/0x70
[ 1533.097307]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1533.097310]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1533.097312]  <EOI>
[ 1533.097315]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1533.097319]  [<ffffffff813446ef>] ? lock_kernel+0x2f/0x40
[ 1533.097322]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1533.097326]  [<ffffffff8104c760>] ? __dequeue_signal+0x110/0x160
[ 1533.097330]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1533.097333]  [<ffffffff81049962>] ? recalc_sigpending+0x12/0x30
[ 1533.097335]  <EOI>  [<ffffffff8104ccc5>] ? get_signal_to_deliver+0x185/0x340
[ 1533.097341]  [<ffffffff81012c52>] ? mwait_idle+0x52/0x70
[ 1533.097344]  [<ffffffff8100a8e4>] ? do_notify_resume+0xb4/0x7d0
[ 1533.097347]  [<ffffffff81009980>] ? enter_idle+0x20/0x30
[ 1533.097351]  [<ffffffff8102aa3f>] ? __bad_area_nosemaphore+0xbf/0x1c0
[ 1533.097354]  [<ffffffff81070000>] ? destroy_compound_page+0x70/0xb0
[ 1533.097357]  [<ffffffff81009c35>] ? cpu_idle+0x45/0x70
[ 1533.097361]  [<ffffffff810727d8>] ? __free_pages+0x18/0x30
[ 1533.097366]  [<ffffffff814b58c8>] ? start_secondary+0x168/0x1c0
[ 1533.097370]  [<ffffffff8102ab8f>] ? __bad_area+0x4f/0x70
[ 1533.097372] Code: 78  [<ffffffff8102abce>] ? bad_area+0xe/0x10
[ 1533.097376] 4d 8b  [<ffffffff8102ad94>] ? do_page_fault+0x1b4/0x260
[ 1533.097380] 74 24  [<ffffffff8100bb5a>] ? retint_signal+0x3d/0x83
[ 1533.097384] 30 4d 8b 2e 9c 58 f6 c4 02 0f 85 89 00 00 00 31 c9 ba 02 00 00 00 4c 89 f6 4c 89 e7 e8 28 fc ff ff 49 8b 44 24 28 <41> fe 45 00 4c 89 e7 ff d0 4c 89 ef 89 c3 e8 b0 e1 2e 00 85 db
[ 1533.097398] RIP  [<ffffffff810562bd>] hrtimer_run_queues+0x14d/0x210
[ 1533.097401]  RSP <ffff880052703ea8>
[ 1533.097402] ---[ end trace e16f43a7fa6f9a7b ]---
[ 1533.097403] Kernel panic - not syncing: Fatal exception in interrupt
[ 1533.097405] Pid: 0, comm: swapper Tainted: G      D    2.6.32.41-zimbraI #1
[ 1533.097406] Call Trace:
[ 1533.097407]  <IRQ>  [<ffffffff8103ef40>] panic+0xa0/0x170
[ 1533.097412]  [<ffffffff8100e536>] ? show_registers+0x86/0x260
[ 1533.097415]  [<ffffffff81056e66>] ? down_trylock+0x36/0x50
[ 1533.097417]  [<ffffffff8103f91f>] ? console_unblank+0x1f/0x80
[ 1533.097419]  [<ffffffff8103ebde>] ? print_oops_end_marker+0x1e/0x20
[ 1533.097422]  [<ffffffff8100f33f>] oops_end+0x9f/0xb0
[ 1533.097424]  [<ffffffff8100f446>] die+0x56/0x90
[ 1533.097426]  [<ffffffff810b4ef0>] ? __pollwait+0x0/0x100
[ 1533.097429]  [<ffffffff8100c858>] do_general_protection+0x148/0x150
[ 1533.097432]  [<ffffffff8134486f>] general_protection+0x1f/0x30
[ 1533.097434]  [<ffffffff810b4ef0>] ? __pollwait+0x0/0x100
[ 1533.097436]  [<ffffffff810b4f00>] ? __pollwait+0x10/0x100
[ 1533.097438]  [<ffffffff810562bd>] ? hrtimer_run_queues+0x14d/0x210
[ 1533.097441]  [<ffffffff810562b8>] ? hrtimer_run_queues+0x148/0x210
[ 1533.097444]  [<ffffffff8106a060>] ? __rcu_process_callbacks+0x80/0x320
[ 1533.097446]  [<ffffffff81048dd9>] run_local_timers+0x9/0x20
[ 1533.097449]  [<ffffffff81048e27>] update_process_times+0x37/0x70
[ 1533.097451]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1533.097453]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1533.097456]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1533.097458]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20
[ 1533.097459]  <EOI>  [<ffffffff81012c52>] ? mwait_idle+0x52/0x70
[ 1533.097463]  [<ffffffff81009980>] ? enter_idle+0x20/0x30
[ 1533.097465]  [<ffffffff81009c35>] ? cpu_idle+0x45/0x70
[ 1533.097467]  [<ffffffff814b58c8>] ? start_secondary+0x168/0x1c0
[ 1562.890899] Kernel panic - not syncing: Fatal exception in interrupt
[ 1563.004269] Pid: 1514, comm:  Tainted: G      D    2.6.32.41-zimbraI #1
[ 1563.120857] Call Trace:
[ 1563.187061]  <IRQ>  [<ffffffff8103ef40>] panic+0xa0/0x170
[ 1563.289293]  [<ffffffff81056eb5>] ? up+0x35/0x50
[ 1563.381992]  [<ffffffff8103f6a0>] ? release_console_sem+0x1c0/0x1e0
[ 1563.494825]  [<ffffffff8103f965>] ? console_unblank+0x65/0x80
[ 1563.601234]  [<ffffffff8103ebde>] ? print_oops_end_marker+0x1e/0x20
[ 1563.714056]  [<ffffffff8100f33f>] oops_end+0x9f/0xb0
[ 1563.811354]  [<ffffffff8102a75a>] no_context+0x15a/0x250
[ 1563.912768]  [<ffffffff8102aa5b>] __bad_area_nosemaphore+0xdb/0x1c0
[ 1564.025633]  [<ffffffff8102abde>] bad_area_nosemaphore+0xe/0x10
[ 1564.134185]  [<ffffffff8102ac7f>] do_page_fault+0x9f/0x260
[ 1564.237438]  [<ffffffff8134489f>] page_fault+0x1f/0x30
[ 1564.336434]  [<ffffffff81056298>] ? hrtimer_run_queues+0x128/0x210
[ 1564.448054]  [<ffffffff8105625c>] ? hrtimer_run_queues+0xec/0x210
[ 1564.558378]  [<ffffffff8106a060>] ? __rcu_process_callbacks+0x80/0x320
[ 1564.674098]  [<ffffffff81048dd9>] run_local_timers+0x9/0x20
[ 1564.777966]  [<ffffffff81048e27>] update_process_times+0x37/0x70
[ 1564.886688]  [<ffffffff8105da77>] tick_periodic+0x27/0x70
[ 1564.988144]  [<ffffffff8105dae1>] tick_handle_periodic+0x21/0x80
[ 1565.096979]  [<ffffffff8101e117>] smp_apic_timer_interrupt+0x67/0xa0
[ 1565.210093]  [<ffffffff8100bbf3>] apic_timer_interrupt+0x13/0x20

--------------080303030300050101050100--
