Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1KPOcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:32:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:58521 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab1KPOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:32:12 -0500
Date: Wed, 16 Nov 2011 15:32:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Johannes Berg <johannes@sipsolutions.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing: add trace console
In-Reply-To: <1321452954.4181.20.camel@frodo>
Message-ID: <alpine.LFD.2.02.1111161531420.4902@ionos>
References: <1321438728.4773.16.camel@jlt3.sipsolutions.net> <1321452954.4181.20.camel@frodo>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Steven Rostedt wrote:

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

Acked-by-me
