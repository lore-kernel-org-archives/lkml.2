Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2CZXn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:43:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52982 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2CZXnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:43:55 -0400
Date: Mon, 26 Mar 2012 16:43:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
Message-ID: <20120326234340.GL2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120325205249.GA29528@linux.vnet.ibm.com>
 <1332748484.16159.61.camel@twins>
 <20120326183232.GK2450@linux.vnet.ibm.com>
 <1332788008.23924.114.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332788008.23924.114.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032623-5518-0000-0000-0000033A72F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 02:53:28PM -0400, Steven Rostedt wrote:
> On Mon, 2012-03-26 at 11:32 -0700, Paul E. McKenney wrote:
> 
> > Preemption is disabled at this point, correct?
> > 
> Is this a philosophical question? You're asking if preemption is
> disabled while a task is currently being preempted ;-)

That was my first reaction as well, but never underestimate Peter's
cleverness.  ;-)

							Thanx, Paul

