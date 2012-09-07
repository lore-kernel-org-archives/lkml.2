Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab2IGOr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:47:27 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:42350 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2IGOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:47:26 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 50.43.46.74
Date: Fri, 7 Sep 2012 07:47:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120907144717.GA22059@leaf>
References: <20120904223350.GQ2593@linux.vnet.ibm.com>
 <1346799082.27919.31.camel@gandalf.local.home>
 <20120904230834.GB11494@jtriplet-mobl1>
 <1346801031.27919.39.camel@gandalf.local.home>
 <20120904233344.GB11855@jtriplet-mobl1>
 <20120904234307.GY2593@linux.vnet.ibm.com>
 <20120906185402.GB5738@jtriplet-mobl1>
 <1346961244.1680.46.camel@gandalf.local.home>
 <20120907060940.GA21166@leaf>
 <20120907142441.GD2462@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907142441.GD2462@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 07:24:41AM -0700, Paul E. McKenney wrote:
> On Thu, Sep 06, 2012 at 11:09:40PM -0700, Josh Triplett wrote:
> > On Thu, Sep 06, 2012 at 03:54:04PM -0400, Steven Rostedt wrote:
> > > On Thu, 2012-09-06 at 11:54 -0700, Josh Triplett wrote:
> > > > Not sure I see much difference in aesthetics between the three approaches,
> > > > > but am willing to switch over to a generally agreed-upon scheme.
> > > > 
> > > > Steve, could I get an ack from you on the patch I sent?
> > > 
> > > I acked it, but do you just want me to take the patch? I'm getting ready
> > > for another 3.7 push to tip.
> > 
> > Up to Paul.  What would make it easiest to coordinate that patch and the
> > corresponding bits in the RCU patch series?
> 
> All I need to do is to eventually remove the exports, correct?
> If so, full speed ahead!

Sounds like you could go ahead and remove the exports now, and just make
sure Steve's push goes in before yours.

- Josh Triplett
