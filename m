Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0LTKPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:15:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49790 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab0LTKPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:15:36 -0500
Subject: Re: [GIT PULL] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
References: <20101219152713.GA20101@elte.hu>
	 <AANLkTinJ8hAG1TpyC+CSYPR47p48+1=E7fiC45hMXT_1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 11:15:36 +0100
Message-ID: <1292840136.2708.131.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 12:45 -0800, Linus Torvalds wrote:
> On Sun, Dec 19, 2010 at 7:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > @@ -3943,6 +4128,7 @@ need_resched_nonpreemptible:
> >                rq->nr_switches++;
> >                rq->curr = next;
> >                ++*switch_count;
> > +               WARN_ON_ONCE(test_tsk_need_resched(next));
> >
> >                context_switch(rq, prev, next); /* unlocks the rq */
> >                /*
> > diff --git a/kernel/timer.c b/kern
> 
> Please don't add like this in an -rc. It looks like it's some
> debugging aid, I don't think it should have gone in now.
> 
Correct, I did ask Ingo to remove that line before he pushed it out to
you. Anyway, it seems to be sorted now. Sorry for the bother.


