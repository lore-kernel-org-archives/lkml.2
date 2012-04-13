Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2DMNh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:37:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24346 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2DMNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:37:26 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ASPqzAbYsGkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=swNhhU6mUVexVLaUfhUA:9 a=PUjeQqilurYA:10 a=yFd4LeGOoOUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334324244.23924.357.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.4] tracing: Fix build breakage without
 CONFIG_PERF_EVENTS (again)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Date: Fri, 13 Apr 2012 09:37:24 -0400
In-Reply-To: <20120413085315.GC3168@opensource.wolfsonmicro.com>
References: <1334262300.23924.348.camel@gandalf.stny.rr.com>
	 <1334263193.23924.353.camel@gandalf.stny.rr.com>
	 <20120413085315.GC3168@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 09:53 +0100, Mark Brown wrote:
> On Thu, Apr 12, 2012 at 04:39:53PM -0400, Steven Rostedt wrote:
> 
> > Looking at this patch in more depth, it may be cleaner to do:
> 
> > #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_FUNCTION_TRACER)
> > int perf_ftrace_event_register(struct ftrace_event_call *call,
> >   			       enum trace_reg type, void *data);
> > #else
> > # define perf_ftrace_event_register NULL
> > #endif
> 
> > Mark, would you like to make the above update?
> 
> I've sent a revised version of the patch out.  I really don't care which
> version gets merged or who writes the patch so long as we can get this
> fixed.

I know it's trivial, but people do get upset when one developer redoes
the work of another. But thanks! I'm adding it to my tree now and
testing it.

-- Steve


