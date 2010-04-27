Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0D0Pw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:52:28 -0400
Received: from www.tglx.de ([62.245.132.106]:39609 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab0D0Pw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:52:26 -0400
Date: Tue, 27 Apr 2010 17:52:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       John Stultz <johnstul@us.ibm.com>
Subject: [ANNOUNCE] 2.6.33.3-rt16
In-Reply-To: <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
I pushed out rt14 and rt15 w/o a release mail, so here are the change
logs from rt13 to rt16
  
Changes from rt13 to rt14
 846bcf3: Merge 2.6.33.3
 863c3ad: net: Fix iptables get_counters()

Changes from rt14 to rt15
 510cc22: net: gianfar: More RT fixups
 923499c: rtmutex: Preserve TASK_STOPPED state when blocking on a "spin_lock"
 1268870: powerpc: Replace kmap_atomic with kmap in pte_offset_map

Changes from rt15 to rt16
 That's the long awaited merge of Nick's VFS scalability
 patches. Thanks to Nick and John for keeping it up to date and fixing
 the problems which we observed with earlier versions.

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

To build the 2.6.33.3-rt16 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.3.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.3-rt16.bz2

Enjoy !

      tglx
