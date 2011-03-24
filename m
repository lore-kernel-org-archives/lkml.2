Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab1CXUDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:03:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847Ab1CXUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:03:05 -0400
Date: Thu, 24 Mar 2011 21:03:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
Message-ID: <20110324200300.GD7957@elte.hu>
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
 <20110324084819.GH30812@elte.hu>
 <4D8B6569.2030001@gmail.com>
 <20110324163332.GA2414@elte.hu>
 <4D8B7570.40101@gmail.com>
 <20110324182221.GF1239@redhat.com>
 <4D8B8CC4.8000500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B8CC4.8000500@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 03/24/2011 09:22 PM, Don Zickus wrote:
> > On Thu, Mar 24, 2011 at 07:46:40PM +0300, Cyrill Gorcunov wrote:
> >>>> The read of a proper MSR register was missed so instead of a counter the 
> >>>> configration register is tested (it has ARCH_P4_UNFLAGGED_BIT always cleared) 
> >>>> and unflagged overflows never have been catched. Fix it by reading a proper 
> >>>> MSR register.
> >>>
> >>> So what effect does this have on the regular perf user? Please try to describe 
> >>> the real-life effect of the bug/problem fixed here.
> >>>
> >>> Thanks,
> >>>
> >>> 	Ingo
> >>
> >> Unflagged overflows never have been catched due to missed read of a register which
> >> is to signalize about it, and as result unknown nmi may happen leading to
> >> "Dazen and confused" message. That is what supposed to be in changelog?
> > 
> > I think Ingo is looking for something like this:
> > 
> 
> Thanks Don, if Ingo agree I can update it.

Sure - please resend the final patch in a clean thread, with a proper title, 
etc.

Thanks,

	Ingo
