Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0EFU07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:26:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51223 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab0EFU06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:26:58 -0400
Date: Thu, 6 May 2010 13:26:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] One more additional RCU fix for 2.6.34
Message-ID: <20100506202646.GA4903@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again, Ingo,

Here is one more commit with the RCU infrastructure for an RCU-lockdep
fix in vfs.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

The actual fix in vfs will be sent to the vfs folks once the above commit
hits mainline.  In the meantime, I am carrying the vfs commit in my -rcu
tree as branch vfs.2010.05.06a.

							Thanx, Paul

------------------>
Paul E. McKenney <paulmck@linux.vnet.ibm.com> (1)
	rcu: create rcu_my_thread_group_empty() wrapper

 include/linux/rcupdate.h |    2 --
 kernel/rcupdate.c        |   11 -----------
 2 files changed, 13 deletions(-)
