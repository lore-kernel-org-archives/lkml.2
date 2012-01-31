Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2AaQ6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:58:49 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56743 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2AaQ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:58:42 -0500
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 22:28:40 +0530
Message-ID: <CABJk5kkXe7jXZ=tNEgSOkE3_EwXbydh4rfkQwOc1WY8S2me6uA@mail.gmail.com>
Subject: Linux Kernel hangs
From: radiatejava <radiatejava@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am kind of new to linux kernel (not totally new). The issue I am
facing on my linux is that the machine hangs. I get to see these
messages in my /var/log/messages file and I need some pointers on
where the issue could be and because of what ? Linnux kernel is
2.6.18-128. Thanks in adv.

Jan 27 11:37:25 ECDCCAM1 kernel:
Jan 27 11:37:25 ECDCCAM1 kernel:
         sibling
Jan 27 11:37:25 ECDCCAM1 kernel:   task             PC      pid father
child younger older
Jan 27 11:37:25 ECDCCAM1 kernel: init          S 003CB211   768     1
    0     2               (NOTLB)
Jan 27 11:37:25 ECDCCAM1 kernel:        cb70ab68 00000082 6bccccd7
003cb211 cb70ab1c f7e3e000 cb70ab70 0000000a
Jan 27 11:37:26 ECDCCAM1 kernel:        cb70baa0 6bcd1a39 003cb211
00004d62 00000002 cb70bbac cb6202a8 f7df8040
Jan 27 11:37:26 ECDCCAM1 kernel:        cb70ab4c 00000000 00000286
c042c2e0 f7e3e000 cb70ab70 00000286 ffffffff
Jan 27 11:37:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f8886302>]
ext3_get_blocks_handle+0x899/0x8cc [ext3]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04730c1>] __find_get_block+0x15c/0x166
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04730fb>] __getblk+0x30/0x27a
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:37:26 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0488b5a>] __lookup_mnt+0x4a/0x53
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0485637>] __d_lookup+0x98/0xdb
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c047cce4>] do_lookup+0x53/0x174
Jan 27 11:37:26 ECDCCAM1 kernel:  [<c0485a36>] dput+0x22/0xed
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c047ee89>] __link_path_walk+0xbfa/0xd33
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c047f3d8>] do_path_lookup+0x20e/0x25e
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0479080>] cp_new_stat64+0xfc/0x10e
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:37:27 ECDCCAM1 kernel:  =======================
Jan 27 11:37:27 ECDCCAM1 kernel: migration/0   S 003CB1B7  3636     2
    1             3       (L-TLB)
Jan 27 11:37:27 ECDCCAM1 kernel:        f7e1dfac 00000046 ddf46253
003cb1b7 f7e1df98 c041ef1d 00933494 00000001
Jan 27 11:37:27 ECDCCAM1 kernel:        cb703550 ddf469f5 003cb1b7
000007a2 00000000 cb70365c cb6126e0 f72bdac0
Jan 27 11:37:27 ECDCCAM1 kernel:        00000003 00000000 cb6270d0
f4c3ef68 f4c3ef6c 00000293 f7e1dfac ffffffff
Jan 27 11:37:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c041ef1d>] move_tasks+0x26b/0x30f
Jan 27 11:37:27 ECDCCAM1 kernel:  [<c0421509>] migration_thread+0x151/0x1d3
Jan 27 11:42:37 ECDCCAM1 kernel: ut+0x13/0x8c
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:42:37 ECDCCAM1 xinetd[2261]: START: shell pid=12681 from=192.168.0.253
Jan 27 11:42:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:09 ECDCCAM1 send_arp[12773]: info: Killed old send_arp
process [12741]
Jan 27 11:48:09 ECDCCAM1 kernel:  =======================
Jan 27 11:48:09 ECDCCAM1 ipfail[3190]: info: Ping node count is balanced.
Jan 27 11:48:09 ECDCCAM1 send_arp[12773]: info: Killed old send_arp
process [12813]
Jan 27 11:48:09 ECDCCAM1 kernel: java          R running  2360 27916
   1         28138 27915 (NOTLB)
Jan 27 11:48:09 ECDCCAM1 rshd[12934]: root@192.168.0.253 as root:
cmd='/perfigo/common/bin/syslogconf 10.13.19.121'
Jan 27 11:48:09 ECDCCAM1 kernel: java          S 003CB1D3  2656 28138
    1         28139 27916 (NOTLB)
Jan 27 11:48:10 ECDCCAM1 ipfail[3190]: info: Link Status update: Link
10.13.230.94/10.13.230.94 now has status dead
Jan 27 11:48:10 ECDCCAM1 kernel:        e77c6d34 00000086 fee5dda6
003cb1d3 c05b56ff f770dc54 f770dc68 0000000a
Jan 27 11:48:10 ECDCCAM1 kernel:        e6b85000 feeb3186 003cb1d3
000553e0 00000000 e6b8510c cb6126e0 d5103900
Jan 27 11:48:10 ECDCCAM1 ipfail[3190]: info: Status update: Node
10.13.230.94 now has status dead
Jan 27 11:48:10 ECDCCAM1 kernel:        c06100a9 00000000 00000000
e77c6f60 00000001 ddfe584c ddfe584c ffffffff
Jan 27 11:48:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:10 ECDCCAM1 kernel:  =======================
Jan 27 11:48:10 ECDCCAM1 kernel: java          S 003CB1D8  2948 28139
    1          3825 28138 (NOTLB)
Jan 27 11:48:10 ECDCCAM1 kernel:        d5b29e94 00000086 a52a0296
003cb1d8 c0458d9b 00000202 d5103900 0000000a
Jan 27 11:48:10 ECDCCAM1 kernel:        e6b85550 a52a2d36 003cb1d8
00002aa0 00000003 e6b8565c cb62708c d5103900
Jan 27 11:48:10 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
00000286 c042c2e0 d5b29e9c cb6270d0 00000000
Jan 27 11:48:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:48:10 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042c33e>] try_to_del_timer_sync+0x44/0x4a
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:11 ECDCCAM1 kernel:  =======================
Jan 27 11:48:11 ECDCCAM1 kernel: java          S 003CB201  2528  3825
    1         27184 28139 (NOTLB)
Jan 27 11:48:11 ECDCCAM1 kernel:        e5574e94 00000086 1a4a133e
003cb201 00000000 00000202 d5103900 00000008
Jan 27 11:48:11 ECDCCAM1 kernel:        f798a550 1a4cc5d6 003cb201
0002b298 00000000 f798a65c cb6126e0 d5103900
Jan 27 11:48:11 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 c07a6200 e5574e9c 00000286 ffffffff
Jan 27 11:48:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:11 ECDCCAM1 kernel:  =======================
Jan 27 11:48:11 ECDCCAM1 kernel: java          S 003CB211  2660 27184
    1         27185  3825 (NOTLB)
Jan 27 11:48:11 ECDCCAM1 kernel:        f4d92d34 00000086 e3927488
003cb211 00000003 2e04f20e 003cb1ff 0000000a
Jan 27 11:48:11 ECDCCAM1 kernel:        cc149000 e392c858 003cb211
000053d0 00000000 cc14910c cb6126e0 d5103900
Jan 27 11:48:11 ECDCCAM1 kernel:        00000000 00000000 00000000
003cb20f 0000000a 00000100 cb612724 ffffffff
Jan 27 11:48:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041deec>] enqueue_task+0x29/0x39
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7x37b
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:11 ECDCCAM1 kernel:  =======================
Jan 27 11:48:11 ECDCCAM1 kernel: java          S 003CB1FA  2216 31176
    1         11434 31175 (NOTLB)
Jan 27 11:48:11 ECDCCAM1 kernel:        dbe4de94 00000086 0a7271fe
003cb1fa 00000000 00000001 00000070 0000000a
Jan 27 11:48:11 ECDCCAM1 kernel:        d1bd9550 0a7338c8 003cb1fa
0000c6ca 00000000 d1bd965c cb6126e0 d5103900
Jan 27 11:48:11 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 c07a6200 dbe4de9c 00000286 ffffffff
Jan 27 11:48:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:11 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:12 ECDCCAM1 kernel:  =======================
Jan 27 11:48:12 ECDCCAM1 kernel: java          S 003CB092  3396 11434
    1         11486 31176 (NOTLB)
Jan 27 11:48:12 ECDCCAM1 kernel:        e74fde94 00000086 c28847fa
003cb092 00000180 00000202 d5103900 0000000a
Jan 27 11:48:12 ECDCCAM1 kernel:        d9c11550 c28909b9 003cb092
0000c1bf 00000000 d9c1165c cb6126e0 d5103900
Jan 27 11:48:12 ECDCCAM1 kernel:        00000000 e74fde88 00000000
00000000 00000003 cfda9f0c cb612b9c cfda9f0c
Jan 27 11:48:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:12 ECDCCAM1 kernel:  =======================
Jan 27 11:48:12 ECDCCAM1 kernel: java          S 003CB0A7  3396 11486
    1         12400 11434 (NOTLB)
Jan 27 11:48:12 ECDCCAM1 kernel:        d9367e94 00000086 ec8dc956
003cb0a7 00000000 00000202 d5103900 00000006
Jan 27 11:48:12 ECDCCAM1 kernel:        cfd8d000 ec8e8abd 003cb0a7
0000c167 00000002 cfd8d10c cb6202a8 d5103900
Jan 27 11:48:12 ECDCCAM1 kernel:        00000000 d9367e88 00000000
00000000 00000003 e61dbf0c cb6202ec e61dbf0c
Jan 27 11:48:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:12 ECDCCAM1 kernel:  =======================
Jan 27 11:48:12 ECDCCAM1 kernel: java          S 003CB1EF  3396 12400
    1         12475 11486 (NOTLB)
Jan 27 11:48:12 ECDCCAM1 kernel:        dbd1ee94 00000086 bb1b7579
003cb1ef 00000000 00000206 d5103900 00000006
Jan 27 11:48:12 ECDCCAM1 kernel:        cfc7aaa0 bb1c402d 003cb1ef
0000cab4 00000001 cfc7abac cb6194c4 d5103900
Jan 27 11:48:12 ECDCCAM1 kernel:        00000000 dbd1ee88 00000000
00000000 00000003 dcf44f0c cb619980 dcf44f0c
Jan 27 11:48:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:13 ECDCCAM1 kernel:  =======================
Jan 27 11:48:13 ECDCCAM1 kernel: java          S 003CB204  3396 12475
    1         12505 12400 (NOTLB)
Jan 27 11:48:13 ECDCCAM1 kernel:        e5c8be94 00000086 e445a097
003cb204 00000000 00000000 00000000 00000006
Jan 27 11:48:13 ECDCCAM1 kernel:        cff92000 e446641a 003cb204
0000c383 00000002 cff9210c cb6202a8 d5103900
Jan 27 11:48:13 ECDCCAM1 kernel:        00000000 e5c8be88 00000000
00000000 00000003 d9d4df0c cb620764 d9d4df0c
Jan 27 11:48:13 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:13 ECDCCAM1 kernel:  =======================
Jan 27 11:48:13 ECDCCAM1 kernel: java          S 003CB1CB  3004 12505
    1         12558 12475 (NOTLB)
Jan 27 11:48:13 ECDCCAM1 kernel:        d4a2fd0c 00000086 91ccdd35
003cb1cb 00000006 5352bc27 00000000 00000008
Jan 27 11:48:13 ECDCCAM1 kernel:        d51c7aa0 91cce8e1 003cb1cb
00000bac 00000000 d51c7bac cb6126e0 d5103900
Jan 27 11:48:13 ECDCCAM1 kernel:        00000002 00000000 00000000
d7ce2940 f7669180 00000000 c05decfa ffffffff
Jan 27 11:48:13 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:13 ECDCCAM1 kernel:  =======================
Jan 27 11:48:13 ECDCCAM1 kernel: java          S 003CB1E1  2904 12558
    1         12571 12505 (NOTLB)
Jan 27 11:48:14 ECDCCAM1 kernel:        e2ae1d0c 00000086 3fbebdda
003cb1e1 00000006 59454211 00000000 00000006
Jan 27 11:48:14 ECDCCAM1 kernel:        f3d71000 3fbed5b9 003cb1e1
000017df 00000000 f3d7110c cb6126e0 d5103900
Jan 27 11:48:14 ECDCCAM1 kernel:        00000102 00000000 00000000
d751cdc0 f71e7480 00000000 c05df338 ffffffff
Jan 27 11:48:14 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05df338>] tcp_rcv_established+0x736/0x7c6
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:14 ECDCCAM1 kernel:  =======================
Jan 27 11:48:14 ECDCCAM1 kernel: java          S 003CB1E6  3004 12571
    1         12595 12558 (NOTLB)
Jan 27 11:48:14 ECDCCAM1 kernel:        eae66d0c 00000086 5684e0bb
003cb1e6 00000007 5a1da0aa 00000000 00000007
Jan 27 11:48:14 ECDCCAM1 kernel:        d202b550 56850c4e 003cb1e6
00002b93 00000000 d202b65c cb6126e0 d5103900
Jan 27 11:48:14 ECDCCAM1 kernel:        00000286 00000000 f300a800
00000246 00000000 d93e36c0 f300a800 ffffffff
Jan 27 11:48:14 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:14 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:15 ECDCCAM1 kernel:  =======================
Jan 27 11:48:15 ECDCCAM1 kernel: java          S 003CB1EF  3396 12595
    1         12598 12571 (NOTLB)
Jan 27 11:48:15 ECDCCAM1 kernel:        dcf44e94 00000086 bb1dc79c
003cb1ef 00000000 00000000 00000000 00000006
Jan 27 11:48:15 ECDCCAM1 kernel:        cfc87aa0 bb1e3d62 003cb1ef
000075c6 00000001 cfc87bac cb6194c4 d5103900
Jan 27 11:48:15 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 f7e3c000 dcf44e9c 00000286 ffffffff
Jan 27 11:48:15 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:15 ECDCCAM1 kernel:  =======================
Jan 27 11:48:15 ECDCCAM1 kernel: java          S 003CB1F0  2904 12598
    1         12608 12595 (NOTLB)
Jan 27 11:48:15 ECDCCAM1 kernel:        d16e1d0c 00000086 67e95731
003cb1f0 00000006 5d62ca6b 00000000 0000000a
Jan 27 11:48:15 ECDCCAM1 kernel:        f744e000 67e9727f 003cb1f0
00001b4e 00000000 f744e10c cb6126e0 d5103900
Jan 27 11:48:15 ECDCCAM1 kernel:        00000102 00000000 00000000
e33ce040 d203de00 00000000 c05df338 ffffffff
Jan 27 11:48:15 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05df338>] tcp_rcv_established+0x736/0x7c6
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:15 ECDCCAM1 kernel:  =======================
Jan 27 11:48:16 ECDCCAM1 kernel: java          S 003CB1F4  2904 12608
    1         12647 12598 (NOTLB)
Jan 27 11:48:16 ECDCCAM1 kernel:        db857d0c 00000086 c9bed819
003cb1f4 00000006 5e1d08bc 00000000 0000000a
Jan 27 11:48:16 ECDCCAM1 kernel:        cf99f000 c9bef609 003cb1f4
00001df0 00000000 cf99f10c cb6126e0 d5103900
Jan 27 11:48:16 ECDCCAM1 kernel:        00000102 00000000 00000000
e2a76040 d7a55a40 00000000 c05df338 ffffffff
Jan 27 11:48:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05df338>] tcp_rcv_established+0x736/0x7c6
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05acc46>] lock_sock+0x8e/0x96
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c048115d>] sys_ioctl+0x58/0x5f
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:16 ECDCCAM1 kernel:  =======================
Jan 27 11:48:16 ECDCCAM1 kernel: java          S 003CB204  3396 12647
    1         12772 12608 (NOTLB)
Jan 27 11:48:16 ECDCCAM1 kernel:        d9d4de94 00000086 e446641a
003cb204 00000000 00000000 00000000 00000006
Jan 27 11:48:16 ECDCCAM1 kernel:        d202b000 e447082b 003cb204
0000a411 00000002 d202b10c cb6202a8 d5103900
Jan 27 11:48:16 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
c042c2e0 f7e3e000 d9d4de9c 00000286 ffffffff
Jan 27 11:48:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:16 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:17 ECDCCAM1 kernel:  =======================
Jan 27 11:48:17 ECDCCAM1 kernel: httpd.worker  S 003CB25A  1752  2567
    1 25167    2653  2566 (NOTLB)
Jan 27 11:48:17 ECDCCAM1 kernel:        d39e1b68 00200086 35623c16
003cb25a c04074d6 d39e1b20 d39e1b70 00000001
Jan 27 11:48:17 ECDCCAM1 kernel:        cfe05aa0 3562c7be 003cb25a
00008ba8 00000001 cfe05bac cb6194c4 f7df8200
Jan 27 11:48:17 ECDCCAM1 kernel:        000003e8 00000000 00000000
c042c2e0 f7e3c000 d39e1b70 cb619508 c042c3f1
Jan 27 11:48:17 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f8885778>]
ext3_mark_inode_dirty+0x29/0x30 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0472d7d>] __find_get_block_slow+0xfb/0x105
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04730c1>] __find_get_block+0x15c/0x166
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04730fb>] __getblk+0x30/0x27a
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<f88875a3>]
ext3_ordered_commit_write+0xae/0xcc [ext3]
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c041e807>] try_to_wake_up+0x3e6/0x3f0
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:48:17 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434c0b>] remove_wait_queue+0x16/0x23
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:18 ECDCCAM1 kernel:  =======================
Jan 27 11:48:18 ECDCCAM1 kernel: perl          S 003CB2A7  2508  2570
    1 12909    2571  3467 (NOTLB)
Jan 27 11:48:18 ECDCCAM1 kernel:        f721df00 00000086 85fe15e4
003cb2a7 f711cb08 f711caf8 00000001 00000009
Jan 27 11:48:18 ECDCCAM1 kernel:        d06ca000 85fec78a 003cb2a7
0000b1a6 00000002 d06ca10c cb6202a8 f711cac0
Jan 27 11:48:18 ECDCCAM1 kernel:        f711cac0 00000000 f701b284
f711cac0 00000000 00000000 f721df08 ffffffff
Jan 27 11:48:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04805d0>] fasync_helper+0x3c/0xae
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:18 ECDCCAM1 kernel:  =======================
Jan 27 11:48:18 ECDCCAM1 kernel: tee           S 0000001A  2640  2571
    1          3566  2570 (NOTLB)
Jan 27 11:48:18 ECDCCAM1 kernel:        d3174f00 00000082 0a308454
0000001a f7f4517c f7f98648 f7f450d4 00000007
Jan 27 11:48:18 ECDCCAM1 kernel:        d2161000 0a36a414 0000001a
00061fc0 00000000 d216110c cb6126e0 f7f48580
Jan 27 11:48:18 ECDCCAM1 kernel:        d2173698 00000000 d11c4b74
f7f48580 00000000 fffac000 d3174f08 ffffffff
Jan 27 11:48:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04628b9>] unmap_region+0xb8/0xf0
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:18 ECDCCAM1 kernel:  =======================
Jan 27 11:48:18 ECDCCAM1 kernel: diskwatchmana S 003CB25A  2668  2653
    1 12685    2722  2567 (NOTLB)
Jan 27 11:48:18 ECDCCAM1 kernel:        d0a13f00 00000082 35e50527
003cb25a f7f48e88 f7f48e78 00000001 00000007
Jan 27 11:48:18 ECDCCAM1 kernel:        d19e6000 35e5bd43 003cb25a
0000b81c 00000000 d19e610c cb6126e0 f7f48e40
Jan 27 11:48:18 ECDCCAM1 kernel:        f7f48e40 082dd100 d41efb74
f7f48e40 00000000 00000000 cb612b9c ef0f6200
Jan 27 11:48:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:18 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:19 ECDCCAM1 kernel:  =======================
Jan 27 11:48:19 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2476  2722
    1  2725    2732  2653 (NOTLB)
Jan 27 11:48:19 ECDCCAM1 kernel:        d195fc08 00000082 7fe56291
003cb2a7 00000000 f79d0400 f768e4c0 00000001
Jan 27 11:48:19 ECDCCAM1 kernel:        f75bb550 7fe6b7ea 003cb2a7
00015559 00000003 f75bb65c cb62708c f72bde40
Jan 27 11:48:19 ECDCCAM1 kernel:        f8885396 00000000 00000000
c042c2e0 cb740000 d195fc10 00000286 c042c3f1
Jan 27 11:48:19 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:19 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:19 ECDCCAM1 last message repeated 7 times
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0458aa7>] get_page_from_freelist+0x96/0x333
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0466230>] anon_vma_prepare+0x11/0xa5
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0403d29>] copy_thread+0x2f/0x1e6
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c043272c>] attach_pid+0x6c/0x98
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04307fd>] sys_times+0x182/0x1c8
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:19 ECDCCAM1 kernel:  =======================
Jan 27 11:48:19 ECDCCAM1 kernel: heartbeat     S 003CB2A7  3044  2725
 2722          2726       (NOTLB)
Jan 27 11:48:19 ECDCCAM1 kernel:        cffa5f00 00000082 7e70037c
003cb2a7 00000001 0000000f 00000000 00000007
Jan 27 11:48:19 ECDCCAM1 kernel:        d294d000 7e70085e 003cb2a7
000004e2 00000003 d294d10c cb62708c f72bdc80
Jan 27 11:48:19 ECDCCAM1 kernel:        00000246 00000000 00000000
f79d0400 f884e67c 00000001 cffa5f08 ffffffff
Jan 27 11:48:19 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:19 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:19 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:20 ECDCCAM1 kernel:  =======================
Jan 27 11:48:20 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2164  2726
 2722          2727  2725 (NOTLB)
Jan 27 11:48:20 ECDCCAM1 kernel:        d4b30c08 00000082 7fe16089
003cb2a7 d2918bd4 00000000 a0020000 00000001
Jan 27 11:48:20 ECDCCAM1 kernel:        d4b2faa0 7fe24c64 003cb2a7
0000ebdb 00000002 d4b2fbac cb6202a8 d06c9740
Jan 27 11:48:20 ECDCCAM1 kernel:        d4b30c18 f8cf2dea 0000000c
0000000c f8cf2eeb 0000000c d4b30c18 d2918bd4
Jan 27 11:48:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:20 ECDCCAM1 kernel:  [<f8cf2dea>]
nscatterwalk_map+0x32/0x40 [crypto_algapi]
Jan 27 11:48:20 ECDCCAM1 kernel:  [<f8cf2eeb>]
nscatterwalk_copychunks+0x9f/0xd1 [crypto_algapi]
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0605a47>] unix_poll+0x17/0x8f
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b9cd4>] neigh_resolve_output+0x1a6/0x1d0
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05fcda1>] xfrm4_output_finish2+0xaa/0x281
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05d064c>]
ip_push_pending_frames+0x33d/0x396
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05e8f6c>]
udp_push_pending_frames+0x1ce/0x1ef
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05e9b15>] udp_sendmsg+0x44e/0x514
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04059d7>] apic_timer_interrupt+0x1f/0x24
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05aa412>] sock_recvmsg+0xfc/0x100
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:20 ECDCCAM1 kernel:  =======================
Jan 27 11:48:20 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2740  2727
 2722          2728  2726 (NOTLB)
Jan 27 11:48:20 ECDCCAM1 kernel:        d4914d34 00000086 75bf1217
003cb2a7 00000246 00000007 e9e41780 00000001
Jan 27 11:48:20 ECDCCAM1 kernel:        d415c000 75bf6fff 003cb2a7
00005de8 00000000 d415c10c cb6126e0 f7ba9200
Jan 27 11:48:20 ECDCCAM1 kernel:        000000a9 00000000 c05b0fec
e2532864 bfb2e4f8 000000a9 cb760ea7 ffffffff
Jan 27 11:48:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b0fec>]
skb_copy_and_csum_datagram+0x94/0x31b
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:20 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041f0e0>] rebalance_tick+0x11f/0x2e4
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:21 ECDCCAM1 kernel:  =======================
Jan 27 11:48:21 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2192  2728
 2722          2729  2727 (NOTLB)
Jan 27 11:48:21 ECDCCAM1 kernel:        d4b2dc08 00000086 7fe24c64
003cb2a7 00000002 00000003 2dfb8a40 00000001
Jan 27 11:48:21 ECDCCAM1 kernel:        d41f1000 7fe35d14 003cb2a7
000110b0 00000002 d41f110c cb6202a8 d06c9900
Jan 27 11:48:21 ECDCCAM1 kernel:        d4b2dc00 00000000 00000000
d4b2dc00 00000000 d4b2dca0 cb6202ec ffffffff
Jan 27 11:48:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0605a47>] unix_poll+0x17/0x8f
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041e807>] try_to_wake_up+0x3e6/0x3f0
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0607fc8>] unix_write_space+0xf/0x69
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:21 ECDCCAM1 kernel:  =======================
Jan 27 11:48:21 ECDCCAM1 kernel: heartbeat     S 003CB2A7  2744  2729
 2722          3190  2728 (NOTLB)
Jan 27 11:48:21 ECDCCAM1 kernel:        d5872d34 00000082 774abb71
003cb2a7 00000000 0aee8500 00000000 00000001
Jan 27 11:48:21 ECDCCAM1 kernel:        f76c0aa0 774bbdb5 003cb2a7
00010244 00000000 f76c0bac cb6126e0 d5103580
Jan 27 11:48:21 ECDCCAM1 kernel:        0aeef2e4 00000000 00000000
cb619f44 d5872d68 00000082 d195fcf8 ffffffff
Jan 27 11:48:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:21 ECDCCAM1 kernel:  [<c05e83d7>] raw_recvmsg+0x6e/0x176
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:22 ECDCCAM1 kernel:  =======================
Jan 27 11:48:22 ECDCCAM1 kernel: ipfail        S 003CB2A7  2360  3190
 2722         12872  2729 (NOTLB)
Jan 27 11:48:22 ECDCCAM1 kernel:        cfc76d34 00000086 86711c30
003cb2a7 0032bdad 2269eeaa 002cc28e 0000000a
Jan 27 11:48:22 ECDCCAM1 kernel:        f7645aa0 8671d93d 003cb2a7
0000bd0d 00000000 f7645bac cb6126e0 cfd8c3c0
Jan 27 11:48:22 ECDCCAM1 kernel:        d546cce0 00000000 00000000
c04074d6 cfc76d28 d546ce04 cb6202ec d546cce0
Jan 27 11:48:22 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0458ccb>]
get_page_from_freelist+0x2ba/0x333
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0466230>] anon_vma_prepare+0x11/0xa5
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0461537>] __handle_mm_fault+0xb1c/0xb7b
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:22 ECDCCAM1 kernel:  =======================
Jan 27 11:48:22 ECDCCAM1 kernel: postmaster    S 003CACEC  1572  3447
 2304          3450  2313 (NOTLB)
Jan 27 11:48:22 ECDCCAM1 kernel:        cfc9bd0c 00200086 42ba2286
003cacec 00000002 cb620e08 00000001 00000007
Jan 27 11:48:22 ECDCCAM1 kernel:        cfc7a550 42ba2b81 003cacec
000008fb 00000001 cfc7a65c cb6194c4 f74a8ac0
Jan 27 11:48:22 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b136c0 f70615c0 00000001 c05decfa ffffffff
Jan 27 11:48:22 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:23 ECDCCAM1 kernel:  =======================
Jan 27 11:48:23 ECDCCAM1 kernel: postmaster    S 003CB209  1548  3450
 2304          3451  3447 (NOTLB)
Jan 27 11:48:23 ECDCCAM1 kernel:        e21a0d0c 00200082 7163fcb2
003cb209 00000006 252532a6 00000001 0000000a
Jan 27 11:48:23 ECDCCAM1 kernel:        d294d550 71640e2a 003cb209
00001178 00000002 d294d65c cb6202a8 d5103c80
Jan 27 11:48:23 ECDCCAM1 kernel:        00000002 00000000 00000001
d0b12dc0 f7061380 00000001 c05decfa ffffffff
Jan 27 11:48:23 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:23 ECDCCAM1 kernel:  =======================
Jan 27 11:48:23 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3451
 2304          3452  3450 (NOTLB)
Jan 27 11:48:23 ECDCCAM1 kernel:        d0b15d0c 00200086 87981f32
003cadc1 00000003 cb627bec 00000001 00000007
Jan 27 11:48:23 ECDCCAM1 kernel:        f770b000 879828ab 003cadc1
00000979 00000001 f770b10c cb6194c4 f7df8ac0
Jan 27 11:48:23 ECDCCAM1 kernel:        00000000 00000000 00000001
cfcabb40 e37c0480 00000001 c05decfa ffffffff
Jan 27 11:48:23 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:23 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:24 ECDCCAM1 kernel:  =======================
Jan 27 11:48:24 ECDCCAM1 kernel: postmaster    S 003CAD5D  1548  3452
 2304          3453  3451 (NOTLB)
Jan 27 11:48:24 ECDCCAM1 kernel:        d0b1ad0c 00200082 43a700db
003cad5d 00000006 c81d1a1a 00000001 00000007
Jan 27 11:48:24 ECDCCAM1 kernel:        d51c7000 43a70b44 003cad5d
00000a69 00000001 d51c710c cb6194c4 f7df8c80
Jan 27 11:48:24 ECDCCAM1 kernel:        00000000 00000000 00000001
cfca9b40 d62d49c0 00000001 c05decfa ffffffff
Jan 27 11:48:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:24 ECDCCAM1 kernel:  =======================
Jan 27 11:48:24 ECDCCAM1 kernel: postmaster    S 003CAD4E  1548  3453
 2304          3454  3452 (NOTLB)
Jan 27 11:48:24 ECDCCAM1 kernel:        d0b38d0c 00200082 b363f426
003cad4e 00000006 17960523 00000001 0000000a
Jan 27 11:48:24 ECDCCAM1 kernel:        f7140550 b363fe5e 003cad4e
00000a38 00000000 f714065c cb6126e0 f72bd040
Jan 27 11:48:24 ECDCCAM1 kernel:        00000000 00000000 00000001
cfcab6c0 dffe7600 00000001 c05decfa ffffffff
Jan 27 11:48:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:24 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:25 ECDCCAM1 kernel:  =======================
Jan 27 11:48:25 ECDCCAM1 kernel: postmaster    S 003CAD3D  1572  3454
 2304          3455  3453 (NOTLB)
Jan 27 11:48:25 ECDCCAM1 kernel:        d0b40d0c 00200086 33513659
003cad3d 00000006 652bbf06 00000001 00000008
Jan 27 11:48:25 ECDCCAM1 kernel:        f75fbaa0 33514de7 003cad3d
0000178e 00000001 f75fbbac cb6194c4 f72bd200
Jan 27 11:48:25 ECDCCAM1 kernel:        00000002 00000000 00000001
d0b124c0 e8c628c0 00000001 c05decfa ffffffff
Jan 27 11:48:25 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:25 ECDCCAM1 kernel:  =======================
Jan 27 11:48:25 ECDCCAM1 kernel: postmaster    S 003CAE22  1572  3455
 2304          3456  3454 (NOTLB)
