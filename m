Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0IUNga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:36:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0IUNg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:36:29 -0400
X-Authority-Analysis: v=1.1 cv=Ba7GFA6IM/Rlu/bGJ5lftWmk/oljGo5ZwASPcBcXAAo= c=1 sm=0 a=JHTv7ofuiP8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JrdKiqj9pGYcGQDrDXsA:9 a=42MEi0imciRN29XeKkFIj9Zkwp0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/4] tracing/sched: Add sched_rt_push and sched_rt_pull
 tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1285072416.23122.1723.camel@gandalf.stny.rr.com>
References: <20100921024002.672817629@goodmis.org>
	 <20100921024139.095017089@goodmis.org>  <1285058793.2275.799.camel@laptop>
	 <1285072416.23122.1723.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 09:36:27 -0400
Message-ID: <1285076187.23122.1809.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 08:33 -0400, Steven Rostedt wrote:

> > Why doesn't the migration tracepoint cover this? It shows you the task,
> > the prio, the old and new cpu. If the migration is logged from the old
> > cpu, its a push, if its logged from the new its a pull, no?
> 
> For some reason it did not help me enough in my analysis. I'll go back
> and see why.
> 
> I originally had these tracepoints at the front of the series, and
> realized they may be a little controversial, thus I moved them to the
> end.

OK, I went back and looked, and I think you are right. I can determine
this from the migration tracepoint. I think I was just being lazy and
wanted to have the direction obvious to me :-)  I can easily do that by
adding a plugin.

Anyway, I'll remove this patch and rename the sched_rt_setprio
tracepoint to sched_pi_setprio. Would that be OK with you?

Thanks,

-- Steve


