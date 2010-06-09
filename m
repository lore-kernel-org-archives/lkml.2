Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0FIQoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:44:11 -0400
Received: from www.tglx.de ([62.245.132.106]:34122 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab0FIQoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:44:09 -0400
Date: Wed, 9 Jun 2010 18:44:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [ANNOUNCE] 2.6.33.5-rt23
In-Reply-To: <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain> <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
Changes from 2.6.33.3-rt19 to 2.6.33.4-rt20:

  5b6c7b0: net: Make [dis/en]able_irq_*_lockdep() RT safe
  d6434af: fs: Resolve mntput_no_expire issues.
  56e4c7f: fs: Fix mnt_count typo
  1540c84: Merge branch '2.6.33.4' into rt/2.6.33
  1a3a403: autofs4: Remove another autofs4_lock deadlock
  6b568a0: autofs: Remove deadlock
  c54c071: fs: Add missing parantheses

Changes from 2.6.33.4-rt20 to 2.6.33.4-rt21:

  cc4a826: sched: Fix wake_affine() vs RT tasks
  ea17fed: printk: Fix missing klogd wakeup
  9846da2: fix undefined references to kernel_sem
  e868252: fs: namespace: Fix fuse mount fallout
  44b341a: net: ehea: make rx irq handler non-threaded (IRQF_NODELAY)

Changes from 2.6.33.4-rt21 to 2.6.33.5-rt22:

  ef4afcc: Merge stable/linux-2.6.33.y into rt/2.6.33

Changes from 2.6.33.5-rt22 to 2.6.33.5-rt23:

  ab774e8: drivers/hwmon/coretemp.c: get TjMax value from MSR
  e8bfcca: drivers/hwmon/coretemp.c: detect the thermal sensors by CPUID
  a06a867: dcache: Prevent d_genocide() from decrementing d_count more than once
  bdeadaf: nfs: Avoid igrab deadlock.
  6976846: dcache: Fix select_parent dentry traversal locking
  1f0f6ec: powerpc: chrp/time.c fix preprocessor conditional

Bulk of changes comes from stable tree. The -rt related changes are
mostly fixes for the vfs fallout the rest are fixlets all over the
place and hardware enablement.

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

To build the 2.6.33.5-rt23 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.5.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.5-rt23.bz2

Enjoy !

      tglx

