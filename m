Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab1HMKxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 06:53:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1HMKxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 06:53:35 -0400
Subject: [ANNOUNCE] 3.0.1-rt11
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Date: Sat, 13 Aug 2011 12:53:10 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313232790.25267.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Whee, I can skip release announcements too!

So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
grabs.

Changes include (including the missing -rt10):

  - hrtimer fix that should make RT_GROUP work again
  - RCU fixes that should make the RCU stalls go away
  - fixes SMP=n builds after breaking them in -rt9


The patch should be at (once the mirrors catch up):

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0.1-rt11.patch.bz2

The quilt series can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2