Jan 27 11:48:25 ECDCCAM1 kernel:        d0b29d0c 00200082 3f525fdb
003cae22 00000006 c6c46a92 00000001 00000007
Jan 27 11:48:25 ECDCCAM1 kernel:        f7619550 3f52799d 003cae22
000019c2 00000003 f761965c cb62708c f711cc80
Jan 27 11:48:25 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b53b40 d831c800 00000001 c05decfa ffffffff
Jan 27 11:48:25 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:25 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:26 ECDCCAM1 kernel:  =======================
Jan 27 11:48:26 ECDCCAM1 kernel: postmaster    S 003CAD56  1548  3456
 2304          3457  3455 (NOTLB)
Jan 27 11:48:26 ECDCCAM1 kernel:        d0b57d0c 00200082 c9e7f1cd
003cad56 00000003 cb627bec 00000001 00000007
Jan 27 11:48:26 ECDCCAM1 kernel:        cfdc6550 c9e7fa44 003cad56
00000877 00000001 cfdc665c cb6194c4 cfd8c040
Jan 27 11:48:26 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b53240 d39afc80 00000001 c05decfa ffffffff
Jan 27 11:48:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:26 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:27 ECDCCAM1 kernel:  =======================
Jan 27 11:48:27 ECDCCAM1 kernel: postmaster    S 003CAE22  1572  3457
 2304          3458  3456 (NOTLB)
Jan 27 11:48:27 ECDCCAM1 kernel:        d0b60d0c 00200082 3f52604d
003cae22 00000006 af747b08 00000001 00000007
Jan 27 11:48:27 ECDCCAM1 kernel:        d51fdaa0 3f526b72 003cae22
00000b25 00000001 d51fdbac cb6194c4 f72bd580
Jan 27 11:48:27 ECDCCAM1 kernel:        00000000 00000000 00000001
cf91e4c0 cfdcf680 00000001 c05decfa ffffffff
Jan 27 11:48:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:27 ECDCCAM1 kernel:  =======================
Jan 27 11:48:27 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3458
 2304          3459  3457 (NOTLB)
Jan 27 11:48:27 ECDCCAM1 kernel:        d0b50d0c 00200082 8788e6e0
003cadc1 00000100 0038a24d 00000001 00000007
Jan 27 11:48:27 ECDCCAM1 kernel:        f7469aa0 8788ee7f 003cadc1
0000079f 00000000 f7469bac cb6126e0 f74a8580
Jan 27 11:48:27 ECDCCAM1 kernel:        00000000 00000000 00000001
cfccb6c0 cfdcf380 00000001 c05decfa ffffffff
Jan 27 11:48:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:27 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:28 ECDCCAM1 kernel:  =======================
Jan 27 11:48:28 ECDCCAM1 kernel: postmaster    S 003CB2A7  1548  3459
 2304          3460  3458 (NOTLB)
Jan 27 11:48:28 ECDCCAM1 kernel:        d0b79d0c 00200082 85299456
003cb2a7 cfe05000 c0458d9b 00000044 0000000a
Jan 27 11:48:28 ECDCCAM1 kernel:        cfe05000 852cec00 003cb2a7
000357aa 00000000 cfe0510c cb6126e0 cfc67580
Jan 27 11:48:28 ECDCCAM1 kernel:        00200286 c042c3f1 00000000
00200286 d0b52940 d0b52940 cb612724 bd4ead0f
Jan 27 11:48:28 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05acc73>] sk_reset_timer+0xc/0x16
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c060daf6>] schedule+0x9e2/0xa55
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:28 ECDCCAM1 kernel:  =======================
Jan 27 11:48:28 ECDCCAM1 kernel: postmaster    S 003CB094  1572  3460
 2304          3461  3459 (NOTLB)
Jan 27 11:48:28 ECDCCAM1 kernel:        d0b70d0c 00200082 28da522f
003cb094 00000003 cb627bec 00000001 00000007
Jan 27 11:48:28 ECDCCAM1 kernel:        f774caa0 28da683a 003cb094
0000160b 00000001 f774cbac cb6194c4 f711c580
Jan 27 11:48:28 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b52040 e0e85080 00000001 c05decfa ffffffff
Jan 27 11:48:28 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:29 ECDCCAM1 kernel:  =======================
Jan 27 11:48:29 ECDCCAM1 kernel: postmaster    S 003CB00A  1548  3461
 2304          3462  3460 (NOTLB)
Jan 27 11:48:29 ECDCCAM1 kernel:        d0b97d0c 00200082 74347c0f
003cb00a 00000006 488ecf9e 00000001 00000007
Jan 27 11:48:29 ECDCCAM1 kernel:        cfdcc550 743493c1 003cb00a
000017b2 00000003 cfdcc65c cb62708c f74a8040
Jan 27 11:48:29 ECDCCAM1 kernel:        00000000 00000000 00000001
d0bb16c0 f7061080 00000001 c05decfa ffffffff
Jan 27 11:48:29 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:29 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:30 ECDCCAM1 kernel:  =======================
Jan 27 11:48:30 ECDCCAM1 kernel: postmaster    S 003CB0B6  1572  3462
 2304          3463  3461 (NOTLB)
Jan 27 11:48:30 ECDCCAM1 kernel:        d0ba0d0c 00200082 cad156e7
003cb0b6 00000006 f20cd69b 00000001 0000000a
Jan 27 11:48:30 ECDCCAM1 kernel:        d4b67550 cad162ff 003cb0b6
00000c18 00000001 d4b6765c cb6194c4 f7f48040
Jan 27 11:48:30 ECDCCAM1 kernel:        00000002 00000000 00000001
d0bb36c0 f408c3c0 00000001 c05decfa ffffffff
Jan 27 11:48:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:30 ECDCCAM1 kernel:  =======================
Jan 27 11:48:30 ECDCCAM1 kernel: postmaster    S 003CB131  1548  3463
 2304          3464  3462 (NOTLB)
Jan 27 11:48:30 ECDCCAM1 kernel:        d0bacd0c 00200086 c4e4424b
003cb131 00000006 98e32794 00000001 0000000a
Jan 27 11:48:30 ECDCCAM1 kernel:        f774c550 c4e454c8 003cb131
0000127d 00000001 f774c65c cb6194c4 f7f24900
Jan 27 11:48:30 ECDCCAM1 kernel:        00000002 00200286 00000000
d0bb2dc0 e444ee00 00000001 cb619980 00000001
Jan 27 11:48:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:31 ECDCCAM1 kernel:  =======================
Jan 27 11:48:31 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3464
 2304         13412  3463 (NOTLB)
Jan 27 11:48:31 ECDCCAM1 kernel:        d0bbbd0c 00200086 8788e58a
003cadc1 00000003 cb627bec 00000001 00000007
Jan 27 11:48:31 ECDCCAM1 kernel:        d2914550 8788fcc8 003cadc1
0000173e 00000003 d291465c cb62708c f7771ac0
Jan 27 11:48:31 ECDCCAM1 kernel:        00000000 00000000 00000001
d0bb0dc0 dfd15780 00000001 c05decfa ffffffff
Jan 27 11:48:31 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:31 ECDCCAM1 kernel:  =======================
Jan 27 11:48:31 ECDCCAM1 kernel: mingetty      S 00000031  3020  3566
    1          3567  2571 (NOTLB)
Jan 27 11:48:31 ECDCCAM1 kernel:        d20a3ee4 00000086 e8c868e2
00000031 00000020 d2808600 d280c29e 00000007
Jan 27 11:48:31 ECDCCAM1 kernel:        cfc7a000 e8c92780 00000031
0000be9e 00000001 cfc7a10c cb6194c4 d4b63900
Jan 27 11:48:31 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:31 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:31 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:32 ECDCCAM1 kernel:  =======================
Jan 27 11:48:32 ECDCCAM1 kernel: mingetty      S 00000031  3072  3567
    1          3568  3566 (NOTLB)
Jan 27 11:48:32 ECDCCAM1 kernel:        cfda7ee4 00000082 e8c7d541
00000031 00000020 d2814600 d280e29e 00000007
Jan 27 11:48:32 ECDCCAM1 kernel:        d41f1aa0 e8c868e2 00000031
000093a1 00000001 d41f1bac cb6194c4 f7f62e40
Jan 27 11:48:32 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:32 ECDCCAM1 kernel:  =======================
Jan 27 11:48:32 ECDCCAM1 kernel: mingetty      S 00000031  2660  3568
    1          3569  3567 (NOTLB)
Jan 27 11:48:32 ECDCCAM1 kernel:        d2028ee4 00000082 e8ca15cb
00000031 00000020 d2826a00 d282b29e 00000006
Jan 27 11:48:32 ECDCCAM1 kernel:        d41d0550 e8cab32c 00000031
00009d61 00000001 d41d065c cb6194c4 f7ba9e40
Jan 27 11:48:32 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:32 ECDCCAM1 kernel:  =======================
Jan 27 11:48:32 ECDCCAM1 kernel: mingetty      S 00000031  3072  3569
    1          3570  3568 (NOTLB)
Jan 27 11:48:32 ECDCCAM1 kernel:        d0be8ee4 00000086 e8c92780
00000031 00000020 d2826c00 d611629e 00000007
Jan 27 11:48:32 ECDCCAM1 kernel:        f7d22550 e8c9e75c 00000031
0000bfdc 00000001 f7d2265c cb6194c4 f77713c0
Jan 27 11:48:32 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:33 ECDCCAM1 kernel:  =======================
Jan 27 11:48:33 ECDCCAM1 kernel: mingetty      S 00000031  3016  3570
    1          3571  3569 (NOTLB)
Jan 27 11:48:33 ECDCCAM1 kernel:        cfdcaee4 00000086 e8cab32c
00000031 00000020 d2031e00 d282c29e 00000004
Jan 27 11:48:33 ECDCCAM1 kernel:        d41d0000 e8cb65fd 00000031
0000b2d1 00000001 d41d010c cb6194c4 cfc673c0
Jan 27 11:48:33 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:48:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:33 ECDCCAM1 kernel:  =======================
Jan 27 11:48:33 ECDCCAM1 kernel: agetty        S 00000032  2412  3571
    1          3646  3570 (NOTLB)
Jan 27 11:48:33 ECDCCAM1 kernel:        d51b7ee4 00000082 290b7071
00000032 000000ca c04546b7 00000000 00000008
Jan 27 11:48:33 ECDCCAM1 kernel:        d51c7550 290c069f 00000032
0000962e 00000002 d51c765c cb6202a8 cfd84580
Jan 27 11:48:33 ECDCCAM1 kernel:        cb5f8e20 00000000 00000000
00000000 c07ce7e0 c07ce7e0 c07ce7e0 ffffffff
Jan 27 11:48:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:34 ECDCCAM1 kernel:  =======================
Jan 27 11:48:34 ECDCCAM1 kernel: snmpd         S 003CB25A  1604  3646
    1          3651  3571 (NOTLB)
Jan 27 11:48:34 ECDCCAM1 kernel:        d283db68 00200086 36bd040f
003cb25a cfdccaa0 d283db7c c060dae0 00000009
Jan 27 11:48:34 ECDCCAM1 kernel:        cfdccaa0 36c41e1f 003cb25a
00071a10 00000002 cfdccbac cb6202a8 f7771200
Jan 27 11:48:34 ECDCCAM1 kernel:        000402af 00000002 00200286
c042c2e0 f7e3e000 d283db70 cb620764 c042c3f1
Jan 27 11:48:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:34 ECDCCAM1 last message repeated 4 times
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041d39b>] find_busiest_group+0x177/0x464
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041f0e0>] rebalance_tick+0x11f/0x2e4
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c041d39b>] find_busiest_group+0x177/0x464
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0458ccb>]
get_page_from_freelist+0x2ba/0x333
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0466230>] anon_vma_prepare+0x11/0xa5
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0461537>] __handle_mm_fault+0xb1c/0xb7b
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e8888>] scnprintf+0x1f/0x2b
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0428929>] current_fs_time+0x4a/0x55
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0487c1f>] touch_atime+0x60/0x91
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c047c654>] pipe_readv+0x315/0x321
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:34 ECDCCAM1 kernel:  =======================
Jan 27 11:48:34 ECDCCAM1 kernel: snmpd         S 00000031  2868  3651
    1          4053  3646 (NOTLB)
Jan 27 11:48:34 ECDCCAM1 kernel:        d2863d18 00200086 f944dcf2
00000031 c05ba88b 00000e3e 00000000 00000001
Jan 27 11:48:34 ECDCCAM1 kernel:        cfdc6000 f946068e 00000031
0001299c 00000001 cfdc610c cb6194c4 f7771200
Jan 27 11:48:34 ECDCCAM1 kernel:        c06100a9 00000000 c0405a89
d2863f4c 0000010f d587a000 d587a0a0 ffffffff
Jan 27 11:48:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:34 ECDCCAM1 kernel:  [<c05ba88b>] rtnetlink_dump_ifinfo+0x4a/0x6c
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0405a89>] error_code+0x39/0x40
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05c73d6>] netlink_recvmsg+0x46/0x281
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05c7223>] netlink_sendmsg+0x277/0x284
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c048595f>] d_alloc+0x14f/0x17d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0484f20>] d_rehash+0x1c/0x2b
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:35 ECDCCAM1 kernel:  =======================
Jan 27 11:48:35 ECDCCAM1 kernel: postmaster    S 003CADC1  1572 13412
 2304         12049  3464 (NOTLB)
Jan 27 11:48:35 ECDCCAM1 kernel:        f3bf3d0c 00200086 8779a572
003cadc1 00000000 cb613240 00000001 00000007
Jan 27 11:48:35 ECDCCAM1 kernel:        f59b5aa0 8779b14e 003cadc1
00000bdc 00000000 f59b5bac cb6126e0 f7f623c0
Jan 27 11:48:35 ECDCCAM1 kernel:        00000000 00000000 00000001
d105d240 dfd15780 00000001 c05decfa ffffffff
Jan 27 11:48:35 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:35 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:36 ECDCCAM1 kernel:  =======================
Jan 27 11:48:36 ECDCCAM1 kernel: postmaster    S 003CADC1  1572 12049
 2304               13412 (NOTLB)
Jan 27 11:48:36 ECDCCAM1 kernel:        e4e88d0c 00200086 8772ad4a
003cadc1 cb6202ec cfdc6550 00000001 00000007
Jan 27 11:48:36 ECDCCAM1 kernel:        dbe24000 8772b8d5 003cadc1
00000b8b 00000002 dbe2410c cb6202a8 f7f48ac0
Jan 27 11:48:36 ECDCCAM1 kernel:        00000000 00000000 00000001
cfca96c0 d667dd80 00000001 c05decfa ffffffff
Jan 27 11:48:36 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:36 ECDCCAM1 kernel:  =======================
Jan 27 11:48:36 ECDCCAM1 kernel: sshd          S 003CB1B8  2552 30911
    1         27915 12110 (NOTLB)
Jan 27 11:48:36 ECDCCAM1 kernel:        e1537b68 00000082 1331412b
003cb1b8 00000000 00000003 28c23661 00000007
Jan 27 11:48:36 ECDCCAM1 kernel:        cfd9b550 13319fe7 003cb1b8
00005ebc 00000000 cfd9b65c cb6126e0 d0fb2580
Jan 27 11:48:36 ECDCCAM1 kernel:        e1537c10 00000000 00000000
e1537c0c 00000203 00000200 cb612724 ffffffff
Jan 27 11:48:36 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c04815fa>] free_poll_entry+0xe/0x16
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:36 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:36 ECDCCAM1 last message repeated 8 times
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0458aa7>] get_page_from_freelist+0x96/0x333
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c046d8c7>] cache_alloc_refill+0x60/0x450
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c05aff95>] __alloc_skb+0x49/0xf4
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0458aa7>] get_page_from_freelist+0x96/0x333
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c05ae0a5>] sock_def_readable+0xf/0x5b
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0485a36>] dput+0x22/0xed
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c04a0be3>] proc_flush_task+0x97/0x1b0
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c048263b>] sys_select+0xcf/0x180
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:37 ECDCCAM1 kernel:  =======================
Jan 27 11:48:37 ECDCCAM1 kernel: httpd.worker  S 003C61D5  3088 25167
 2567         25180       (NOTLB)
Jan 27 11:48:37 ECDCCAM1 kernel:        cd08cf00 00200082 4a4c1b2d
003c61d5 f76f3554 f7b2b788 f76f34ac 00000007
Jan 27 11:48:37 ECDCCAM1 kernel:        da792aa0 4a4c2191 003c61d5
00000664 00000002 da792bac cb6202a8 e5a50740
Jan 27 11:48:37 ECDCCAM1 kernel:        f7970564 00000000 00000000
e5a50740 00000000 00000000 cd08cf08 dc293000
Jan 27 11:48:37 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c041df46>] __activate_task+0x4a/0x59
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:37 ECDCCAM1 kernel:  =======================
Jan 27 11:48:37 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2588 25180
 2567         25181 25167 (NOTLB)
Jan 27 11:48:37 ECDCCAM1 kernel:        d7815e94 00200082 24a6831a
003cb13f 00000040 c06a7400 d7815eb4 0000000a
Jan 27 11:48:37 ECDCCAM1 kernel:        d61ba000 24a6a547 003cb13f
0000222d 00000000 d61ba10c cb6126e0 e5a50740
Jan 27 11:48:37 ECDCCAM1 kernel:        d7815eb4 00000000 00000200
00000040 d7815efc 00000200 d7815efc ffffffff
Jan 27 11:48:37 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:37 ECDCCAM1 kernel:  =======================
Jan 27 11:48:37 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25181
 2567         25182 25180 (NOTLB)
Jan 27 11:48:38 ECDCCAM1 kernel:        e1c80e94 00200082 257f9fd2
003cb13f 00000040 c06a7400 e1c80eb4 00000008
Jan 27 11:48:38 ECDCCAM1 kernel:        d4d4d000 257fbf68 003cb13f
00001f96 00000000 d4d4d10c cb6126e0 e5a50740
Jan 27 11:48:38 ECDCCAM1 kernel:        e1c80eb4 00000000 00000200
00000040 e1c80efc 00000200 e1c80efc ffffffff
Jan 27 11:48:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:38 ECDCCAM1 kernel:  =======================
Jan 27 11:48:38 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2468 25182
 2567         25185 25181 (NOTLB)
Jan 27 11:48:38 ECDCCAM1 kernel:        db0a6e94 00200082 ac819552
003cb13e 00000040 c06a7400 db0a6eb4 0000000a
Jan 27 11:48:38 ECDCCAM1 kernel:        e6b6e550 ac81d56e 003cb13e
0000401c 00000000 e6b6e65c cb6126e0 e5a50740
Jan 27 11:48:38 ECDCCAM1 kernel:        db0a6eb4 00000000 00000200
00000040 db0a6efc 00000200 db0a6efc ffffffff
Jan 27 11:48:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:38 ECDCCAM1 kernel:  =======================
Jan 27 11:48:38 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2504 25185
 2567         25187 25182 (NOTLB)
Jan 27 11:48:38 ECDCCAM1 kernel:        d441fe94 00200082 be3c308a
003cb13d 00000040 c06a7400 d441feb4 00000004
Jan 27 11:48:38 ECDCCAM1 kernel:        cfdcc000 be3c5541 003cb13d
000024b7 00000000 cfdcc10c cb6126e0 e5a50740
Jan 27 11:48:38 ECDCCAM1 kernel:        d441feb4 00000000 00000200
00000040 d441fefc 00000200 d441fefc ffffffff
Jan 27 11:48:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:38 ECDCCAM1 kernel:  =======================
Jan 27 11:48:38 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2660 25187
 2567         25189 25185 (NOTLB)
Jan 27 11:48:38 ECDCCAM1 kernel:        ea267e94 00200082 bdf13c7d
003cb13d 00000040 c06a7400 ea267eb4 00000008
Jan 27 11:48:39 ECDCCAM1 kernel:        d643f000 bdf15f5a 003cb13d
000022dd 00000000 d643f10c cb6126e0 e5a50740
Jan 27 11:48:39 ECDCCAM1 kernel:        ea267eb4 00000000 00000200
00000040 ea267efc 00000200 ea267efc ffffffff
Jan 27 11:48:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:39 ECDCCAM1 kernel:  =======================
Jan 27 11:48:39 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25189
 2567         25191 25187 (NOTLB)
Jan 27 11:48:39 ECDCCAM1 kernel:        e2996e94 00200082 25639220
003cb13f 00000040 c06a7400 e2996eb4 00000008
Jan 27 11:48:39 ECDCCAM1 kernel:        d428faa0 2563b6d1 003cb13f
000024b1 00000000 d428fbac cb6126e0 e5a50740
Jan 27 11:48:39 ECDCCAM1 kernel:        e2996eb4 00000000 00000200
00000040 e2996efc 00000200 e2996efc ffffffff
Jan 27 11:48:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:39 ECDCCAM1 kernel:  =======================
Jan 27 11:48:39 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2636 25191
 2567         25193 25189 (NOTLB)
Jan 27 11:48:39 ECDCCAM1 kernel:        f4733e94 00200082 2487e92c
003cb13f 00000040 c06a7400 f4733eb4 00000008
Jan 27 11:48:39 ECDCCAM1 kernel:        d428f550 248806e2 003cb13f
00001db6 00000000 d428f65c cb6126e0 e5a50740
Jan 27 11:48:39 ECDCCAM1 kernel:        f4733eb4 00000000 00000200
00000040 f4733efc 00000200 f4733efc ffffffff
Jan 27 11:48:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:39 ECDCCAM1 kernel:  =======================
Jan 27 11:48:39 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2636 25193
 2567         25195 25191 (NOTLB)
Jan 27 11:48:39 ECDCCAM1 kernel:        deff2e94 00200082 adb91100
003cb13e 00000040 c06a7400 deff2eb4 0000000a
Jan 27 11:48:40 ECDCCAM1 kernel:        d643faa0 adb93fb6 003cb13e
00002eb6 00000001 d643fbac cb6194c4 e5a50740
Jan 27 11:48:40 ECDCCAM1 kernel:        deff2eb4 00000000 00000200
00000040 deff2efc 00000200 deff2efc ffffffff
Jan 27 11:48:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:40 ECDCCAM1 kernel:  =======================
Jan 27 11:48:40 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2636 25195
 2567         25196 25193 (NOTLB)
Jan 27 11:48:40 ECDCCAM1 kernel:        e7cbae94 00200082 bdebd162
003cb13d 00000040 c06a7400 e7cbaeb4 00000008
Jan 27 11:48:40 ECDCCAM1 kernel:        f59b5000 bdebf852 003cb13d
000026f0 00000000 f59b510c cb6126e0 e5a50740
Jan 27 11:48:40 ECDCCAM1 kernel:        e7cbaeb4 00000000 00000200
00000040 e7cbaefc 00000200 e7cbaefc ffffffff
Jan 27 11:48:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:40 ECDCCAM1 kernel:  =======================
Jan 27 11:48:40 ECDCCAM1 kernel: httpd.worker  S 003CB140  2660 25196
 2567         25199 25195 (NOTLB)
Jan 27 11:48:40 ECDCCAM1 kernel:        d8669e94 00200082 a3755652
003cb140 00000040 c06a7400 d8669eb4 00000008
Jan 27 11:48:40 ECDCCAM1 kernel:        f5502550 a37594ee 003cb140
00003e9c 00000000 f550265c cb6126e0 e5a50740
Jan 27 11:48:40 ECDCCAM1 kernel:        d8669eb4 00000000 00000200
00000040 d8669efc 00000200 d8669efc ffffffff
Jan 27 11:48:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:40 ECDCCAM1 kernel:  =======================
Jan 27 11:48:40 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25199
 2567         25201 25196 (NOTLB)
Jan 27 11:48:40 ECDCCAM1 kernel:        e2cd1e94 00200082 adf49291
003cb13e 00000040 c06a7400 e2cd1eb4 0000000a
Jan 27 11:48:40 ECDCCAM1 kernel:        ea93d550 adf4baf5 003cb13e
00002864 00000000 ea93d65c cb6126e0 e5a50740
Jan 27 11:48:40 ECDCCAM1 kernel:        e2cd1eb4 c05aa190 00000000
00000040 e2cd1efc 00000200 e2cd1efc 00000200
Jan 27 11:48:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:41 ECDCCAM1 kernel:  =======================
Jan 27 11:48:41 ECDCCAM1 kernel: httpd.worker  S 003CB211  2636 25201
 2567         25203 25199 (NOTLB)
Jan 27 11:48:41 ECDCCAM1 kernel:        d191fc08 00200082 42190808
003cb211 d191fe5c d191fe60 d191fe64 0000000a
Jan 27 11:48:41 ECDCCAM1 kernel:        d51fd550 421b6dc3 003cb211
000265bb 00000000 d51fd65c cb6126e0 e5a50740
Jan 27 11:48:41 ECDCCAM1 kernel:        00000000 00000000 00200286
c042c2e0 c07a6200 d191fc10 00200286 ffffffff
Jan 27 11:48:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f88875a3>]
ext3_ordered_commit_write+0xae/0xcc [ext3]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04563d3>]
__generic_file_aio_write_nolock+0x4a6/0x52a
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0437bb6>] futex_wake+0x3c/0xa5
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04564b7>] generic_file_aio_write+0x60/0xaa
Jan 27 11:48:41 ECDCCAM1 kernel:  [<f8883e91>] ext3_file_write+0x19/0x83 [ext3]
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0470fb2>] do_sync_write+0xb6/0xf1
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04718cd>] vfs_write+0x103/0x143
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:41 ECDCCAM1 kernel:  =======================
Jan 27 11:48:41 ECDCCAM1 kernel: httpd.worker  S 003CB152  2660 25203
 2567         25205 25201 (NOTLB)
Jan 27 11:48:41 ECDCCAM1 kernel:        f26ebe94 00200082 363c4d6e
003cb152 c05d2cb8 f770dc40 ef0e946c 00000007
Jan 27 11:48:41 ECDCCAM1 kernel:        e6b6eaa0 363cc397 003cb152
00007629 00000000 e6b6ebac cb6126e0 e5a50740
Jan 27 11:48:41 ECDCCAM1 kernel:        00000000 00000000 ef0e946c
c0434a67 f26ebe70 f26ebe70 f26ebefc ffffffff
Jan 27 11:48:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:41 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:42 ECDCCAM1 kernel:  =======================
Jan 27 11:48:42 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2636 25205
 2567         25206 25203 (NOTLB)
Jan 27 11:48:42 ECDCCAM1 kernel:        db048e94 00200082 bec119be
003cb13d 00000040 c06a7400 db048eb4 00000004
Jan 27 11:48:42 ECDCCAM1 kernel:        d9153550 bec13bd8 003cb13d
0000221a 00000000 d915365c cb6126e0 e5a50740
Jan 27 11:48:42 ECDCCAM1 kernel:        db048eb4 00000000 00000200
00000040 db048efc 00000200 db048efc ffffffff
Jan 27 11:48:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:42 ECDCCAM1 kernel:  =======================
Jan 27 11:48:42 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25206
 2567         25208 25205 (NOTLB)
Jan 27 11:48:42 ECDCCAM1 kernel:        e1226e94 00200082 ae3667ae
003cb13e 00000040 c06a7400 e1226eb4 0000000a
Jan 27 11:48:42 ECDCCAM1 kernel:        f5c31000 ae368062 003cb13e
000018b4 00000000 f5c3110c cb6126e0 e5a50740
Jan 27 11:48:42 ECDCCAM1 kernel:        e1226eb4 c05aa190 00000000
00000040 e1226efc 00000200 cb612b9c 00000200
Jan 27 11:48:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:42 ECDCCAM1 kernel:  =======================
Jan 27 11:48:42 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25208
 2567         25210 25206 (NOTLB)
Jan 27 11:48:42 ECDCCAM1 kernel:        e8884e94 00200082 ae363be5
003cb13e 00000040 c06a7400 e8884eb4 0000000a
Jan 27 11:48:42 ECDCCAM1 kernel:        ed6e9000 ae3667ae 003cb13e
00002bc9 00000000 ed6e910c cb6126e0 e5a50740
Jan 27 11:48:42 ECDCCAM1 kernel:        e8884eb4 c05aa190 00000000
00000040 e8884efc 00000200 cb612b9c 00000200
Jan 27 11:48:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:43 ECDCCAM1 kernel:  =======================
Jan 27 11:48:43 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25210
 2567         25213 25208 (NOTLB)
Jan 27 11:48:43 ECDCCAM1 kernel:        f749ae94 00200082 ae73ddc0
003cb13e 00000040 c06a7400 f749aeb4 0000000a
Jan 27 11:48:43 ECDCCAM1 kernel:        de3f6aa0 ae740411 003cb13e
00002651 00000000 de3f6bac cb6126e0 e5a50740
Jan 27 11:48:43 ECDCCAM1 kernel:        f749aeb4 00000000 00000200
00000040 f749aefc 00000200 f749aefc ffffffff
Jan 27 11:48:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:43 ECDCCAM1 kernel:  =======================
Jan 27 11:48:43 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2636 25213
 2567         25214 25210 (NOTLB)
Jan 27 11:48:43 ECDCCAM1 kernel:        e5fa8e94 00200082 ae45b561
003cb13e 00000040 c06a7400 e5fa8eb4 0000000a
Jan 27 11:48:43 ECDCCAM1 kernel:        cf4f0000 ae45d9f6 003cb13e
00002495 00000000 cf4f010c cb6126e0 e5a50740
Jan 27 11:48:43 ECDCCAM1 kernel:        e5fa8eb4 00000000 00000200
00000040 e5fa8efc 00000200 e5fa8efc ffffffff
Jan 27 11:48:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:43 ECDCCAM1 kernel:  =======================
Jan 27 11:48:43 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2660 25214
 2567         25215 25213 (NOTLB)
Jan 27 11:48:43 ECDCCAM1 kernel:        e7582e94 00200082 be94dcff
003cb13d 00000040 c06a7400 e7582eb4 00000004
Jan 27 11:48:43 ECDCCAM1 kernel:        e9e93550 be9508f5 003cb13d
00002bf6 00000000 e9e9365c cb6126e0 e5a50740
Jan 27 11:48:44 ECDCCAM1 kernel:        e7582eb4 00000000 00000200
00000040 e7582efc 00000200 e7582efc ffffffff
Jan 27 11:48:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:44 ECDCCAM1 kernel:  =======================
Jan 27 11:48:44 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2568 25215
 2567         25216 25214 (NOTLB)
Jan 27 11:48:44 ECDCCAM1 kernel:        e570ee94 00200082 2468c8fe
003cb13f 00000040 c06a7400 e570eeb4 00000008
Jan 27 11:48:44 ECDCCAM1 kernel:        d41b1550 2468fb55 003cb13f
00003257 00000001 d41b165c cb6194c4 e5a50740
Jan 27 11:48:44 ECDCCAM1 kernel:        e570eeb4 00000000 00000200
00000040 e570eefc 00000200 e570eefc ffffffff
Jan 27 11:48:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:44 ECDCCAM1 kernel:  =======================
Jan 27 11:48:44 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2568 25216
 2567         25217 25215 (NOTLB)
Jan 27 11:48:44 ECDCCAM1 kernel:        ee71de94 00200082 239f053f
003cb13f 00000040 c06a7400 ee71deb4 0000000a
Jan 27 11:48:44 ECDCCAM1 kernel:        ed6e9aa0 239f45e8 003cb13f
000040a9 00000000 ed6e9bac cb6126e0 e5a50740
Jan 27 11:48:44 ECDCCAM1 kernel:        ee71deb4 00000000 00000200
00000040 ee71defc 00000200 ee71defc ffffffff
Jan 27 11:48:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:44 ECDCCAM1 kernel:  =======================
Jan 27 11:48:44 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2636 25217
 2567         25218 25216 (NOTLB)
