Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2CBRBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:01:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:43936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936Ab2CBRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:01:14 -0500
Date: Fri, 2 Mar 2012 18:01:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.2.9-rt15
Message-ID: <alpine.LFD.2.02.1203021743040.2742@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.2.9-rt15 release. There have been a few
not announced intermediate releases which are mostly updates to the
stable tree.

Changes vs. 3.2.9-rt14:

  * seqlock/seqcount live lock fixes 

    	This is a rather massive change, which fixes live locks in the
    	fs code and elsewhere.

  * acpi raw spinlock annotations reverted

    	The raw spinlock conversions cause trouble in the ACPI
    	interrupt handler code and we have no idea why we did that
    	conversion in the first place :(

	So with this revert we hopefully get reports for the initial
	problem so we can look at that for a less problematic fix.

  * Hotplug fixes [Steven Rostedt]

    	This is most of the series Steven posted yesterday. I left out
    	the hotplug core changes as we really need to come up with a
    	less ugly solution for that.
  
  * Futex deadlock fix [Steven Rostedt]

  * Ringbuffer irq disabled check [Steven Rostedt]
	
  * Scheduler state check fix [Steven Rostedt]


The incremental patch against 3.2.9-rt14 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.9-rt14-rt15.patch.xz


The RT patch against 3.2.9 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.9-rt15.patch.xz


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patches-3.2.9-rt15.tar.xz


Enjoy,

	tglx
