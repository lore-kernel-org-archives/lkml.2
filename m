Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3AERJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:09:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49012 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3AERJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:09:46 -0500
Date: Sat, 5 Jan 2013 09:09:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/6] RCU fixes for 3.9
Message-ID: <20130105170920.GA13766@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-2876-0000-0000-000003CFAA2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following fixes are intended for 3.9:

1.	Fix int/long type confusion in trace_rcu_start_batch().
2.	Declare rcu_is_cpu_rrupt_from_idle() static, courtesy of
	Josh Triplett.
3.	Make rcu_eqs_enter_common() trace the new nesting value instead
	of zero, courtesy of Li Zhong.
4.	Silence a gcc array-out-of-bounds false positive in rcu_init_one().
5.	Code style fix in rcu_torture_barrier_init(), courtesy of Sasha Levin.

								Thanx, Paul


 b/include/trace/events/rcu.h |    6 +++---
 b/kernel/rcutiny.c           |    2 +-
 b/kernel/rcutorture.c        |    2 +-
 b/kernel/rcutree.c           |   10 +++++++---
 4 files changed, 12 insertions(+), 8 deletions(-)