Jan 27 11:48:44 ECDCCAM1 kernel:        e0ad4e94 00200082 bebd6e20
003cb13d 00000040 c06a7400 e0ad4eb4 00000008
Jan 27 11:48:44 ECDCCAM1 kernel:        da792550 bebd9e80 003cb13d
00003060 00000000 da79265c cb6126e0 e5a50740
Jan 27 11:48:44 ECDCCAM1 kernel:        e0ad4eb4 c05aa190 00000000
00000040 e0ad4efc 00000200 e0ad4efc 00000200
Jan 27 11:48:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:44 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:45 ECDCCAM1 kernel:  =======================
Jan 27 11:48:45 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2636 25218
 2567         25219 25217 (NOTLB)
Jan 27 11:48:45 ECDCCAM1 kernel:        f6defe94 00200082 adb9fe54
003cb13e 00000040 c06a7400 f6defeb4 0000000a
Jan 27 11:48:45 ECDCCAM1 kernel:        f76e7550 adba2930 003cb13e
00002adc 00000000 f76e765c cb6126e0 e5a50740
Jan 27 11:48:45 ECDCCAM1 kernel:        f6defeb4 00000000 00000200
00000040 f6defefc 00000200 f6defefc ffffffff
Jan 27 11:48:45 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:45 ECDCCAM1 kernel:  =======================
Jan 27 11:48:45 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25219
 2567         25220 25218 (NOTLB)
Jan 27 11:48:45 ECDCCAM1 kernel:        f4bc6e94 00200082 2477c849
003cb13f 00000040 c06a7400 f4bc6eb4 00000008
Jan 27 11:48:45 ECDCCAM1 kernel:        d18a6aa0 2477ee70 003cb13f
00002627 00000000 d18a6bac cb6126e0 e5a50740
Jan 27 11:48:45 ECDCCAM1 kernel:        f4bc6eb4 00000000 00000200
00000040 f4bc6efc 00000200 f4bc6efc ffffffff
Jan 27 11:48:45 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:45 ECDCCAM1 kernel:  =======================
Jan 27 11:48:45 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25220
 2567         25221 25219 (NOTLB)
Jan 27 11:48:45 ECDCCAM1 kernel:        ea556e94 00200082 2641312b
003cb13f 00000040 c06a7400 ea556eb4 00000008
Jan 27 11:48:45 ECDCCAM1 kernel:        d941aaa0 2641535b 003cb13f
00002230 00000000 d941abac cb6126e0 e5a50740
Jan 27 11:48:45 ECDCCAM1 kernel:        ea556eb4 00000000 00000200
00000040 ea556efc 00000200 ea556efc ffffffff
Jan 27 11:48:45 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:45 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:46 ECDCCAM1 kernel:  =======================
Jan 27 11:48:46 ECDCCAM1 kernel: httpd.worker  S 003CB211  3196 25221
 2567         20315 25220 (NOTLB)
Jan 27 11:48:46 ECDCCAM1 kernel:        e3714f58 00200082 3c78695f
003cb211 f7054adc 00200246 fffffff5 00000007
Jan 27 11:48:46 ECDCCAM1 kernel:        d9c0caa0 3c790479 003cb211
00009b1a 00000000 d9c0cbac cb6126e0 e5a50740
Jan 27 11:48:46 ECDCCAM1 kernel:        7fffffff 00000000 f705417c
f705465c 00000000 00000001 e3714f6c ffffffff
Jan 27 11:48:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0484cf6>] fcntl_setlk+0x174/0x222
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0480c50>] sys_fcntl64+0x6f/0x80
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:46 ECDCCAM1 kernel:  =======================
Jan 27 11:48:46 ECDCCAM1 kernel: httpd.worker  S 003C61D5  3088 20315
 2567         20317 25221 (NOTLB)
Jan 27 11:48:46 ECDCCAM1 kernel:        dd64ff00 00200086 4a4c13ac
003c61d5 f76f3554 f7b2b788 f76f34ac 00000008
Jan 27 11:48:46 ECDCCAM1 kernel:        dbe24aa0 4a4c1b2d 003c61d5
00000781 00000002 dbe24bac cb6202a8 d0fb2200
Jan 27 11:48:46 ECDCCAM1 kernel:        dbe24aa0 08056bd0 00000000
d0fb2200 00000000 00000000 dd64ff08 dc293000
Jan 27 11:48:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:46 ECDCCAM1 kernel:  =======================
Jan 27 11:48:46 ECDCCAM1 kernel: httpd.worker  S 003CAE04  2636 20318
 2567         20320 20317 (NOTLB)
Jan 27 11:48:46 ECDCCAM1 kernel:        d71fbe94 00200086 e3c7c172
003cae04 00000040 c06a7400 d71fbeb4 0000000a
Jan 27 11:48:46 ECDCCAM1 kernel:        d41db000 e3c7ebd0 003cae04
00002a5e 00000000 d41db10c cb6126e0 d0fb2200
Jan 27 11:48:46 ECDCCAM1 kernel:        d71fbeb4 00000000 00000200
00000040 d71fbefc 00000200 d71fbefc ffffffff
Jan 27 11:48:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:46 ECDCCAM1 kernel:  =======================
Jan 27 11:48:47 ECDCCAM1 kernel: httpd.worker  S 003CB1B1  2636 20320
 2567         20321 20318 (NOTLB)
Jan 27 11:48:47 ECDCCAM1 kernel:        d9e78e94 00200086 12512830
003cb1b1 c05d2cb8 f770dc40 f5a26eac 00000007
Jan 27 11:48:47 ECDCCAM1 kernel:        f744eaa0 1251a6d7 003cb1b1
00007ea7 00000000 f744ebac cb6126e0 d0fb2200
Jan 27 11:48:47 ECDCCAM1 kernel:        00000000 00000000 f5a26eac
c0434a67 d9e78e70 d9e78e70 d9e78efc ffffffff
Jan 27 11:48:47 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:47 ECDCCAM1 kernel:  =======================
Jan 27 11:48:47 ECDCCAM1 kernel: httpd.worker  S 003CB0FD  2636 20321
 2567         20322 20320 (NOTLB)
Jan 27 11:48:47 ECDCCAM1 kernel:        de84ce94 00200086 16c5ca2d
003cb0fd c05d2cb8 f770dc40 e868c42c 00000007
Jan 27 11:48:47 ECDCCAM1 kernel:        dbe24550 16c64903 003cb0fd
00007ed6 00000000 dbe2465c cb6126e0 d0fb2200
Jan 27 11:48:47 ECDCCAM1 kernel:        00000000 00000000 e868c42c
c0434a67 de84ce70 de84ce70 de84cefc ffffffff
Jan 27 11:48:47 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:47 ECDCCAM1 kernel:  =======================
Jan 27 11:48:47 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20322
 2567         20323 20321 (NOTLB)
Jan 27 11:48:47 ECDCCAM1 kernel:        f1085e94 00200086 1606d42f
003cb185 00000040 c06a7400 f1085eb4 00000007
Jan 27 11:48:47 ECDCCAM1 kernel:        f7619aa0 1606f658 003cb185
00002229 00000000 f7619bac cb6126e0 d0fb2200
Jan 27 11:48:47 ECDCCAM1 kernel:        f1085eb4 00000000 00000200
00000040 f1085efc 00000200 f1085efc ffffffff
Jan 27 11:48:47 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:47 ECDCCAM1 kernel:  =======================
Jan 27 11:48:47 ECDCCAM1 kernel: httpd.worker  S 003CB07E  2660 20323
 2567         20324 20322 (NOTLB)
Jan 27 11:48:48 ECDCCAM1 kernel:        e7672e94 00200086 b8aa403e
003cb07e 00000040 c06a7400 e7672eb4 00000008
Jan 27 11:48:48 ECDCCAM1 kernel:        d20d6550 b8aa6525 003cb07e
000024e7 00000000 d20d665c cb6126e0 d0fb2200
Jan 27 11:48:48 ECDCCAM1 kernel:        e7672eb4 00000000 00000200
00000040 e7672efc 00000200 e7672efc ffffffff
Jan 27 11:48:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:48 ECDCCAM1 kernel:  =======================
Jan 27 11:48:48 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20324
 2567         20325 20323 (NOTLB)
Jan 27 11:48:48 ECDCCAM1 kernel:        e2748e94 00200086 15eddac4
003cb185 00000040 c06a7400 e2748eb4 00000002
Jan 27 11:48:48 ECDCCAM1 kernel:        d6986aa0 15edfd4d 003cb185
00002289 00000000 d6986bac cb6126e0 d0fb2200
Jan 27 11:48:48 ECDCCAM1 kernel:        e2748eb4 00000000 00000200
00000040 e2748efc 00000200 e2748efc ffffffff
Jan 27 11:48:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:48 ECDCCAM1 kernel:  =======================
Jan 27 11:48:48 ECDCCAM1 kernel: httpd.worker  S 003CB07E  2612 20325
 2567         20326 20324 (NOTLB)
Jan 27 11:48:48 ECDCCAM1 kernel:        e5173e94 00200086 b42b3f85
003cb07e 00000040 c06a7400 e5173eb4 0000000a
Jan 27 11:48:48 ECDCCAM1 kernel:        f3498aa0 b42b6915 003cb07e
00002990 00000000 f3498bac cb6126e0 d0fb2200
Jan 27 11:48:48 ECDCCAM1 kernel:        e5173eb4 00000000 00000200
00000040 e5173efc 00000200 e5173efc ffffffff
Jan 27 11:48:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:48 ECDCCAM1 kernel:  =======================
Jan 27 11:48:48 ECDCCAM1 kernel: httpd.worker  S 003CB07E  2636 20326
 2567         20327 20325 (NOTLB)
Jan 27 11:48:48 ECDCCAM1 kernel:        d86bee94 00200086 b1bb2c19
003cb07e 00000040 c06a7400 d86beeb4 00000008
Jan 27 11:48:49 ECDCCAM1 kernel:        f50c1aa0 b1bba3fb 003cb07e
000077e2 00000000 f50c1bac cb6126e0 d0fb2200
Jan 27 11:48:49 ECDCCAM1 kernel:        d86beeb4 00000000 00000200
00000040 d86beefc 00000200 d86beefc ffffffff
Jan 27 11:48:49 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:49 ECDCCAM1 kernel:  =======================
Jan 27 11:48:49 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20327
 2567         20328 20326 (NOTLB)
Jan 27 11:48:49 ECDCCAM1 kernel:        e9216e94 00200086 157c3c8d
003cb185 00000040 c06a7400 e9216eb4 00000002
Jan 27 11:48:49 ECDCCAM1 kernel:        f5add000 157c626f 003cb185
000025e2 00000000 f5add10c cb6126e0 d0fb2200
Jan 27 11:48:49 ECDCCAM1 kernel:        e9216eb4 00000000 00000200
00000040 e9216efc 00000200 e9216efc ffffffff
Jan 27 11:48:49 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:49 ECDCCAM1 kernel:  =======================
Jan 27 11:48:49 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20328
 2567         20329 20327 (NOTLB)
Jan 27 11:48:49 ECDCCAM1 kernel:        d90a7e94 00200086 f6c242ef
003cb171 00000040 c06a7400 d90a7eb4 0000000a
Jan 27 11:48:49 ECDCCAM1 kernel:        f09daaa0 f6c2661a 003cb171
0000232b 00000000 f09dabac cb6126e0 d0fb2200
Jan 27 11:48:49 ECDCCAM1 kernel:        d90a7eb4 00000000 00000200
00000040 d90a7efc 00000200 d90a7efc ffffffff
Jan 27 11:48:49 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:49 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:49 ECDCCAM1 kernel:  =======================
Jan 27 11:48:49 ECDCCAM1 kernel: httpd.worker  S 003CB20C  2400 20329
 2567         20330 20328 (NOTLB)
Jan 27 11:48:49 ECDCCAM1 kernel:        d05fde94 00200086 d4f379bb
003cb20c c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:48:49 ECDCCAM1 kernel:        d54cc000 d4f4001c 003cb20c
00008661 00000000 d54cc10c cb6126e0 d0fb2200
Jan 27 11:48:50 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 d05fde70 00000001 ffffffff
Jan 27 11:48:50 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:50 ECDCCAM1 kernel:  =======================
Jan 27 11:48:50 ECDCCAM1 kernel: httpd.worker  S 003CB06D  2660 20330
 2567         20331 20329 (NOTLB)
Jan 27 11:48:50 ECDCCAM1 kernel:        cc385e94 00200086 ea567075
003cb06d c05d2cb8 f770dc40 f09b3d2c 0000000a
Jan 27 11:48:50 ECDCCAM1 kernel:        f7059aa0 ea56f00e 003cb06d
00007f99 00000000 f7059bac cb6126e0 d0fb2200
Jan 27 11:48:50 ECDCCAM1 kernel:        00000000 00000000 f09b3d2c
c0434a67 cc385e70 cc385e70 cc385efc ffffffff
Jan 27 11:48:50 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:50 ECDCCAM1 kernel:  =======================
Jan 27 11:48:50 ECDCCAM1 kernel: httpd.worker  S 003CB211  2660 20331
 2567         20332 20330 (NOTLB)
Jan 27 11:48:50 ECDCCAM1 kernel:        dea86e94 00200086 4c397096
003cb211 c05d2cb8 f770dc40 e86318ec 00000007
Jan 27 11:48:50 ECDCCAM1 kernel:        d415c550 4c39e1e4 003cb211
0000714e 00000000 d415c65c cb6126e0 d0fb2200
Jan 27 11:48:50 ECDCCAM1 kernel:        00000000 00000000 e86318ec
c0434a67 dea86e70 dea86e70 dea86efc ffffffff
Jan 27 11:48:50 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:50 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:51 ECDCCAM1 kernel:  =======================
Jan 27 11:48:51 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20332
 2567         20333 20331 (NOTLB)
Jan 27 11:48:51 ECDCCAM1 kernel:        ef03ae94 00200086 15bc2e20
003cb185 00000040 c06a7400 ef03aeb4 00000002
Jan 27 11:48:51 ECDCCAM1 kernel:        e1a04aa0 15bc5388 003cb185
00002568 00000000 e1a04bac cb6126e0 d0fb2200
Jan 27 11:48:51 ECDCCAM1 kernel:        ef03aeb4 00000000 00000200
00000040 ef03aefc 00000200 ef03aefc ffffffff
Jan 27 11:48:51 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:51 ECDCCAM1 kernel:  =======================
Jan 27 11:48:51 ECDCCAM1 kernel: httpd.worker  S 003CAF56  2660 20333
 2567         20334 20332 (NOTLB)
Jan 27 11:48:51 ECDCCAM1 kernel:        e548ae94 00200086 69226c8b
003caf56 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:48:51 ECDCCAM1 kernel:        e1a04550 6922eee1 003caf56
00008256 00000000 e1a0465c cb6126e0 d0fb2200
Jan 27 11:48:51 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 e548ae70 00000001 ffffffff
Jan 27 11:48:51 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:51 ECDCCAM1 kernel:  =======================
Jan 27 11:48:51 ECDCCAM1 kernel: httpd.worker  S 003CB1BF  2660 20340
 2567         20341 20339 (NOTLB)
Jan 27 11:48:51 ECDCCAM1 kernel:        e598ae94 00200086 b76b77da
003cb1bf c05d2cb8 f770dc40 de05cd6c 00000007
Jan 27 11:48:51 ECDCCAM1 kernel:        d428f000 b76bf87e 003cb1bf
000080a4 00000000 d428f10c cb6126e0 d0fb2200
Jan 27 11:48:51 ECDCCAM1 kernel:        00000000 00000000 de05cd6c
c0434a67 e598ae70 e598ae70 e598aefc ffffffff
Jan 27 11:48:51 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:51 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:52 ECDCCAM1 kernel:  =======================
Jan 27 11:48:52 ECDCCAM1 kernel: httpd.worker  S 003CB062  2660 20341
 2567         20342 20340 (NOTLB)
Jan 27 11:48:52 ECDCCAM1 kernel:        dd98fe94 00200086 668a0943
003cb062 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:48:52 ECDCCAM1 kernel:        d29ae000 668a9527 003cb062
00008be4 00000000 d29ae10c cb6126e0 d0fb2200
Jan 27 11:48:52 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 dd98fe70 00000001 ffffffff
Jan 27 11:48:52 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:52 ECDCCAM1 kernel:  =======================
Jan 27 11:48:52 ECDCCAM1 kernel: httpd.worker  S 003CB08F  2636 20342
 2567         20343 20341 (NOTLB)
Jan 27 11:48:52 ECDCCAM1 kernel:        e311be94 00200086 6e2c4e55
003cb08f c05d2cb8 f770dc40 e86318ec 00000007
Jan 27 11:48:52 ECDCCAM1 kernel:        d2e0a000 6e2cb3e1 003cb08f
0000658c 00000000 d2e0a10c cb6126e0 d0fb2200
Jan 27 11:48:52 ECDCCAM1 kernel:        00000000 00000000 e86318ec
c0434a67 e311be70 e311be70 e311befc ffffffff
Jan 27 11:48:52 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:52 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:52 ECDCCAM1 kernel:  =======================
Jan 27 11:48:52 ECDCCAM1 kernel: httpd.worker  S 003CB0B1  2636 20343
 2567         20344 20342 (NOTLB)
Jan 27 11:48:52 ECDCCAM1 kernel:        e2fc0e94 00200086 30f642f1
003cb0b1 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:48:53 ECDCCAM1 kernel:        f798a000 30f6cc62 003cb0b1
00008971 00000000 f798a10c cb6126e0 d0fb2200
Jan 27 11:48:53 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 e2fc0e70 00000001 ffffffff
Jan 27 11:48:53 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:53 ECDCCAM1 kernel:  =======================
Jan 27 11:48:53 ECDCCAM1 kernel: httpd.worker  S 003CB140  1836 20344
 2567         20345 20343 (NOTLB)
Jan 27 11:48:53 ECDCCAM1 kernel:        e89dfe94 00200086 a4439ac7
003cb140 00000040 c06a7400 e89dfeb4 0000000a
Jan 27 11:48:53 ECDCCAM1 kernel:        e44b2000 a443c701 003cb140
00002c3a 00000000 e44b210c cb6126e0 d0fb2200
Jan 27 11:48:53 ECDCCAM1 kernel:        e89dfeb4 00000000 00000200
00000040 e89dfefc 00000200 e89dfefc ffffffff
Jan 27 11:48:53 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:53 ECDCCAM1 kernel:  =======================
Jan 27 11:48:53 ECDCCAM1 kernel: httpd.worker  S 003CB1A4  2660 20345
 2567         20346 20344 (NOTLB)
Jan 27 11:48:53 ECDCCAM1 kernel:        cd116e94 00200086 ab5a0cde
003cb1a4 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:48:53 ECDCCAM1 kernel:        d9c11000 ab5a8df1 003cb1a4
00008113 00000000 d9c1110c cb6126e0 d0fb2200
Jan 27 11:48:53 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 cd116e70 00000001 ffffffff
Jan 27 11:48:53 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:53 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:54 ECDCCAM1 kernel:  =======================
Jan 27 11:48:54 ECDCCAM1 kernel: httpd.worker  S 003CB1B8  2660 20346
 2567         20347 20345 (NOTLB)
Jan 27 11:48:54 ECDCCAM1 kernel:        dd81be94 00200086 12d06fa4
003cb1b8 00000040 c06a7400 dd81beb4 0000000a
Jan 27 11:48:54 ECDCCAM1 kernel:        d61baaa0 12d0c335 003cb1b8
00005391 00000000 d61babac cb6126e0 d0fb2200
Jan 27 11:48:54 ECDCCAM1 kernel:        dd81beb4 00000000 00000200
00000040 dd81befc 00000200 dd81befc ffffffff
Jan 27 11:48:54 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:54 ECDCCAM1 kernel:  =======================
Jan 27 11:48:54 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20354
 2567         20355 20353 (NOTLB)
Jan 27 11:48:54 ECDCCAM1 kernel:        e29ace94 00200086 154f7a4b
003cb185 00000040 c06a7400 e29aceb4 00000002
Jan 27 11:48:54 ECDCCAM1 kernel:        e6c9b550 154f9e6f 003cb185
00002424 00000000 e6c9b65c cb6126e0 d0fb2200
Jan 27 11:48:54 ECDCCAM1 kernel:        e29aceb4 00000000 00000200
00000040 e29acefc 00000200 e29acefc ffffffff
Jan 27 11:48:54 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:54 ECDCCAM1 kernel:  =======================
Jan 27 11:48:54 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20355
 2567         20356 20354 (NOTLB)
Jan 27 11:48:54 ECDCCAM1 kernel:        dbb18e94 00200086 142107c4
003cb185 00000040 c06a7400 dbb18eb4 00000001
Jan 27 11:48:54 ECDCCAM1 kernel:        e6c9b000 14213e7a 003cb185
000036b6 00000000 e6c9b10c cb6126e0 d0fb2200
Jan 27 11:48:54 ECDCCAM1 kernel:        dbb18eb4 00000000 00000200
00000040 dbb18efc 00000200 dbb18efc ffffffff
Jan 27 11:48:54 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:54 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:54 ECDCCAM1 kernel:  =======================
Jan 27 11:48:54 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20356
 2567         20357 20355 (NOTLB)
Jan 27 11:48:54 ECDCCAM1 kernel:        d2755e94 00200086 15d0bbc3
003cb185 00000040 c06a7400 d2755eb4 00000008
Jan 27 11:48:55 ECDCCAM1 kernel:        e8b74aa0 15d0de95 003cb185
000022d2 00000000 e8b74bac cb6126e0 d0fb2200
Jan 27 11:48:55 ECDCCAM1 kernel:        d2755eb4 c05aa190 00000000
00000040 d2755efc 00000200 d2755efc 00000200
Jan 27 11:48:55 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:55 ECDCCAM1 kernel:  =======================
Jan 27 11:48:55 ECDCCAM1 kernel: httpd.worker  S 003CB211  3292 20357
 2567         20358 20356 (NOTLB)
Jan 27 11:48:55 ECDCCAM1 kernel:        e4442f58 00200086 3c7da27a
003cb211 f7054adc 00200246 fffffff5 00000007
Jan 27 11:48:55 ECDCCAM1 kernel:        e8b74550 3c7dac64 003cb211
000009ea 00000001 e8b7465c cb6194c4 d0fb2200
Jan 27 11:48:55 ECDCCAM1 kernel:        d89571b0 00000000 f7054bfc
f7054e9c 00000000 00402040 e4442f6c ffffffff
Jan 27 11:48:55 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0484cf6>] fcntl_setlk+0x174/0x222
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0480c50>] sys_fcntl64+0x6f/0x80
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:55 ECDCCAM1 kernel:  =======================
Jan 27 11:48:55 ECDCCAM1 kernel: httpd.worker  S 003C61D5  3088 20317
 2567         20318 20315 (NOTLB)
Jan 27 11:48:55 ECDCCAM1 kernel:        e5537f00 00200086 4a4c2191
003c61d5 f76f3554 f7b2b788 f76f34ac 00000007
Jan 27 11:48:55 ECDCCAM1 kernel:        e46f0000 4a4c2829 003c61d5
00000698 00000002 e46f010c cb6202a8 e985a3c0
Jan 27 11:48:55 ECDCCAM1 kernel:        def707cc 00000000 00000000
e985a3c0 00000000 00000000 e5537f08 ffffffff
Jan 27 11:48:55 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c041df46>] __activate_task+0x4a/0x59
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:55 ECDCCAM1 kernel:  =======================
Jan 27 11:48:55 ECDCCAM1 kernel: httpd.worker  S 003CB17F  2660 20334
 2567         20335 20333 (NOTLB)
Jan 27 11:48:55 ECDCCAM1 kernel:        e041fe94 00200086 619c7fef
003cb17f c05d2cb8 f770dc40 f3bbb8ac 00000007
Jan 27 11:48:55 ECDCCAM1 kernel:        d0752000 619d0257 003cb17f
00008268 00000000 d075210c cb6126e0 e985a3c0
Jan 27 11:48:55 ECDCCAM1 kernel:        00000000 00000000 f3bbb8ac
c0434a67 e041fe70 e041fe70 e041fefc ffffffff
Jan 27 11:48:55 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:48:55 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:56 ECDCCAM1 kernel:  =======================
Jan 27 11:48:56 ECDCCAM1 kernel: httpd.worker  S 003CB171  2504 20335
 2567         20336 20334 (NOTLB)
Jan 27 11:48:56 ECDCCAM1 kernel:        dff21e94 00200086 55c69f9c
003cb171 00000040 c06a7400 dff21eb4 0000000a
Jan 27 11:48:56 ECDCCAM1 kernel:        e6b6e000 55c6cd0f 003cb171
00002d73 00000000 e6b6e10c cb6126e0 e985a3c0
Jan 27 11:48:56 ECDCCAM1 kernel:        dff21eb4 00000000 00000200
00000040 dff21efc 00000200 dff21efc ffffffff
Jan 27 11:48:56 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:56 ECDCCAM1 kernel:  =======================
Jan 27 11:48:56 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20336
 2567         20337 20335 (NOTLB)
Jan 27 11:48:56 ECDCCAM1 kernel:        dbfc1e94 00200086 f6ba3b22
003cb171 00000040 c06a7400 dbfc1eb4 0000000a
Jan 27 11:48:56 ECDCCAM1 kernel:        f5255000 f6ba64f3 003cb171
000029d1 00000000 f525510c cb6126e0 e985a3c0
Jan 27 11:48:56 ECDCCAM1 kernel:        dbfc1eb4 00000000 00000200
00000040 dbfc1efc 00000200 dbfc1efc ffffffff
Jan 27 11:48:56 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:56 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:56 ECDCCAM1 kernel:  =======================
Jan 27 11:48:56 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20337
 2567         20338 20336 (NOTLB)
Jan 27 11:48:56 ECDCCAM1 kernel:        e88f9e94 00200086 f6798a15
003cb171 00000040 c06a7400 e88f9eb4 0000000a
Jan 27 11:48:56 ECDCCAM1 kernel:        f5c31aa0 f679b1e9 003cb171
000027d4 00000000 f5c31bac cb6126e0 e985a3c0
Jan 27 11:48:57 ECDCCAM1 kernel:        e88f9eb4 c05aa190 00000000
00000040 e88f9efc 00000200 cb612724 00000200
Jan 27 11:48:57 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:57 ECDCCAM1 kernel:  =======================
Jan 27 11:48:57 ECDCCAM1 kernel: httpd.worker  S 003CB171  2620 20338
 2567         20339 20337 (NOTLB)
Jan 27 11:48:57 ECDCCAM1 kernel:        d8da5e94 00200086 f657f4ab
003cb171 00000040 c06a7400 d8da5eb4 0000000a
Jan 27 11:48:57 ECDCCAM1 kernel:        f7582550 f6581fd6 003cb171
00002b2b 00000000 f758265c cb6126e0 e985a3c0
Jan 27 11:48:57 ECDCCAM1 kernel:        d8da5eb4 c05aa190 00000000
00000040 d8da5efc 00000200 cb612724 00000200
Jan 27 11:48:57 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:57 ECDCCAM1 kernel:  =======================
Jan 27 11:48:57 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20339
 2567         20340 20338 (NOTLB)
Jan 27 11:48:57 ECDCCAM1 kernel:        ef9abe94 00200086 4299f02c
003cb170 00000040 c06a7400 ef9abeb4 0000000a
Jan 27 11:48:57 ECDCCAM1 kernel:        de3f6000 429a1546 003cb170
0000251a 00000000 de3f610c cb6126e0 e985a3c0
Jan 27 11:48:57 ECDCCAM1 kernel:        ef9abeb4 00000000 00000200
00000040 ef9abefc 00000200 ef9abefc ffffffff
Jan 27 11:48:57 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:57 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:57 ECDCCAM1 kernel:  =======================
Jan 27 11:48:57 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20347
 2567         20348 20346 (NOTLB)
Jan 27 11:48:57 ECDCCAM1 kernel:        e391ae94 00200086 42e995a4
003cb170 00000040 c06a7400 e391aeb4 0000000a
Jan 27 11:48:57 ECDCCAM1 kernel:        d0bf0000 42e9c266 003cb170
00002cc2 00000001 d0bf010c cb6194c4 e985a3c0
Jan 27 11:48:58 ECDCCAM1 kernel:        e391aeb4 00000000 00000200
00000040 e391aefc 00000200 e391aefc ffffffff
Jan 27 11:48:58 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:58 ECDCCAM1 kernel:  =======================
Jan 27 11:48:58 ECDCCAM1 kernel: httpd.worker  S 003CB151  2660 20348
 2567         20349 20347 (NOTLB)
Jan 27 11:48:58 ECDCCAM1 kernel:        db25fe94 00200086 a200a7c6
003cb151 00000040 c06a7400 db25feb4 00000009
Jan 27 11:48:58 ECDCCAM1 kernel:        d0bf0550 a200ca14 003cb151
0000224e 00000000 d0bf065c cb6126e0 e985a3c0
Jan 27 11:48:58 ECDCCAM1 kernel:        db25feb4 00000000 00000200
00000040 db25fefc 00000200 db25fefc ffffffff
Jan 27 11:48:58 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:58 ECDCCAM1 kernel:  =======================
Jan 27 11:48:58 ECDCCAM1 kernel: httpd.worker  S 003CB151  2636 20349
 2567         20350 20348 (NOTLB)
Jan 27 11:48:58 ECDCCAM1 kernel:        da869e94 00200086 a1ebe94b
003cb151 00000040 c06a7400 da869eb4 0000000a
Jan 27 11:48:58 ECDCCAM1 kernel:        d281aaa0 a1ec1c2d 003cb151
000032e2 00000000 d281abac cb6126e0 e985a3c0
Jan 27 11:48:58 ECDCCAM1 kernel:        da869eb4 00000000 00000200
00000040 da869efc 00000200 da869efc ffffffff
Jan 27 11:48:58 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:48:58 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:58 ECDCCAM1 kernel:  =======================
Jan 27 11:48:58 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20350
 2567         20351 20349 (NOTLB)
Jan 27 11:48:59 ECDCCAM1 kernel:        e1193e94 00200086 411ced45
003cb170 00000040 c06a7400 e1193eb4 00000008
Jan 27 11:48:59 ECDCCAM1 kernel:        dab4eaa0 411d353c 003cb170
000047f7 00000000 dab4ebac cb6126e0 e985a3c0
Jan 27 11:48:59 ECDCCAM1 kernel:        e1193eb4 00000000 00000200
00000040 e1193efc 00000200 e1193efc ffffffff
Jan 27 11:48:59 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:59 ECDCCAM1 kernel:  =======================
Jan 27 11:48:59 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20351
 2567         20352 20350 (NOTLB)
