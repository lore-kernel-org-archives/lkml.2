Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0CULHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 07:07:19 -0400
Received: from www.tglx.de ([62.245.132.106]:56458 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0CULHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 07:07:16 -0400
Date: Sun, 21 Mar 2010 12:06:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>, Wu Zhangjin <wuzhangjin@gmail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [ANNOUNCE] 2.6.33.1-rt11
In-Reply-To: <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

I pushed out a bunch of updates while traveling w/o a release mail, so
here is the change log from rt6 to rt11

Changes from rt10 to rt11
318e45e: sched: Fix pick_next_highest_task_rt() for cgroups
6d79084: ARM: Eliminate decompressor -Dstatic= PIC hack

Changes from rt9 to rt10
e89fab2: x86: Fix the highmem fallout really

Changes from rt8 to rt9
Update to 2.6.33.1, see http://lwn.net/Articles/378613/

Changes from rt7 to rt8
5d2740b: sched: Break out from load_balancing on rq_lock contention
cd4ac9b: x86: Fix iomap_atomic with highmem=y again

Changes from rt6 to rt7
2c5f66a: Revert "Loongson: add a new option FUJITSU_QUIRKS"

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git development branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page
 
To build the 2.6.33-rt11 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.1.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.1-rt11.bz2

Enjoy !

      tglx
