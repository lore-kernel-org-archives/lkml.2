Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3AGQCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:02:35 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47460 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3AGQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:02:34 -0500
X-Originating-IP: 217.70.178.140
X-Originating-IP: 50.43.39.152
Date: Mon, 7 Jan 2013 08:02:25 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/3] Documentation and rcutorture changes
 for 3.9
Message-ID: <20130107160225.GD11145@leaf>
References: <20130105170356.GA13534@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105170356.GA13534@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 09:03:56AM -0800, Paul E. McKenney wrote:
> Hello!
> 
> The following are changes to documentation and rcutorture:
> 
> 1.	Export trace_clock_local() in order to allow rcutorture event
> 	tracing to emit the time of the beginning of the RCU read-side
> 	critical section at the point where a failure is detected.
> 2.	Reduce rcutorture's read-side tracing to include only failures,
> 	thus cutting the number of events down to something reasonable
> 	(normally zero, in fact!).
> 3.	Add atomic_xchg() to the list of atomic operations and memory
> 	barriers, courtesy of Richard Braun.

For the whole series:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
