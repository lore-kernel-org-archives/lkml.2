Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1AQRgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:36:13 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57893 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753445Ab1AQRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:36:12 -0500
Date: Mon, 17 Jan 2011 12:36:07 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 00/28] Removal of trace event semicolons
Message-ID: <20110117173607.GB16154@Krystal>
References: <20110109215927.633266833@efficios.com> <20110115234440.GC1768@nowhere> <20110117011916.GB6668@Krystal> <20110117164059.GC1778@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117164059.GC1778@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:35:04 up 54 days, 22:38,  6 users,  load average: 0.12, 0.10,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Sun, Jan 16, 2011 at 08:19:16PM -0500, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Sun, Jan 09, 2011 at 04:59:27PM -0500, Mathieu Desnoyers wrote:
> > > > Hi,
> > > > 
> > > > I am hereby proposing the removal of trailing semicolons within the trace event
> > > > headers.
> > > > 
> > > > Please refer to "patch 01: TRACE_EVENT: gradual semicolon removal" for
> > > > explanation of this change. This patchset is based on the 2.6.37 kernel.
> > > > 
> > > > Feedback is welcome,
> > > > 
> > > > Thanks,
> > > > 
> > > > Mathieu
> > > 
> > > 
> > > So, it seems there is no issue in spreading the whole into
> > > each relevant trees?
> > 
> > Because there is a dependency on patch 01, I think it would be much less painful
> > to bring in the whole patchset through the tracing tree rather than each
> > targeted tree. Otherwise, we have to ensure that each tree has pulled the commit
> > from the tracing tree before pulling the patches that depend on it.
> 
> Ok.
>  
> > And it only really touches the include/trace/ header files, so it's not as if it
> > touched any specific subsystem code.
> 
> Beware, there are many trace events all over the kernel, not only in
> include/trace

That's right. I grepped for all includes of define_trace.h throughout the whole
kernel to find the others. But they also depend on patch 01.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
