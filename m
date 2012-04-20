Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab2DTV1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:27:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2DTV1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:27:33 -0400
Date: Fri, 20 Apr 2012 23:26:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] (Was: syscall_regfunc() && TIF_SYSCALL_TRACEPOINT)
Message-ID: <20120420212654.GA11156@redhat.com>
References: <20120330183104.GA12927@redhat.com> <1333134131.23924.191.camel@gandalf.stny.rr.com> <20120330201550.GA16628@redhat.com> <1333152806.23924.196.camel@gandalf.stny.rr.com> <20120331204501.GA18572@redhat.com> <1333229859.23924.200.camel@gandalf.stny.rr.com> <20120401213748.GA17795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401213748.GA17795@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should I resend this or we do not really care?

The problem is minor, but both patches look like the simple
and obvious bugfix to me.

On 04/01, Oleg Nesterov wrote:
>
> On 03/31, Steven Rostedt wrote:
> >
> > On Sat, 2012-03-31 at 22:45 +0200, Oleg Nesterov wrote:
> > >
> > > So what do you think we should do,
> > >
> > > 	- keep this check
> > >
> > > 	- remove it
> > >
> > > 	- remove it in a separate patch
> >
> > I say this one (remove it in a separate patch). That way if something
> > breaks we know exactly what did it ;-)
>
> OK, agreed.
>
> Don't really know how can I test this... but the kernel didn't
> crash after I enabled the syscall tracer ;)
>
> Oleg.