Jan 27 11:48:59 ECDCCAM1 kernel:        de018e94 00200086 428a0003
003cb170 00000040 c06a7400 de018eb4 0000000a
Jan 27 11:48:59 ECDCCAM1 kernel:        dab4e550 428a18d8 003cb170
000018d5 00000000 dab4e65c cb6126e0 e985a3c0
Jan 27 11:48:59 ECDCCAM1 kernel:        de018eb4 00000000 00000200
00000040 de018efc 00000200 de018efc ffffffff
Jan 27 11:48:59 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:59 ECDCCAM1 kernel:  =======================
Jan 27 11:48:59 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20352
 2567         20353 20351 (NOTLB)
Jan 27 11:48:59 ECDCCAM1 kernel:        e0c18e94 00200086 42dc4326
003cb170 00000040 c06a7400 e0c18eb4 0000000a
Jan 27 11:48:59 ECDCCAM1 kernel:        dab4e000 42dc6bf6 003cb170
000028d0 00000000 dab4e10c cb6126e0 e985a3c0
Jan 27 11:48:59 ECDCCAM1 kernel:        e0c18eb4 00000000 00000200
00000040 e0c18efc 00000200 e0c18efc ffffffff
Jan 27 11:48:59 ECDCCAM1 kernel: Call Trace:
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:48:59 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:48:59 ECDCCAM1 kernel:  =======================
Jan 27 11:48:59 ECDCCAM1 kernel: httpd.worker  S 003CB16B  2660 20353
 2567         20354 20352 (NOTLB)
Jan 27 11:48:59 ECDCCAM1 kernel:        d6470e94 00200086 033699cc
003cb16b c05d2cb8 f770dc40 f3bbb12c 00000007
Jan 27 11:48:59 ECDCCAM1 kernel:        e6c9baa0 0337091f 003cb16b
00006f53 00000000 e6c9bbac cb6126e0 e985a3c0
Jan 27 11:49:00 ECDCCAM1 kernel:        00000000 00000000 f3bbb12c
c0434a67 d6470e70 d6470e70 d6470efc ffffffff
Jan 27 11:49:00 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:00 ECDCCAM1 kernel:  =======================
Jan 27 11:49:00 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20358
 2567         20359 20357 (NOTLB)
Jan 27 11:49:00 ECDCCAM1 kernel:        dad42e94 00200086 58c82d49
003cb171 00000040 c06a7400 dad42eb4 00000008
Jan 27 11:49:00 ECDCCAM1 kernel:        e8b74000 58c85867 003cb171
00002b1e 00000001 e8b7410c cb6194c4 e985a3c0
Jan 27 11:49:00 ECDCCAM1 kernel:        dad42eb4 00000000 00000200
00000040 dad42efc 00000200 dad42efc ffffffff
Jan 27 11:49:00 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:00 ECDCCAM1 kernel:  =======================
Jan 27 11:49:00 ECDCCAM1 kernel: httpd.worker  S 003CB169  2660 20359
 2567         20360 20358 (NOTLB)
Jan 27 11:49:00 ECDCCAM1 kernel:        e13bee94 00200086 110e45c0
003cb169 c05d2cb8 f770dc40 e1100bec 00000007
Jan 27 11:49:00 ECDCCAM1 kernel:        f4ff7aa0 110ecc15 003cb169
00008655 00000000 f4ff7bac cb6126e0 e985a3c0
Jan 27 11:49:00 ECDCCAM1 kernel:        00000000 00000000 e1100bec
c0434a67 e13bee70 e13bee70 e13beefc ffffffff
Jan 27 11:49:00 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:00 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:01 ECDCCAM1 kernel:  =======================
Jan 27 11:49:01 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20360
 2567         20361 20359 (NOTLB)
Jan 27 11:49:01 ECDCCAM1 kernel:        dd5fde94 00200086 f619c5a0
003cb171 00000040 c06a7400 dd5fdeb4 0000000a
Jan 27 11:49:01 ECDCCAM1 kernel:        f4ff7550 f619f112 003cb171
00002b72 00000000 f4ff765c cb6126e0 e985a3c0
Jan 27 11:49:01 ECDCCAM1 kernel:        dd5fdeb4 00000000 00000200
00000040 dd5fdefc 00000200 dd5fdefc ffffffff
Jan 27 11:49:01 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:01 ECDCCAM1 kernel:  =======================
Jan 27 11:49:01 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20361
 2567         20362 20360 (NOTLB)
Jan 27 11:49:01 ECDCCAM1 kernel:        dd382e94 00200086 5487fd6a
003cb171 00000040 c06a7400 dd382eb4 00000008
Jan 27 11:49:01 ECDCCAM1 kernel:        f4ff7000 54883ec3 003cb171
00004159 00000000 f4ff710c cb6126e0 e985a3c0
Jan 27 11:49:01 ECDCCAM1 kernel:        dd382eb4 00000000 00000200
00000040 dd382efc 00000200 dd382efc ffffffff
Jan 27 11:49:01 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:01 ECDCCAM1 kernel:  =======================
Jan 27 11:49:01 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20362
 2567         20363 20361 (NOTLB)
Jan 27 11:49:01 ECDCCAM1 kernel:        e2062e94 00200086 4289cb54
003cb170 00000040 c06a7400 e2062eb4 0000000a
Jan 27 11:49:01 ECDCCAM1 kernel:        eafe3aa0 428a0003 003cb170
000034af 00000000 eafe3bac cb6126e0 e985a3c0
Jan 27 11:49:01 ECDCCAM1 kernel:        e2062eb4 c05aa190 00000000
00000040 e2062efc 00000200 cb612724 00000200
Jan 27 11:49:01 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:01 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:02 ECDCCAM1 kernel:  =======================
Jan 27 11:49:02 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20363
 2567         20364 20362 (NOTLB)
Jan 27 11:49:02 ECDCCAM1 kernel:        e1ac8e94 00200086 5787590e
003cb171 00000040 c06a7400 e1ac8eb4 0000000a
Jan 27 11:49:02 ECDCCAM1 kernel:        eafe3550 5787cf01 003cb171
000075f3 00000000 eafe365c cb6126e0 e985a3c0
Jan 27 11:49:02 ECDCCAM1 kernel:        e1ac8eb4 00000000 00001f40
00000040 e1ac8efc 00001f40 e1ac8efc ffffffff
Jan 27 11:49:02 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:02 ECDCCAM1 kernel:  =======================
Jan 27 11:49:02 ECDCCAM1 kernel: httpd.worker  S 003CB170  2612 20364
 2567         20365 20363 (NOTLB)
Jan 27 11:49:02 ECDCCAM1 kernel:        ddfc2e94 00200086 42e8c4ef
003cb170 00000040 c06a7400 ddfc2eb4 0000000a
Jan 27 11:49:02 ECDCCAM1 kernel:        eafe3000 42e8e88f 003cb170
000023a0 00000000 eafe310c cb6126e0 e985a3c0
Jan 27 11:49:02 ECDCCAM1 kernel:        ddfc2eb4 00000000 00000200
00000040 ddfc2efc 00000200 ddfc2efc ffffffff
Jan 27 11:49:02 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:02 ECDCCAM1 kernel:  =======================
Jan 27 11:49:02 ECDCCAM1 kernel: httpd.worker  S 003CB165  2660 20365
 2567         20366 20364 (NOTLB)
Jan 27 11:49:02 ECDCCAM1 kernel:        ddd07e94 00200086 a2858caf
003cb165 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:49:02 ECDCCAM1 kernel:        e4df5aa0 a2861773 003cb165
00008ac4 00000000 e4df5bac cb6126e0 e985a3c0
Jan 27 11:49:02 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 ddd07e70 00000001 ffffffff
Jan 27 11:49:02 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:02 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:03 ECDCCAM1 kernel:  =======================
Jan 27 11:49:03 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20366
 2567         20367 20365 (NOTLB)
Jan 27 11:49:03 ECDCCAM1 kernel:        ddd3fe94 00200086 f6357f31
003cb171 00000040 c06a7400 ddd3feb4 0000000a
Jan 27 11:49:03 ECDCCAM1 kernel:        e4df5550 f635a888 003cb171
00002957 00000001 e4df565c cb6194c4 e985a3c0
Jan 27 11:49:03 ECDCCAM1 kernel:        ddd3feb4 00000000 00000200
00000040 ddd3fefc 00000200 ddd3fefc ffffffff
Jan 27 11:49:03 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:03 ECDCCAM1 kernel:  =======================
Jan 27 11:49:03 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20367
 2567         20368 20366 (NOTLB)
Jan 27 11:49:03 ECDCCAM1 kernel:        f18ffe94 00200086 f572990e
003cb171 00000040 c06a7400 f18ffeb4 0000000a
Jan 27 11:49:03 ECDCCAM1 kernel:        e4df5000 f572d627 003cb171
00003d19 00000000 e4df510c cb6126e0 e985a3c0
Jan 27 11:49:03 ECDCCAM1 kernel:        f18ffeb4 00000000 00000200
00000040 f18ffefc 00000200 f18ffefc ffffffff
Jan 27 11:49:03 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:03 ECDCCAM1 kernel:  =======================
Jan 27 11:49:03 ECDCCAM1 kernel: httpd.worker  S 003CB151  2660 20368
 2567         20369 20367 (NOTLB)
Jan 27 11:49:03 ECDCCAM1 kernel:        d634ee94 00200086 a2077cf1
003cb151 00000040 c06a7400 d634eeb4 0000000a
Jan 27 11:49:03 ECDCCAM1 kernel:        d8957aa0 a2079ec6 003cb151
000021d5 00000000 d8957bac cb6126e0 e985a3c0
Jan 27 11:49:03 ECDCCAM1 kernel:        d634eeb4 00000000 00000200
00000040 d634eefc 00000200 d634eefc ffffffff
Jan 27 11:49:03 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:03 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:04 ECDCCAM1 kernel:  =======================
Jan 27 11:49:04 ECDCCAM1 kernel: httpd.worker  S 003CB151  2660 20369
 2567         20370 20368 (NOTLB)
Jan 27 11:49:04 ECDCCAM1 kernel:        e1cd8e94 00200086 a1bd4857
003cb151 00000040 c06a7400 e1cd8eb4 0000000a
Jan 27 11:49:04 ECDCCAM1 kernel:        d8957550 a1bd7363 003cb151
00002b0c 00000001 d895765c cb6194c4 e985a3c0
Jan 27 11:49:04 ECDCCAM1 kernel:        e1cd8eb4 00000000 00000200
00000040 e1cd8efc 00000200 e1cd8efc ffffffff
Jan 27 11:49:04 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:04 ECDCCAM1 kernel:  =======================
Jan 27 11:49:04 ECDCCAM1 kernel: httpd.worker  S 003CB211  3292 20370
 2567               20369 (NOTLB)
Jan 27 11:49:04 ECDCCAM1 kernel:        e7c65f40 00200086 3c7d93f8
003cb211 00200200 d8957000 00000000 00000007
Jan 27 11:49:04 ECDCCAM1 kernel:        d8957000 3c7da27a 003cb211
00000e82 00000001 d895710c cb6194c4 e985a3c0
Jan 27 11:49:04 ECDCCAM1 kernel:        003cb1e6 000007c0 00000000
00000000 f7054bfc d8957000 d51fd700 cb6163e4
Jan 27 11:49:04 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0495241>] sys_epoll_wait+0x14a/0x38d
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:04 ECDCCAM1 kernel:  =======================
Jan 27 11:49:04 ECDCCAM1 kernel: in.rshd       S 003CB2A7  2420 12681
 2261                     (NOTLB)
Jan 27 11:49:04 ECDCCAM1 kernel:        eaf9ad34 00000082 850175a2
003cb2a7 c0461537 f4dc0680 f4244810 00000009
Jan 27 11:49:04 ECDCCAM1 kernel:        d941a550 85078504 003cb2a7
00060f62 00000000 d941a65c cb6126e0 d0fb2e40
Jan 27 11:49:04 ECDCCAM1 kernel:        00f30007 00000000 8831f2b8
29aa208b 9693c8bf 00000050 eaf9ae8c ffffffff
Jan 27 11:49:04 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0461537>] __handle_mm_fault+0xb1c/0xb7b
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0485a36>] dput+0x22/0xed
Jan 27 11:49:04 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c047f3d8>] do_path_lookup+0x20e/0x25e
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0479080>] cp_new_stat64+0xfc/0x10e
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:05 ECDCCAM1 kernel:  =======================
Jan 27 11:49:05 ECDCCAM1 kernel: crond         S 003CB2A7  2792 12684
 2370                     (NOTLB)
Jan 27 11:49:05 ECDCCAM1 kernel:        dbb30d34 00000082 7dee4cd3
003cb2a7 c04546b7 00000000 00f3001d 00000007
Jan 27 11:49:05 ECDCCAM1 kernel:        d9c0c000 7df1f858 003cb2a7
0003ab85 00000002 d9c0c10c cb6202a8 d0fb2740
Jan 27 11:49:05 ECDCCAM1 kernel:        00f3001d 00000000 00000000
f7f7695c f52b78c0 f77a99f8 f374e754 cc2cc4e4
Jan 27 11:49:05 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0428929>] current_fs_time+0x4a/0x55
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c06061eb>] unix_find_other+0xc7/0x162
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0607afe>] unix_dgram_connect+0x6a/0x137
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0607b42>] unix_dgram_connect+0xae/0x137
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05ab760>] sys_connect+0x7d/0xa9
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0480c5a>] sys_fcntl64+0x79/0x80
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:05 ECDCCAM1 kernel:  =======================
Jan 27 11:49:05 ECDCCAM1 kernel: diskwatchclie S 003CB25A  2908 12685
 2653 12700               (NOTLB)
Jan 27 11:49:05 ECDCCAM1 kernel:        d04bff00 00000086 375c2686
003cb25a d0fb2408 d0fb23f8 00000000 00000004
Jan 27 11:49:05 ECDCCAM1 kernel:        f5255550 375c52a0 003cb25a
00002c1a 00000000 f525565c cb6126e0 d0fb23c0
Jan 27 11:49:05 ECDCCAM1 kernel:        d0fb23c0 080f59f4 00000000
d0fb23c0 00000000 00000000 d04bff08 da289e00
Jan 27 11:49:05 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:49:05 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:06 ECDCCAM1 kernel:  =======================
Jan 27 11:49:06 ECDCCAM1 kernel: diskwatchclie S 003CB25A  3404 12700
12685 12701               (NOTLB)
Jan 27 11:49:06 ECDCCAM1 kernel:        dfd4af54 00000086 3763c918
003cb25a fffacff8 ffffffff 7fffffff 00000002
Jan 27 11:49:06 ECDCCAM1 kernel:        f4c1caa0 37642690 003cb25a
00005d78 00000000 f4c1cbac cb6126e0 e985aac0
Jan 27 11:49:06 ECDCCAM1 kernel:        f4c1caa0 cb703700 00000004
ffffffff f4c1caa0 00000000 cb612b9c d643f550
Jan 27 11:49:06 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:06 ECDCCAM1 kernel:  =======================
Jan 27 11:49:06 ECDCCAM1 kernel: hdparm        S 003CB2A7  2532 12701
12700         12702       (NOTLB)
Jan 27 11:49:06 ECDCCAM1 kernel:        e9b67f3c 00000082 705c0435
003cb2a7 c042b45a e9b67f00 5c180960 00000007
Jan 27 11:49:06 ECDCCAM1 kernel:        f561baa0 705c7385 003cb2a7
00006f50 00000001 f561bbac cb6194c4 e985ac80
Jan 27 11:49:06 ECDCCAM1 kernel:        00000000 c0436cee 00000000
00000286 c0436f95 fd60bf76 007ccf73 4a906176
Jan 27 11:49:06 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c042b45a>] getnstimeofday+0x30/0xb6
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0436cee>] enqueue_hrtimer+0x4b/0x6a
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0436f95>] hrtimer_start+0xb6/0xc0
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c060e5ba>] do_nanosleep+0x3c/0x6a
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0436fef>] hrtimer_nanosleep+0x50/0x106
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0436df2>] hrtimer_wakeup+0x0/0x18
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c042cd4c>] sigprocmask+0xb0/0xce
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c04370e6>] sys_nanosleep+0x41/0x51
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:06 ECDCCAM1 kernel:  =======================
Jan 27 11:49:06 ECDCCAM1 kernel: grep          S 003CB25A  3088 12702
12700               12701 (NOTLB)
Jan 27 11:49:06 ECDCCAM1 kernel:        d6f7cf00 00000086 3764653b
003cb25a 000280d2 00000010 ca24c900 00000001
Jan 27 11:49:06 ECDCCAM1 kernel:        d643f550 376c1f49 003cb25a
0007ba0e 00000001 d643f65c cb6194c4 d0fb2900
Jan 27 11:49:06 ECDCCAM1 kernel:        ffffff9c 0927c434 00000000
d0fb2900 00000000 00000000 d6f7cf08 e532e800
Jan 27 11:49:06 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c04671a8>]
free_pages_and_swap_cache+0x6b/0x7f
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:49:06 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:07 ECDCCAM1 kernel:  =======================
Jan 27 11:49:07 ECDCCAM1 kernel: SendArp       S 003CB2A7  3404 12772
    1 12773   12812 12647 (NOTLB)
Jan 27 11:49:07 ECDCCAM1 kernel:        d6730f54 00000082 74e397aa
003cb2a7 fff91ff8 ffffffff 7fffffff 00000001
Jan 27 11:49:07 ECDCCAM1 kernel:        d9153aa0 74e42ff7 003cb2a7
0000984d 00000001 d9153bac cb6194c4 d4b63040
Jan 27 11:49:07 ECDCCAM1 kernel:        d9153aa0 00000000 00000004
ffffffff d9153aa0 00000000 00000000 ffffffff
Jan 27 11:49:07 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:07 ECDCCAM1 kernel:  =======================
Jan 27 11:49:07 ECDCCAM1 kernel: send_arp      S 003CB2A7  3044 12773
12772                     (NOTLB)
Jan 27 11:49:07 ECDCCAM1 kernel:        dc14dd34 00000082 75382e27
003cb2a7 c0461537 dc14ddb8 00000002 00000001
Jan 27 11:49:07 ECDCCAM1 kernel:        d6986000 753aec9d 003cb2a7
0002be76 00000002 d698610c cb6202a8 d4b63c80
Jan 27 11:49:07 ECDCCAM1 kernel:        00000100 00000000 00000681
00000002 00000002 00000001 00000000 ffffffff
Jan 27 11:49:07 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0461537>] __handle_mm_fault+0xb1c/0xb7b
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0457076>] filemap_nopage+0x192/0x314
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0428929>] current_fs_time+0x4a/0x55
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c06061eb>] unix_find_other+0xc7/0x162
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0457076>] filemap_nopage+0x192/0x314
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0607afe>] unix_dgram_connect+0x6a/0x137
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0607b42>] unix_dgram_connect+0xae/0x137
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c05ab760>] sys_connect+0x7d/0xa9
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0480c5a>] sys_fcntl64+0x79/0x80
Jan 27 11:49:07 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:07 ECDCCAM1 kernel:  =======================
Jan 27 11:49:07 ECDCCAM1 kernel: SendArp       S 003CB2A7  3404 12812
    1 12813   12881 12772 (NOTLB)
Jan 27 11:49:07 ECDCCAM1 kernel:        f78a1f54 00000082 7833d197
003cb2a7 fff76ff8 ffffffff 7fffffff 00000001
Jan 27 11:49:08 ECDCCAM1 kernel:        f76c0000 7834b4f5 003cb2a7
0000e35e 00000002 f76c010c cb6202a8 d06c9040
Jan 27 11:49:08 ECDCCAM1 kernel:        f76c0000 00000000 00000004
ffffffff f76c0000 00000000 00000000 ffffffff
Jan 27 11:49:08 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:08 ECDCCAM1 kernel:  =======================
Jan 27 11:49:08 ECDCCAM1 kernel: send_arp      S 003CB2A7  2660 12813
12812                     (NOTLB)
Jan 27 11:49:08 ECDCCAM1 kernel:        e4d93fb0 00000082 84659e61
003cb2a7 00000000 d9153000 cfd89944 00000001
Jan 27 11:49:08 ECDCCAM1 kernel:        d9153000 84666e3e 003cb2a7
0000cfdd 00000000 d915310c cb6126e0 e985ae40
Jan 27 11:49:08 ECDCCAM1 kernel:        00000000 00000000 e4d93000
c0427e48 00000000 00000000 00000000 ffffffff
Jan 27 11:49:08 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0427e48>] sys_setitimer+0x74/0x7f
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c042eb62>] sys_pause+0x14/0x1a
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:08 ECDCCAM1 kernel:  =======================
Jan 27 11:49:08 ECDCCAM1 kernel: heartbeat     S 003CB2A7  3072 12872
 2722 12873          3190 (NOTLB)
Jan 27 11:49:08 ECDCCAM1 kernel:        e5f75f54 00000082 81efe25a
003cb2a7 00000000 c0403d29 00100011 00000001
Jan 27 11:49:08 ECDCCAM1 kernel:        d8c22550 81efee66 003cb2a7
00000c0c 00000001 d8c2265c cb6194c4 f7f62580
Jan 27 11:49:08 ECDCCAM1 kernel:        d8c22550 00000000 00000004
00003253 d8c22550 2602d065 00000001 ffffffff
Jan 27 11:49:08 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0403d29>] copy_thread+0x2f/0x1e6
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:08 ECDCCAM1 kernel:  =======================
Jan 27 11:49:08 ECDCCAM1 kernel: ResourceManag X 003CB2A7  2884 12873
12872         12883       (L-TLB)
Jan 27 11:49:08 ECDCCAM1 kernel:        e5c00f7c 00000046 81d7551c
003cb2a7 d41c4b90 00000010 c04e5002 00000001
Jan 27 11:49:08 ECDCCAM1 kernel:        f54d5550 81efe25a 003cb2a7
00188d3e 00000001 f54d565c cb6194c4 f74a8740
Jan 27 11:49:08 ECDCCAM1 kernel:        c0489306 e11a0180 00000000
00000246 eaa1f514 e2194834 cb619508 c04e18a8
Jan 27 11:49:08 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c04e5002>] _atomic_dec_and_lock+0x2a/0x44
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c04e18a8>] cfq_free_io_context+0x2a/0x55
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c04273ef>] do_exit+0x78a/0x794
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c042746f>] sys_exit_group+0x0/0xd
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:08 ECDCCAM1 kernel:  =======================
Jan 27 11:49:08 ECDCCAM1 kernel: udevd         S 003CB2A7  2060 12878
  490 12885   12879       (NOTLB)
Jan 27 11:49:08 ECDCCAM1 kernel:        ee707f3c c060dae0 82574467
003cb2a7 c042b45a ee707f00 5c180bbc 00000004
Jan 27 11:49:08 ECDCCAM1 kernel:        c06783c0 8257966d 003cb2a7
00005206 00000000 d1004bac cb6126e0 d0fb2c80
Jan 27 11:49:08 ECDCCAM1 kernel:        00000000 00000000 00000286
c0436e23 ee707f6c ffffffff 00000001 00000286
Jan 27 11:49:08 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:49:08 ECDCCAM1 kernel:  [<c042b45a>] getnstimeofday+0x30/0xb6
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0436e23>] lock_hrtimer_base+0x19/0x35
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0436ec5>] hrtimer_try_to_cancel+0x3c/0x42
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0436ed5>] hrtimer_cancel+0xa/0x14
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c060f2ed>] _write_lock_irq+0xf/0x10
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0425fd7>] release_task+0x74/0x2f5
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c04268aa>] do_wait+0x652/0x97c
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:09 ECDCCAM1 kernel:  =======================
Jan 27 11:49:09 ECDCCAM1 kernel: udevd         S 003CB2A7  3296 12879
  490 12884         12878 (NOTLB)
Jan 27 11:49:09 ECDCCAM1 kernel:        d7c50f3c 00000086 81fa08a0
003cb2a7 c042b45a d7c50f00 5c180bb0 00000003
Jan 27 11:49:09 ECDCCAM1 kernel:        d2161aa0 81fa60e0 003cb2a7
00005840 00000001 d2161bac cb6194c4 f74a8200
Jan 27 11:49:09 ECDCCAM1 kernel:        00000000 00000000 cb61a5f0
00000286 c0436f95 6225f29d 007ccf73 ffffffff
Jan 27 11:49:09 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c042b45a>] getnstimeofday+0x30/0xb6
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0436f95>] hrtimer_start+0xb6/0xc0
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c060e5ba>] do_nanosleep+0x3c/0x6a
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0436fef>] hrtimer_nanosleep+0x50/0x106
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0436df2>] hrtimer_wakeup+0x0/0x18
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c04370e6>] sys_nanosleep+0x41/0x51
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:09 ECDCCAM1 kernel:  =======================
Jan 27 11:49:09 ECDCCAM1 kernel: mingetty      S 003CB2A7  2728 12881
    1               12812 (NOTLB)
Jan 27 11:49:09 ECDCCAM1 kernel:        f4fdaee4 00000086 83505a72
003cb2a7 00000004 00000000 c00b833e 00000007
Jan 27 11:49:09 ECDCCAM1 kernel:        f55ff000 8351cfd4 003cb2a7
00017562 00000002 f55ff10c cb6202a8 cfd84ac0
Jan 27 11:49:09 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000286 c0683780
Jan 27 11:49:09 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:49:09 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:09 ECDCCAM1 kernel:  =======================
Jan 27 11:49:09 ECDCCAM1 kernel: ResourceManag S 003CB2A7  2908 12883
12872 12931         12873 (NOTLB)
Jan 27 11:49:10 ECDCCAM1 kernel:        da04ef54 00000086 87013bea
003cb2a7 00000000 00000100 ffffffff 00000001
Jan 27 11:49:10 ECDCCAM1 kernel:        f09da000 8701cca4 003cb2a7
000090ba 00000002 f09da10c cb6202a8 f74a8900
Jan 27 11:49:10 ECDCCAM1 kernel:        00000246 00000000 00000004
ffffffff f09da000 1ad7f065 00000001 ffffffff
Jan 27 11:49:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:10 ECDCCAM1 kernel:  =======================
Jan 27 11:49:10 ECDCCAM1 kernel: udev_run_hotp X 003CB2A7  2928 12884
12879                     (L-TLB)
Jan 27 11:49:10 ECDCCAM1 kernel:        f3ceaf7c 00000046 8200c78c
003cb2a7 f7d686dc 00000008 f7d685bc 00000002
Jan 27 11:49:10 ECDCCAM1 kernel:        de3f6550 82072a13 003cb2a7
00066287 00000002 de3f665c cb6202a8 d0fb2040
Jan 27 11:49:10 ECDCCAM1 kernel:        c0489306 00000000 d542e240
c046fad5 d542e240 00000001 00000008 ffffffff
Jan 27 11:49:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c04273ef>] do_exit+0x78a/0x794
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c042746f>] sys_exit_group+0x0/0xd
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:10 ECDCCAM1 kernel:  =======================
Jan 27 11:49:10 ECDCCAM1 kernel: udev_run_hotp X 003CB2A7  2928 12885
12878                     (L-TLB)
Jan 27 11:49:10 ECDCCAM1 kernel:        e4449f7c 00000046 825f6782
003cb2a7 f7d686dc 00000008 f7d685bc 00000003
Jan 27 11:49:10 ECDCCAM1 kernel:        cffa4000 8263d62e 003cb2a7
00046eac 00000001 cffa410c cb6194c4 cfd8c900
Jan 27 11:49:10 ECDCCAM1 kernel:        c0489306 00000000 cfc79840
c046fad5 cfc79840 00000001 00000008 ffffffff
Jan 27 11:49:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c04273ef>] do_exit+0x78a/0x794
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c042746f>] sys_exit_group+0x0/0xd
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:10 ECDCCAM1 kernel:  =======================
Jan 27 11:49:10 ECDCCAM1 kernel: sh            R running  3092 12909
2570                     (NOTLB)
Jan 27 11:49:10 ECDCCAM1 kernel: IPaddr        D 003CB2A7  2908 12931
12883                     (NOTLB)
Jan 27 11:49:10 ECDCCAM1 kernel:        d72ebea0 00000082 870136f1
003cb2a7 d72ebf3c c047f075 cdaca000 00000001
Jan 27 11:49:10 ECDCCAM1 kernel:        d5471aa0 8706aa97 003cb2a7
000573a6 00000003 d5471bac cb62708c f7f24580
Jan 27 11:49:10 ECDCCAM1 kernel:        0000007b 00000000 ffffffff
00000007 00000019 00000007 ffffff9c ffffffff
Jan 27 11:49:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c060e53b>] __mutex_lock_slowpath+0x4d/0x7c
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c060e579>] .text.lock.mutex+0xf/0x14
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0531100>] tty_open+0x33/0x2f1
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c04e573e>] kobject_get+0xf/0x13
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0478dca>] chrdev_open+0x117/0x132
Jan 27 11:49:10 ECDCCAM1 kernel:  [<c0478cb3>] chrdev_open+0x0/0x132
Jan 27 11:49:11 ECDCCAM1 kernel:  [<c046fc57>] __dentry_open+0xc7/0x1ab
Jan 27 11:49:11 ECDCCAM1 kernel:  [<c046fd9f>] nameidata_to_filp+0x19/0x28
Jan 27 11:49:11 ECDCCAM1 kernel:  [<c046fdd9>] do_filp_open+0x2b/0x31
Jan 27 11:49:11 ECDCCAM1 kernel:  [<c046fe1d>] do_sys_open+0x3e/0xae
Jan 27 11:49:11 ECDCCAM1 kernel:  [<c046feba>] sys_open+0x16/0x18
Jan 27 11:49:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:49:11 ECDCCAM1 kernel:  =======================
Jan 27 11:50:20 ECDCCAM1 syslogd 1.4.1: restart.
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: NS: We still can ping 1 nodes
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Asking other side for
ping node count.
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Status update: Node
ecdccam2 now has status dead
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: NS: We still can ping 1 nodes
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Asking other side for
ping node count.
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Link Status update: Link
ecdccam2/eth1 now has status dead
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Link Status update: Link
ecdccam2/eth1 now has status up
Jan 27 11:50:20 ECDCCAM1 racoon: INFO: 127.0.0.1[500] used as isakmp
port (fd=11)
Jan 27 11:50:20 ECDCCAM1 racoon: INFO: 127.0.0.1[500] used for NAT-T
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Link Status update: Link
10.13.230.94/10.13.230.94 now has status up
Jan 27 11:50:20 ECDCCAM1 racoon: INFO: 10.13.230.66[500] used as
isakmp port (fd=12)
Jan 27 11:50:21 ECDCCAM1 racoon: INFO: 10.13.230.66[500] used for NAT-T
Jan 27 11:50:20 ECDCCAM1 ipfail[3190]: info: Status update: Node
10.13.230.94 now has status ping
Jan 27 11:50:21 ECDCCAM1 xinetd[2261]: EXIT: shell status=0 pid=12681
duration=464(sec)
Jan 27 11:50:21 ECDCCAM1 racoon: INFO: 192.168.0.254[500] used as
isakmp port (fd=13)
Jan 27 11:50:21 ECDCCAM1 ipfail[3190]: info: A ping node just came up.
Jan 27 11:55:35 ECDCCAM1 kernel: x28
Jan 27 11:55:35 ECDCCAM1 cl_status[13142]: ERROR: initiate_connection:
connect failure: Connection refused
Jan 27 11:55:35 ECDCCAM1 racoon: INFO: 192.168.0.254[500] used for NAT-T
Jan 27 11:55:36 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:36 ECDCCAM1 cl_status[13142]: ERROR: Cannot signon with heartbeat
Jan 27 11:55:36 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:36 ECDCCAM1 cl_status[13142]: ERROR: REASON:
hb_api_signon: Can't initiate connection  to heartbeat
Jan 27 11:55:36 ECDCCAM1 kernel:  [<c040598f>] invalidate_interrupt+0x1f/0x24
Jan 27 11:55:36 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:36 ECDCCAM1 kernel:  =======================
Jan 27 11:55:36 ECDCCAM1 kernel: java          S 003CB25A  2624 12110
    1         30911 28651 (NOTLB)
