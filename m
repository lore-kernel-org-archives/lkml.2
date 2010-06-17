Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab0FQJfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759729Ab0FQJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:35:29 -0400
Date: Thu, 17 Jun 2010 10:46:43 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       ghaskins@novell.com
Subject: Re: [PATCH 2/6: v4] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
In-Reply-To: <1276763719.27822.3.camel@twins>
Message-ID: <alpine.LFD.2.00.1006171039050.22185@localhost.localdomain>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com> <1276554087-3632-3-git-send-email-jkacur@redhat.com> <1276714154.1745.623.camel@laptop> <alpine.LFD.2.00.1006162213220.28756@localhost.localdomain> <1276723008.2077.9574.camel@twins>
 <1276723773.3556.65.camel@gandalf.stny.rr.com> <1276763719.27822.3.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jun 2010, Peter Zijlstra wrote:

> On Wed, 2010-06-16 at 17:29 -0400, Steven Rostedt wrote:
> > On Wed, 2010-06-16 at 23:16 +0200, Peter Zijlstra wrote:
> > 
> > > Also, google doesn't seem to index msg-ids, so I've no idea what you're
> > > referring to.
> > 
> > But marc.info does:
> > 
> > http://marc.info/?i=4BCEAD7B0200005A0006513E@soto.provo.novell.com
> 
> Right, so that was before Yong Zhang's patch, if it still happens we
> need to again look at what is causing this. Again, blindly increasing
> the limit is not a good option.

Well, as I said, I'm testing with Yong Zhang's patch, and it seems to be 
doing the trick, so I am actually not pushing for my patch right now.
 
But please stop characterizing this as "blindly increasing the limit", 
because that is not at all what I or others do. We have a debug build with 
tons of options turned on in which case we increased it to the minimum 
that worked for us, and we have a tracing build in which case we left it 
at the default. Also as I pointed out, in Sven's case it sounds like they may 
have had a build where they even wanted to decrease it.

Your objection in the past was that it was another tunable that nobody understands, and I 
have more sympathy for that argument. My counterargument is that if we're 
all putting a version of this patch in our private builds, then it's a tad 
counterproductive. Let's leave things the way they are for now, unless 
this becomes a problem again.

Thanks.

