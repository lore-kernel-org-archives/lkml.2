Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0H0Plu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:41:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:43506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0H0Pls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:41:48 -0400
Subject: Re: [RFC PATCH 00/11] sched: CFS low-latency features
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100827153006.GD14926@Krystal>
References: <1282849045.1975.1587.camel@laptop>
	 <alpine.LFD.2.00.1008262306140.2768@localhost.localdomain>
	 <alpine.LFD.2.00.1008270013390.2768@localhost.localdomain>
	 <20100826231806.GK2367@linux.vnet.ibm.com> <20100826232858.GA28177@Krystal>
	 <20100826233811.GM2367@linux.vnet.ibm.com> <20100826235323.GC4194@Krystal>
	 <20100827000911.GO2367@linux.vnet.ibm.com> <20100827151807.GA14926@Krystal>
	 <alpine.LFD.2.00.1008271719270.2768@localhost.localdomain>
	 <20100827153006.GD14926@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 17:41:28 +0200
Message-ID: <1282923688.1975.2781.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 11:30 -0400, Mathieu Desnoyers wrote:
> So do you think Paul's ideal would be a good candidate for the timer_create
> SIGEV_THREAD glibc implementation then ? 

Simply do not _ever_ use SIGEV_THREAD, there really is no reason to.