Jan 27 11:55:36 ECDCCAM1 kernel:        e8770e94 00000086 3618c153
003cb25a 00000000 00000001 00000070 00000008
Jan 27 11:55:36 ECDCCAM1 kernel:        d414b550 361b386b 003cb25a
00027718 00000000 d414b65c cb6126e0 d5103900
Jan 27 11:55:37 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 c07a6200 e8770e9c 00000286 ffffffff
Jan 27 11:55:37 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c05e193c>]
__tcp_push_pending_frames+0x6ac/0x761
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:37 ECDCCAM1 kernel:  =======================
Jan 27 11:55:37 ECDCCAM1 kernel: java          S 003CB2C5  2660 27915
    1         27916 30911 (NOTLB)
Jan 27 11:55:37 ECDCCAM1 kernel:        de5dbd34 00000086 43693322
003cb2c5 c05b56ff f770dc54 f770dc68 00000008
Jan 27 11:55:37 ECDCCAM1 kernel:        f59b5550 4369b57e 003cb2c5
0000825c 00000000 f59b565c cb6126e0 d5103900
Jan 27 11:55:37 ECDCCAM1 kernel:        401ba580 00000000 00000000
f71ba720 da29e224 f71ba5f0 cb612724 ffffffff
Jan 27 11:55:37 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:37 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:38 ECDCCAM1 kernel:  =======================
Jan 27 11:55:38 ECDCCAM1 kernel: java          S 003CB2C1  2360 27916
    1         28138 27915 (NOTLB)
Jan 27 11:55:38 ECDCCAM1 kernel:        f48cbe94 00000086 030a3960
003cb2c1 00000100 00000001 00000070 0000000a
Jan 27 11:55:38 ECDCCAM1 kernel:        f7059550 030a54b9 003cb2c1
00001b59 00000002 f705965c cb6202a8 d5103900
Jan 27 11:55:38 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 f7e3e000 f48cbe9c 00000286 ffffffff
Jan 27 11:55:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:38 ECDCCAM1 kernel:  =======================
Jan 27 11:55:38 ECDCCAM1 kernel: java          S 003CB2AD  2656 28138
    1         28139 27916 (NOTLB)
Jan 27 11:55:38 ECDCCAM1 kernel:        e77c6d34 00000086 43272daf
003cb2ad c05b56ff f770dc54 f770dc68 0000000a
Jan 27 11:55:38 ECDCCAM1 kernel:        e6b85000 432bbc78 003cb2ad
00048ec9 00000000 e6b8510c cb6126e0 d5103900
Jan 27 11:55:38 ECDCCAM1 kernel:        c06100a9 00000000 00000000
e77c6f60 00000001 ddfe584c ddfe584c ffffffff
Jan 27 11:55:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:55:38 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:39 ECDCCAM1 kernel:  =======================
Jan 27 11:55:39 ECDCCAM1 kernel: java          S 003CB2B3  2948 28139
    1          3825 28138 (NOTLB)
Jan 27 11:55:39 ECDCCAM1 kernel:        d5b29e94 00000086 7591b42d
003cb2b3 c0458d9b 00000202 d5103900 0000000a
Jan 27 11:55:39 ECDCCAM1 kernel:        e6b85550 7591da5a 003cb2b3
0000262d 00000002 e6b8565c cb6202a8 d5103900
Jan 27 11:55:39 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
00000286 c042c2e0 d5b29e9c ffffffff ffffffff
Jan 27 11:55:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:39 ECDCCAM1 kernel:  =======================
Jan 27 11:55:39 ECDCCAM1 kernel: java          S 003CB201  2528  3825
    1         27184 28139 (NOTLB)
Jan 27 11:55:39 ECDCCAM1 kernel:        e5574e94 00000086 1a4a133e
003cb201 00000000 00000202 d5103900 00000008
Jan 27 11:55:39 ECDCCAM1 kernel:        f798a550 1a4cc5d6 003cb201
0002b298 00000000 f798a65c cb6126e0 d5103900
Jan 27 11:55:39 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 c07a6200 e5574e9c 00000286 ffffffff
Jan 27 11:55:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:39 ECDCCAM1 kernel:  =======================
Jan 27 11:55:40 ECDCCAM1 kernel: java          S 003CB2C6  2660 27184
    1         27185  3825 (NOTLB)
Jan 27 11:55:40 ECDCCAM1 kernel:        f4d92d34 00000086 189e1ce2
003cb2c6 cc149000 c0678570 cb60f600 0000000a
Jan 27 11:55:40 ECDCCAM1 kernel:        cc149000 189e252f 003cb2c6
0000084d 00000000 cc14910c cb6126e0 d5103900
Jan 27 11:55:40 ECDCCAM1 kernel:        0000000a 00000000 00000000
cc149000 00000000 cb6126e0 cb612724 ffffffff
Jan 27 11:55:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:40 ECDCCAM1 kernel:  =======================
Jan 27 11:55:40 ECDCCAM1 kernel: java          S 003CB2C4  2360 27185
    1         27205 27184 (NOTLB)
Jan 27 11:55:40 ECDCCAM1 kernel:        ed466e94 00000086 b704dec1
003cb2c4 00000000 00000202 ed466e60 0000000a
Jan 27 11:55:40 ECDCCAM1 kernel:        cc149550 b704ed9f 003cb2c4
00000ede 00000002 cc14965c cb6202a8 d5103900
Jan 27 11:55:40 ECDCCAM1 kernel:        c045f1ed 00000000 00000000
c042c2e0 f7e3e000 ed466e9c 00000286 c042c3f1
Jan 27 11:55:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:40 ECDCCAM1 kernel:  =======================
Jan 27 11:55:40 ECDCCAM1 kernel: java          S 003CB2C6  2504 27205
    1         27206 27185 (NOTLB)
Jan 27 11:55:40 ECDCCAM1 kernel:        e0bd8d34 00000086 04801584
003cb2c6 00000003 2d1a0f83 00000092 0000000a
Jan 27 11:55:40 ECDCCAM1 kernel:        f7f41550 048541eb 003cb2c6
00052c67 00000000 f7f4165c cb6126e0 d5103900
Jan 27 11:55:41 ECDCCAM1 kernel:        c06100a9 00000000 00000000
e0bd8f60 00000001 e95b904c cb612724 ffffffff
Jan 27 11:55:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c05e9fce>] udp_recvmsg+0x4b/0x205
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0438d4f>] do_futex+0x6a3/0xb5e
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:41 ECDCCAM1 kernel:  =======================
Jan 27 11:55:41 ECDCCAM1 kernel: java          S 003CB2C5  2660 27206
    1         26698 27205 (NOTLB)
Jan 27 11:55:41 ECDCCAM1 kernel:        d01e4e94 00000086 7e8459e0
003cb2c5 00000002 00000202 d5103900 0000000a
Jan 27 11:55:41 ECDCCAM1 kernel:        f09da550 7e84845f 003cb2c5
00002a7f 00000002 f09da65c cb6202a8 d5103900
Jan 27 11:55:41 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
c042c2e0 f7e3e000 d01e4e9c 00000286 ffffffff
Jan 27 11:55:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:41 ECDCCAM1 kernel:  =======================
Jan 27 11:55:41 ECDCCAM1 kernel: java          S 003CB2C6  2532 26698
    1         31512 27206 (NOTLB)
Jan 27 11:55:41 ECDCCAM1 kernel:        f5acfe94 00000086 04cb10e3
003cb2c6 e6a550c8 f5acfe5c d279a5ec 0000000a
Jan 27 11:55:41 ECDCCAM1 kernel:        f3498550 04cf6420 003cb2c6
0004533d 00000003 f349865c cb62708c d5103900
Jan 27 11:55:41 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 cb740000 f5acfe9c 00000286 ffffffff
Jan 27 11:55:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:41 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c05e193c>]
__tcp_push_pending_frames+0x6ac/0x761
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:42 ECDCCAM1 kernel:  =======================
Jan 27 11:55:42 ECDCCAM1 kernel: java          S 003C8DB3  3480 31512
    1         11434 26698 (NOTLB)
Jan 27 11:55:42 ECDCCAM1 kernel:        ed50ce94 00000086 fb3309c2
003c8db3 00000000 00000000 00000000 00000009
Jan 27 11:55:42 ECDCCAM1 kernel:        d2e0aaa0 fb33d008 003c8db3
0000c646 00000000 d2e0abac cb6126e0 d5103900
Jan 27 11:55:42 ECDCCAM1 kernel:        00000000 ed50ce88 00000000
c042c2e0 c07a6200 ed50ce9c cb612724 c042c3f1
Jan 27 11:55:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:42 ECDCCAM1 kernel:  =======================
Jan 27 11:55:42 ECDCCAM1 kernel: java          S 003CB092  3396 11434
    1         11486 31512 (NOTLB)
Jan 27 11:55:42 ECDCCAM1 kernel:        e74fde94 00000086 c28847fa
003cb092 00000180 00000202 d5103900 0000000a
Jan 27 11:55:42 ECDCCAM1 kernel:        d9c11550 c28909b9 003cb092
0000c1bf 00000000 d9c1165c cb6126e0 d5103900
Jan 27 11:55:42 ECDCCAM1 kernel:        00000000 e74fde88 00000000
00000000 00000003 cfda9f0c cb612b9c cfda9f0c
Jan 27 11:55:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:55:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:42 ECDCCAM1 kernel:  =======================
Jan 27 11:55:42 ECDCCAM1 kernel: java          S 003CB0A7  3396 11486
    1         12595 11434 (NOTLB)
Jan 27 11:55:42 ECDCCAM1 kernel:        d9367e94 00000086 ec8dc956
003cb0a7 00000000 00000202 d5103900 00000006
Jan 27 11:55:42 ECDCCAM1 kernel:        cfd8d000 ec8e8abd 003cb0a7
0000c167 00000002 cfd8d10c cb6202a8 d5103900
Jan 27 11:55:43 ECDCCAM1 kernel:        00000000 d9367e88 00000000
00000000 00000003 e61dbf0c cb6202ec e61dbf0c
Jan 27 11:55:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:43 ECDCCAM1 kernel:  =======================
Jan 27 11:55:43 ECDCCAM1 kernel: java          S 003CB2BC  3396 12595
    1         12598 11486 (NOTLB)
Jan 27 11:55:43 ECDCCAM1 kernel:        dcf44e94 00000086 6acf768a
003cb2bc 00000000 00000000 00000000 00000006
Jan 27 11:55:43 ECDCCAM1 kernel:        cfc87aa0 6ad03ce0 003cb2bc
0000c656 00000001 cfc87bac cb6194c4 d5103900
Jan 27 11:55:43 ECDCCAM1 kernel:        00000000 dcf44e88 00000000
00000000 00000003 eea55f0c cb619980 eea55f0c
Jan 27 11:55:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c042835a>] sys_gettimeofday+0x27/0x53
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:43 ECDCCAM1 kernel:  =======================
Jan 27 11:55:43 ECDCCAM1 kernel: java          R running  2904 12598
   1         12608 12595 (L-TLB)
Jan 27 11:55:43 ECDCCAM1 kernel: java          R running  2904 12608
   1         12647 12598 (NOTLB)
Jan 27 11:55:43 ECDCCAM1 kernel: java          S 003CB204  3396 12647
    1         12939 12608 (NOTLB)
Jan 27 11:55:43 ECDCCAM1 kernel:        d9d4de94 00000086 e446641a
003cb204 00000000 00000000 00000000 00000006
Jan 27 11:55:43 ECDCCAM1 kernel:        d202b000 e447082b 003cb204
0000a411 00000002 d202b10c cb6202a8 d5103900
Jan 27 11:55:43 ECDCCAM1 kernel:        c045f1ed 00000000 00000286
c042c2e0 f7e3e000 d9d4de9c 00000286 ffffffff
Jan 27 11:55:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:44 ECDCCAM1 kernel:  =======================
Jan 27 11:55:44 ECDCCAM1 kernel: java          S 003CB2BC  3396 12939
    1         12941 12647 (NOTLB)
Jan 27 11:55:44 ECDCCAM1 kernel:        eea55e94 00000086 6ad23465
003cb2bc 00000000 00000000 00000000 00000006
Jan 27 11:55:44 ECDCCAM1 kernel:        e1a04000 6ad26593 003cb2bc
0000312e 00000001 e1a0410c cb6194c4 d5103900
Jan 27 11:55:44 ECDCCAM1 kernel:        00000000 00000000 00000286
c042c2e0 f7e3c000 eea55e9c 00000286 ffffffff
Jan 27 11:55:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:44 ECDCCAM1 kernel:  =======================
Jan 27 11:55:44 ECDCCAM1 kernel: java          S 003CB2BC  3396 12941
    1         12947 12939 (NOTLB)
Jan 27 11:55:44 ECDCCAM1 kernel:        e9a95e94 00000086 a317a57a
003cb2bc e3c4df38 e3c4df10 00000000 00000008
Jan 27 11:55:44 ECDCCAM1 kernel:        f7103000 a3180362 003cb2bc
00005de8 00000001 f710310c cb6194c4 d5103900
Jan 27 11:55:44 ECDCCAM1 kernel:        e9a95e84 c041dc38 00000000
c042c2e0 f7e3c000 e9a95e9c 00000286 c042c3f1
Jan 27 11:55:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:44 ECDCCAM1 kernel:  =======================
Jan 27 11:55:44 ECDCCAM1 kernel: java          S 003CB2C6  3004 13032
    1         13034 12947 (NOTLB)
Jan 27 11:55:44 ECDCCAM1 kernel:        eeacfd0c 00000086 00a265ac
003cb2c6 00000000 00000000 00000000 00000008
Jan 27 11:55:44 ECDCCAM1 kernel:        d555eaa0 00a2f181 003cb2c6
00008bd5 00000003 d555ebac cb62708c d5103900
Jan 27 11:55:44 ECDCCAM1 kernel:        00000000 00000000 00000000
00000000 00000000 00000000 00000000 ffffffff
Jan 27 11:55:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:44 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0462d04>] __vma_link+0x5b/0x68
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0463166>] split_vma+0xda/0xeb
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:45 ECDCCAM1 kernel:  =======================
Jan 27 11:55:45 ECDCCAM1 kernel: java          S 003CB2C6  3072 13034
    1         13102 13032 (NOTLB)
Jan 27 11:55:45 ECDCCAM1 kernel:        d8738d0c 00000086 0cdd8aaf
003cb2c6 00000006 94a85ff9 00000000 0000000a
Jan 27 11:55:45 ECDCCAM1 kernel:        d555e550 0cdda961 003cb2c6
00001eb2 00000000 d555e65c cb6126e0 d5103900
Jan 27 11:55:45 ECDCCAM1 kernel:        00000102 00000286 00000000
cfcaadc0 ee19b180 00000000 cb612724 00000000
Jan 27 11:55:45 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:45 ECDCCAM1 kernel:  =======================
Jan 27 11:55:45 ECDCCAM1 kernel: java          S 003CB2C6  2904 13102
    1               13034 (NOTLB)
Jan 27 11:55:45 ECDCCAM1 kernel:        f4550d0c 00000086 11fd4fa7
003cb2c6 00000006 94e26e14 00000000 0000000a
Jan 27 11:55:45 ECDCCAM1 kernel:        eeb16aa0 11fd96f4 003cb2c6
0000474d 00000000 eeb16bac cb6126e0 d5103900
Jan 27 11:55:46 ECDCCAM1 kernel:        00000002 00000286 00000000
d93e36c0 e5131c00 00000000 c05decfa 00000000
Jan 27 11:55:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c041ce0d>] __wake_up_common+0x2f/0x53
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c043794f>] wake_futex+0x3a/0x44
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c04388e5>] do_futex+0x239/0xb5e
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c0463010>] vma_adjust+0x2ff/0x37b
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05acc46>] lock_sock+0x8e/0x96
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c048115d>] sys_ioctl+0x58/0x5f
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:46 ECDCCAM1 kernel:  =======================
Jan 27 11:55:46 ECDCCAM1 kernel: httpd.worker  S 003CB2C5  1752  2567
    1 25167    2653  2566 (NOTLB)
Jan 27 11:55:46 ECDCCAM1 kernel:        d39e1b68 00200086 efbfa5fb
003cb2c5 c04074d6 d39e1b20 d39e1b70 00000007
Jan 27 11:55:46 ECDCCAM1 kernel:        cfe05aa0 efc015ab 003cb2c5
00006fb0 00000001 cfe05bac cb6194c4 f7df8200
Jan 27 11:55:46 ECDCCAM1 kernel:        000003e8 00000000 00200286
c042c2e0 f7e3c000 d39e1b70 00200286 ffffffff
Jan 27 11:55:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:55:46 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:55:46 ECDCCAM1 kernel:  [<f8885778>]
ext3_mark_inode_dirty+0x29/0x30 [ext3]
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c0472d7d>] __find_get_block_slow+0xfb/0x105
Jan 27 11:55:46 ECDCCAM1 kernel:  [<c04730c1>] __find_get_block+0x15c/0x166
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04730fb>] __getblk+0x30/0x27a
Jan 27 11:55:47 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:55:47 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:55:47 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:47 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:55:47 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:55:47 ECDCCAM1 kernel:  [<f88875a3>]
ext3_ordered_commit_write+0xae/0xcc [ext3]
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c041e807>] try_to_wake_up+0x3e6/0x3f0
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0405946>] common_interrupt+0x1a/0x20
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0434c0b>] remove_wait_queue+0x16/0x23
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:47 ECDCCAM1 kernel:  =======================
Jan 27 11:55:47 ECDCCAM1 kernel: perl          R running  2508  2570
   1 12985    2571  3467 (NOTLB)
Jan 27 11:55:47 ECDCCAM1 kernel: tee           S 0000001A  2640  2571
    1          3566  2570 (NOTLB)
Jan 27 11:55:47 ECDCCAM1 kernel:        d3174f00 00000082 0a308454
0000001a f7f4517c f7f98648 f7f450d4 00000007
Jan 27 11:55:47 ECDCCAM1 kernel:        d2161000 0a36a414 0000001a
00061fc0 00000000 d216110c cb6126e0 f7f48580
Jan 27 11:55:47 ECDCCAM1 kernel:        d2173698 00000000 d11c4b74
f7f48580 00000000 fffac000 d3174f08 ffffffff
Jan 27 11:55:47 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04628b9>] unmap_region+0xb8/0xf0
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:55:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:48 ECDCCAM1 kernel:  =======================
Jan 27 11:55:48 ECDCCAM1 kernel: diskwatchmana S 003CB25A  2668  2653
    1 12685    2722  2567 (NOTLB)
Jan 27 11:55:48 ECDCCAM1 kernel:        d0a13f00 00000082 35e50527
003cb25a f7f48e88 f7f48e78 00000001 00000007
Jan 27 11:55:48 ECDCCAM1 kernel:        d19e6000 35e5bd43 003cb25a
0000b81c 00000000 d19e610c cb6126e0 f7f48e40
Jan 27 11:55:48 ECDCCAM1 kernel:        f7f48e40 082dd100 d41efb74
f7f48e40 00000000 00000000 cb612b9c ef0f6200
Jan 27 11:55:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:48 ECDCCAM1 kernel:  =======================
Jan 27 11:55:48 ECDCCAM1 kernel: heartbeat     S 003CB2C6  2476  2722
    1  2725    2732  2653 (NOTLB)
Jan 27 11:55:48 ECDCCAM1 kernel:        d195fc08 00000082 189e3698
003cb2c6 00000000 f79d0400 f768e4c0 00000001
Jan 27 11:55:48 ECDCCAM1 kernel:        f75bb550 18a68557 003cb2c6
00084ebf 00000001 f75bb65c cb6194c4 f72bde40
Jan 27 11:55:48 ECDCCAM1 kernel:        f8885396 00000000 00000286
c042c2e0 f7e3c000 d195fc10 00000286 ffffffff
Jan 27 11:55:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:48 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:48 ECDCCAM1 last message repeated 7 times
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:55:48 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04563d3>]
__generic_file_aio_write_nolock+0x4a6/0x52a
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0466295>] anon_vma_prepare+0x76/0xa5
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c042d117>] check_kill_permission+0xf2/0xfc
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c042dc3d>] group_send_sig_info+0x12/0x56
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c042dcbd>] kill_proc_info+0x3c/0x4c
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c042e9d3>] sys_kill+0xdc/0xe8
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04307fd>] sys_times+0x182/0x1c8
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:49 ECDCCAM1 kernel:  =======================
Jan 27 11:55:49 ECDCCAM1 kernel: heartbeat     S 003CB2C6  3044  2725
 2722          2726       (NOTLB)
Jan 27 11:55:49 ECDCCAM1 kernel:        cffa5f00 00000082 01cd7dd4
003cb2c6 00000001 0000000f 00000000 00000007
Jan 27 11:55:49 ECDCCAM1 kernel:        d294d000 01ce2ec3 003cb2c6
0000b0ef 00000003 d294d10c cb62708c f72bdc80
Jan 27 11:55:49 ECDCCAM1 kernel:        00000246 00000000 f77399c0
f79d0400 f884e67c 00000000 cffa5f08 ffffffff
Jan 27 11:55:49 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:49 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:49 ECDCCAM1 kernel:  =======================
Jan 27 11:55:49 ECDCCAM1 kernel: heartbeat     S 003CB2C6  2164  2726
 2722          2727  2725 (NOTLB)
Jan 27 11:55:49 ECDCCAM1 kernel:        d4b30c08 00000082 0c34f25a
003cb2c6 cc4d6f14 00000000 a0020000 00000001
Jan 27 11:55:49 ECDCCAM1 kernel:        d4b2faa0 0c361221 003cb2c6
00011fc7 00000003 d4b2fbac cb62708c d06c9740
Jan 27 11:55:49 ECDCCAM1 kernel:        d4b30c18 f8cf2dea 0000000c
0000000c f8cf2eeb 0000000c d4b30c18 cc4d6f14
Jan 27 11:55:49 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:49 ECDCCAM1 kernel:  [<f8cf2dea>]
nscatterwalk_map+0x32/0x40 [crypto_algapi]
Jan 27 11:55:49 ECDCCAM1 kernel:  [<f8cf2eeb>]
nscatterwalk_copychunks+0x9f/0xd1 [crypto_algapi]
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c0605a47>] unix_poll+0x17/0x8f
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c05c1a68>] __qdisc_run+0x66/0x1d3
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c05fcda1>] xfrm4_output_finish2+0xaa/0x281
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c05d064c>]
ip_push_pending_frames+0x33d/0x396
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c05e8f6c>]
udp_push_pending_frames+0x1ce/0x1ef
Jan 27 11:55:49 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05e9b15>] udp_sendmsg+0x44e/0x514
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c04059d7>] apic_timer_interrupt+0x1f/0x24
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05aa412>] sock_recvmsg+0xfc/0x100
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:50 ECDCCAM1 kernel:  =======================
Jan 27 11:55:50 ECDCCAM1 kernel: heartbeat     R running  2740  2727
2722          2728  2726 (NOTLB)
Jan 27 11:55:50 ECDCCAM1 kernel: heartbeat     S 003CB2C6  2192  2728
 2722          2729  2727 (NOTLB)
Jan 27 11:55:50 ECDCCAM1 kernel:        d4b2dc08 00000086 0c361221
003cb2c6 00000002 00000003 2dfb8a40 00000001
Jan 27 11:55:50 ECDCCAM1 kernel:        d41f1000 0c375244 003cb2c6
00014023 00000003 d41f110c cb62708c d06c9900
Jan 27 11:55:50 ECDCCAM1 kernel:        d4b2dc00 00000000 00000000
d4b2dc00 00000000 d4b2dca0 cb6270d0 ffffffff
Jan 27 11:55:50 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0605a47>] unix_poll+0x17/0x8f
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05b3e14>] dev_hard_start_xmit+0x198/0x1ee
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05c1a68>] __qdisc_run+0x66/0x1d3
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05b56ff>] dev_queue_xmit+0x22e/0x24b
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05d064c>]
ip_push_pending_frames+0x33d/0x396
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0607fc8>] unix_write_space+0xf/0x69
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0606eb8>] unix_stream_recvmsg+0x3b3/0x4c5
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:50 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:51 ECDCCAM1 kernel:  =======================
Jan 27 11:55:51 ECDCCAM1 kernel: heartbeat     S 003CB2C6  2744  2729
 2722          3190  2728 (NOTLB)
Jan 27 11:55:51 ECDCCAM1 kernel:        d5872d34 00000082 0282339f
003cb2c6 00000000 0aefceac 00000000 00000001
Jan 27 11:55:51 ECDCCAM1 kernel:        f76c0aa0 0283126a 003cb2c6
0000decb 00000003 f76c0bac cb62708c d5103580
Jan 27 11:55:51 ECDCCAM1 kernel:        0aeef2e4 0282f118 00000000
cb619f44 d5872d68 00000082 d195fcf8 d39c951c
Jan 27 11:55:51 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05e83d7>] raw_recvmsg+0x6e/0x176
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c05abfeb>] sys_socketcall+0x135/0x19e
Jan 27 11:55:51 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:51 ECDCCAM1 kernel:  =======================
Jan 27 11:55:51 ECDCCAM1 kernel: ipfail        S 003CB2C6  2360  3190
 2722                2729 (NOTLB)
Jan 27 11:55:51 ECDCCAM1 kernel:        cfc76d34 00000086 0f5ab609
003cb2c6 0032bdad 2269eeaa 00000000 0000000a
Jan 27 11:55:51 ECDCCAM1 kernel:        f7645aa0 0f5b536b 003cb2c6
00009d62 00000003 f7645bac cb62708c cfd8c3c0
Jan 27 11:55:52 ECDCCAM1 kernel:        d5852398 00000000 00000000
cfc76d30 c041dc38 00000082 d195fc88 ffffffff
Jan 27 11:55:52 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0428929>] current_fs_time+0x4a/0x55
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c06061eb>] unix_find_other+0xc7/0x162
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0607afe>] unix_dgram_connect+0x6a/0x137
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0607b42>] unix_dgram_connect+0xae/0x137
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05ab760>] sys_connect+0x7d/0xa9
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:52 ECDCCAM1 kernel:  =======================
Jan 27 11:55:52 ECDCCAM1 kernel: postmaster    S 003CACEC  1572  3447
 2304          3450  2313 (NOTLB)
Jan 27 11:55:52 ECDCCAM1 kernel:        cfc9bd0c 00200086 42ba2286
003cacec 00000002 cb620e08 00000001 00000007
Jan 27 11:55:52 ECDCCAM1 kernel:        cfc7a550 42ba2b81 003cacec
000008fb 00000001 cfc7a65c cb6194c4 f74a8ac0
Jan 27 11:55:52 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b136c0 f70615c0 00000001 c05decfa ffffffff
Jan 27 11:55:52 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:52 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:53 ECDCCAM1 kernel:  =======================
Jan 27 11:55:53 ECDCCAM1 kernel: postmaster    S 003CB2C6  1548  3450
 2304          3451  3447 (NOTLB)
Jan 27 11:55:53 ECDCCAM1 kernel:        e21a0d0c 00200082 02fdc5ef
003cb2c6 00000006 2528bab8 00000001 0000000a
Jan 27 11:55:53 ECDCCAM1 kernel:        d294d550 02fdda81 003cb2c6
00001492 00000003 d294d65c cb62708c d5103c80
Jan 27 11:55:53 ECDCCAM1 kernel:        00000002 00200286 00000000
d0b12dc0 e9c95ec0 00000001 cb627548 00000001
Jan 27 11:55:53 ECDCCAM1 ipfail[13198]: ERROR: Cannot chdir to
[/var/lib/heartbeat/cores/hacluster]: Permission denied
Jan 27 11:55:53 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:53 ECDCCAM1 kernel:  =======================
Jan 27 11:55:53 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3451
 2304          3452  3450 (NOTLB)
Jan 27 11:55:53 ECDCCAM1 kernel:        d0b15d0c 00200086 87981f32
003cadc1 00000003 cb627bec 00000001 00000007
Jan 27 11:55:53 ECDCCAM1 kernel:        f770b000 879828ab 003cadc1
00000979 00000001 f770b10c cb6194c4 f7df8ac0
Jan 27 11:55:53 ECDCCAM1 kernel:        00000000 00000000 00000001
cfcabb40 e37c0480 00000001 c05decfa ffffffff
Jan 27 11:55:53 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:53 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:54 ECDCCAM1 kernel:  =======================
Jan 27 11:55:54 ECDCCAM1 kernel: postmaster    S 003CAD5D  1548  3452
 2304          3453  3451 (NOTLB)
Jan 27 11:55:54 ECDCCAM1 kernel:        d0b1ad0c 00200082 43a700db
003cad5d 00000006 c81d1a1a 00000001 00000007
Jan 27 11:55:54 ECDCCAM1 kernel:        d51c7000 43a70b44 003cad5d
00000a69 00000001 d51c710c cb6194c4 f7df8c80
Jan 27 11:55:54 ECDCCAM1 kernel:        00000000 00000000 00000001
cfca9b40 d62d49c0 00000001 c05decfa ffffffff
Jan 27 11:55:54 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:55:54 ECDCCAM1 ipfail[13198]: info: Ping node count is balanced.
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:54 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:55 ECDCCAM1 kernel:  =======================
Jan 27 11:55:55 ECDCCAM1 kernel: postmaster    S 003CAD4E  1548  3453
 2304          3454  3452 (NOTLB)
Jan 27 11:55:55 ECDCCAM1 kernel:        d0b38d0c 00200082 b363f426
003cad4e 00000006 17960523 00000001 0000000a
Jan 27 11:55:55 ECDCCAM1 kernel:        f7140550 b363fe5e 003cad4e
00000a38 00000000 f714065c cb6126e0 f72bd040
Jan 27 11:55:55 ECDCCAM1 kernel:        00000000 00000000 00000001
cfcab6c0 dffe7600 00000001 c05decfa ffffffff
Jan 27 11:55:55 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:55 ECDCCAM1 kernel:  =======================
Jan 27 11:55:55 ECDCCAM1 kernel: postmaster    S 003CAD3D  1572  3454
 2304          3455  3453 (NOTLB)
Jan 27 11:55:55 ECDCCAM1 kernel:        d0b40d0c 00200086 33513659
003cad3d 00000006 652bbf06 00000001 00000008
Jan 27 11:55:55 ECDCCAM1 kernel:        f75fbaa0 33514de7 003cad3d
0000178e 00000001 f75fbbac cb6194c4 f72bd200
Jan 27 11:55:55 ECDCCAM1 kernel:        00000002 00000000 00000001
d0b124c0 e8c628c0 00000001 c05decfa ffffffff
Jan 27 11:55:55 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:55 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:56 ECDCCAM1 kernel:  =======================
Jan 27 11:55:56 ECDCCAM1 kernel: postmaster    S 003CAE22  1572  3455
 2304          3456  3454 (NOTLB)
