Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0FOW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:29:28 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45279 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0FOW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:29:27 -0400
Date: Tue, 15 Jun 2010 15:29:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/rcu/urgent 0/3] Fix more lockdep-RCU splats
Message-ID: <20100615222923.GA14571@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Three patches to fix RCU-lockdep splats in wake_affine and idr_get_next().

								Thanx, Paul

 b/kernel/sched_fair.c |    2 ++
 b/lib/idr.c           |    4 ++--
 kernel/sched_fair.c   |    2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)
