Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1EDBvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 21:51:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50614 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752299Ab1EDBvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 21:51:49 -0400
Date: Tue, 3 May 2011 21:51:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC patch 25/32] trace event video gpu remove semicolons
Message-ID: <20110504015147.GB3165@Krystal>
References: <20110503231023.968960757@efficios.com> <20110503231428.245701713@efficios.com> <20110503172141.7d06fd7d@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503172141.7d06fd7d@jbarnes-desktop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:51:24 up 161 days,  6:54,  5 users,  load average: 0.00, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes (jbarnes@virtuousgeek.org) wrote:
> On Tue, 03 May 2011 19:10:48 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> > of events, thus saving space for trace event probes.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > CC: Dave Airlie <airlied@redhat.com>
> > CC: Chris Wilson <chris@chris-wilson.co.uk>
> > CC: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  drivers/gpu/drm/drm_trace.h       |    6 ++--
> >  drivers/gpu/drm/i915/i915_trace.h |   52 +++++++++++++++++++-------------------
> >  2 files changed, 29 insertions(+), 29 deletions(-)
> > 
> 
> Yeah, looks fine to me Mathieu, thanks.  I guess it should go in along
> with the rest of your tracing fixes so the dependencies don't get
> spread out across a bunch of different trees.

Yes, this is the intent.

> 
> Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks!

Mathieu

> 
> -- 
> Jesse Barnes, Intel Open Source Technology Center

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
