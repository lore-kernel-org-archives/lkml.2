Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1JXMDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:03:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54320 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab1JXMDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:03:30 -0400
Date: Mon, 24 Oct 2011 05:02:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 22/55] rcu: Add grace-period,
 quiescent-state, and call_rcu trace events
Message-ID: <20111024120231.GC2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-22-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111017013352.GB19421@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017013352.GB19421@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102412-3534-0000-0000-000000DB356E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 06:33:53PM -0700, Josh Triplett wrote:
> On Tue, Sep 06, 2011 at 11:00:16AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > Add trace events to record grace-period start and end, quiescent states,
> > CPUs noticing grace-period start and end, grace-period initialization,
> > call_rcu() invocation, tasks blocking in RCU read-side critical sections,
> > tasks exiting those same critical sections, force_quiescent_state()
> > detection of dyntick-idle and offline CPUs, CPUs entering and leaving
> > dyntick-idle mode (except from NMIs), CPUs coming online and going
> > offline, and CPUs being kicked for staying in dyntick-idle mode for too
> > long (as in many weeks, even on 32-bit systems).
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > rcu: Add the rcu flavor to callback trace events
> > 
> > The earlier trace events for registering RCU callbacks and for invoking
> > them did not include the RCU flavor (rcu_bh, rcu_preempt, or rcu_sched).
> > This commit adds the RCU flavor to those trace events.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Did you intend for this commit message to contain two full commit
> messages, and three signoffs from you?

No, messed up a rebase.  <red face>

> Also, the subject doesn't seem to cover the second half of the commit
> message.

This is indeed the first set of trace events where the name of the RCU
flavor was important.

							Thanx, Paul

