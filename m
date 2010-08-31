Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0HaXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:02:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40181 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0HaXCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:02:16 -0400
Date: Tue, 31 Aug 2010 16:02:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Joe Perches <joe@perches.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of
 todo list, add RCU todo list
Message-ID: <20100831230213.GG2421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100826154537.GA4874@linux.vnet.ibm.com>
 <1282837904.1875.64.camel@Joe-Laptop>
 <20100826161451.GB2367@linux.vnet.ibm.com>
 <1282839933.8133.11.camel@mulgrave.site>
 <20100826092923.4bdbea69.rdunlap@xenotime.net>
 <20100826093838.74ab9958@infradead.org>
 <1283275388.1377.216.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283275388.1377.216.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 01:23:08PM -0400, Steven Rostedt wrote:
> On Thu, 2010-08-26 at 09:38 -0700, Arjan van de Ven wrote:
> 
> > I have to say that I'm not yet convinced that keeping a todo list in a
> > place that's not with the actual source code does not give me warm
> > fuzzy feelings. Every time we've kept information about the source code
> > separate from our source code it's been a failure; it gets out of sync
> > fast and it just adds to the maintenance.
> > 
> > A git commit that both fixes an issue and removed the line from the
> > todo file (or moves it to a "done" section, whatever) is the ultimate
> > goal obviously... having a U: seems to go in exactly the opposite
> > direction.
> > 
> > otoh having a kernel-doc type (eg structured, parsable) way of
> > gathering todo items throughout the tree.... that I can see as useful.
> 
> We could add a toplevel "todo/" directory, with each project file in it
> and a list of things todo. When the todo is done, that same commit could
> remove the todo item.
> 
> Just a worthless thought ;-)

I am with Dmitry on this one.  I really don't want to be prevented from
updating my todo items outside of the merge window.

Different people have different needs, so we need to accommodate todo
lists both within and outside the kernel source tree.

							Thanx, Paul
