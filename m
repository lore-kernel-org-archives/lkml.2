Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0IUMfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:35:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab0IUMfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:35:24 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=q55zqXDHAPkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=GcgHa30R1u_DrxsObdMA:9 a=5KF8lihef8IuIVKs1eZz_-OZV4YA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/4] tracing/sched: Add sched_rt_setprio tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1285067692.2275.830.camel@laptop>
References: <20100921024002.672817629@goodmis.org>
	 <20100921024139.369929073@goodmis.org>  <1285067692.2275.830.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 08:35:22 -0400
Message-ID: <1285072522.23122.1728.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 13:14 +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-20 at 22:40 -0400, Steven Rostedt wrote:
> > plain text document attachment
> > (0004-tracing-sched-Add-sched_rt_setprio-tracepoint.patch)
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Add a tracepoint that shows the priority of a task being boosted
> > via priority inheritance.
> 
> I'm not too sure about having this tracepoint.. Ideally I'd like to
> rewrite the whole PI crap to not actually need anything like this.

Yeah, I know we want to change all that. But until we have new code, we
could have this tracepoint to even help with modifying it.

Tracepoints show internal functioning of the kernel and are always
subject to change. Until we have a TRACE_EVENT_ABI(), these can come and
go with each version. I think this tracepoint is valuable.

> 
> Also, sched_pi_setprio() would be a better name I think.
> 

I'll update it for the above, thanks!

-- Steve


