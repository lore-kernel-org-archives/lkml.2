Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1ERBVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:21:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1ERBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:21:16 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=XYJHFtupD_QA:10 a=g7CSJYxaNw4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0QjK-NrcmBp6hxVYtzUA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 17 May 2011 21:21:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: avoid overpull when pulling RT task
Message-ID: <20110518012114.GB23940@home.goodmis.org>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
 <1305441316.7460.40.camel@marge.simson.net>
 <BANLkTino730kar=fEDJGCy8bCSVUe52aOw@mail.gmail.com>
 <1305555077.12285.63.camel@marge.simson.net>
 <BANLkTi=0pe8U6TZsQcXssV3iK_5Y+jRWCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=0pe8U6TZsQcXssV3iK_5Y+jRWCA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:25:54PM +0800, Hillf Danton wrote:
> 
> Efforts are put on the puller's side, but bad result is reached:(
> 
> Another patch is prepared, in which pusher is asked to do the hard works,
> say pushees and tasks are selected.
> 
> Unlike puller who only concerns one runqueue that accepts the pulled tasks,
> pusher delivers tasks to more runqueues, so the overpull could get bigger.
> 
> Please review again, thanks.
> 

Have you actually observed an overpull? And if so, how bad was it?

I hate to be fixing bugs that don't really exist.

-- Steve

