Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1FQCl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:41:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1FQCly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:41:54 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=TESY4y5sNP4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=vH8EL2zNPtjTOrYgRDcA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=_RhRFcbxBZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 4/7] sched, rt: Fix rq->rt.pushable_tasks bug in
 push_rt_task()
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>, Hillf Danton <dhillf@gmail.com>
In-Reply-To: <1308278005.15063.12.camel@marge.simson.net>
References: <20110617015516.301117218@goodmis.org>
	 <20110617015919.136959032@goodmis.org>
	 <1308278005.15063.12.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 22:41:53 -0400
Message-ID: <1308278513.9218.164.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 04:33 +0200, Mike Galbraith wrote:
> On Thu, 2011-06-16 at 21:55 -0400, Steven Rostedt wrote:
> > plain text document attachment
> > (0004-sched-rt-Fix-rq-rt.pushable_tasks-bug-in-push_rt_tas.patch)
> > From: Hillf Danton <dhillf@gmail.com>
> > 
> > Do not call dequeue_pushable_task() when failing to push an eligible
> > task, as it remains pushable, merely not at this particular moment.
> > 
> > Cc: Yong Zhang <yong.zhang0@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > Signed-off-by: Mike Galbraith <mgalbraith@gmx.de>
> 
> Mixing addresses doesn't work.  Less bouncy SOB.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 

Thanks! I'm going to rebase these patches anyway. I'll update it when I
do that.

-- Steve


