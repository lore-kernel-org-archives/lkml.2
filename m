Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1KCNaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:30:55 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48005 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1KCNax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:30:53 -0400
Date: Thu, 3 Nov 2011 06:30:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 17/28] rcu: Make srcu_read_lock_held()
 call common lockdep-enabled function
Message-ID: <20111103133018.GZ2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103034854.GD2042@leaf>
 <20111103111413.GC8198@somewhere.redhat.com>
 <1320326366.27370.1.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320326366.27370.1.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110313-8974-0000-0000-0000016311E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 09:19:26AM -0400, Steven Rostedt wrote:
> On Thu, 2011-11-03 at 12:14 +0100, Frederic Weisbecker wrote:
> > On Wed, Nov 02, 2011 at 08:48:54PM -0700, Josh Triplett wrote:
> > > On Wed, Nov 02, 2011 at 01:30:38PM -0700, Paul E. McKenney wrote:
> > > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > > 
> > > > A common debug_lockdep_rcu_enabled() function is used to check whether
> > > > RCU lockdep splats should be reported, but srcu_read_lock() does not
> > > > use it.  This commit therefore brings srcu_read_lock_held() up to date.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Just how signed off does this patch need to be? ;)
> > 
> > Dunno but I feel uncomfortable now with that strange feeling I'm walking
> > on the street with two Paul holding my hand on each side.
> 
> We already established the split Paul, but what is really scarey, is
> that the Pauls on both sides of you, are the evil Pauls. ;)

Well, I -could- make the first one by my linaro.org address and the
second one be my linux.vnet.ibm.com address...  ;-)

							Thanx, Paul

