Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2H3SpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:45:06 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40138 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2H3SpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:45:04 -0400
Date: Thu, 30 Aug 2012 11:44:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/5] Documentation and rcutorture changes
Message-ID: <20120830184448.GA31753@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-7408-0000-0000-0000080A581E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series covers changes to rcutorture and documentation updates.
The individual patches in this series are as follows:

1.	Update rcutorture default values so that casual rcutorture
	users will do more aggressive testing.
2.	Make rcutorture track CPU-hotplug latency statistics.
3.	Document SRCU's new-found ability to be used by offline and
	idle CPUs, and also emphasize SRCU's limitations.
4.	Use the new pr_*() interfaces in rcutorture.
5.	Prevent kthread-initialization races in rcutorture.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/checklist.txt |    6 +
 b/Documentation/RCU/whatisRCU.txt |    9 +-
 b/kernel/rcutorture.c             |    4 -
 kernel/rcutorture.c               |  152 +++++++++++++++++++++++---------------
 4 files changed, 108 insertions(+), 63 deletions(-)

