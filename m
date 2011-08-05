Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1HEVo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:44:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:43014 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1HEVow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:44:52 -0400
Subject: [ANNOUNCE] 3.0.1-rt8
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 05 Aug 2011 23:44:41 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312580681.28695.44.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since yesterday is old, and yesterday's kernels aren't interesting,
here's a fresh one: 3.0.1-rt8.

Aside from the obvious rebase to 3.0.1 changes include:

 - a fix from Rostedt for his cpupri rework involving memory ordering
 - a fix from me regarding this highmem muck, seeing as I mostly
   wrecked things last time around :-)
 - some lockdep annotations from upstream for things people were
   seeing here as well
 - a patch from Clark adding a sysfs file to recognize a PREEMP_RT
   kernel for udev -- is there really no saner solution !?
 - and a fresh raw_spinlock_t conversion of cpufreq_driver_lock, done
   just minutes before releasing this, to keep life interesting.

Still working on the known issues from last time..

The patch is at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0.1-rt8.patch.bz2

The quilt series can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt8.tar.bz2

Once kernel.org mirrors catch up that is..
