Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1FJClq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 22:41:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37658 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab1FJClp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 22:41:45 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=cWu3orRm09UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=rwAI9wVLXzAZ26kzK84A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove resetting exec_start in
 put_prev_task_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=Y+0h9bMaT6Z4+MhHf==POMKJNoQ@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	 <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
	 <1307622863.9218.40.camel@gandalf.stny.rr.com>
	 <BANLkTi=Y+0h9bMaT6Z4+MhHf==POMKJNoQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 09 Jun 2011 22:41:43 -0400
Message-ID: <1307673703.9218.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 10:38 +0800, Yong Zhang wrote:
> On Thu, Jun 9, 2011 at 8:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > I disagree. Yes the exec_start is reset there, but I like the fact that
> > it's 0 when not running.
> 
> Actually this depends on how we look at the code:
> if we set exec_start to 0 explicitly, as you said the code is more direct and
> readable.
> if we don't set exec_start to 0, we can save one instruction though
> it's minor.
> 
> I have no strong opinion on either of them :)

I don't have any real strong opinion on this either, so I'll just let
Peter decide :)

-- Steve

> 
> BTW, put_prev_task_fair() doesn't set exec_start to 0.


