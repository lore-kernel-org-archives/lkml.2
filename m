Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0GMPyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:54:44 -0400
Received: from www.tglx.de ([62.245.132.106]:40945 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0GMPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:54:42 -0400
Date: Tue, 13 Jul 2010 17:54:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [ANNOUNCE] 2.6.33.6-rt26
In-Reply-To: <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1007131745230.3321@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain> <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
 <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
Changes from 2.6.33.5-rt23 to 2.6.33.5-rt24:

  42edbcb: gianfar: Fix TX ring processing on SMP machines
  faf3581: timer_stats: Convert table_lock to raw_spin_lock
  654e404: hvc_console: Fix race between hvc_close and hvc_remove
  09fd768: hvc_console: Fix race between hvc_close and hvc_remove
  ea2d2a0: perf: Fix errors path in perf_output_begin()
  60bd946: KEYS: find_keyring_by_name() can gain access to a freed keyring
  b5ac516: tracing: Update the comm field in the right variable in update_max_tr
  77cb7c1: lockdep: Reduce stack_trace usage
  cee9ee0: powerpc: Disable sparse irq for RT
  c7dec16: powerpc: Enable interrupts in do_signal()

Changes from 2.6.33.5-rt24 to 2.6.33.5-rt25:

  ec646ea: vfs: Revert the scalability patches

Changes from 2.6.33.5-rt26 to 2.6.33.6-rt26:

  7e1af11: Merge git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y

Bulk of changes comes from the stable tree and from the big revert of
the VFS scalability patches. They looked promising, but the nasty
details bit us hard. We'll revisit them later.

There are some pending issues:
      - rtc_lock suspend/resume (working on a patch)
      - futex requeue_pi (patch available, needs testing/confirmation)
      - powerpc64 oddities (patch available, needs rework)

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

To build the 2.6.33.6-rt26 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.6.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.6-rt26.bz2

Enjoy !

      tglx
