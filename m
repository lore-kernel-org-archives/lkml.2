Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0EDRmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:42:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0EDRmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:42:42 -0400
Subject: Re: [PATCH 04/12] perf: add @rq to perf_event_task_sched_out()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <4BE057EB.80604@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272976724-14312-5-git-send-email-tj@kernel.org>
	 <1272993090.1642.184.camel@laptop>  <4BE057EB.80604@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 19:42:34 +0200
Message-ID: <1272994954.1642.204.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 19:22 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/04/2010 07:11 PM, Peter Zijlstra wrote:
> > On Tue, 2010-05-04 at 14:38 +0200, Tejun Heo wrote:
> >> Add @rq to perf_event_task_sched_out() so that its argument matches
> >> those of trace_sched_switch().  This will help unifying notifiers in
> >> sched.
> > 
> > The alternative is dropping rq from the trace events, its not like
> > anybody outside sched.o can do anything sensible with it anyway.
> 
> The comment in include/trace/events/sched.h says...
> 
>  * (NOTE: the 'rq' argument is not used by generic trace events,
>  *        but used by the latency tracer plugin. )
> 
> So, I left it there.  It would be great if all those @rq params can be
> removed tho.  The latency tracer thing needs it, right?

I had a quick look but couldn't actually find anything.

