Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2KMAuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:50:18 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53599 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2KMAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:50:16 -0500
Date: Mon, 12 Nov 2012 16:49:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121113004906.GA10557@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111300-2876-0000-0000-000001F76683
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I know of people using TINY_RCU, TREE_RCU, and TREE_PREEMPT_RCU, but I
have not heard of anyone using TINY_PREEMPT_RCU for whom TREE_PREEMPT_RCU
was not a viable option (in contrast, the people running Linux on
tiny-memmory systems typically use TINY_RCU).  Of course, if no one
really needs it, the proper thing to do is to remove it.

So, if you need TINY_PREEMPT_RCU, please let me know.  Otherwise, I will
remove it, probably in the 3.9 timeframe.

							Thanx, Paul

