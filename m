Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2AOVME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:12:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24090 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2AOVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:12:02 -0500
Date: Sun, 15 Jan 2012 22:12:01 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
In-Reply-To: <1326661784.7642.140.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LNX.2.00.1201152210300.13389@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net> <1326661784.7642.140.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jan 2012, Steven Rostedt wrote:

> On Sun, 2012-01-15 at 21:48 +0100, Jesper Juhl wrote:
> > What was originally going to be 2.6.41 became 3.1 .
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  include/trace/events/power.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/trace/events/power.h b/include/trace/events/power.h
> > index 1bcc2a8..b262699 100644
> > --- a/include/trace/events/power.h
> > +++ b/include/trace/events/power.h
> > @@ -65,7 +65,7 @@ TRACE_EVENT(machine_suspend,
> >  	TP_printk("state=%lu", (unsigned long)__entry->state)
> >  );
> >  
> > -/* This code will be removed after deprecation time exceeded (2.6.41) */
> > +/* This code will be removed after deprecation time exceeded (3.1) */
> 
> Shouldn't the real fix be to remove this code? What's the use of
> changing the version number that this code will be removed from, when
> the change won't get in until after the version that this code should
> have been removed?
> 
> This is like updating 2014 calendars to say the world will end in 2012.
> 
Heh, yeah, in a way you are right. But we have lots of code in the kernel 
that says it will be removed at <some date in the past>, so I just figured 
that if this code ends up hanging around it should at least display the 
correct version number for when it /should/ have been removed.
The actual removal I'll leave up to others.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

