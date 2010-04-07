Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0DGOYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:24:48 -0400
Received: from www.tglx.de ([62.245.132.106]:60881 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab0DGOYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:24:47 -0400
Date: Wed, 7 Apr 2010 16:24:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>, Wu Zhangjin <wuzhangjin@gmail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [ANNOUNCE] 2.6.33.2-rt13
In-Reply-To: <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cWe are pleased to announce the next update to our new preempt-rt
series.

I pushed out rt12 w/o a release mail, so here is the change log from
rt11 to rt13
 
Changes from rt11 to rt12
  35b5256: x86: Fix irq off tracing for 32 bit
  6e331ac: net: gianfar: Make RT aware
  ac4d7f0: Merge 2.6.33.2 into -RT

Changes from rt12 to rt13
  b2c877a: mqueue: Convert message queue timeout to use hrtimers
  3c3016f: hrtimers: Provide schedule_hrtimeout for CLOCK_REALTIME
  d980cb7: raid5: Make raid5_percpu handling RT aware
  e86d615: powerpc: Convert uic->lock to raw_spinlock

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
 
To build the 2.6.33.2-rt13 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.2.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.2-rt13.bz2

Enjoy !

      tglx