Jan 27 11:55:56 ECDCCAM1 kernel:        d0b29d0c 00200082 3f525fdb
003cae22 00000006 c6c46a92 00000001 00000007
Jan 27 11:55:56 ECDCCAM1 kernel:        f7619550 3f52799d 003cae22
000019c2 00000003 f761965c cb62708c f711cc80
Jan 27 11:55:56 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b53b40 d831c800 00000001 c05decfa ffffffff
Jan 27 11:55:56 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:56 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:57 ECDCCAM1 kernel:  =======================
Jan 27 11:55:57 ECDCCAM1 kernel: postmaster    S 003CAD56  1548  3456
 2304          3457  3455 (NOTLB)
Jan 27 11:55:57 ECDCCAM1 kernel:        d0b57d0c 00200082 c9e7f1cd
003cad56 00000003 cb627bec 00000001 00000007
Jan 27 11:55:57 ECDCCAM1 kernel:        cfdc6550 c9e7fa44 003cad56
00000877 00000001 cfdc665c cb6194c4 cfd8c040
Jan 27 11:55:57 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b53240 d39afc80 00000001 c05decfa ffffffff
Jan 27 11:55:57 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:57 ECDCCAM1 kernel:  =======================
Jan 27 11:55:57 ECDCCAM1 kernel: postmaster    S 003CAE22  1572  3457
 2304          3458  3456 (NOTLB)
Jan 27 11:55:57 ECDCCAM1 kernel:        d0b60d0c 00200082 3f52604d
003cae22 00000006 af747b08 00000001 00000007
Jan 27 11:55:57 ECDCCAM1 kernel:        d51fdaa0 3f526b72 003cae22
00000b25 00000001 d51fdbac cb6194c4 f72bd580
Jan 27 11:55:57 ECDCCAM1 kernel:        00000000 00000000 00000001
cf91e4c0 cfdcf680 00000001 c05decfa ffffffff
Jan 27 11:55:57 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:57 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:58 ECDCCAM1 kernel:  =======================
Jan 27 11:55:58 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3458
 2304          3459  3457 (NOTLB)
Jan 27 11:55:58 ECDCCAM1 kernel:        d0b50d0c 00200082 8788e6e0
003cadc1 00000100 0038a24d 00000001 00000007
Jan 27 11:55:58 ECDCCAM1 kernel:        f7469aa0 8788ee7f 003cadc1
0000079f 00000000 f7469bac cb6126e0 f74a8580
Jan 27 11:55:58 ECDCCAM1 kernel:        00000000 00000000 00000001
cfccb6c0 cfdcf380 00000001 c05decfa ffffffff
Jan 27 11:55:58 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:55:58 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:59 ECDCCAM1 kernel:  =======================
Jan 27 11:55:59 ECDCCAM1 kernel: postmaster    S 003CB2C6  1548  3459
 2304          3460  3458 (NOTLB)
Jan 27 11:55:59 ECDCCAM1 kernel:        d0b79d0c 00200082 03687f22
003cb2c6 00000006 bd743867 00000001 0000000a
Jan 27 11:55:59 ECDCCAM1 kernel:        cfe05000 03689824 003cb2c6
00001902 00000002 cfe0510c cb6202a8 cfc67580
Jan 27 11:55:59 ECDCCAM1 kernel:        00000002 00200286 00000000
d0b52940 ef3ff480 00000001 c05decfa 00000001
Jan 27 11:55:59 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c041d39b>] find_busiest_group+0x177/0x464
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:55:59 ECDCCAM1 kernel:  =======================
Jan 27 11:55:59 ECDCCAM1 kernel: postmaster    S 003CB094  1572  3460
 2304          3461  3459 (NOTLB)
Jan 27 11:55:59 ECDCCAM1 kernel:        d0b70d0c 00200082 28da522f
003cb094 00000003 cb627bec 00000001 00000007
Jan 27 11:55:59 ECDCCAM1 kernel:        f774caa0 28da683a 003cb094
0000160b 00000001 f774cbac cb6194c4 f711c580
Jan 27 11:55:59 ECDCCAM1 kernel:        00000000 00000000 00000001
d0b52040 e0e85080 00000001 c05decfa ffffffff
Jan 27 11:55:59 ECDCCAM1 kernel: Call Trace:
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:55:59 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:00 ECDCCAM1 kernel:  =======================
Jan 27 11:56:00 ECDCCAM1 kernel: postmaster    S 003CB00A  1548  3461
 2304          3462  3460 (NOTLB)
Jan 27 11:56:00 ECDCCAM1 kernel:        d0b97d0c 00200082 74347c0f
003cb00a 00000006 488ecf9e 00000001 00000007
Jan 27 11:56:00 ECDCCAM1 kernel:        cfdcc550 743493c1 003cb00a
000017b2 00000003 cfdcc65c cb62708c f74a8040
Jan 27 11:56:00 ECDCCAM1 kernel:        00000000 00000000 00000001
d0bb16c0 f7061080 00000001 c05decfa ffffffff
Jan 27 11:56:00 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:56:00 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:01 ECDCCAM1 kernel:  =======================
Jan 27 11:56:01 ECDCCAM1 kernel: postmaster    R running  1572  3462
2304          3463  3461 (NOTLB)
Jan 27 11:56:01 ECDCCAM1 kernel: postmaster    S 003CB2C6  1548  3463
 2304          3464  3462 (NOTLB)
Jan 27 11:56:01 ECDCCAM1 kernel:        d0bacd0c 00200086 1d2a0242
003cb2c6 00000006 98e356f7 00000001 0000000a
Jan 27 11:56:01 ECDCCAM1 kernel:        f774c550 1d2a0e39 003cb2c6
00000bf7 00000003 f774c65c cb62708c f7f24900
Jan 27 11:56:01 ECDCCAM1 kernel:        00000002 00000000 00000001
d0bb2dc0 eea31240 00000001 c05decfa ffffffff
Jan 27 11:56:01 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c043710c>] ktime_get_ts+0x16/0x44
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c044d7d2>] delayacct_end+0x58/0x7a
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c045465a>] find_get_pages_tag+0x30/0x75
Jan 27 11:56:01 ECDCCAM1 kernel:  [<c045a72f>] pagevec_lookup_tag+0x1b/0x22
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:02 ECDCCAM1 kernel:  =======================
Jan 27 11:56:02 ECDCCAM1 kernel: postmaster    S 003CADC1  1572  3464
 2304         13412  3463 (NOTLB)
Jan 27 11:56:02 ECDCCAM1 kernel:        d0bbbd0c 00200086 8788e58a
003cadc1 00000003 cb627bec 00000001 00000007
Jan 27 11:56:02 ECDCCAM1 kernel:        d2914550 8788fcc8 003cadc1
0000173e 00000003 d291465c cb62708c f7771ac0
Jan 27 11:56:02 ECDCCAM1 kernel:        00000000 00000000 00000001
d0bb0dc0 dfd15780 00000001 c05decfa ffffffff
Jan 27 11:56:02 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:56:02 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:03 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:03 ECDCCAM1 kernel:  =======================
Jan 27 11:56:04 ECDCCAM1 kernel: mingetty      S 00000031  3020  3566
    1          3567  2571 (NOTLB)
Jan 27 11:56:04 ECDCCAM1 kernel:        d20a3ee4 00000086 e8c868e2
00000031 00000020 d2808600 d280c29e 00000007
Jan 27 11:56:04 ECDCCAM1 kernel:        cfc7a000 e8c92780 00000031
0000be9e 00000001 cfc7a10c cb6194c4 d4b63900
Jan 27 11:56:04 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:56:04 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:04 ECDCCAM1 kernel:  =======================
Jan 27 11:56:04 ECDCCAM1 kernel: mingetty      S 00000031  3072  3567
    1          3568  3566 (NOTLB)
Jan 27 11:56:04 ECDCCAM1 kernel:        cfda7ee4 00000082 e8c7d541
00000031 00000020 d2814600 d280e29e 00000007
Jan 27 11:56:04 ECDCCAM1 kernel:        d41f1aa0 e8c868e2 00000031
000093a1 00000001 d41f1bac cb6194c4 f7f62e40
Jan 27 11:56:04 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:56:04 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:04 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:04 ECDCCAM1 kernel:  =======================
Jan 27 11:56:04 ECDCCAM1 kernel: mingetty      S 00000031  2660  3568
    1          3569  3567 (NOTLB)
Jan 27 11:56:05 ECDCCAM1 kernel:        d2028ee4 00000082 e8ca15cb
00000031 00000020 d2826a00 d282b29e 00000006
Jan 27 11:56:05 ECDCCAM1 kernel:        d41d0550 e8cab32c 00000031
00009d61 00000001 d41d065c cb6194c4 f7ba9e40
Jan 27 11:56:05 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:56:05 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:05 ECDCCAM1 kernel:  =======================
Jan 27 11:56:05 ECDCCAM1 kernel: mingetty      S 00000031  3072  3569
    1          3570  3568 (NOTLB)
Jan 27 11:56:05 ECDCCAM1 kernel:        d0be8ee4 00000086 e8c92780
00000031 00000020 d2826c00 d611629e 00000007
Jan 27 11:56:05 ECDCCAM1 kernel:        f7d22550 e8c9e75c 00000031
0000bfdc 00000001 f7d2265c cb6194c4 f77713c0
Jan 27 11:56:05 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:56:05 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:05 ECDCCAM1 kernel:  =======================
Jan 27 11:56:05 ECDCCAM1 kernel: mingetty      S 00000031  3016  3570
    1          3571  3569 (NOTLB)
Jan 27 11:56:05 ECDCCAM1 kernel:        cfdcaee4 00000086 e8cab32c
00000031 00000020 d2031e00 d282c29e 00000004
Jan 27 11:56:05 ECDCCAM1 kernel:        d41d0000 e8cb65fd 00000031
0000b2d1 00000001 d41d010c cb6194c4 cfc673c0
Jan 27 11:56:05 ECDCCAM1 kernel:        cb5f00ff cb5f1a20 00000000
00000000 c0460e6e 00000000 00000282 c0683780
Jan 27 11:56:05 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:05 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:06 ECDCCAM1 kernel:  =======================
Jan 27 11:56:06 ECDCCAM1 kernel: agetty        S 00000032  2412  3571
    1          3646  3570 (NOTLB)
Jan 27 11:56:06 ECDCCAM1 kernel:        d51b7ee4 00000082 290b7071
00000032 000000ca c04546b7 00000000 00000008
Jan 27 11:56:06 ECDCCAM1 kernel:        d51c7550 290c069f 00000032
0000962e 00000002 d51c765c cb6202a8 cfd84580
Jan 27 11:56:06 ECDCCAM1 kernel:        cb5f8e20 00000000 00000000
00000000 c07ce7e0 c07ce7e0 c07ce7e0 ffffffff
Jan 27 11:56:06 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:06 ECDCCAM1 kernel:  =======================
Jan 27 11:56:06 ECDCCAM1 kernel: snmpd         S 003CB2C5  1604  3646
    1          3651  3571 (NOTLB)
Jan 27 11:56:06 ECDCCAM1 kernel:        d283db68 00200086 fcb9796a
003cb2c5 c052d9b6 d283dcb0 d283db70 00000009
Jan 27 11:56:06 ECDCCAM1 kernel:        cfdccaa0 fcbd1108 003cb2c5
0003979e 00000003 cfdccbac cb62708c f7771200
Jan 27 11:56:06 ECDCCAM1 kernel:        feb08d8d 00000050 00000000
c042c2e0 cb740000 d283db70 00200286 ffffffff
Jan 27 11:56:06 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c052d9b6>] __add_entropy_words+0x56/0x18b
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:56:06 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:07 ECDCCAM1 last message repeated 4 times
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c04e4f74>] __next_cpu+0x12/0x21
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c041d39b>] find_busiest_group+0x177/0x464
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c041edaf>] move_tasks+0xfd/0x30f
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c041f14d>] rebalance_tick+0x18c/0x2e4
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c049eb49>] proc_alloc_inode+0x3e/0x63
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0486e24>] alloc_inode+0xde/0x166
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0494581>] inotify_d_instantiate+0x3c/0x5f
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0484f20>] d_rehash+0x1c/0x2b
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c04a1ebe>] proc_lookup+0x72/0xa4
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c049ee1f>] proc_root_lookup+0xe/0x26
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c047cce4>] do_lookup+0x53/0x174
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0485a36>] dput+0x22/0xed
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c047ee89>] __link_path_walk+0xbfa/0xd33
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c04a3f19>] show_stat+0x89d/0x8aa
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c047f3d8>] do_path_lookup+0x20e/0x25e
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c04e87b3>] vsnprintf+0x41f/0x45d
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c048c691>] seq_printf+0x2b/0x48
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c060f372>] lock_kernel+0x16/0x25
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0482606>] sys_select+0x9a/0x180
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:07 ECDCCAM1 kernel:  =======================
Jan 27 11:56:07 ECDCCAM1 kernel: snmpd         S 00000031  2868  3651
    1          4053  3646 (NOTLB)
Jan 27 11:56:07 ECDCCAM1 kernel:        d2863d18 00200086 f944dcf2
00000031 c05ba88b 00000e3e 00000000 00000001
Jan 27 11:56:07 ECDCCAM1 kernel:        cfdc6000 f946068e 00000031
0001299c 00000001 cfdc610c cb6194c4 f7771200
Jan 27 11:56:07 ECDCCAM1 kernel:        c06100a9 00000000 c0405a89
d2863f4c 0000010f d587a000 d587a0a0 ffffffff
Jan 27 11:56:07 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c05ba88b>] rtnetlink_dump_ifinfo+0x4a/0x6c
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c06100a9>] do_page_fault+0x0/0x600
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0405a89>] error_code+0x39/0x40
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c05b17a2>] skb_recv_datagram+0x130/0x1a9
Jan 27 11:56:07 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05c73d6>] netlink_recvmsg+0x46/0x281
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05c7223>] netlink_sendmsg+0x277/0x284
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c04546b7>] find_get_page+0x18/0x3f
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c048595f>] d_alloc+0x14f/0x17d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0484f20>] d_rehash+0x1c/0x2b
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:08 ECDCCAM1 kernel:  =======================
Jan 27 11:56:08 ECDCCAM1 kernel: postmaster    S 003CADC1  1572 13412
 2304         12049  3464 (NOTLB)
Jan 27 11:56:08 ECDCCAM1 kernel:        f3bf3d0c 00200086 8779a572
003cadc1 00000000 cb613240 00000001 00000007
Jan 27 11:56:08 ECDCCAM1 kernel:        f59b5aa0 8779b14e 003cadc1
00000bdc 00000000 f59b5bac cb6126e0 f7f623c0
Jan 27 11:56:08 ECDCCAM1 kernel:        00000000 00000000 00000001
d105d240 dfd15780 00000001 c05decfa ffffffff
Jan 27 11:56:08 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c04b79a8>] update_queue+0x1e/0x73
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:56:08 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:09 ECDCCAM1 kernel:  =======================
Jan 27 11:56:09 ECDCCAM1 kernel: postmaster    S 003CADC1  1572 12049
 2304         12943 13412 (NOTLB)
Jan 27 11:56:09 ECDCCAM1 kernel:        e4e88d0c 00200086 8772ad4a
003cadc1 cb6202ec cfdc6550 00000001 00000007
Jan 27 11:56:09 ECDCCAM1 kernel:        dbe24000 8772b8d5 003cadc1
00000b8b 00000002 dbe2410c cb6202a8 f7f48ac0
Jan 27 11:56:09 ECDCCAM1 kernel:        00000000 00000000 00000001
cfca96c0 d667dd80 00000001 c05decfa ffffffff
Jan 27 11:56:09 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05decfa>] tcp_rcv_established+0xf8/0x7c6
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c060f25f>] _spin_lock_bh+0x8/0x18
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05acb33>] release_sock+0xc/0x91
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05ad2e2>] sk_wait_data+0x67/0x98
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05d8a58>] tcp_recvmsg+0x3b6/0x9f7
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05ac642>] sock_common_recvmsg+0x2f/0x45
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c040a088>] save_i387+0x23f/0x273
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05abb28>] sys_recvfrom+0xcf/0x130
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c042cc8a>] recalc_sigpending+0xe/0x20
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c0404a47>] do_notify_resume+0x53b/0x67d
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c04721ee>] file_move+0x27/0x32
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c046fc7a>] __dentry_open+0xea/0x1ab
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05abba2>] sys_recv+0x19/0x1d
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c05abfcd>] sys_socketcall+0x117/0x19e
Jan 27 11:56:09 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:09 ECDCCAM1 kernel:  =======================
Jan 27 11:56:09 ECDCCAM1 kernel: sshd          S 003CB1B8  2552 30911
    1         27915 12110 (NOTLB)
Jan 27 11:56:09 ECDCCAM1 kernel:        e1537b68 00000082 1331412b
003cb1b8 00000000 00000003 28c23661 00000007
Jan 27 11:56:09 ECDCCAM1 kernel:        cfd9b550 13319fe7 003cb1b8
00005ebc 00000000 cfd9b65c cb6126e0 d0fb2580
Jan 27 11:56:09 ECDCCAM1 kernel:        e1537c10 00000000 00000000
e1537c0c 00000203 00000200 cb612724 ffffffff
Jan 27 11:56:09 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c04815fa>] free_poll_entry+0xe/0x16
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0481d3c>] do_select+0x371/0x3cb
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:10 ECDCCAM1 last message repeated 8 times
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0458aa7>] get_page_from_freelist+0x96/0x333
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0458d9b>] __alloc_pages+0x57/0x297
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c046d8c7>] cache_alloc_refill+0x60/0x450
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c05aff95>] __alloc_skb+0x49/0xf4
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0458aa7>] get_page_from_freelist+0x96/0x333
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c05ae0a5>] sock_def_readable+0xf/0x5b
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c048203f>] core_sys_select+0x2a9/0x2ca
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c04041e5>] setup_sigcontext+0x10d/0x190
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c045b849>] truncate_inode_pages+0x9/0xc
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0485a36>] dput+0x22/0xed
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c04a0be3>] proc_flush_task+0x97/0x1b0
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c040a143>] restore_i387+0x87/0x1a1
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c048263b>] sys_select+0xcf/0x180
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:10 ECDCCAM1 kernel:  =======================
Jan 27 11:56:10 ECDCCAM1 kernel: httpd.worker  S 003C61D5  3088 25167
 2567         25180       (NOTLB)
Jan 27 11:56:10 ECDCCAM1 kernel:        cd08cf00 00200082 4a4c1b2d
003c61d5 f76f3554 f7b2b788 f76f34ac 00000007
Jan 27 11:56:10 ECDCCAM1 kernel:        da792aa0 4a4c2191 003c61d5
00000664 00000002 da792bac cb6202a8 e5a50740
Jan 27 11:56:10 ECDCCAM1 kernel:        f7970564 00000000 00000000
e5a50740 00000000 00000000 cd08cf08 dc293000
Jan 27 11:56:10 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:10 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c041df46>] __activate_task+0x4a/0x59
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:11 ECDCCAM1 kernel:  =======================
Jan 27 11:56:11 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2588 25180
 2567         25181 25167 (NOTLB)
Jan 27 11:56:11 ECDCCAM1 kernel:        d7815e94 00200082 24a6831a
003cb13f 00000040 c06a7400 d7815eb4 0000000a
Jan 27 11:56:11 ECDCCAM1 kernel:        d61ba000 24a6a547 003cb13f
0000222d 00000000 d61ba10c cb6126e0 e5a50740
Jan 27 11:56:11 ECDCCAM1 kernel:        d7815eb4 00000000 00000200
00000040 d7815efc 00000200 d7815efc ffffffff
Jan 27 11:56:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:11 ECDCCAM1 kernel:  =======================
Jan 27 11:56:11 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25181
 2567         25182 25180 (NOTLB)
Jan 27 11:56:11 ECDCCAM1 kernel:        e1c80e94 00200082 257f9fd2
003cb13f 00000040 c06a7400 e1c80eb4 00000008
Jan 27 11:56:11 ECDCCAM1 kernel:        d4d4d000 257fbf68 003cb13f
00001f96 00000000 d4d4d10c cb6126e0 e5a50740
Jan 27 11:56:11 ECDCCAM1 kernel:        e1c80eb4 00000000 00000200
00000040 e1c80efc 00000200 e1c80efc ffffffff
Jan 27 11:56:11 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:11 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:11 ECDCCAM1 kernel:  =======================
Jan 27 11:56:11 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2468 25182
 2567         25185 25181 (NOTLB)
Jan 27 11:56:12 ECDCCAM1 kernel:        db0a6e94 00200082 ac819552
003cb13e 00000040 c06a7400 db0a6eb4 0000000a
Jan 27 11:56:12 ECDCCAM1 kernel:        e6b6e550 ac81d56e 003cb13e
0000401c 00000000 e6b6e65c cb6126e0 e5a50740
Jan 27 11:56:12 ECDCCAM1 kernel:        db0a6eb4 00000000 00000200
00000040 db0a6efc 00000200 db0a6efc ffffffff
Jan 27 11:56:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:12 ECDCCAM1 kernel:  =======================
Jan 27 11:56:12 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2504 25185
 2567         25187 25182 (NOTLB)
Jan 27 11:56:12 ECDCCAM1 kernel:        d441fe94 00200082 be3c308a
003cb13d 00000040 c06a7400 d441feb4 00000004
Jan 27 11:56:12 ECDCCAM1 kernel:        cfdcc000 be3c5541 003cb13d
000024b7 00000000 cfdcc10c cb6126e0 e5a50740
Jan 27 11:56:12 ECDCCAM1 kernel:        d441feb4 00000000 00000200
00000040 d441fefc 00000200 d441fefc ffffffff
Jan 27 11:56:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:12 ECDCCAM1 kernel:  =======================
Jan 27 11:56:12 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2660 25187
 2567         25189 25185 (NOTLB)
Jan 27 11:56:12 ECDCCAM1 kernel:        ea267e94 00200082 bdf13c7d
003cb13d 00000040 c06a7400 ea267eb4 00000008
Jan 27 11:56:12 ECDCCAM1 kernel:        d643f000 bdf15f5a 003cb13d
000022dd 00000000 d643f10c cb6126e0 e5a50740
Jan 27 11:56:12 ECDCCAM1 kernel:        ea267eb4 00000000 00000200
00000040 ea267efc 00000200 ea267efc ffffffff
Jan 27 11:56:12 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:12 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:13 ECDCCAM1 kernel:  =======================
Jan 27 11:56:13 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25189
 2567         25191 25187 (NOTLB)
Jan 27 11:56:13 ECDCCAM1 kernel:        e2996e94 00200082 25639220
003cb13f 00000040 c06a7400 e2996eb4 00000008
Jan 27 11:56:13 ECDCCAM1 kernel:        d428faa0 2563b6d1 003cb13f
000024b1 00000000 d428fbac cb6126e0 e5a50740
Jan 27 11:56:13 ECDCCAM1 kernel:        e2996eb4 00000000 00000200
00000040 e2996efc 00000200 e2996efc ffffffff
Jan 27 11:56:13 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:13 ECDCCAM1 kernel:  =======================
Jan 27 11:56:13 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2636 25191
 2567         25193 25189 (NOTLB)
Jan 27 11:56:13 ECDCCAM1 kernel:        f4733e94 00200082 2487e92c
003cb13f 00000040 c06a7400 f4733eb4 00000008
Jan 27 11:56:13 ECDCCAM1 kernel:        d428f550 248806e2 003cb13f
00001db6 00000000 d428f65c cb6126e0 e5a50740
Jan 27 11:56:13 ECDCCAM1 kernel:        f4733eb4 00000000 00000200
00000040 f4733efc 00000200 f4733efc ffffffff
Jan 27 11:56:13 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:13 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:13 ECDCCAM1 kernel:  =======================
Jan 27 11:56:13 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2636 25193
 2567         25195 25191 (NOTLB)
Jan 27 11:56:13 ECDCCAM1 kernel:        deff2e94 00200082 adb91100
003cb13e 00000040 c06a7400 deff2eb4 0000000a
Jan 27 11:56:14 ECDCCAM1 kernel:        d643faa0 adb93fb6 003cb13e
00002eb6 00000001 d643fbac cb6194c4 e5a50740
Jan 27 11:56:14 ECDCCAM1 kernel:        deff2eb4 00000000 00000200
00000040 deff2efc 00000200 deff2efc ffffffff
Jan 27 11:56:14 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:14 ECDCCAM1 kernel:  =======================
Jan 27 11:56:14 ECDCCAM1 kernel: httpd.worker  S 003CB2C6  2636 25195
 2567         25196 25193 (NOTLB)
Jan 27 11:56:14 ECDCCAM1 kernel:        e7cbac08 00200082 04d77022
003cb2c6 e7cbae5c e7cbae60 e7cbae64 0000000a
Jan 27 11:56:14 ECDCCAM1 kernel:        f59b5000 04da0bf1 003cb2c6
00029bcf 00000002 f59b510c cb6202a8 e5a50740
Jan 27 11:56:14 ECDCCAM1 kernel:        003cb2c6 0000000a 00200286
c042c2e0 f7e3e000 e7cbac10 00200286 c042c3f1
Jan 27 11:56:14 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c060e207>] schedule_timeout+0x71/0x8c
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c042b9ef>] process_timeout+0x0/0x5
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c04818af>] do_sys_poll+0x261/0x339
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c04822bf>] __pollwait+0x0/0xb2
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f884eac7>]
do_get_write_access+0x441/0x46e [jbd]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f88854fa>]
__ext3_get_inode_loc+0x109/0x2d5 [ext3]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f8885396>]
ext3_mark_iloc_dirty+0x2d8/0x333 [ext3]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c041dc38>] __wake_up+0x2a/0x3d
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f88875a3>]
ext3_ordered_commit_write+0xae/0xcc [ext3]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c0455e26>]
generic_file_buffered_write+0x4b0/0x5b7
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f884e67c>] journal_stop+0x1b0/0x1ba [jbd]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f888c750>]
__ext3_journal_stop+0x19/0x34 [ext3]
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c04563d3>]
__generic_file_aio_write_nolock+0x4a6/0x52a
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c0437bb6>] futex_wake+0x3c/0xa5
Jan 27 11:56:14 ECDCCAM1 kernel:  [<c04564b7>] generic_file_aio_write+0x60/0xaa
Jan 27 11:56:14 ECDCCAM1 kernel:  [<f8883e91>] ext3_file_write+0x19/0x83 [ext3]
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0470fb2>] do_sync_write+0xb6/0xf1
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c04718cd>] vfs_write+0x103/0x143
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c04819c8>] sys_poll+0x41/0x44
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:15 ECDCCAM1 kernel:  =======================
Jan 27 11:56:15 ECDCCAM1 kernel: httpd.worker  S 003CB140  2660 25196
 2567         25199 25195 (NOTLB)
Jan 27 11:56:15 ECDCCAM1 kernel:        d8669e94 00200082 a3755652
003cb140 00000040 c06a7400 d8669eb4 00000008
Jan 27 11:56:15 ECDCCAM1 kernel:        f5502550 a37594ee 003cb140
00003e9c 00000000 f550265c cb6126e0 e5a50740
Jan 27 11:56:15 ECDCCAM1 kernel:        d8669eb4 00000000 00000200
00000040 d8669efc 00000200 d8669efc ffffffff
Jan 27 11:56:15 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:15 ECDCCAM1 kernel:  =======================
Jan 27 11:56:15 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25199
 2567         25201 25196 (NOTLB)
Jan 27 11:56:15 ECDCCAM1 kernel:        e2cd1e94 00200082 adf49291
003cb13e 00000040 c06a7400 e2cd1eb4 0000000a
Jan 27 11:56:15 ECDCCAM1 kernel:        ea93d550 adf4baf5 003cb13e
00002864 00000000 ea93d65c cb6126e0 e5a50740
Jan 27 11:56:15 ECDCCAM1 kernel:        e2cd1eb4 c05aa190 00000000
00000040 e2cd1efc 00000200 e2cd1efc 00000200
Jan 27 11:56:15 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:15 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:15 ECDCCAM1 kernel:  =======================
Jan 27 11:56:16 ECDCCAM1 kernel: httpd.worker  S 003CB2B1  2636 25201
 2567         25203 25199 (NOTLB)
Jan 27 11:56:16 ECDCCAM1 kernel:        d191fe94 00200082 483c862e
003cb2b1 00000040 c06a7400 d191feb4 0000000a
Jan 27 11:56:16 ECDCCAM1 kernel:        d51fd550 483cd187 003cb2b1
00004b59 00000000 d51fd65c cb6126e0 e5a50740
Jan 27 11:56:16 ECDCCAM1 kernel:        d191feb4 00000000 00000200
00000040 d191fefc 00000200 d191fefc ffffffff
Jan 27 11:56:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:16 ECDCCAM1 kernel:  =======================
Jan 27 11:56:16 ECDCCAM1 kernel: httpd.worker  S 003CB152  2660 25203
 2567         25205 25201 (NOTLB)
Jan 27 11:56:16 ECDCCAM1 kernel:        f26ebe94 00200082 363c4d6e
003cb152 c05d2cb8 f770dc40 ef0e946c 00000007
Jan 27 11:56:16 ECDCCAM1 kernel:        e6b6eaa0 363cc397 003cb152
00007629 00000000 e6b6ebac cb6126e0 e5a50740
Jan 27 11:56:16 ECDCCAM1 kernel:        00000000 00000000 ef0e946c
c0434a67 f26ebe70 f26ebe70 f26ebefc ffffffff
Jan 27 11:56:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:16 ECDCCAM1 kernel:  =======================
Jan 27 11:56:16 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2636 25205
 2567         25206 25203 (NOTLB)
Jan 27 11:56:16 ECDCCAM1 kernel:        db048e94 00200082 bec119be
003cb13d 00000040 c06a7400 db048eb4 00000004
Jan 27 11:56:16 ECDCCAM1 kernel:        d9153550 bec13bd8 003cb13d
0000221a 00000000 d915365c cb6126e0 e5a50740
Jan 27 11:56:16 ECDCCAM1 kernel:        db048eb4 00000000 00000200
00000040 db048efc 00000200 db048efc ffffffff
Jan 27 11:56:16 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:16 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:17 ECDCCAM1 kernel:  =======================
Jan 27 11:56:17 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25206
 2567         25208 25205 (NOTLB)
Jan 27 11:56:17 ECDCCAM1 kernel:        e1226e94 00200082 ae3667ae
003cb13e 00000040 c06a7400 e1226eb4 0000000a
Jan 27 11:56:17 ECDCCAM1 kernel:        f5c31000 ae368062 003cb13e
000018b4 00000000 f5c3110c cb6126e0 e5a50740
Jan 27 11:56:17 ECDCCAM1 kernel:        e1226eb4 c05aa190 00000000
00000040 e1226efc 00000200 cb612b9c 00000200
Jan 27 11:56:17 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:17 ECDCCAM1 kernel:  =======================
Jan 27 11:56:17 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25208
 2567         25210 25206 (NOTLB)
