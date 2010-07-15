Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab0GOSbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:31:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45078 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014Ab0GOSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:31:08 -0400
Date: Thu, 15 Jul 2010 20:31:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zeev Tarantov <zeev.tarantov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
Message-ID: <20100715183105.GA14167@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> <20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> <1278721339.1537.166.camel@gandalf.stny.rr.com> <20100710063459.GA14596@merkur.ravnborg.org> <20100715150514.GB14073@merkur.ravnborg.org> <1279206959.4190.55.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279206959.4190.55.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 11:15:59AM -0400, Steven Rostedt wrote:
> On Thu, 2010-07-15 at 17:05 +0200, Sam Ravnborg wrote:
> > On Sat, Jul 10, 2010 at 08:34:59AM +0200, Sam Ravnborg wrote:
> > > Zeev - please try this replacement patch.
> > > The alignmnet is increased to 32 bytes compared to my previous version and
> > > we introduce alignmnet for ftrace_events too.
> > > 
> > > 	Sam
> > 
> > Steven - Zeev reported that this fixed the boot problem.
> > What is next step?
> > Do you forward this patch or do you prefer another fix?
> > 
> 
> Hi Sam,
> 
> I'm currently at OLS (yes it still exists!) I'll test it and send off
> this fix to Ingo when I get back on Monday, as I believe Linus did
> prefer this one.

Great. I'm most likely away from mail the next week so do not
expect prompt responses from me.

	Sam
