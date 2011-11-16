Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1KPOfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:35:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33164 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab1KPOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:35:40 -0500
Date: Wed, 16 Nov 2011 15:35:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing: add trace console
Message-ID: <20111116143528.GB7323@somewhere.redhat.com>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net>
 <1321452954.4181.20.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321452954.4181.20.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 09:15:54AM -0500, Steven Rostedt wrote:
> [ Added Peter, Thomas and Andrew ]
> 
> On Wed, 2011-11-16 at 11:18 +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > As described in the Kconfig entry, logging printk
> > output is useful to correlate (existing) printk
> > debugging with (existing) tracing. The easiest way
> > to achieve this is to register a console that just
> > calls trace_printk(), which this module does.
> 
> I'm good with this. Anyone have any issues with it?

Correlating trace_printk with printk is a feature I've
often missed.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.
