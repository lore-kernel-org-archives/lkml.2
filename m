Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab1EaD0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 23:26:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59648 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752493Ab1EaD0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 23:26:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX187+slcE2Q7QomwQqGegiumf+4kCBltTeNAfwxxb7
	48uj74Zh/SpNAG
Subject: Re: [PATCH] sched: fix need_resched() when checking peempt
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
References: <BANLkTin4OiDiPO3znMvKTVZcYukHReydMQ@mail.gmail.com>
	 <1306244383.1465.59.camel@gandalf.stny.rr.com>
	 <BANLkTin2r7omjQC9ro0f2_qEc8SzPX33Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 05:26:24 +0200
Message-ID: <1306812384.7903.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 21:50 +0800, Hillf Danton wrote:
> On Tue, May 24, 2011 at 9:39 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2011-05-24 at 21:27 +0800, Hillf Danton wrote:
> >> When checking if current task could be preempted by a newly woken task,
> >> further check could be bypassed if the current thread is different from
> >> the current task of run-queue, and it is corrected accordingly.
> >
> > Ug, that change log is an obfuscated mess. But looking at the actual
> > patch, I figured what you wanted to say. How about this:
> >
> > ----
> > The RT preempt check tests the wrong task if NEED_RESCHED is set. It
> > currently checks the local CPU task. It is suppose to check the task
> > that is running on the run queue we are about to wake another task on.
> > ----
> >
> Thanks, it is great changelog:)

Has this been queued, or is it awaiting re-submission?

	-Mike

