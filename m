Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1HLMqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 08:46:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44857 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1HLMqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 08:46:33 -0400
Subject: [ANNOUNCE] 3.0.1-rt9
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 12 Aug 2011 14:46:06 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313153166.6576.36.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yay!! another -rt kernel..


Changes include:

 - fixes so that PREEMPT_LL and PREEMPT_RTB kernels actually build
   and boot, thanks to Tim Sanders for persisting on that.
 - removed the removal of the export of of_find_property, spotted by Uwe
 - added a few more patches that mostly clean up migrate_disable()
   and pagefault_disable() bits.


The patch is at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0.1-rt9.patch.bz2

The quilt series can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt9.tar.bz2

