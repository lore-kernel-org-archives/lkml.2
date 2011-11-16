Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1KPPRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:17:38 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:33311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab1KPPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:17:37 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111116151037.GA26166@infradead.org>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <20111116151037.GA26166@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 16:17:32 +0100
Message-ID: <1321456652.4502.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 10:10 -0500, Christoph Hellwig wrote:
> On Wed, Nov 16, 2011 at 11:18:48AM +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > As described in the Kconfig entry, logging printk
> > output is useful to correlate (existing) printk
> > debugging with (existing) tracing. The easiest way
> > to achieve this is to register a console that just
> > calls trace_printk(), which this module does.
> 
> I'd much prefer if we could have it built in all the time, but had a
> way to enable it at runtime, just like all the "real" tracepoints.

That's possible, basically adding a tracepoints to printk -- that would
even catch everything and not require setting the console level (which
has its advantages too since other consoles might be slow).

It's a completely different thing though. I did it this way because it
was trivial to do out of tree for a quick test I was doing yesterday.
Doing it the other way is obviously more intrusive in core code.

johannes

