Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab2IGGJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:09:51 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34027 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2IGGJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:09:50 -0400
X-Originating-IP: 217.70.178.148
X-Originating-IP: 50.43.46.74
Date: Thu, 6 Sep 2012 23:09:40 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120907060940.GA21166@leaf>
References: <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831180052.GB4259@jtriplet-mobl1>
 <20120904223350.GQ2593@linux.vnet.ibm.com>
 <1346799082.27919.31.camel@gandalf.local.home>
 <20120904230834.GB11494@jtriplet-mobl1>
 <1346801031.27919.39.camel@gandalf.local.home>
 <20120904233344.GB11855@jtriplet-mobl1>
 <20120904234307.GY2593@linux.vnet.ibm.com>
 <20120906185402.GB5738@jtriplet-mobl1>
 <1346961244.1680.46.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346961244.1680.46.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 03:54:04PM -0400, Steven Rostedt wrote:
> On Thu, 2012-09-06 at 11:54 -0700, Josh Triplett wrote:
> > Not sure I see much difference in aesthetics between the three approaches,
> > > but am willing to switch over to a generally agreed-upon scheme.
> > 
> > Steve, could I get an ack from you on the patch I sent?
> 
> I acked it, but do you just want me to take the patch? I'm getting ready
> for another 3.7 push to tip.

Up to Paul.  What would make it easiest to coordinate that patch and the
corresponding bits in the RCU patch series?

- Josh Triplett
