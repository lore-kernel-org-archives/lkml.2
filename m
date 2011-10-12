Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1JLQY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:24:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab1JLQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:24:55 -0400
Date: Wed, 12 Oct 2011 18:23:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111012162320.GA31857@elte.hu>
References: <20111011152026.701326733@goodmis.org>
 <20111012081629.GA25086@elte.hu>
 <1318418515.13262.21.camel@gandalf.stny.rr.com>
 <1318425974.13262.26.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318425974.13262.26.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2011-10-12 at 07:21 -0400, Steven Rostedt wrote:
> > [ Added hpa ]
> > 
> > On Wed, 2011-10-12 at 10:16 +0200, Ingo Molnar wrote:
> > >  
> > > > Please pull the latest tip/perf/core tree, which can be found at:
> > > > 
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > > > tip/perf/core
> > > > 
> > > > Head SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187
> > > 
> > > Hm, even after 12+ hours of wait i can only pull 177e216 from your 
> > > tip/perf/core. Is this a korg delay, or did you forget to push? The 
> > > perf/urgent branch was there, so i don't think it's korg delay.
> > 
> > I just tried again, and got:
> > 
> > $ git push push trace/tip/perf/core:tip/perf/core
> > Enter passphrase for key '/home/rostedt/.ssh/id_rsa_korg': 
> > Everything up-to-date
> 
> > It seems that gitolite isn't refreshing rebases?
> 
> There seems to be issues with kernel.org refreshing. You can get the
> same branch at my github repo:
> 
>   git://github.com/rostedt/linux.git
> tip/perf/core
> 
> 
> It has the same SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187

Got it from there - thanks Steve!

Tests are also looking good so far.

	Ingo
