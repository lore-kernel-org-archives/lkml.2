Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3AEQ6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 11:58:42 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54911 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab3AEQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 11:58:40 -0500
Date: Sat, 5 Jan 2013 08:58:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/urgent] no-CB CPU changes for 3.8
Message-ID: <20130105165817.GA13260@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010516-5806-0000-0000-00001DD57ED0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains a couple of fixes to the no-CBs CPU feature,
both courtesy of Paul Gortmaker:

1.	Prevent soft-lockup complaints from no-CBs kthreads.
2.	Make rcu_nocb_poll and early_param instead of a module parameter.

There is probably at least one more fix in this area.

							Thanx, Paul

 b/Documentation/kernel-parameters.txt |    2 +-
 b/kernel/rcutree_plugin.h             |   13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

