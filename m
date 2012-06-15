Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2FOS55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:57:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49841 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2FOS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:57:56 -0400
Date: Fri, 15 Jun 2012 11:57:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/6] rcutorture and documentation patches for 3.6
Message-ID: <20120615185725.GA25163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061518-6148-0000-0000-000006BC9D10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series updates documentation and rcutorture:

1.	Update documentation to allow for the new call_srcu() and
	srcu_barrier() functions.
2.	Fix ordering of the torture_ops list.
3.	Make rcutorture actually test the new srcu_barrier() function.
4.	Fix synchronization of the kthreads testing the various
	rcu_barrier() functions.
5.	Fix an incorrect (and quite confusing) message in rcutorture.
6.	Make rcutorture's fakewriters occasionally invoke the appropriate
	rcu_barrier() function so that we test concurrent rcu_barrier()
	calls.

							Thanx, Paul

 b/Documentation/RCU/checklist.txt  |   39 ++++++++++++++++++-------------------
 b/Documentation/RCU/rcubarrier.txt |    6 +++--
 b/Documentation/RCU/torture.txt    |    9 ++++++++
 b/Documentation/RCU/whatisRCU.txt  |    6 ++---
 b/kernel/rcutorture.c              |    4 +--
 kernel/rcutorture.c                |   32 ++++++++++++++++++++++++------
 6 files changed, 64 insertions(+), 32 deletions(-)

