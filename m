Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab1AMTEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:04:24 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35633 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192Ab1AMTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 14:04:22 -0500
Date: Thu, 13 Jan 2011 11:04:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: [PATCH tip/core/rcu 0/2] config-param reduction and blocked-task
 warning
Message-ID: <20110113190414.GA10457@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

A couple of fixes:

1.	Revert the ill-considered addition of a configuration parameter.
2.	Avoid a pointless blocked-task warning.

After a bit more testing and review, I believe that these should go into
2.6.38, as they both represent regressions.

							Thanx, Paul
