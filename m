Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2ELOHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 10:07:11 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:55574 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2ELOHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 10:07:10 -0400
X-Greylist: delayed 3511 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 May 2012 10:07:09 EDT
Message-ID: <4FAE60D2.8010308@xs4all.nl>
Date: Sat, 12 May 2012 15:08:34 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: INFO: rcu_bh detected stall on CPU x (t=0 jiffies)
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found a number of these messages in my messages files.
They have a format of:
'INFO: rcu_bh detected stall on CPU x (t=0 jiffies)'
where 'x' may vary (0-3).
This is on an AMD x86_64 box with a kernel.org kernel with minimal patching.
I do not yet know of any correlation with other observations of this box.

How can we eliminate these stall warnings?

Kind regards,
Udo

May 12 11:45:12 bb3 kernel: INFO: rcu_bh detected stall on CPU 3 (t=0
jiffies)
May 12 11:45:12 bb3 kernel: Pid: 3574, comm: plugin-containe Not tainted
3.3.4 #5
May 12 11:45:12 bb3 kernel: Call Trace:
May 12 11:45:12 bb3 kernel: <IRQ>  [<ffffffff8109887b>] ?
__rcu_pending+0x16b/0x3f0
May 12 11:45:12 bb3 kernel: [<ffffffff810713c0>] ?
tick_nohz_handler+0xe0/0xe0
May 12 11:45:12 bb3 kernel: [<ffffffff8109901b>] ?
rcu_check_callbacks+0xfb/0x170
May 12 11:45:12 bb3 kernel: [<ffffffff81042fce>] ?
update_process_times+0x3e/0x80
May 12 11:45:12 bb3 kernel: [<ffffffff8107141a>] ?
tick_sched_timer+0x5a/0xb0
May 12 11:45:12 bb3 kernel: [<ffffffff81055720>] ? __run_hrtimer+0x60/0x140
May 12 11:45:12 bb3 kernel: [<ffffffff8105602d>] ?
hrtimer_interrupt+0xed/0x200
May 12 11:45:12 bb3 kernel: [<ffffffff8101b063>] ?
smp_apic_timer_interrupt+0x63/0xa0
May 12 11:45:12 bb3 kernel: [<ffffffff8140068b>] ?
apic_timer_interrupt+0x6b/0x70
May 12 11:45:12 bb3 kernel: <EOI>  [<ffffffff813ffc22>] ?
system_call_fastpath+0x16/0x1b

May 10 16:40:18 bb3 kernel: INFO: rcu_bh detected stall on CPU 3 (t=0
jiffies)
May 10 16:40:18 bb3 kernel: Pid: 12236, comm: plugin-containe Not
tainted 3.3.4 #5
May 10 16:40:18 bb3 kernel: Call Trace:
May 10 16:40:18 bb3 kernel: <IRQ>  [<ffffffff8109887b>] ?
__rcu_pending+0x16b/0x3f0
May 10 16:40:18 bb3 kernel: [<ffffffff810713c0>] ?
tick_nohz_handler+0xe0/0xe0
May 10 16:40:18 bb3 kernel: [<ffffffff8109901b>] ?
rcu_check_callbacks+0xfb/0x170
May 10 16:40:18 bb3 kernel: [<ffffffff81042fce>] ?
update_process_times+0x3e/0x80
May 10 16:40:18 bb3 kernel: [<ffffffff8107141a>] ?
tick_sched_timer+0x5a/0xb0
May 10 16:40:18 bb3 kernel: [<ffffffff81055720>] ? __run_hrtimer+0x60/0x140
May 10 16:40:18 bb3 kernel: [<ffffffff8105602d>] ?
hrtimer_interrupt+0xed/0x200
May 10 16:40:18 bb3 kernel: [<ffffffff8101b063>] ?
smp_apic_timer_interrupt+0x63/0xa0
May 10 16:40:18 bb3 kernel: [<ffffffff8140068b>] ?
apic_timer_interrupt+0x6b/0x70
May 10 16:40:18 bb3 kernel: <EOI>  [<ffffffff813ffc22>] ?
system_call_fastpath+0x16/0x1b

Apr 28 16:54:31 bb3 kernel: INFO: rcu_bh detected stall on CPU 2 (t=0
jiffies)
Apr 28 16:54:31 bb3 kernel: Pid: 4939, comm: gnome-shell Not tainted
3.3.4 #4
Apr 28 16:54:31 bb3 kernel: Call Trace:
Apr 28 16:54:31 bb3 kernel: <IRQ>  [<ffffffff8109887b>] ?
__rcu_pending+0x16b/0x3f0
Apr 28 16:54:31 bb3 kernel: [<ffffffff810713c0>] ?
tick_nohz_handler+0xe0/0xe0
Apr 28 16:54:31 bb3 kernel: [<ffffffff8109901b>] ?
rcu_check_callbacks+0xfb/0x170
Apr 28 16:54:31 bb3 kernel: [<ffffffff81042fce>] ?
update_process_times+0x3e/0x80
Apr 28 16:54:31 bb3 kernel: [<ffffffff8107141a>] ?
tick_sched_timer+0x5a/0xb0
Apr 28 16:54:31 bb3 kernel: [<ffffffff81055720>] ? __run_hrtimer+0x60/0x140
Apr 28 16:54:31 bb3 kernel: [<ffffffff8105602d>] ?
hrtimer_interrupt+0xed/0x200
Apr 28 16:54:31 bb3 kernel: [<ffffffff8101b063>] ?
smp_apic_timer_interrupt+0x63/0xa0
Apr 28 16:54:31 bb3 kernel: [<ffffffff81400a0b>] ?
apic_timer_interrupt+0x6b/0x70
Apr 28 16:54:31 bb3 kernel: <EOI>  [<ffffffff813fffa2>] ?
system_call_fastpath+0x16/0x1b

