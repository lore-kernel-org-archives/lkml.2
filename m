Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1KCNaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:30:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33809 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1KCNaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:30:20 -0400
Date: Thu, 3 Nov 2011 06:29:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 17/28] rcu: Make srcu_read_lock_held()
 call common lockdep-enabled function
Message-ID: <20111103132942.GY2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103034854.GD2042@leaf>
 <20111103111413.GC8198@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103111413.GC8198@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110313-9360-0000-0000-00000049ADD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 12:14:20PM +0100, Frederic Weisbecker wrote:
> On Wed, Nov 02, 2011 at 08:48:54PM -0700, Josh Triplett wrote:
> > On Wed, Nov 02, 2011 at 01:30:38PM -0700, Paul E. McKenney wrote:
> > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > > A common debug_lockdep_rcu_enabled() function is used to check whether
> > > RCU lockdep splats should be reported, but srcu_read_lock() does not
> > > use it.  This commit therefore brings srcu_read_lock_held() up to date.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Just how signed off does this patch need to be? ;)

If you have sufficient patience to scroll past the Signed-off-by's
to see the patch, then there clearly are not enough.  ;-)

> Dunno but I feel uncomfortable now with that strange feeling I'm walking
> on the street with two Paul holding my hand on each side.

I did catch one of these, but missed the other.  Here is the history:

o	Paul wrote the patch.

o	Frederic reworked the patches that this one depended on,
	and then resent the patch.

o	Paul did "git am -s" on the series that Frederic sent,
	which added the extra Signed-off-by.
	
It is not clear to me what the Signed-off-by chain should look like in
this case.  My default action would be to remove my second Signed-off-by.

							Thanx, Paul