Jan 27 11:56:17 ECDCCAM1 kernel:        e8884e94 00200082 ae363be5
003cb13e 00000040 c06a7400 e8884eb4 0000000a
Jan 27 11:56:17 ECDCCAM1 kernel:        ed6e9000 ae3667ae 003cb13e
00002bc9 00000000 ed6e910c cb6126e0 e5a50740
Jan 27 11:56:17 ECDCCAM1 kernel:        e8884eb4 c05aa190 00000000
00000040 e8884efc 00000200 cb612b9c 00000200
Jan 27 11:56:17 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:17 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:18 ECDCCAM1 kernel:  =======================
Jan 27 11:56:18 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2660 25210
 2567         25213 25208 (NOTLB)
Jan 27 11:56:18 ECDCCAM1 kernel:        f749ae94 00200082 ae73ddc0
003cb13e 00000040 c06a7400 f749aeb4 0000000a
Jan 27 11:56:18 ECDCCAM1 kernel:        de3f6aa0 ae740411 003cb13e
00002651 00000000 de3f6bac cb6126e0 e5a50740
Jan 27 11:56:18 ECDCCAM1 kernel:        f749aeb4 00000000 00000200
00000040 f749aefc 00000200 f749aefc ffffffff
Jan 27 11:56:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:18 ECDCCAM1 kernel:  =======================
Jan 27 11:56:18 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2636 25213
 2567         25214 25210 (NOTLB)
Jan 27 11:56:18 ECDCCAM1 kernel:        e5fa8e94 00200082 ae45b561
003cb13e 00000040 c06a7400 e5fa8eb4 0000000a
Jan 27 11:56:18 ECDCCAM1 kernel:        cf4f0000 ae45d9f6 003cb13e
00002495 00000000 cf4f010c cb6126e0 e5a50740
Jan 27 11:56:18 ECDCCAM1 kernel:        e5fa8eb4 00000000 00000200
00000040 e5fa8efc 00000200 e5fa8efc ffffffff
Jan 27 11:56:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:18 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:18 ECDCCAM1 kernel:  =======================
Jan 27 11:56:18 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2660 25214
 2567         25215 25213 (NOTLB)
Jan 27 11:56:18 ECDCCAM1 kernel:        e7582e94 00200082 be94dcff
003cb13d 00000040 c06a7400 e7582eb4 00000004
Jan 27 11:56:18 ECDCCAM1 kernel:        e9e93550 be9508f5 003cb13d
00002bf6 00000000 e9e9365c cb6126e0 e5a50740
Jan 27 11:56:18 ECDCCAM1 kernel:        e7582eb4 00000000 00000200
00000040 e7582efc 00000200 e7582efc ffffffff
Jan 27 11:56:18 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:19 ECDCCAM1 kernel:  =======================
Jan 27 11:56:19 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2568 25215
 2567         25216 25214 (NOTLB)
Jan 27 11:56:19 ECDCCAM1 kernel:        e570ee94 00200082 2468c8fe
003cb13f 00000040 c06a7400 e570eeb4 00000008
Jan 27 11:56:19 ECDCCAM1 kernel:        d41b1550 2468fb55 003cb13f
00003257 00000001 d41b165c cb6194c4 e5a50740
Jan 27 11:56:19 ECDCCAM1 kernel:        e570eeb4 00000000 00000200
00000040 e570eefc 00000200 e570eefc ffffffff
Jan 27 11:56:19 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:19 ECDCCAM1 syslogd 1.4.1: restart.
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:19 ECDCCAM1 xinetd[2261]: START: shell pid=13284 from=192.168.0.253
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:19 ECDCCAM1 rshd[13285]: root@192.168.0.253 as root:
cmd='/perfigo/common/bin/syslogconf 10.13.19.121'
Jan 27 11:56:19 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:19 ECDCCAM1 kernel:  =======================
Jan 27 11:56:19 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2568 25216
 2567         25217 25215 (NOTLB)
Jan 27 11:56:19 ECDCCAM1 kernel:        ee71de94 00200082 239f053f
003cb13f 00000040 c06a7400 ee71deb4 0000000a
Jan 27 11:56:19 ECDCCAM1 kernel:        ed6e9aa0 239f45e8 003cb13f
000040a9 00000000 ed6e9bac cb6126e0 e5a50740
Jan 27 11:56:19 ECDCCAM1 xinetd[2261]: EXIT: shell status=0 pid=13284
duration=0(sec)
Jan 27 11:56:19 ECDCCAM1 kernel:        ee71deb4 00000000 00000200
00000040 ee71defc 00000200 ee71defc ffffffff
Jan 27 11:56:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:20 ECDCCAM1 kernel:  =======================
Jan 27 11:56:20 ECDCCAM1 kernel: httpd.worker  S 003CB13D  2636 25217
 2567         25218 25216 (NOTLB)
Jan 27 11:56:20 ECDCCAM1 kernel:        e0ad4e94 00200082 bebd6e20
003cb13d 00000040 c06a7400 e0ad4eb4 00000008
Jan 27 11:56:20 ECDCCAM1 kernel:        da792550 bebd9e80 003cb13d
00003060 00000000 da79265c cb6126e0 e5a50740
Jan 27 11:56:20 ECDCCAM1 kernel:        e0ad4eb4 c05aa190 00000000
00000040 e0ad4efc 00000200 e0ad4efc 00000200
Jan 27 11:56:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:20 ECDCCAM1 kernel:  =======================
Jan 27 11:56:20 ECDCCAM1 kernel: httpd.worker  S 003CB13E  2636 25218
 2567         25219 25217 (NOTLB)
Jan 27 11:56:20 ECDCCAM1 kernel:        f6defe94 00200082 adb9fe54
003cb13e 00000040 c06a7400 f6defeb4 0000000a
Jan 27 11:56:20 ECDCCAM1 kernel:        f76e7550 adba2930 003cb13e
00002adc 00000000 f76e765c cb6126e0 e5a50740
Jan 27 11:56:20 ECDCCAM1 kernel:        f6defeb4 00000000 00000200
00000040 f6defefc 00000200 f6defefc ffffffff
Jan 27 11:56:20 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:20 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:21 ECDCCAM1 kernel:  =======================
Jan 27 11:56:21 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25219
 2567         25220 25218 (NOTLB)
Jan 27 11:56:21 ECDCCAM1 kernel:        f4bc6e94 00200082 2477c849
003cb13f 00000040 c06a7400 f4bc6eb4 00000008
Jan 27 11:56:21 ECDCCAM1 kernel:        d18a6aa0 2477ee70 003cb13f
00002627 00000000 d18a6bac cb6126e0 e5a50740
Jan 27 11:56:21 ECDCCAM1 kernel:        f4bc6eb4 00000000 00000200
00000040 f4bc6efc 00000200 f4bc6efc ffffffff
Jan 27 11:56:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:21 ECDCCAM1 kernel:  =======================
Jan 27 11:56:21 ECDCCAM1 kernel: httpd.worker  S 003CB13F  2660 25220
 2567         25221 25219 (NOTLB)
Jan 27 11:56:21 ECDCCAM1 kernel:        ea556e94 00200082 2641312b
003cb13f 00000040 c06a7400 ea556eb4 00000008
Jan 27 11:56:21 ECDCCAM1 kernel:        d941aaa0 2641535b 003cb13f
00002230 00000000 d941abac cb6126e0 e5a50740
Jan 27 11:56:21 ECDCCAM1 kernel:        ea556eb4 00000000 00000200
00000040 ea556efc 00000200 ea556efc ffffffff
Jan 27 11:56:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:21 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:21 ECDCCAM1 kernel:  =======================
Jan 27 11:56:21 ECDCCAM1 kernel: httpd.worker  S 003CB2C5  3196 25221
 2567         20315 25220 (NOTLB)
Jan 27 11:56:21 ECDCCAM1 kernel:        e3714f40 00200082 fa332f55
003cb2c5 04000001 00000000 c04805d0 00000007
Jan 27 11:56:21 ECDCCAM1 kernel:        d9c0caa0 fa33d83b 003cb2c5
0000a8e6 00000003 d9c0cbac cb62708c e5a50740
Jan 27 11:56:21 ECDCCAM1 kernel:        003cb211 00000000 02000000
00000000 f7054efc ffffffff 7fffffff ffffffff
Jan 27 11:56:21 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c04805d0>] fasync_helper+0x3c/0xae
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0495241>] sys_epoll_wait+0x14a/0x38d
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:22 ECDCCAM1 kernel:  =======================
Jan 27 11:56:22 ECDCCAM1 kernel: httpd.worker  S 003C61D5  3088 20315
 2567         20317 25221 (NOTLB)
Jan 27 11:56:22 ECDCCAM1 kernel:        dd64ff00 00200086 4a4c13ac
003c61d5 f76f3554 f7b2b788 f76f34ac 00000008
Jan 27 11:56:22 ECDCCAM1 kernel:        dbe24aa0 4a4c1b2d 003c61d5
00000781 00000002 dbe24bac cb6202a8 d0fb2200
Jan 27 11:56:22 ECDCCAM1 kernel:        dbe24aa0 08056bd0 00000000
d0fb2200 00000000 00000000 dd64ff08 dc293000
Jan 27 11:56:22 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:22 ECDCCAM1 kernel:  =======================
Jan 27 11:56:22 ECDCCAM1 kernel: httpd.worker  S 003CAE04  2636 20318
 2567         20320 20317 (NOTLB)
Jan 27 11:56:22 ECDCCAM1 kernel:        d71fbe94 00200086 e3c7c172
003cae04 00000040 c06a7400 d71fbeb4 0000000a
Jan 27 11:56:22 ECDCCAM1 kernel:        d41db000 e3c7ebd0 003cae04
00002a5e 00000000 d41db10c cb6126e0 d0fb2200
Jan 27 11:56:22 ECDCCAM1 kernel:        d71fbeb4 00000000 00000200
00000040 d71fbefc 00000200 d71fbefc ffffffff
Jan 27 11:56:22 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:22 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:22 ECDCCAM1 kernel:  =======================
Jan 27 11:56:23 ECDCCAM1 kernel: httpd.worker  S 003CB1B1  2636 20320
 2567         20321 20318 (NOTLB)
Jan 27 11:56:23 ECDCCAM1 kernel:        d9e78e94 00200086 12512830
003cb1b1 c05d2cb8 f770dc40 f5a26eac 00000007
Jan 27 11:56:23 ECDCCAM1 kernel:        f744eaa0 1251a6d7 003cb1b1
00007ea7 00000000 f744ebac cb6126e0 d0fb2200
Jan 27 11:56:23 ECDCCAM1 kernel:        00000000 00000000 f5a26eac
c0434a67 d9e78e70 d9e78e70 d9e78efc ffffffff
Jan 27 11:56:23 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:23 ECDCCAM1 kernel:  =======================
Jan 27 11:56:23 ECDCCAM1 kernel: httpd.worker  S 003CB0FD  2636 20321
 2567         20322 20320 (NOTLB)
Jan 27 11:56:23 ECDCCAM1 kernel:        de84ce94 00200086 16c5ca2d
003cb0fd c05d2cb8 f770dc40 e868c42c 00000007
Jan 27 11:56:23 ECDCCAM1 kernel:        dbe24550 16c64903 003cb0fd
00007ed6 00000000 dbe2465c cb6126e0 d0fb2200
Jan 27 11:56:23 ECDCCAM1 kernel:        00000000 00000000 e868c42c
c0434a67 de84ce70 de84ce70 de84cefc ffffffff
Jan 27 11:56:23 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:23 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:23 ECDCCAM1 kernel:  =======================
Jan 27 11:56:23 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20322
 2567         20323 20321 (NOTLB)
Jan 27 11:56:23 ECDCCAM1 kernel:        f1085e94 00200086 1606d42f
003cb185 00000040 c06a7400 f1085eb4 00000007
Jan 27 11:56:23 ECDCCAM1 kernel:        f7619aa0 1606f658 003cb185
00002229 00000000 f7619bac cb6126e0 d0fb2200
Jan 27 11:56:23 ECDCCAM1 kernel:        f1085eb4 00000000 00000200
00000040 f1085efc 00000200 f1085efc ffffffff
Jan 27 11:56:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:24 ECDCCAM1 kernel:  =======================
Jan 27 11:56:24 ECDCCAM1 kernel: httpd.worker  S 003CB07E  2660 20323
 2567         20324 20322 (NOTLB)
Jan 27 11:56:24 ECDCCAM1 kernel:        e7672e94 00200086 b8aa403e
003cb07e 00000040 c06a7400 e7672eb4 00000008
Jan 27 11:56:24 ECDCCAM1 kernel:        d20d6550 b8aa6525 003cb07e
000024e7 00000000 d20d665c cb6126e0 d0fb2200
Jan 27 11:56:24 ECDCCAM1 kernel:        e7672eb4 00000000 00000200
00000040 e7672efc 00000200 e7672efc ffffffff
Jan 27 11:56:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:24 ECDCCAM1 kernel:  =======================
Jan 27 11:56:24 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20324
 2567         20325 20323 (NOTLB)
Jan 27 11:56:24 ECDCCAM1 kernel:        e2748e94 00200086 15eddac4
003cb185 00000040 c06a7400 e2748eb4 00000002
Jan 27 11:56:24 ECDCCAM1 kernel:        d6986aa0 15edfd4d 003cb185
00002289 00000000 d6986bac cb6126e0 d0fb2200
Jan 27 11:56:24 ECDCCAM1 kernel:        e2748eb4 00000000 00000200
00000040 e2748efc 00000200 e2748efc ffffffff
Jan 27 11:56:24 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:24 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:25 ECDCCAM1 kernel:  =======================
Jan 27 11:56:25 ECDCCAM1 kernel: httpd.worker  S 003CB07E  2612 20325
 2567         20326 20324 (NOTLB)
Jan 27 11:56:25 ECDCCAM1 kernel:        e5173e94 00200086 b42b3f85
003cb07e 00000040 c06a7400 e5173eb4 0000000a
Jan 27 11:56:25 ECDCCAM1 kernel:        f3498aa0 b42b6915 003cb07e
00002990 00000000 f3498bac cb6126e0 d0fb2200
Jan 27 11:56:25 ECDCCAM1 kernel:        e5173eb4 00000000 00000200
00000040 e5173efc 00000200 e5173efc ffffffff
Jan 27 11:56:25 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:25 ECDCCAM1 kernel:  =======================
Jan 27 11:56:25 ECDCCAM1 kernel: httpd.worker  S 003CB07E  2636 20326
 2567         20327 20325 (NOTLB)
Jan 27 11:56:25 ECDCCAM1 kernel:        d86bee94 00200086 b1bb2c19
003cb07e 00000040 c06a7400 d86beeb4 00000008
Jan 27 11:56:25 ECDCCAM1 kernel:        f50c1aa0 b1bba3fb 003cb07e
000077e2 00000000 f50c1bac cb6126e0 d0fb2200
Jan 27 11:56:25 ECDCCAM1 kernel:        d86beeb4 00000000 00000200
00000040 d86beefc 00000200 d86beefc ffffffff
Jan 27 11:56:25 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:25 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:25 ECDCCAM1 kernel:  =======================
Jan 27 11:56:25 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20327
 2567         20328 20326 (NOTLB)
Jan 27 11:56:25 ECDCCAM1 kernel:        e9216e94 00200086 157c3c8d
003cb185 00000040 c06a7400 e9216eb4 00000002
Jan 27 11:56:25 ECDCCAM1 kernel:        f5add000 157c626f 003cb185
000025e2 00000000 f5add10c cb6126e0 d0fb2200
Jan 27 11:56:26 ECDCCAM1 kernel:        e9216eb4 00000000 00000200
00000040 e9216efc 00000200 e9216efc ffffffff
Jan 27 11:56:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:26 ECDCCAM1 kernel:  =======================
Jan 27 11:56:26 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20328
 2567         20329 20327 (NOTLB)
Jan 27 11:56:26 ECDCCAM1 kernel:        d90a7e94 00200086 f6c242ef
003cb171 00000040 c06a7400 d90a7eb4 0000000a
Jan 27 11:56:26 ECDCCAM1 kernel:        f09daaa0 f6c2661a 003cb171
0000232b 00000000 f09dabac cb6126e0 d0fb2200
Jan 27 11:56:26 ECDCCAM1 kernel:        d90a7eb4 00000000 00000200
00000040 d90a7efc 00000200 d90a7efc ffffffff
Jan 27 11:56:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:26 ECDCCAM1 kernel:  =======================
Jan 27 11:56:26 ECDCCAM1 kernel: httpd.worker  S 003CB20C  2400 20329
 2567         20330 20328 (NOTLB)
Jan 27 11:56:26 ECDCCAM1 kernel:        d05fde94 00200086 d4f379bb
003cb20c c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:56:26 ECDCCAM1 kernel:        d54cc000 d4f4001c 003cb20c
00008661 00000000 d54cc10c cb6126e0 d0fb2200
Jan 27 11:56:26 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 d05fde70 00000001 ffffffff
Jan 27 11:56:26 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:26 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:27 ECDCCAM1 kernel:  =======================
Jan 27 11:56:27 ECDCCAM1 kernel: httpd.worker  S 003CB06D  2660 20330
 2567         20331 20329 (NOTLB)
Jan 27 11:56:27 ECDCCAM1 kernel:        cc385e94 00200086 ea567075
003cb06d c05d2cb8 f770dc40 f09b3d2c 0000000a
Jan 27 11:56:27 ECDCCAM1 kernel:        f7059aa0 ea56f00e 003cb06d
00007f99 00000000 f7059bac cb6126e0 d0fb2200
Jan 27 11:56:27 ECDCCAM1 kernel:        00000000 00000000 f09b3d2c
c0434a67 cc385e70 cc385e70 cc385efc ffffffff
Jan 27 11:56:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:27 ECDCCAM1 kernel:  =======================
Jan 27 11:56:27 ECDCCAM1 kernel: httpd.worker  S 003CB211  2660 20331
 2567         20332 20330 (NOTLB)
Jan 27 11:56:27 ECDCCAM1 kernel:        dea86e94 00200086 4c397096
003cb211 c05d2cb8 f770dc40 e86318ec 00000007
Jan 27 11:56:27 ECDCCAM1 kernel:        d415c550 4c39e1e4 003cb211
0000714e 00000000 d415c65c cb6126e0 d0fb2200
Jan 27 11:56:27 ECDCCAM1 kernel:        00000000 00000000 e86318ec
c0434a67 dea86e70 dea86e70 dea86efc ffffffff
Jan 27 11:56:27 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:27 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:28 ECDCCAM1 kernel:  =======================
Jan 27 11:56:28 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20332
 2567         20333 20331 (NOTLB)
Jan 27 11:56:28 ECDCCAM1 kernel:        ef03ae94 00200086 15bc2e20
003cb185 00000040 c06a7400 ef03aeb4 00000002
Jan 27 11:56:28 ECDCCAM1 kernel:        e1a04aa0 15bc5388 003cb185
00002568 00000000 e1a04bac cb6126e0 d0fb2200
Jan 27 11:56:28 ECDCCAM1 kernel:        ef03aeb4 00000000 00000200
00000040 ef03aefc 00000200 ef03aefc ffffffff
Jan 27 11:56:28 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:28 ECDCCAM1 kernel:  =======================
Jan 27 11:56:28 ECDCCAM1 kernel: httpd.worker  S 003CAF56  2660 20333
 2567         20334 20332 (NOTLB)
Jan 27 11:56:28 ECDCCAM1 kernel:        e548ae94 00200086 69226c8b
003caf56 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:56:28 ECDCCAM1 kernel:        e1a04550 6922eee1 003caf56
00008256 00000000 e1a0465c cb6126e0 d0fb2200
Jan 27 11:56:28 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 e548ae70 00000001 ffffffff
Jan 27 11:56:28 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:28 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:28 ECDCCAM1 kernel:  =======================
Jan 27 11:56:28 ECDCCAM1 kernel: httpd.worker  S 003CB1BF  2660 20340
 2567         20341 20339 (NOTLB)
Jan 27 11:56:29 ECDCCAM1 kernel:        e598ae94 00200086 b76b77da
003cb1bf c05d2cb8 f770dc40 de05cd6c 00000007
Jan 27 11:56:29 ECDCCAM1 kernel:        d428f000 b76bf87e 003cb1bf
000080a4 00000000 d428f10c cb6126e0 d0fb2200
Jan 27 11:56:29 ECDCCAM1 kernel:        00000000 00000000 de05cd6c
c0434a67 e598ae70 e598ae70 e598aefc ffffffff
Jan 27 11:56:29 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:29 ECDCCAM1 kernel:  =======================
Jan 27 11:56:29 ECDCCAM1 kernel: httpd.worker  S 003CB062  2660 20341
 2567         20342 20340 (NOTLB)
Jan 27 11:56:29 ECDCCAM1 kernel:        dd98fe94 00200086 668a0943
003cb062 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:56:29 ECDCCAM1 kernel:        d29ae000 668a9527 003cb062
00008be4 00000000 d29ae10c cb6126e0 d0fb2200
Jan 27 11:56:29 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 dd98fe70 00000001 ffffffff
Jan 27 11:56:29 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:29 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:29 ECDCCAM1 kernel:  =======================
Jan 27 11:56:29 ECDCCAM1 kernel: httpd.worker  S 003CB08F  2636 20342
 2567         20343 20341 (NOTLB)
Jan 27 11:56:29 ECDCCAM1 kernel:        e311be94 00200086 6e2c4e55
003cb08f c05d2cb8 f770dc40 e86318ec 00000007
Jan 27 11:56:29 ECDCCAM1 kernel:        d2e0a000 6e2cb3e1 003cb08f
0000658c 00000000 d2e0a10c cb6126e0 d0fb2200
Jan 27 11:56:30 ECDCCAM1 kernel:        00000000 00000000 e86318ec
c0434a67 e311be70 e311be70 e311befc ffffffff
Jan 27 11:56:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:30 ECDCCAM1 kernel:  =======================
Jan 27 11:56:30 ECDCCAM1 kernel: httpd.worker  S 003CB0B1  2636 20343
 2567         20344 20342 (NOTLB)
Jan 27 11:56:30 ECDCCAM1 kernel:        e2fc0e94 00200086 30f642f1
003cb0b1 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:56:30 ECDCCAM1 kernel:        f798a000 30f6cc62 003cb0b1
00008971 00000000 f798a10c cb6126e0 d0fb2200
Jan 27 11:56:30 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 e2fc0e70 00000001 ffffffff
Jan 27 11:56:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:30 ECDCCAM1 kernel:  =======================
Jan 27 11:56:30 ECDCCAM1 kernel: httpd.worker  S 003CB140  1836 20344
 2567         20345 20343 (NOTLB)
Jan 27 11:56:30 ECDCCAM1 kernel:        e89dfe94 00200086 a4439ac7
003cb140 00000040 c06a7400 e89dfeb4 0000000a
Jan 27 11:56:30 ECDCCAM1 kernel:        e44b2000 a443c701 003cb140
00002c3a 00000000 e44b210c cb6126e0 d0fb2200
Jan 27 11:56:30 ECDCCAM1 kernel:        e89dfeb4 00000000 00000200
00000040 e89dfefc 00000200 e89dfefc ffffffff
Jan 27 11:56:30 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:30 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:31 ECDCCAM1 kernel:  =======================
Jan 27 11:56:31 ECDCCAM1 kernel: httpd.worker  S 003CB1A4  2660 20345
 2567         20346 20344 (NOTLB)
Jan 27 11:56:31 ECDCCAM1 kernel:        cd116e94 00200086 ab5a0cde
003cb1a4 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:56:31 ECDCCAM1 kernel:        d9c11000 ab5a8df1 003cb1a4
00008113 00000000 d9c1110c cb6126e0 d0fb2200
Jan 27 11:56:31 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 cd116e70 00000001 ffffffff
Jan 27 11:56:31 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:31 ECDCCAM1 kernel:  =======================
Jan 27 11:56:31 ECDCCAM1 kernel: httpd.worker  S 003CB1B8  2660 20346
 2567         20347 20345 (NOTLB)
Jan 27 11:56:31 ECDCCAM1 kernel:        dd81be94 00200086 12d06fa4
003cb1b8 00000040 c06a7400 dd81beb4 0000000a
Jan 27 11:56:31 ECDCCAM1 kernel:        d61baaa0 12d0c335 003cb1b8
00005391 00000000 d61babac cb6126e0 d0fb2200
Jan 27 11:56:31 ECDCCAM1 kernel:        dd81beb4 00000000 00000200
00000040 dd81befc 00000200 dd81befc ffffffff
Jan 27 11:56:31 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:31 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:32 ECDCCAM1 kernel:  =======================
Jan 27 11:56:32 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20354
 2567         20355 20353 (NOTLB)
Jan 27 11:56:32 ECDCCAM1 kernel:        e29ace94 00200086 154f7a4b
003cb185 00000040 c06a7400 e29aceb4 00000002
Jan 27 11:56:32 ECDCCAM1 kernel:        e6c9b550 154f9e6f 003cb185
00002424 00000000 e6c9b65c cb6126e0 d0fb2200
Jan 27 11:56:32 ECDCCAM1 kernel:        e29aceb4 00000000 00000200
00000040 e29acefc 00000200 e29acefc ffffffff
Jan 27 11:56:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:32 ECDCCAM1 kernel:  =======================
Jan 27 11:56:32 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20355
 2567         20356 20354 (NOTLB)
Jan 27 11:56:32 ECDCCAM1 kernel:        dbb18e94 00200086 142107c4
003cb185 00000040 c06a7400 dbb18eb4 00000001
Jan 27 11:56:32 ECDCCAM1 kernel:        e6c9b000 14213e7a 003cb185
000036b6 00000000 e6c9b10c cb6126e0 d0fb2200
Jan 27 11:56:32 ECDCCAM1 kernel:        dbb18eb4 00000000 00000200
00000040 dbb18efc 00000200 dbb18efc ffffffff
Jan 27 11:56:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:32 ECDCCAM1 kernel:  =======================
Jan 27 11:56:32 ECDCCAM1 kernel: httpd.worker  S 003CB185  2660 20356
 2567         20357 20355 (NOTLB)
Jan 27 11:56:32 ECDCCAM1 kernel:        d2755e94 00200086 15d0bbc3
003cb185 00000040 c06a7400 d2755eb4 00000008
Jan 27 11:56:32 ECDCCAM1 kernel:        e8b74aa0 15d0de95 003cb185
000022d2 00000000 e8b74bac cb6126e0 d0fb2200
Jan 27 11:56:32 ECDCCAM1 kernel:        d2755eb4 c05aa190 00000000
00000040 d2755efc 00000200 d2755efc 00000200
Jan 27 11:56:32 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:32 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:33 ECDCCAM1 kernel:  =======================
Jan 27 11:56:33 ECDCCAM1 kernel: httpd.worker  S 003CB2C5  3292 20357
 2567         20358 20356 (NOTLB)
Jan 27 11:56:33 ECDCCAM1 kernel:        e4442f58 00200086 fa4e3890
003cb2c5 da00765c 00200246 fffffff5 00000007
Jan 27 11:56:33 ECDCCAM1 kernel:        e8b74550 fa4e4828 003cb2c5
00000f98 00000000 e8b7465c cb6126e0 d0fb2200
Jan 27 11:56:33 ECDCCAM1 kernel:        d89571b0 00000000 f7054e9c
f7054bfc 00000000 00402040 e4442f6c ffffffff
Jan 27 11:56:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0484cf6>] fcntl_setlk+0x174/0x222
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0480c50>] sys_fcntl64+0x6f/0x80
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:33 ECDCCAM1 kernel:  =======================
Jan 27 11:56:33 ECDCCAM1 kernel: httpd.worker  S 003C61D5  3088 20317
 2567         20318 20315 (NOTLB)
Jan 27 11:56:33 ECDCCAM1 kernel:        e5537f00 00200086 4a4c2191
003c61d5 f76f3554 f7b2b788 f76f34ac 00000007
Jan 27 11:56:33 ECDCCAM1 kernel:        e46f0000 4a4c2829 003c61d5
00000698 00000002 e46f010c cb6202a8 e985a3c0
Jan 27 11:56:33 ECDCCAM1 kernel:        def707cc 00000000 00000000
e985a3c0 00000000 00000000 e5537f08 ffffffff
Jan 27 11:56:33 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c041df46>] __activate_task+0x4a/0x59
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:33 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:33 ECDCCAM1 kernel:  =======================
Jan 27 11:56:33 ECDCCAM1 kernel: httpd.worker  S 003CB17F  2660 20334
 2567         20335 20333 (NOTLB)
Jan 27 11:56:33 ECDCCAM1 kernel:        e041fe94 00200086 619c7fef
003cb17f c05d2cb8 f770dc40 f3bbb8ac 00000007
Jan 27 11:56:34 ECDCCAM1 kernel:        d0752000 619d0257 003cb17f
00008268 00000000 d075210c cb6126e0 e985a3c0
Jan 27 11:56:34 ECDCCAM1 kernel:        00000000 00000000 f3bbb8ac
c0434a67 e041fe70 e041fe70 e041fefc ffffffff
Jan 27 11:56:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:34 ECDCCAM1 kernel:  =======================
Jan 27 11:56:34 ECDCCAM1 kernel: httpd.worker  S 003CB171  2504 20335
 2567         20336 20334 (NOTLB)
Jan 27 11:56:34 ECDCCAM1 kernel:        dff21e94 00200086 55c69f9c
003cb171 00000040 c06a7400 dff21eb4 0000000a
Jan 27 11:56:34 ECDCCAM1 kernel:        e6b6e000 55c6cd0f 003cb171
00002d73 00000000 e6b6e10c cb6126e0 e985a3c0
Jan 27 11:56:34 ECDCCAM1 kernel:        dff21eb4 00000000 00000200
00000040 dff21efc 00000200 dff21efc ffffffff
Jan 27 11:56:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:34 ECDCCAM1 kernel:  =======================
Jan 27 11:56:34 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20336
 2567         20337 20335 (NOTLB)
Jan 27 11:56:34 ECDCCAM1 kernel:        dbfc1e94 00200086 f6ba3b22
003cb171 00000040 c06a7400 dbfc1eb4 0000000a
Jan 27 11:56:34 ECDCCAM1 kernel:        f5255000 f6ba64f3 003cb171
000029d1 00000000 f525510c cb6126e0 e985a3c0
Jan 27 11:56:34 ECDCCAM1 kernel:        dbfc1eb4 00000000 00000200
00000040 dbfc1efc 00000200 dbfc1efc ffffffff
Jan 27 11:56:34 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:34 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:35 ECDCCAM1 kernel:  =======================
Jan 27 11:56:35 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20337
 2567         20338 20336 (NOTLB)
Jan 27 11:56:35 ECDCCAM1 kernel:        e88f9e94 00200086 f6798a15
003cb171 00000040 c06a7400 e88f9eb4 0000000a
Jan 27 11:56:35 ECDCCAM1 kernel:        f5c31aa0 f679b1e9 003cb171
000027d4 00000000 f5c31bac cb6126e0 e985a3c0
Jan 27 11:56:35 ECDCCAM1 kernel:        e88f9eb4 c05aa190 00000000
00000040 e88f9efc 00000200 cb612724 00000200
Jan 27 11:56:35 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:35 ECDCCAM1 kernel:  =======================
Jan 27 11:56:35 ECDCCAM1 kernel: httpd.worker  S 003CB171  2620 20338
 2567         20339 20337 (NOTLB)
