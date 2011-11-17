Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab1KQO6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:58:07 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab1KQO6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:58:05 -0500
Subject: Re: [PATCH] printk: add console output tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111117145502.GA18437@somewhere> (sfid-20111117_155545_388000_E8D366A6)
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
	 <20111116151037.GA26166@infradead.org>
	 <1321456652.4502.12.camel@jlt3.sipsolutions.net>
	 <1321461693.4181.26.camel@frodo>
	 <1321461902.4502.14.camel@jlt3.sipsolutions.net>
	 <1321462856.4181.28.camel@frodo>
	 <1321468380.4502.16.camel@jlt3.sipsolutions.net>
	 <1321473443.4181.38.camel@frodo>
	 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
	 <20111117145502.GA18437@somewhere> (sfid-20111117_155545_388000_E8D366A6)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 15:57:57 +0100
Message-ID: <1321541877.3997.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 15:55 +0100, Frederic Weisbecker wrote:

> > +++ b/kernel/trace/printk-trace.c	2011-11-16 21:22:20.000000000 +0100
> > @@ -0,0 +1,14 @@
> > +/*
> > + * printk trace points
> > + *
> > + * Copyright (C) 2011 Johannes Berg <johannes.berg@intel.com>
> > + */
> > +
> > +#include <linux/string.h>
> > +#include <linux/types.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/sched.h>
> > +#include <linux/module.h>
> > +
> > +#define CREATE_TRACE_POINTS
> > +#include <trace/events/printk.h>
> 
> Why not defining the tracepoint in kernel/printk.c ?

Is that even possible? Do you then have to do something like

#include <.../printk.h>
#define CREATE_TRACE_POINTS
#include <.../printk.h>

or how else? In any case it seemed more common to not do that.

johannes

