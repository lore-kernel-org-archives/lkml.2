Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0IUMdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 08:33:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0IUMdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 08:33:39 -0400
X-Authority-Analysis: v=1.1 cv=xllhIT3+0iZermAJQK9ulaVoiSOvD1gApk/LON5m1IU= c=1 sm=0 a=JHTv7ofuiP8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VZ7G-AfNjWW1V1sEdUEA:9 a=sOo07PD3mfrEO3UdwpsEcZNkkEUA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/4] tracing/sched: Add sched_rt_push and sched_rt_pull
 tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <1285058793.2275.799.camel@laptop>
References: <20100921024002.672817629@goodmis.org>
	 <20100921024139.095017089@goodmis.org>  <1285058793.2275.799.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 08:33:36 -0400
Message-ID: <1285072416.23122.1723.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 10:46 +0200, Peter Zijlstra wrote:
> On Mon, 2010-09-20 at 22:40 -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Seeing how tasks are affected by the push/pull algorithm of the RT
> > scheduler helps in understanding the migration of RT tasks.
> > 
> > Adding these two tracepoints to show when an RT task is pushed from
> > one CPU to another, or pulled helps with analyzing the way the
> > scheduler works. 
> 
> Why doesn't the migration tracepoint cover this? It shows you the task,
> the prio, the old and new cpu. If the migration is logged from the old
> cpu, its a push, if its logged from the new its a pull, no?

For some reason it did not help me enough in my analysis. I'll go back
and see why.

I originally had these tracepoints at the front of the series, and
realized they may be a little controversial, thus I moved them to the
end.

-- Steve


