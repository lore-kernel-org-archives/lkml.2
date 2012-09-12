Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2ILBHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:07:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57220 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2ILBHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:07:33 -0400
Date: Tue, 11 Sep 2012 18:07:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120912010720.GM4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120904230834.GB11494@jtriplet-mobl1>
 <1346801031.27919.39.camel@gandalf.local.home>
 <20120904233344.GB11855@jtriplet-mobl1>
 <20120904234307.GY2593@linux.vnet.ibm.com>
 <20120906185402.GB5738@jtriplet-mobl1>
 <1346961244.1680.46.camel@gandalf.local.home>
 <20120907060940.GA21166@leaf>
 <20120907142441.GD2462@linux.vnet.ibm.com>
 <20120907144717.GA22059@leaf>
 <1347030967.8178.15.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347030967.8178.15.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091201-3534-0000-0000-00000C905AF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:16:07AM -0400, Steven Rostedt wrote:
> On Fri, 2012-09-07 at 07:47 -0700, Josh Triplett wrote:
> > On Fri, Sep 07, 2012 at 07:24:41AM -0700, Paul E. McKenney wrote:
> > > On Thu, Sep 06, 2012 at 11:09:40PM -0700, Josh Triplett wrote:
> > > > On Thu, Sep 06, 2012 at 03:54:04PM -0400, Steven Rostedt wrote:
> > > > > On Thu, 2012-09-06 at 11:54 -0700, Josh Triplett wrote:
> > > > > > Not sure I see much difference in aesthetics between the three approaches,
> > > > > > > but am willing to switch over to a generally agreed-upon scheme.
> > > > > > 
> > > > > > Steve, could I get an ack from you on the patch I sent?
> > > > > 
> > > > > I acked it, but do you just want me to take the patch? I'm getting ready
> > > > > for another 3.7 push to tip.
> > > > 
> > > > Up to Paul.  What would make it easiest to coordinate that patch and the
> > > > corresponding bits in the RCU patch series?
> > > 
> > > All I need to do is to eventually remove the exports, correct?
> > > If so, full speed ahead!
> > 
> > Sounds like you could go ahead and remove the exports now, and just make
> > sure Steve's push goes in before yours.
> > 
> 
> Is there any rush to do this? I just plan on pushing it for 3.7.
> 
> Paul, you just push your changes through tip, right? Then we can just
> let Ingo know. I could even make the patch a separate branch, that Ingo
> can pull into the RCU branch too.

Yep!  But we also need to worry about -next and -fengguang.

How about if you push your change into 3.7 and I push mine into 3.8?

							Thanx, Paul

