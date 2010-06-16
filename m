Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab0FPEW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:22:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33076 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0FPEW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:22:27 -0400
Date: Tue, 15 Jun 2010 21:22:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, daniel.blueman@gmail.com,
       lizf@cn.fujitsu.com, miles.lane@gmail.com, manfred@colorfullife.com
Subject: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
Message-ID: <20100616042224.GA3892@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are a few more fixes for RCU-lockdep splats.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

This is based off of v2.6.35-rc3.

							Thanx, Paul

------------------>
Daniel J Blueman (1):
      rcu: fix lockdep splat in wake_affine()

Paul E. McKenney (2):
      rcu: fix scope of wake_affine()'s new RCU read-side critical section
      idr: fix RCU lockdep splat in idr_get_next()

 kernel/sched_fair.c |    2 ++
 lib/idr.c           |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)
