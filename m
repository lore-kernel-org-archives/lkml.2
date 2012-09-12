Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529Ab2ILQ6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:58:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49197 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2ILQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:58:04 -0400
Date: Wed, 12 Sep 2012 09:57:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used
 from interrupt context
Message-ID: <20120912165721.GR4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120906185402.GB5738@jtriplet-mobl1>
 <1346961244.1680.46.camel@gandalf.local.home>
 <20120907060940.GA21166@leaf>
 <20120907142441.GD2462@linux.vnet.ibm.com>
 <20120907144717.GA22059@leaf>
 <1347030967.8178.15.camel@gandalf.local.home>
 <20120912010720.GM4257@linux.vnet.ibm.com>
 <1347459210.10751.48.camel@gandalf.local.home>
 <20120912150328.GN4257@linux.vnet.ibm.com>
 <1347463120.10751.63.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347463120.10751.63.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091216-6148-0000-0000-000009962CD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:18:40AM -0400, Steven Rostedt wrote:
> [ Added Linus to verify what I'm talking about ]
> 
> On Wed, 2012-09-12 at 08:03 -0700, Paul E. McKenney wrote:
> 
> > Doesn't Fengguang pull branches individually?  And won't that mean
> > that as soon as I push my export-removal commit, that he will see
> > build failures?
> > 
> > Or are you suggesting that we both send both commits?
> 
> No, what I could do is to push the branch out to my repository on
> kernel.org (I'm currently running it under my test suite), and then both
> you and Ingo can pull from it.
> 
> It is based off of v3.6-rc5 and only has Josh's change in it. This way,
> when Ingo pulls it into the perf/core branch, I can work against that,
> and you could either pull the same branch directly from me (as you need
> it to work too), or you could have Ingo pull it into the rcu branches in
> tip, and you could work against that.
> 
> The trick is that the branch I push is against Linus's tree (something
> that we all should be working against) and contains only the one change.
> Then everyone that needs this change can just pull it directly, and git
> will sort it all out without any conflicts. This is the method that
> Linus was talking about at Kernel Summit.

Works for me!

							Thanx, Paul

