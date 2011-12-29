Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1L2RSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1L2RSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:18:47 -0500
Date: Thu, 29 Dec 2011 18:12:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <kirill.tkhai@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: SCHED_RR && time_slice
Message-ID: <20111229171256.GA5955@redhat.com>
References: <1324584060.4222.15.camel@hp> <20111226165930.GA4075@redhat.com> <1325177015.9304.9.camel@hp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325177015.9304.9.camel@hp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29, Kirill Tkhai wrote:
>
> Thanks for the answers, Oleg.
>
> On Mon, 2011-12-26 at 17:59 +0100, Oleg Nesterov wrote:
> > On 12/23, Kirill Tkhai wrote:
> > >
> > > RT class uses its own fixed
> > > timeslice (in case of RR),
> >
> > which looks confusing too, btw.
> >
> > sched_set_scheduler() does not initialize rt.time_slice, and
> > INIT_TASK() sets time_slice = HZ (not DEF_TIMESLICE).
> >
>
> I talk about task_tick_rt().

me too ;)

> When time_slice is over, it is being
> renewed. New value is DEF_TIMESLICE. This happens in case of SCHED_RR
> class.

Yes, but I was talking about initial value of time_slice, when the
task switches to SCHED_RR.

Oleg.

