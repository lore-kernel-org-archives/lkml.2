Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1KPQlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:41:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1KPQlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:41:36 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=l4wf8OQxcBQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=QyXUC8HyAAAA:8 a=oK_g3dvKfHLur5cet_4A:9 a=QEXdDO2ut3YA:10 a=dGJ0OcVc7YAA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] tracing: add trace console
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1321456652.4502.12.camel@jlt3.sipsolutions.net>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 11:41:33 -0500
Message-ID: <1321461693.4181.26.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 16:17 +0100, Johannes Berg wrote:
> On Wed, 2011-11-16 at 10:10 -0500, Christoph Hellwig wrote:
> > On Wed, Nov 16, 2011 at 11:18:48AM +0100, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > As described in the Kconfig entry, logging printk
> > > output is useful to correlate (existing) printk
> > > debugging with (existing) tracing. The easiest way
> > > to achieve this is to register a console that just
> > > calls trace_printk(), which this module does.
> > 
> > I'd much prefer if we could have it built in all the time, but had a
> > way to enable it at runtime, just like all the "real" tracepoints.
> 
> That's possible, basically adding a tracepoints to printk -- that would
> even catch everything and not require setting the console level (which
> has its advantages too since other consoles might be slow).
> 
> It's a completely different thing though. I did it this way because it
> was trivial to do out of tree for a quick test I was doing yesterday.
> Doing it the other way is obviously more intrusive in core code.

I'm not sure it would be too invasive. Think you could get something
working?

-- Steve


