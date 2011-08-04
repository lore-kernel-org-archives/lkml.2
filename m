Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1HDNyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:54:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:55404 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1HDNyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:54:09 -0400
Subject: [ANNOUNCE] 3.0-rt7
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Aug 2011 15:53:10 +0200
Message-ID: <1312465990.16729.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With Thomas enjoying his well earned holidays, I hereby present you with
3.0-rt7.

Goodies included since last time:

 - some raw_spinlock patch from Uwe.
 - cpupri rework from Rostedt, something which should greatly benefit
   everybody with smp hardware, the more cpus the more benefit.
 - a possible fix for some posix timer splat reported by Fernando.
 - i386-highmem support because I'd already written the code anyway
   so I thought I might as well make it work.

I'll take patches implementing similar highmem muck on other arches, if
there's any code to be shared between the arches, do so.

Patches live at the usual location, single patch:

 http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt7.patch.bz2

quilt series tarball:

 http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt7.tar.bz2

If your favourite patch isn't included, make sure it landed in my inbox,
or better yet make it land there again.

Known issues I still have to look at is some posix test fail from der
Hofrat and the ever fun pile of CGROUP_RT.

Enjoy!
