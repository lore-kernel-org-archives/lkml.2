Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0HaXUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:20:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab0HaXUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:20:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Ksummit-2010-discuss] [PATCH] MAINTAINERS: add U: for URL of todo list, add RCU todo list
Date: Wed, 1 Sep 2010 01:19:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, Arjan van de Ven <arjan@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Joe Perches <joe@perches.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
References: <20100826154537.GA4874@linux.vnet.ibm.com> <20100831230213.GG2421@linux.vnet.ibm.com> <1283296622.1377.765.camel@gandalf.stny.rr.com>
In-Reply-To: <1283296622.1377.765.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009010119.18748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 01, 2010, Steven Rostedt wrote:
> On Tue, 2010-08-31 at 16:02 -0700, Paul E. McKenney wrote:
> 
> > > We could add a toplevel "todo/" directory, with each project file in it
> > > and a list of things todo. When the todo is done, that same commit could
> > > remove the todo item.
> > > 
> > > Just a worthless thought ;-)
> > 
> > I am with Dmitry on this one.  I really don't want to be prevented from
> > updating my todo items outside of the merge window.
> > 
> > Different people have different needs, so we need to accommodate todo
> > lists both within and outside the kernel source tree.
> 
> Actually, that would probably happen automatically.
> 
> If you are working on a subsystem, you should probably be working
> against the git tree for that subsystem. When something is done in the
> todo list, the subsystem tree would be updated with the commit that does
> said change.
> 
> Then, the list is maintained outside of mainline (in the subsystem git
> tree) and will automatically update mainline in the next merge window
> when the tree is pulled.

Seriously, given the known history of Documentation/feature-removal-schedule.txt,
I don't think this is going to work.

Thanks,
Rafael
