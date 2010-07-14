Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0GNX1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:27:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39362 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab0GNX1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:27:16 -0400
Date: Wed, 14 Jul 2010 16:27:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 0/30] RCU commits queued for 2.6.36/7
Message-ID: <20100714232712.GI2417@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100714200945.GA10535@linux.vnet.ibm.com>
 <20100714211901.GC4624@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714211901.GC4624@feather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 02:19:02PM -0700, Josh Triplett wrote:
> On Wed, Jul 14, 2010 at 01:09:45PM -0700, Paul E. McKenney wrote:
> > This patchset shows the patches queued for 2.6.36/7.  These are not
> > yet ready to move upstream due to dependencies on commits moving up other
> > trees.  The patches are as follows:
> > 
> > 1-19.	These are the remaining patches implementing Arnd's sparse-checking
> > 	work.  #1 needs to go up the networking tree, but
> > 	will cause regressions until f5155b33277 ("rcu: add an
> > 	rcu_dereference_index_check()") reaches mainline.  #2 depends
> > 	on #1, and many of the later patches (#3-#30) depend on #2.
> > 	Many of #3-#19 will go up non-tip trees.
> > 20.	Update Documentation/RCU to remove the now-deprecated rcu_head
> > 	initialization macros.
> > 21.	Fix long-standing DocBook example showing long-dead three-argument
> > 	variant of call_rcu().
> > 22.	Make the CPU stall warning timeout configurable at build time
> > 	with new RCU_CPU_STALL_TIMEOUT config parameter.
> > 23.	Remove the now-deprecated rcu_head initialization macros.
> > 	This depends on a couple of patches removing their use that
> > 	are making their way up other maintainer trees.
> > 24.	Document the new debug assists from Arnd, Mathieu, and myself.
> > 25.	Add random preemption to rcutorture testing of preemptible
> > 	RCU, courtesy of Lai Jiangshan.
> > 26.	Remove TREE_RCU's ->rda[] array in favor of the new __percpu
> > 	facility, also courtesy of Lai Jiangshan.
> > 27.	Fixlet to #26 for RCU tracing.
> > 28.	Rename __do_rcu_dereference_check() to rcu_lockdep_assert(),
> > 	given that Tetsuo Handa has found outside-of-RCU use for this
> > 	function.
> > 29.	Add a boot parameter to suppress RCU CPU stall warnings.
> > 30.	Update kerneldoc or rcu_read_lock(), call_rcu(), and
> > 	synchronize_rcu().
> 
> I replied to patches 27 and 29 with suggested changes.  For all the
> rest:
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you very much for looking this over!

							Thanx, Paul
