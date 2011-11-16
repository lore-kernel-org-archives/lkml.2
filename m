Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1KPUko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:40:44 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42156 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1KPUkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:40:43 -0500
Date: Wed, 16 Nov 2011 12:39:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/9] Preview of additional RCU changes for
 3.3
Message-ID: <20111116203947.GN2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111115202736.GA11030@linux.vnet.ibm.com>
 <20111115215041.GF31473@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115215041.GF31473@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111620-5806-0000-0000-000007871838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:50:41PM -0800, Josh Triplett wrote:
> On Tue, Nov 15, 2011 at 12:27:36PM -0800, Paul E. McKenney wrote:
> > This patchset is in addition to the set previously posted (see
> > https://lkml.org/lkml/2011/11/2/363).  This new set permits the
> > reworked RCU_FAST_NO_HZ code to be used from TREE_PREEMPT_RCU,
> > allows rcutorture to shut down the system after a fixed time
> > period (useful for KVM-based testing), adds an API to
> > replace the "->pid == 0" discussed in response to the earlier
> > patch set, and applies this API where applicable.  The patches are
> > as follows:
> > 
> > 1.	Update the RCU_FAST_NO_HZ config definition to allow it to
> > 	be used in TREE_PREEMPT_RCU builds, since that is now legal.
> > 2.	Add a module parameter that permit rcutorture to shut down the
> > 	system cleanly after the test has run for the specified time.
> > 3.	Add a module parameter to allow rcutorture start running
> > 	as soon as it is initialized.
> > 4.	Add is_idle_task() API to replace open-coded tests of ->pid
> > 	against zero.
> > 5-9.	Apply the new is_idle_task() API where it makes sense.
> 
> I replied to patches 2-4 with review comments.  For the rest:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you for your careful review and thoughtful comments!

							Thanx, Paul

