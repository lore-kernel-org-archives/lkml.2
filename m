Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab0EFA2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 20:28:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47055 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0EFA2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 20:28:41 -0400
Date: Wed, 5 May 2010 17:28:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] Additional RCU fixes for 2.6.34
Message-ID: <20100506002838.GA31818@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are three more RCU-lockdep fixes for 2.6.34:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

							Thanx, Paul

------------------>
Vivek Goyal <vgoyal@redhat.com> (1)
	blk-cgroup: Fix RCU correctness warning in cfq_init_queue()

Paul E. McKenney <paulmck@linux.vnet.ibm.com> (2)
	vfs: fix RCU-lockdep false positive due to /proc access
	memcg: css_id() must be called under rcu_read_lock()

 block/cfq-iosched.c      |    2 ++
 include/linux/fdtable.h  |    3 ++-
 include/linux/rcupdate.h |   11 +++++++++++
 kernel/rcupdate.c        |   11 +++++++++++
 mm/memcontrol.c          |   21 ++++++++++++++++-----
 5 files changed, 42 insertions(+), 6 deletions(-)
