Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937Ab2ILPEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:04:24 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34407 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2ILPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:04:20 -0400
Date: Wed, 12 Sep 2012 08:03:28 -0700
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
Message-ID: <20120912150328.GN4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120904233344.GB11855@jtriplet-mobl1>
 <20120904234307.GY2593@linux.vnet.ibm.com>
 <20120906185402.GB5738@jtriplet-mobl1>
 <1346961244.1680.46.camel@gandalf.local.home>
 <20120907060940.GA21166@leaf>
 <20120907142441.GD2462@linux.vnet.ibm.com>
 <20120907144717.GA22059@leaf>
 <1347030967.8178.15.camel@gandalf.local.home>
 <20120912010720.GM4257@linux.vnet.ibm.com>
 <1347459210.10751.48.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347459210.10751.48.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091215-7408-0000-0000-0000087409B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:13:30AM -0400, Steven Rostedt wrote:
> On Tue, 2012-09-11 at 18:07 -0700, Paul E. McKenney wrote:
> >  
> > > Paul, you just push your changes through tip, right? Then we can just
> > > let Ingo know. I could even make the patch a separate branch, that Ingo
> > > can pull into the RCU branch too.
> > 
> > Yep!  But we also need to worry about -next and -fengguang.
> > 
> > How about if you push your change into 3.7 and I push mine into 3.8?
> 
> Bah, this is what Linus said not to do. Although he's more about not
> having this happen in a single merge window, but this isn't the "git
> way".
> 
> There should be no problem in pushing the patch based off of Linus's
> tree and have it be pulled into two branches. This is what Linus said he
> wanted. The change will go in via one of the branches, whichever is
> pulled first. And as the change will have the same SHA1 in both
> branches, git will merge it nicely. This is what Linus said at kernel
> summit that he wants people to do.
> 
> Note, this will also get into -next and -fengguang's tree as well,
> without issue.

Doesn't Fengguang pull branches individually?  And won't that mean
that as soon as I push my export-removal commit, that he will see
build failures?

Or are you suggesting that we both send both commits?

							Thanx, Paul

