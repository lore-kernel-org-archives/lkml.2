Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967471Ab2EQWNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:13:06 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46493 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab2EQWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:13:03 -0400
Date: Thu, 17 May 2012 15:12:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/2] Code-style fixes
Message-ID: <20120517221217.GA12196@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051722-7408-0000-0000-000005213F0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series fixes some historical code-style issues in RCU:

1.	If any branch of an if-then-else uses curly brackets, then
	all branches are supposed to.
2.	One exception to the 80-column rule is strings, which are
	not supposed to be broken across lines in deference to
	people attempting to find error messages printed by the
	kernel.

							Thanx, Paul


 b/include/linux/rcupdate.h |    3 +--
 b/kernel/rcutiny_plugin.h  |    3 ++-
 b/kernel/rcutorture.c      |    3 ++-
 b/kernel/rcutree.c         |    7 ++++---
 b/kernel/rcutree_plugin.h  |   18 ++++++++++--------
 b/kernel/rcutree_trace.c   |   25 ++++++++++++-------------
 b/lib/list_debug.c         |    6 ++----
 kernel/rcutorture.c        |   33 ++++++++++++++-------------------
 8 files changed, 47 insertions(+), 51 deletions(-)