Apr 21 08:15:13 bb3 kernel: INFO: rcu_bh detected stall on CPU 3 (t=0
jiffies)
Apr 21 08:15:13 bb3 kernel: Pid: 21862, comm: plugin-containe Tainted: G
       W    3.3.1 #1
Apr 21 08:15:13 bb3 kernel: Call Trace:
Apr 21 08:15:13 bb3 kernel: <IRQ>  [<ffffffff8109877b>] ?
__rcu_pending+0x16b/0x3f0
Apr 21 08:15:13 bb3 kernel: [<ffffffff810711f0>] ?
tick_nohz_handler+0xe0/0xe0
Apr 21 08:15:13 bb3 kernel: [<ffffffff81098f1b>] ?
rcu_check_callbacks+0xfb/0x170
Apr 21 08:15:13 bb3 kernel: [<ffffffff81042fae>] ?
update_process_times+0x3e/0x80
Apr 21 08:15:13 bb3 kernel: [<ffffffff8107124a>] ?
tick_sched_timer+0x5a/0xb0
Apr 21 08:15:13 bb3 kernel: [<ffffffff81055590>] ? __run_hrtimer+0x60/0x140
Apr 21 08:15:13 bb3 kernel: [<ffffffff81055e9d>] ?
hrtimer_interrupt+0xed/0x200
Apr 21 08:15:13 bb3 kernel: [<ffffffff8101b053>] ?
smp_apic_timer_interrupt+0x63/0xa0
Apr 21 08:15:13 bb3 kernel: [<ffffffff8140084b>] ?
apic_timer_interrupt+0x6b/0x70
Apr 21 08:15:13 bb3 kernel: <EOI>  [<ffffffff813ffde2>] ?
system_call_fastpath+0x16/0x1b

Apr 15 11:20:02 bb3 kernel: INFO: rcu_bh detected stall on CPU 0 (t=0
jiffies)
Apr 15 11:20:02 bb3 kernel: Pid: 4691, comm: plugin-containe Not tainted
3.3.1 #1
Apr 15 11:20:02 bb3 kernel: Call Trace:
Apr 15 11:20:02 bb3 kernel: <IRQ>  [<ffffffff8109877b>] ?
__rcu_pending+0x16b/0x3f0
Apr 15 11:20:02 bb3 kernel: [<ffffffff810711f0>] ?
tick_nohz_handler+0xe0/0xe0
Apr 15 11:20:02 bb3 kernel: [<ffffffff81098f1b>] ?
rcu_check_callbacks+0xfb/0x170
Apr 15 11:20:02 bb3 kernel: [<ffffffff81042fae>] ?
update_process_times+0x3e/0x80
Apr 15 11:20:02 bb3 kernel: [<ffffffff8107124a>] ?
tick_sched_timer+0x5a/0xb0
Apr 15 11:20:02 bb3 kernel: [<ffffffff81055590>] ? __run_hrtimer+0x60/0x140
Apr 15 11:20:02 bb3 kernel: [<ffffffff81055e9d>] ?
hrtimer_interrupt+0xed/0x200
Apr 15 11:20:02 bb3 kernel: [<ffffffff8101b053>] ?
smp_apic_timer_interrupt+0x63/0xa0
Apr 15 11:20:02 bb3 kernel: [<ffffffff8140084b>] ?
apic_timer_interrupt+0x6b/0x70
Apr 15 11:20:02 bb3 kernel: <EOI>  [<ffffffff813ffde2>] ?
system_call_fastpath+0x16/0x1b

Apr 12 17:59:35 bb3 kernel: INFO: rcu_bh detected stall on CPU 3 (t=0
jiffies)
Apr 12 17:59:35 bb3 kernel: Pid: 23600, comm: plugin-containe Not
tainted 3.3.1 #1
Apr 12 17:59:35 bb3 kernel: Call Trace:
Apr 12 17:59:35 bb3 kernel: <IRQ>  [<ffffffff8109877b>] ?
__rcu_pending+0x16b/0x3f0
Apr 12 17:59:35 bb3 kernel: [<ffffffff813fef71>] ?
_raw_spin_unlock+0x11/0x30
Apr 12 17:59:35 bb3 kernel: [<ffffffff810711f0>] ?
tick_nohz_handler+0xe0/0xe0
Apr 12 17:59:35 bb3 kernel: [<ffffffff81098f1b>] ?
rcu_check_callbacks+0xfb/0x170
Apr 12 17:59:35 bb3 kernel: [<ffffffff81042fae>] ?
update_process_times+0x3e/0x80
Apr 12 17:59:35 bb3 kernel: [<ffffffff8107124a>] ?
tick_sched_timer+0x5a/0xb0
Apr 12 17:59:35 bb3 kernel: [<ffffffff81055590>] ? __run_hrtimer+0x60/0x140
Apr 12 17:59:35 bb3 kernel: [<ffffffff81055e9d>] ?
hrtimer_interrupt+0xed/0x200
Apr 12 17:59:35 bb3 kernel: [<ffffffff8101b053>] ?
smp_apic_timer_interrupt+0x63/0xa0
Apr 12 17:59:35 bb3 kernel: [<ffffffff8140084b>] ?
apic_timer_interrupt+0x6b/0x70
Apr 12 17:59:35 bb3 kernel: <EOI>  [<ffffffff813ffde2>] ?
system_call_fastpath+0x16/0x1b



