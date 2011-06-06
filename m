Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab1FFL0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:26:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab1FFL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:26:08 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=MbabkVIayccA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=D19gQVrFAAAA:8 a=bEVj1oVnpHg5j2bvhWAA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove noop in pre_schedule_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTinO4p5d-aShHuSOQoPLTCZvAcVjcQ@mail.gmail.com>
References: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
	 <BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
	 <BANLkTinO4p5d-aShHuSOQoPLTCZvAcVjcQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Jun 2011 07:26:03 -0400
Message-ID: <1307359563.31814.14.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 16:35 +0800, Hillf Danton wrote:
> On Fri, May 27, 2011 at 5:17 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Thu, May 26, 2011 at 9:08 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> Checking task to be RT is removed since only RT task is served here.
> >>
> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> >
> > Actually this patch has been raised for two times:
> > https://lkml.org/lkml/2010/12/13/622
> > http://lkml.org/lkml/2010/2/9/139
> >
> 
> Hm... looks curious why it had been delivered more than once.

What's curious about it?

Yong sent me the patch, and I pulled it into git, and sent a pull
request to Ingo along with some trivial changes of mine. All my pull
requests are posted back to LKML so that we keep an open environment of
what goes into the kernel.

-- Steve



