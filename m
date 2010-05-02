Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab0EBTSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 15:18:54 -0400
Received: from www.tglx.de ([62.245.132.106]:56767 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0EBTSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 15:18:52 -0400
Date: Sun, 2 May 2010 21:18:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
Subject: [ANNOUNCE] 2.6.33.3-rt19
In-Reply-To: <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain> <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain> <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain> <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain> <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

Changes from 2.6.33.3-rt17 to 2.6.33.3-rt18:

 edf9d4b5: tclib: Default to tclib timer for RT
 917c377: Atmel TCLIB: Allow higher clock rates for clock events
 b16bd4f: AT91: PIT: Remove irq handler when clock event is unused
 360c3e7: fs: Prevent dput race
 
Changes from 2.6.33.3-rt18 to 2.6.33.3-rt19:

 4b40e94: sched: Warn on rt throttling
 dc15be1: init: Fix config items in debug reminder finally

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

To build the 2.6.33.3-rt19 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.3.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.3-rt19.bz2

Enjoy !

      tglx
