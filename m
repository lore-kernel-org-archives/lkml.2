Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0GaNdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 09:33:10 -0400
Received: from www.tglx.de ([62.245.132.106]:40492 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0GaNdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 09:33:07 -0400
Date: Sat, 31 Jul 2010 15:33:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 2.6.33.6-rt27
In-Reply-To: <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1007311530510.2471@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain> <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
 <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain> <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
Changes from 2.6.33.6-rt26 to 2.6.33.6-rt27:

 d2decbf: v2.6.33.6-rt27
 d972e60: UIO: Add a driver for Hilscher netX-based fieldbus cards
 911d28c: dca: Fix fallout from raw_spinlock conversion
 59fdcc0: powerpc: cpu-hotplug: Prevent softirq wakeup on wrong CPU
 5805f5a: drivers/dca: Convert dca_lock to a raw spinlock
 96c5397: cpu-hotplug: Prevent softirq wakeup on wrong CPU
 8e7dbdf: cpu-hotplug: Don't wake up the desched thread from idle_task_exit()
 5706af4: x86: mce: Convert cmci_discover_lock to raw_spinlock
 5bbbedc: net: iptables: Fix xt_info locking
 60f778f: suspend: Prevent might sleep splats
 19491de: futex: Protect against pi_blocked_on corruption during requeue PI
 d69f558: sched: Fix TASK_WAKING vs fork deadlock
 111abc8: sched: Make select_fallback_rq() cpuset friendly
 bb8eef7: sched: _cpu_down(): Don't play with current->cpus_allowed
 a325588: sched: sched_exec(): Remove the select_fallback_rq() logic
 2d5a7c7: sched: move_task_off_dead_cpu(): Remove retry logic
 ae35e6f: sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
 a1e0f4a: sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
 dd56c23: sched: set_cpus_allowed_ptr(): Don't use rq->migration_thread after unlock


Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

To build the 2.6.33.6-rt27 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.6.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.6-rt27.bz2

Enjoy !

      tglx

