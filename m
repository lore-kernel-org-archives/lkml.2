Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1KPO0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:26:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:39291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab1KPO0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:26:07 -0500
Subject: Re: [PATCH] tracing: add trace console
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 Nov 2011 15:25:37 +0100
In-Reply-To: <1321452954.4181.20.camel@frodo>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <1321452954.4181.20.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321453537.27735.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 09:15 -0500, Steven Rostedt wrote:
> I'm good with this. Anyone have any issues with it?
> 
> -- Steve
> 
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  kernel/trace/Kconfig         |   13 ++++++++++
> >  kernel/trace/Makefile        |    2 +
> >  kernel/trace/trace-console.c |   55 +++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 70 insertions(+)
> > 
> > --- a/kernel/trace/Kconfig    2011-11-16 11:11:27.000000000 +0100
> > +++ b/kernel/trace/Kconfig    2011-11-16 11:11:35.000000000 +0100
> > @@ -368,6 +368,19 @@ config BLK_DEV_IO_TRACE
> >  
> >         If unsure, say N.
> >  
> > +config TRACE_CONSOLE
> > +     tristate "Support for a tracing console"
> > +     help
> > +       Say M (or Y if you must, but this is not recommended) 

Why not?

> to be able
> > +       to get a tracing console that puts every kernel message into the
> > +       tracing infrastructure using trace_printk(). This is useful to
> > +       correlate (existing) printk debugging with tracing. When using it
> > +       remember to set the console level, e.g. with "dmesg -n8". 
