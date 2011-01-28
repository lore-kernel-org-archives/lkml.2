Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1A1OxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:53:19 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43362 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1A1OxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:53:18 -0500
Date: Fri, 28 Jan 2011 20:16:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
Message-ID: <20110128144629.GW19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957741.28776.719.camel@laptop>
 <1295985926.10144.61.camel@gandalf.stny.rr.com>
 <20110126090643.GI19725@linux.vnet.ibm.com>
 <1296147837.10144.79.camel@gandalf.stny.rr.com>
 <20110128045353.GU19725@linux.vnet.ibm.com>
 <1296223077.10144.106.camel@gandalf.stny.rr.com>
 <1296224926.10144.109.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296224926.10144.109.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-01-28 09:28:46]:

> On Fri, 2011-01-28 at 08:57 -0500, Steven Rostedt wrote:
> > On Fri, 2011-01-28 at 10:23 +0530, Srikar Dronamraju wrote:
> > 
> > > Here is the extract from the original patch at
> > > https://lkml.org/lkml/2010/12/16/74 that I sent to LKML and I dont see
> > > p being uninitialized. 
> > 
> > I very much apologize. Seems that Evolution was playing tricks on me.
> > 
> >   http://rostedt.homelinux.com/private/evolution-wtf.png
> > 
> > That's a screen shot of your email in the preview window. Where 'p' is
> > definitely not initialized. WTF happened to my email?
> > 
> > But all the replies to that email does not have it initialized either ??
> > I was not the only one affected by this.
> > 
> 
> Seems to be a bug in Evolution :-p  As both Peter and I tested out this
> email in mutt, and that line appears ?? And Peter tried it out in raw
> mode (^u) and it shows up there in Evolution.
> 
> I know, I know, GUI email clients suck. And for good reason too. I guess
> I just spent too many years in the corporate environment to know any
> better.
> 

Interesting, Nothing you can do if your mail client decides to
delete one arbitrary line. Its Good that you told what you saw and
hence found a bug in evolution.

-- 
Thanks and Regards
Srikar

> -- Steve
> 
> 