Jan 27 11:56:35 ECDCCAM1 kernel:        d8da5e94 00200086 f657f4ab
003cb171 00000040 c06a7400 d8da5eb4 0000000a
Jan 27 11:56:35 ECDCCAM1 kernel:        f7582550 f6581fd6 003cb171
00002b2b 00000000 f758265c cb6126e0 e985a3c0
Jan 27 11:56:35 ECDCCAM1 kernel:        d8da5eb4 c05aa190 00000000
00000040 d8da5efc 00000200 cb612724 00000200
Jan 27 11:56:35 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:35 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:36 ECDCCAM1 kernel:  =======================
Jan 27 11:56:36 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20339
 2567         20340 20338 (NOTLB)
Jan 27 11:56:36 ECDCCAM1 kernel:        ef9abe94 00200086 4299f02c
003cb170 00000040 c06a7400 ef9abeb4 0000000a
Jan 27 11:56:36 ECDCCAM1 kernel:        de3f6000 429a1546 003cb170
0000251a 00000000 de3f610c cb6126e0 e985a3c0
Jan 27 11:56:36 ECDCCAM1 kernel:        ef9abeb4 00000000 00000200
00000040 ef9abefc 00000200 ef9abefc ffffffff
Jan 27 11:56:36 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:36 ECDCCAM1 kernel:  =======================
Jan 27 11:56:36 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20347
 2567         20348 20346 (NOTLB)
Jan 27 11:56:36 ECDCCAM1 kernel:        e391ae94 00200086 42e995a4
003cb170 00000040 c06a7400 e391aeb4 0000000a
Jan 27 11:56:36 ECDCCAM1 kernel:        d0bf0000 42e9c266 003cb170
00002cc2 00000001 d0bf010c cb6194c4 e985a3c0
Jan 27 11:56:36 ECDCCAM1 kernel:        e391aeb4 00000000 00000200
00000040 e391aefc 00000200 e391aefc ffffffff
Jan 27 11:56:36 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:36 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:36 ECDCCAM1 kernel:  =======================
Jan 27 11:56:37 ECDCCAM1 kernel: httpd.worker  S 003CB151  2660 20348
 2567         20349 20347 (NOTLB)
Jan 27 11:56:37 ECDCCAM1 kernel:        db25fe94 00200086 a200a7c6
003cb151 00000040 c06a7400 db25feb4 00000009
Jan 27 11:56:37 ECDCCAM1 kernel:        d0bf0550 a200ca14 003cb151
0000224e 00000000 d0bf065c cb6126e0 e985a3c0
Jan 27 11:56:37 ECDCCAM1 kernel:        db25feb4 00000000 00000200
00000040 db25fefc 00000200 db25fefc ffffffff
Jan 27 11:56:37 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:37 ECDCCAM1 kernel:  =======================
Jan 27 11:56:37 ECDCCAM1 kernel: httpd.worker  S 003CB151  2636 20349
 2567         20350 20348 (NOTLB)
Jan 27 11:56:37 ECDCCAM1 kernel:        da869e94 00200086 a1ebe94b
003cb151 00000040 c06a7400 da869eb4 0000000a
Jan 27 11:56:37 ECDCCAM1 kernel:        d281aaa0 a1ec1c2d 003cb151
000032e2 00000000 d281abac cb6126e0 e985a3c0
Jan 27 11:56:37 ECDCCAM1 kernel:        da869eb4 00000000 00000200
00000040 da869efc 00000200 da869efc ffffffff
Jan 27 11:56:37 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c044b094>] __do_IRQ+0x0/0xd6
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c04074d6>] do_IRQ+0xb5/0xc3
Jan 27 11:56:37 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:37 ECDCCAM1 kernel:  =======================
Jan 27 11:56:37 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20350
 2567         20351 20349 (NOTLB)
Jan 27 11:56:37 ECDCCAM1 kernel:        e1193e94 00200086 411ced45
003cb170 00000040 c06a7400 e1193eb4 00000008
Jan 27 11:56:38 ECDCCAM1 kernel:        dab4eaa0 411d353c 003cb170
000047f7 00000000 dab4ebac cb6126e0 e985a3c0
Jan 27 11:56:38 ECDCCAM1 kernel:        e1193eb4 00000000 00000200
00000040 e1193efc 00000200 e1193efc ffffffff
Jan 27 11:56:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:38 ECDCCAM1 kernel:  =======================
Jan 27 11:56:38 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20351
 2567         20352 20350 (NOTLB)
Jan 27 11:56:38 ECDCCAM1 kernel:        de018e94 00200086 428a0003
003cb170 00000040 c06a7400 de018eb4 0000000a
Jan 27 11:56:38 ECDCCAM1 kernel:        dab4e550 428a18d8 003cb170
000018d5 00000000 dab4e65c cb6126e0 e985a3c0
Jan 27 11:56:38 ECDCCAM1 kernel:        de018eb4 00000000 00000200
00000040 de018efc 00000200 de018efc ffffffff
Jan 27 11:56:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:38 ECDCCAM1 kernel:  =======================
Jan 27 11:56:38 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20352
 2567         20353 20351 (NOTLB)
Jan 27 11:56:38 ECDCCAM1 kernel:        e0c18e94 00200086 42dc4326
003cb170 00000040 c06a7400 e0c18eb4 0000000a
Jan 27 11:56:38 ECDCCAM1 kernel:        dab4e000 42dc6bf6 003cb170
000028d0 00000000 dab4e10c cb6126e0 e985a3c0
Jan 27 11:56:38 ECDCCAM1 kernel:        e0c18eb4 00000000 00000200
00000040 e0c18efc 00000200 e0c18efc ffffffff
Jan 27 11:56:38 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:38 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:39 ECDCCAM1 kernel:  =======================
Jan 27 11:56:39 ECDCCAM1 kernel: httpd.worker  S 003CB16B  2660 20353
 2567         20354 20352 (NOTLB)
Jan 27 11:56:39 ECDCCAM1 kernel:        d6470e94 00200086 033699cc
003cb16b c05d2cb8 f770dc40 f3bbb12c 00000007
Jan 27 11:56:39 ECDCCAM1 kernel:        e6c9baa0 0337091f 003cb16b
00006f53 00000000 e6c9bbac cb6126e0 e985a3c0
Jan 27 11:56:39 ECDCCAM1 kernel:        00000000 00000000 f3bbb12c
c0434a67 d6470e70 d6470e70 d6470efc ffffffff
Jan 27 11:56:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:39 ECDCCAM1 kernel:  =======================
Jan 27 11:56:39 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20358
 2567         20359 20357 (NOTLB)
Jan 27 11:56:39 ECDCCAM1 kernel:        dad42e94 00200086 58c82d49
003cb171 00000040 c06a7400 dad42eb4 00000008
Jan 27 11:56:39 ECDCCAM1 kernel:        e8b74000 58c85867 003cb171
00002b1e 00000001 e8b7410c cb6194c4 e985a3c0
Jan 27 11:56:39 ECDCCAM1 kernel:        dad42eb4 00000000 00000200
00000040 dad42efc 00000200 dad42efc ffffffff
Jan 27 11:56:39 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:39 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:40 ECDCCAM1 kernel:  =======================
Jan 27 11:56:40 ECDCCAM1 kernel: httpd.worker  S 003CB169  2660 20359
 2567         20360 20358 (NOTLB)
Jan 27 11:56:40 ECDCCAM1 kernel:        e13bee94 00200086 110e45c0
003cb169 c05d2cb8 f770dc40 e1100bec 00000007
Jan 27 11:56:40 ECDCCAM1 kernel:        f4ff7aa0 110ecc15 003cb169
00008655 00000000 f4ff7bac cb6126e0 e985a3c0
Jan 27 11:56:40 ECDCCAM1 kernel:        00000000 00000000 e1100bec
c0434a67 e13bee70 e13bee70 e13beefc ffffffff
Jan 27 11:56:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:40 ECDCCAM1 kernel:  =======================
Jan 27 11:56:40 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20360
 2567         20361 20359 (NOTLB)
Jan 27 11:56:40 ECDCCAM1 kernel:        dd5fde94 00200086 f619c5a0
003cb171 00000040 c06a7400 dd5fdeb4 0000000a
Jan 27 11:56:40 ECDCCAM1 kernel:        f4ff7550 f619f112 003cb171
00002b72 00000000 f4ff765c cb6126e0 e985a3c0
Jan 27 11:56:40 ECDCCAM1 kernel:        dd5fdeb4 00000000 00000200
00000040 dd5fdefc 00000200 dd5fdefc ffffffff
Jan 27 11:56:40 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:40 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:41 ECDCCAM1 kernel:  =======================
Jan 27 11:56:41 ECDCCAM1 kernel: httpd.worker  S 003CB171  2660 20361
 2567         20362 20360 (NOTLB)
Jan 27 11:56:41 ECDCCAM1 kernel:        dd382e94 00200086 5487fd6a
003cb171 00000040 c06a7400 dd382eb4 00000008
Jan 27 11:56:41 ECDCCAM1 kernel:        f4ff7000 54883ec3 003cb171
00004159 00000000 f4ff710c cb6126e0 e985a3c0
Jan 27 11:56:41 ECDCCAM1 kernel:        dd382eb4 00000000 00000200
00000040 dd382efc 00000200 dd382efc ffffffff
Jan 27 11:56:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:41 ECDCCAM1 kernel:  =======================
Jan 27 11:56:41 ECDCCAM1 kernel: httpd.worker  S 003CB170  2660 20362
 2567         20363 20361 (NOTLB)
Jan 27 11:56:41 ECDCCAM1 kernel:        e2062e94 00200086 4289cb54
003cb170 00000040 c06a7400 e2062eb4 0000000a
Jan 27 11:56:41 ECDCCAM1 kernel:        eafe3aa0 428a0003 003cb170
000034af 00000000 eafe3bac cb6126e0 e985a3c0
Jan 27 11:56:41 ECDCCAM1 kernel:        e2062eb4 c05aa190 00000000
00000040 e2062efc 00000200 cb612724 00000200
Jan 27 11:56:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c05aa190>] do_sock_read+0xae/0xb7
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:41 ECDCCAM1 kernel:  =======================
Jan 27 11:56:41 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20363
 2567         20364 20362 (NOTLB)
Jan 27 11:56:41 ECDCCAM1 kernel:        e1ac8e94 00200086 5787590e
003cb171 00000040 c06a7400 e1ac8eb4 0000000a
Jan 27 11:56:41 ECDCCAM1 kernel:        eafe3550 5787cf01 003cb171
000075f3 00000000 eafe365c cb6126e0 e985a3c0
Jan 27 11:56:41 ECDCCAM1 kernel:        e1ac8eb4 00000000 00001f40
00000040 e1ac8efc 00001f40 e1ac8efc ffffffff
Jan 27 11:56:41 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:41 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:41 ECDCCAM1 kernel:  =======================
Jan 27 11:56:41 ECDCCAM1 kernel: httpd.worker  S 003CB170  2612 20364
 2567         20365 20363 (NOTLB)
Jan 27 11:56:42 ECDCCAM1 kernel:        ddfc2e94 00200086 42e8c4ef
003cb170 00000040 c06a7400 ddfc2eb4 0000000a
Jan 27 11:56:42 ECDCCAM1 kernel:        eafe3000 42e8e88f 003cb170
000023a0 00000000 eafe310c cb6126e0 e985a3c0
Jan 27 11:56:42 ECDCCAM1 kernel:        ddfc2eb4 00000000 00000200
00000040 ddfc2efc 00000200 ddfc2efc ffffffff
Jan 27 11:56:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:42 ECDCCAM1 kernel:  =======================
Jan 27 11:56:42 ECDCCAM1 kernel: httpd.worker  S 003CB165  2660 20365
 2567         20366 20364 (NOTLB)
Jan 27 11:56:42 ECDCCAM1 kernel:        ddd07e94 00200086 a2858caf
003cb165 c05d2cb8 f770dc40 000009d1 00000007
Jan 27 11:56:42 ECDCCAM1 kernel:        e4df5aa0 a2861773 003cb165
00008ac4 00000000 e4df5bac cb6126e0 e985a3c0
Jan 27 11:56:42 ECDCCAM1 kernel:        00000000 00000000 c0684a00
00000000 00000001 ddd07e70 00000001 ffffffff
Jan 27 11:56:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c05d2cb8>] ip_output+0x22e/0x266
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c046d9b2>] cache_alloc_refill+0x14b/0x450
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c042c2e0>] lock_timer_base+0x15/0x2f
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c042c3f1>] __mod_timer+0x99/0xa3
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:42 ECDCCAM1 kernel:  =======================
Jan 27 11:56:42 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20366
 2567         20367 20365 (NOTLB)
Jan 27 11:56:42 ECDCCAM1 kernel:        ddd3fe94 00200086 f6357f31
003cb171 00000040 c06a7400 ddd3feb4 0000000a
Jan 27 11:56:42 ECDCCAM1 kernel:        e4df5550 f635a888 003cb171
00002957 00000001 e4df565c cb6194c4 e985a3c0
Jan 27 11:56:42 ECDCCAM1 kernel:        ddd3feb4 00000000 00000200
00000040 ddd3fefc 00000200 ddd3fefc ffffffff
Jan 27 11:56:42 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:42 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:43 ECDCCAM1 kernel:  =======================
Jan 27 11:56:43 ECDCCAM1 kernel: httpd.worker  S 003CB171  2636 20367
 2567         20368 20366 (NOTLB)
Jan 27 11:56:43 ECDCCAM1 kernel:        f18ffe94 00200086 f572990e
003cb171 00000040 c06a7400 f18ffeb4 0000000a
Jan 27 11:56:43 ECDCCAM1 kernel:        e4df5000 f572d627 003cb171
00003d19 00000000 e4df510c cb6126e0 e985a3c0
Jan 27 11:56:43 ECDCCAM1 kernel:        f18ffeb4 00000000 00000200
00000040 f18ffefc 00000200 f18ffefc ffffffff
Jan 27 11:56:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:43 ECDCCAM1 kernel:  =======================
Jan 27 11:56:43 ECDCCAM1 kernel: httpd.worker  S 003CB151  2660 20368
 2567         20369 20367 (NOTLB)
Jan 27 11:56:43 ECDCCAM1 kernel:        d634ee94 00200086 a2077cf1
003cb151 00000040 c06a7400 d634eeb4 0000000a
Jan 27 11:56:43 ECDCCAM1 kernel:        d8957aa0 a2079ec6 003cb151
000021d5 00000000 d8957bac cb6126e0 e985a3c0
Jan 27 11:56:43 ECDCCAM1 kernel:        d634eeb4 00000000 00000200
00000040 d634eefc 00000200 d634eefc ffffffff
Jan 27 11:56:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c04710a3>] do_sync_read+0xb6/0xf1
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:43 ECDCCAM1 kernel:  =======================
Jan 27 11:56:43 ECDCCAM1 kernel: httpd.worker  S 003CB2C6  2660 20369
 2567         20370 20368 (NOTLB)
Jan 27 11:56:43 ECDCCAM1 kernel:        e1cd8e94 00200086 0af4865a
003cb2c6 c04563d3 007f2cef 00000000 0000000a
Jan 27 11:56:43 ECDCCAM1 kernel:        d8957550 0af7e35b 003cb2c6
00035d01 00000001 d895765c cb6194c4 e985a3c0
Jan 27 11:56:43 ECDCCAM1 kernel:        00000001 00000000 d5855368
00000060 00000060 00000000 e1cd8efc ffffffff
Jan 27 11:56:43 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c04563d3>]
__generic_file_aio_write_nolock+0x4a6/0x52a
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0438880>] do_futex+0x1d4/0xb5e
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0470fb2>] do_sync_write+0xb6/0xf1
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0486d37>] destroy_inode+0x36/0x45
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c043931b>] sys_futex+0x111/0x127
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:43 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:43 ECDCCAM1 kernel:  =======================
Jan 27 11:56:43 ECDCCAM1 kernel: httpd.worker  S 003CB2C5  3292 20370
 2567               20369 (NOTLB)
Jan 27 11:56:44 ECDCCAM1 kernel:        e7c65f58 00200086 fa3dc8aa
003cb2c5 da00765c 00200246 fffffff5 00000009
Jan 27 11:56:44 ECDCCAM1 kernel:        d8957000 fa3dd4ec 003cb2c5
00000c42 00000000 d895710c cb6126e0 e985a3c0
Jan 27 11:56:44 ECDCCAM1 kernel:        d54ccc50 00000000 f7054adc
f705489c 00000000 00402040 e7c65f6c ffffffff
Jan 27 11:56:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0484cf6>] fcntl_setlk+0x174/0x222
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0480c50>] sys_fcntl64+0x6f/0x80
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:44 ECDCCAM1 kernel:  =======================
Jan 27 11:56:44 ECDCCAM1 kernel: diskwatchclie S 003CB25A  2908 12685
 2653 12700               (NOTLB)
Jan 27 11:56:44 ECDCCAM1 kernel:        d04bff00 00000086 375c2686
003cb25a d0fb2408 d0fb23f8 00000000 00000004
Jan 27 11:56:44 ECDCCAM1 kernel:        f5255550 375c52a0 003cb25a
00002c1a 00000000 f525565c cb6126e0 d0fb23c0
Jan 27 11:56:44 ECDCCAM1 kernel:        d0fb23c0 080f59f4 00000000
d0fb23c0 00000000 00000000 d04bff08 da289e00
Jan 27 11:56:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0434baf>] prepare_to_wait+0x24/0x42
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:44 ECDCCAM1 kernel:  =======================
Jan 27 11:56:44 ECDCCAM1 kernel: diskwatchclie S 003CB25A  3404 12700
12685 12701               (NOTLB)
Jan 27 11:56:44 ECDCCAM1 kernel:        dfd4af54 00000086 3763c918
003cb25a fffacff8 ffffffff 7fffffff 00000002
Jan 27 11:56:44 ECDCCAM1 kernel:        f4c1caa0 37642690 003cb25a
00005d78 00000000 f4c1cbac cb6126e0 e985aac0
Jan 27 11:56:44 ECDCCAM1 kernel:        f4c1caa0 cb703700 00000004
ffffffff f4c1caa0 00000000 cb612b9c d643f550
Jan 27 11:56:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:44 ECDCCAM1 kernel:  =======================
Jan 27 11:56:44 ECDCCAM1 kernel: hdparm        R running  2188 12701
12700         12702       (L-TLB)
Jan 27 11:56:44 ECDCCAM1 kernel: grep          R running  3088 12702
12700               12701 (NOTLB)
Jan 27 11:56:44 ECDCCAM1 kernel: postmaster    R running  2056 12943
2304               12049 (NOTLB)
Jan 27 11:56:44 ECDCCAM1 kernel: crond         S 003CB2C6  2792 12946
 2370                     (NOTLB)
Jan 27 11:56:44 ECDCCAM1 kernel:        eeac4d34 00000082 0e4a77a9
003cb2c6 c05c6273 eeac4d04 c062eed2 00000009
Jan 27 11:56:44 ECDCCAM1 kernel:        eeaee550 0e4a8570 003cb2c6
00000dc7 00000002 eeaee65c cb6202a8 d0fb2740
Jan 27 11:56:44 ECDCCAM1 kernel:        c0405a89 00000000 00000004
ea8eac00 ea8eac00 bf97df1c cb6202ec ffffffff
Jan 27 11:56:44 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c05c6273>] netlink_sendskb+0x19/0x30
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c0405a89>] error_code+0x39/0x40
Jan 27 11:56:44 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c047f075>] link_path_walk+0xb3/0xbd
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0428929>] current_fs_time+0x4a/0x55
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c06061eb>] unix_find_other+0xc7/0x162
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0607afe>] unix_dgram_connect+0x6a/0x137
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0607b42>] unix_dgram_connect+0xae/0x137
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c05ab760>] sys_connect+0x7d/0xa9
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0480c5a>] sys_fcntl64+0x79/0x80
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:45 ECDCCAM1 kernel:  =======================
Jan 27 11:56:45 ECDCCAM1 kernel: mingetty      S 003CB2C5  3020 12947
    1         13032 12941 (NOTLB)
Jan 27 11:56:45 ECDCCAM1 kernel:        d0c83ee4 00000082 fa40977e
003cb2c5 00000004 00000000 c00b85be 00000007
Jan 27 11:56:45 ECDCCAM1 kernel:        eeaee000 fa4e1618 003cb2c5
000d7e9a 00000003 eeaee10c cb62708c f74a8c80
Jan 27 11:56:45 ECDCCAM1 kernel:        cb5f00ff 00000000 00000000
00000000 c0460e6e 00000000 00000082 ffffffff
Jan 27 11:56:45 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0460e6e>] __handle_mm_fault+0x453/0xb7b
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0434be9>] add_wait_queue+0x1c/0x28
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0533c76>] read_chan+0x32d/0x5a7
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0533949>] read_chan+0x0/0x5a7
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0530cde>] tty_read+0x5f/0xb4
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0530c7f>] tty_read+0x0/0xb4
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:45 ECDCCAM1 kernel:  =======================
Jan 27 11:56:45 ECDCCAM1 kernel: perl          S 003CB2C5  3404 12985
 2570 12987               (NOTLB)
Jan 27 11:56:45 ECDCCAM1 kernel:        d9590f54 00000082 fdbf2991
003cb2c5 fffacbf8 ffffffff 7fffffff 00000007
Jan 27 11:56:45 ECDCCAM1 kernel:        d281a550 fdbfc27a 003cb2c5
000098e9 00000000 d281a65c cb6126e0 f7f24740
Jan 27 11:56:45 ECDCCAM1 kernel:        d281a550 cb703700 00000000
000032bb d281a550 00000000 00000000 ea93daa0
Jan 27 11:56:45 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:56:45 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:46 ECDCCAM1 kernel:  =======================
Jan 27 11:56:46 ECDCCAM1 kernel: perfigo_sm    S 003CB2C6  2668 12987
12985 13042               (NOTLB)
Jan 27 11:56:46 ECDCCAM1 kernel:        e1d5cf54 00000086 0123a443
003cb2c6 00000000 c0403d29 01200011 00000003
Jan 27 11:56:46 ECDCCAM1 kernel:        ea93daa0 01240967 003cb2c6
00006524 00000002 ea93dbac cb6202a8 e985a900
Jan 27 11:56:46 ECDCCAM1 kernel:        ea93daa0 00000000 00000004
ffffffff ea93daa0 43a9d065 00000000 ffffffff
Jan 27 11:56:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0403d29>] copy_thread+0x2f/0x1e6
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:46 ECDCCAM1 kernel:  =======================
Jan 27 11:56:46 ECDCCAM1 kernel: pg_sync_peer  S 003CB2C6  2608 13042
12987 13109   13043       (NOTLB)
Jan 27 11:56:46 ECDCCAM1 kernel:        dbe4df54 00000082 0675c76a
003cb2c6 00000000 c0403d29 01200011 00000001
Jan 27 11:56:46 ECDCCAM1 kernel:        d41b1aa0 06769b1b 003cb2c6
0000d3b1 00000003 d41b1bac cb62708c d4b63040
Jan 27 11:56:46 ECDCCAM1 kernel:        d41b1aa0 00000000 00000004
ffffffff d41b1aa0 673ba065 00000000 ffffffff
Jan 27 11:56:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0403d29>] copy_thread+0x2f/0x1e6
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0426ae6>] do_wait+0x88e/0x97c
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c04e9401>] copy_to_user+0x31/0x48
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:46 ECDCCAM1 kernel:  =======================
Jan 27 11:56:46 ECDCCAM1 kernel: tee           S 003CB2C6  2992 13043
12987               13042 (NOTLB)
Jan 27 11:56:46 ECDCCAM1 kernel:        d7fb5f00 00000082 0126114d
003cb2c6 f7f4517c f4ce7a08 f7f450d4 00000002
Jan 27 11:56:46 ECDCCAM1 kernel:        d941a000 012d8226 003cb2c6
000770d9 00000002 d941a10c cb6202a8 d06c9040
Jan 27 11:56:46 ECDCCAM1 kernel:        cfcf9e48 00000000 d5438b74
d06c9040 00000000 fff76000 d7fb5f08 ffffffff
Jan 27 11:56:46 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c047bf08>] pipe_wait+0x57/0x78
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:46 ECDCCAM1 kernel:  [<c047c5f1>] pipe_readv+0x2b2/0x321
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c04628b9>] unmap_region+0xb8/0xf0
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c047c660>] pipe_read+0x0/0x1e
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c047c67a>] pipe_read+0x1a/0x1e
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c04719ac>] vfs_read+0x9f/0x141
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0471dfa>] sys_read+0x3c/0x63
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:47 ECDCCAM1 kernel:  =======================
Jan 27 11:56:47 ECDCCAM1 kernel: su            S 003CB2C6  2888 13109
13042                     (NOTLB)
Jan 27 11:56:47 ECDCCAM1 kernel:        eeac8d34 00000082 0d54de82
003cb2c6 c05c6273 eeac8d04 c062eed2 00000001
Jan 27 11:56:47 ECDCCAM1 kernel:        d5471550 0d570488 003cb2c6
00022606 00000002 d547165c cb6202a8 d0fb2040
Jan 27 11:56:47 ECDCCAM1 kernel:        c0405a89 00000000 00000004
eea89400 eea89400 bfa962dc eea89400 ffffffff
Jan 27 11:56:47 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05c6273>] netlink_sendskb+0x19/0x30
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0405a89>] error_code+0x39/0x40
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c060e1a9>] schedule_timeout+0x13/0x8c
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0434b42>]
prepare_to_wait_exclusive+0x27/0x45
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c060610c>] unix_wait_for_peer+0x7d/0x95
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c060662e>] unix_dgram_sendmsg+0x3a8/0x485
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05aa4e4>] sock_sendmsg+0xce/0xe8
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05aa3fb>] sock_recvmsg+0xe5/0x100
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0434a67>] autoremove_wake_function+0x0/0x2d
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c045f1ed>] do_wp_page+0x456/0x4a1
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05ab69c>] sys_sendto+0x116/0x140
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c04614f1>] __handle_mm_fault+0xad6/0xb7b
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05aec93>] skb_dequeue+0x39/0x3f
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05ab6df>] sys_send+0x19/0x1d
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c05abfa3>] sys_socketcall+0xed/0x19e
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:47 ECDCCAM1 kernel:  =======================
Jan 27 11:56:47 ECDCCAM1 kernel: udevd         S 003CB2C6  3296 13121
  490 13122   13124       (NOTLB)
Jan 27 11:56:47 ECDCCAM1 kernel:        eaa6df3c c060dae0 12cacdcd
003cb2c6 c042b45a eaa6df00 5c1b0e4c 00000001
Jan 27 11:56:47 ECDCCAM1 kernel:        cb70b550 12cb2098 003cb2c6
000052cb 00000001 f349810c cb6194c4 f74a8200
Jan 27 11:56:47 ECDCCAM1 kernel:        00000000 00000000 00000286
c0436e23 eaa6df6c ffffffff 00000001 00000286
Jan 27 11:56:47 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c060dae0>] schedule+0x9cc/0xa55
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c042b45a>] getnstimeofday+0x30/0xb6
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0436e23>] lock_hrtimer_base+0x19/0x35
Jan 27 11:56:47 ECDCCAM1 kernel:  [<c0436ec5>] hrtimer_try_to_cancel+0x3c/0x42
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0436ed5>] hrtimer_cancel+0xa/0x14
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c060f2ed>] _write_lock_irq+0xf/0x10
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0425fd7>] release_task+0x74/0x2f5
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c04268aa>] do_wait+0x652/0x97c
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c041e811>] default_wake_function+0x0/0xc
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0426bfb>] sys_wait4+0x27/0x2a
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0426c11>] sys_waitpid+0x13/0x17
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:48 ECDCCAM1 kernel:  =======================
Jan 27 11:56:48 ECDCCAM1 kernel: udev_run_hotp X 003CB2C6  2928 13122
13121                     (L-TLB)
Jan 27 11:56:48 ECDCCAM1 kernel:        e9760f7c 00000046 12dd5139
003cb2c6 f7d686dc 00000008 f7d685bc 00000001
Jan 27 11:56:48 ECDCCAM1 kernel:        f4c26000 12e79e8a 003cb2c6
000a4d51 00000001 f4c2610c cb6194c4 d06c93c0
Jan 27 11:56:48 ECDCCAM1 kernel:        c0489306 00000000 d542e840
c046fad5 d542e840 00000001 00000008 ffffffff
Jan 27 11:56:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c04273ef>] do_exit+0x78a/0x794
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c042746f>] sys_exit_group+0x0/0xd
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:48 ECDCCAM1 kernel:  =======================
Jan 27 11:56:48 ECDCCAM1 kernel: udevd         S 003CB2C6  3296 13124
  490 13125         13121 (NOTLB)
Jan 27 11:56:48 ECDCCAM1 kernel:        eeab3f3c 00000082 1305f399
003cb2c6 c042b45a eeab3f00 5c1b0e50 00000001
Jan 27 11:56:48 ECDCCAM1 kernel:        da792000 130646f4 003cb2c6
0000535b 00000001 da79210c cb6194c4 d0fb2c80
Jan 27 11:56:48 ECDCCAM1 kernel:        00000000 00000000 cb61a5f0
00000286 c0436f95 fa3fe719 007ccf91 ffffffff
Jan 27 11:56:48 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c042b45a>] getnstimeofday+0x30/0xb6
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0436f95>] hrtimer_start+0xb6/0xc0
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c060e5ba>] do_nanosleep+0x3c/0x6a
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0436fef>] hrtimer_nanosleep+0x50/0x106
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c061037b>] do_page_fault+0x2d2/0x600
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c06103f4>] do_page_fault+0x34b/0x600
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0436df2>] hrtimer_wakeup+0x0/0x18
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c04370e6>] sys_nanosleep+0x41/0x51
Jan 27 11:56:48 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:48 ECDCCAM1 kernel:  =======================
Jan 27 11:56:48 ECDCCAM1 kernel: udev_run_hotp X 003CB2C6  2928 13125
13124                     (L-TLB)
Jan 27 11:56:48 ECDCCAM1 kernel:        d6d4ef7c 00000046 130f2739
003cb2c6 f7d686dc 00000008 f7d685bc 00000001
Jan 27 11:56:48 ECDCCAM1 kernel:        cf99f550 13194d49 003cb2c6
000a2610 00000001 cf99f65c cb6194c4 e985a580
Jan 27 11:56:49 ECDCCAM1 kernel:        c0489306 00000000 cfc6f800
c046fad5 cfc6f800 00000001 00000008 ffffffff
Jan 27 11:56:49 ECDCCAM1 kernel: Call Trace:
Jan 27 11:56:49 ECDCCAM1 kernel:  [<c0489306>] mntput_no_expire+0x11/0x6a
Jan 27 11:56:49 ECDCCAM1 kernel:  [<c046fad5>] filp_close+0x4e/0x54
Jan 27 11:56:49 ECDCCAM1 kernel:  [<c04273ef>] do_exit+0x78a/0x794
Jan 27 11:56:49 ECDCCAM1 kernel:  [<c042746f>] sys_exit_group+0x0/0xd
Jan 27 11:56:49 ECDCCAM1 kernel:  [<c0404f17>] syscall_call+0x7/0xb
Jan 27 11:56:49 ECDCCAM1 kernel:  =======================
Jan 27 11:57:56 ECDCCAM1 logger: Sending SNMP alert: node became standby
