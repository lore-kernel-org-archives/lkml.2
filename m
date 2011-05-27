Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1E0MbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:31:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1E0MbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:31:03 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=MbabkVIayccA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=OHgYj2wvPM0udUonRTMA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: remove noop in pre_schedule_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
References: <BANLkTin1QYAx7as41t78-n0giLSBWoToVA@mail.gmail.com>
	 <BANLkTi=N8cm_9OKk8VCPVxPPn+Ejuhzq6w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 08:31:00 -0400
Message-ID: <1306499460.3857.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 17:17 +0800, Yong Zhang wrote:
> On Thu, May 26, 2011 at 9:08 PM, Hillf Danton <dhillf@gmail.com> wrote:
> > Checking task to be RT is removed since only RT task is served here.
> >
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> 
> Actually this patch has been raised for two times:
> https://lkml.org/lkml/2010/12/13/622
> http://lkml.org/lkml/2010/2/9/139
> 

Heh, and that's still sitting in my repo on kernel.org. Never been
pulled. I'll ping Ingo about that for the next merge window.

Thanks! I forgot about that pull request.

-- Steve



