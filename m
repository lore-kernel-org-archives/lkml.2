Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab0EMTmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:42:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35563 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0EMTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:42:44 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=EYIAjt0hOJkA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=siLC1mCeuq4SDB2pEqUA:9 a=ZLMMt6bphTYFq4pMZjlJUaRajqMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/4] tracing: Allow mmio tracer to display
 trace_printk() and other events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1273763483.27703.991.camel@gandalf.stny.rr.com>
References: <20100513012110.558313399@goodmis.org>
	 <20100513012302.352845720@goodmis.org>
	 <20100513115414.7688b51d@daedalus.pq.iki.fi>
	 <1273752909.27703.809.camel@gandalf.stny.rr.com>
	 <20100513152915.3d3f852b@daedalus.pq.iki.fi>
	 <1273763483.27703.991.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 15:42:41 -0400
Message-ID: <1273779761.27703.1329.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:11 -0400, Steven Rostedt wrote:

> > > How does that sound?
> > 
> > That would be fine. Is it not redundant with what you said in
> > your first sentence?
> > 
> 
> Right now with this patch as is. When you enable the mmiotracer it
> clears the ring buffer. But if someone previously enabled an event (like
> sched_switch for example) then that event will appear in the output of
> the tracer.
> 
> The user will need to disable that event and restart the mmiotracer so
> the output will not break the userspace tools. Is this OK?
> 
> If not, then my suggestion is to have an mmiotracer option that keeps it
> from printing out any event except for the ones it knows about.
> 
> The reason I added this patch in the first place was because Larry
> Finger was using the mmiotrace with trace_printk() and the current code
> does not print out the trace_printk() when mmiotracer is active.

Pekka,

Are you OK with this version of the patch or do you want me to add the
option as described above?

-- Steve


