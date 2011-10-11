Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1JKIQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:16:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39127 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1JKIQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:16:52 -0400
Date: Tue, 11 Oct 2011 10:15:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111011081511.GA4523@elte.hu>
References: <20111010133852.829771373@goodmis.org>
 <1318254776.7904.87.camel@gandalf.stny.rr.com>
 <20111011055119.GB32616@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011055119.GB32616@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 2011-10-10 at 09:38 -0400, Steven Rostedt wrote:
> > 
> > > Please pull the latest tip/perf/core tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> > Oops, I need to update my scripts. The new path is:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> 
> Ok - this one worked.

but it has not been build tested with the function tracer disabled:

 kernel/trace/trace.h:588:1: error: multiple storage classes in declaration specifiers

Thanks,

	Ingo
