Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1EBVmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:42:14 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50337 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918Ab1EBVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:36:52 -0400
Date: Mon, 2 May 2011 09:13:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/7] More uses of kfree_rcu
Message-ID: <20110502161321.GA6537@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset replaces call_rcu() with kfree_rcu() in a few more places.

							Thanx, Paul

 include/net/sock.h              |    4 +---
 kernel/sysctl.c                 |   11 +++--------
 net/batman-adv/gateway_client.c |   10 +---------
 net/batman-adv/originator.c     |   10 +---------
 net/batman-adv/soft-interface.c |   10 +---------
 net/core/filter.c               |   12 ------------
 net/ipv6/sit.c                  |    7 +------
 net/netfilter/xt_RATEEST.c      |    8 +-------
 8 files changed, 9 insertions(+), 63 deletions(-)
