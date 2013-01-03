Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3ACDPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:15:18 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49790 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3ACDPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:15:17 -0500
Date: Wed, 2 Jan 2013 19:14:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
Message-ID: <20130103031449.GB25701@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130102190920.GD29452@charite.de>
 <20130102205630.GA5594@home.goodmis.org>
 <20130102212948.GA25701@linux.vnet.ibm.com>
 <1357174163.10284.8.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357174163.10284.8.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010303-7408-0000-0000-00000B7FBB41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 07:49:23PM -0500, Steven Rostedt wrote:
> On Wed, 2013-01-02 at 13:29 -0800, Paul E. McKenney wrote:
> > On Wed, Jan 02, 2013 at 03:56:30PM -0500, Steven Rostedt wrote:
> > > On Wed, Jan 02, 2013 at 08:09:20PM +0100, Ralf Hildebrandt wrote:
> > > > This happened of a virtual guest (Linux mail 3.2.0-35-virtual #55-Ubuntu SMP Wed Dec 5 18:02:05 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux)
> > > 
> > > 3.2 is rather old and this looks to be a stock Ubuntu kernel. May want
> > > to file a Bugzilla (or whatever they call it) with them.
> > > 
> > > > 
> > > > Jan  2 13:24:08 mail kernel: [3531872.484283] INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
> > > 
> > > 0 jiffies?
> > 
> > One possibility is that they are missing commit a10d206e (rcu: Fix
> > day-one dyntick-idle stall-warning bug), at least assuming that
> > CONFIG_PREEMPT=n.  This went into 3.6, IIRC.
> 
> If that does fix the issue, we probably should send that off to Ben for
> inclusion into 3.2 stable.

Looks like you already CCed him, thank you!  ;-)

							Thanx, Paul

> Thanks,
> 
> -- Steve
> 
> > 
> > 							Thanx, Paul
> > 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

