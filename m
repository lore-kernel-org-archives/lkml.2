Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2CJAfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:35:34 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38077 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2CJAfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:35:33 -0500
Message-ID: <1331339714.26253.139.camel@work-vm>
Subject: Re: [PATCH] sched, x86: fix overflow in cyc2ns_offset
From: john stultz <johnstul@us.ibm.com>
To: Salman Qazi <sqazi@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Mar 2012 16:35:14 -0800
In-Reply-To: <CAKUOC8Wo6-YgrX7POQ2fukNcVre7K_f4n1+gXNk5s3gsbF-s+Q@mail.gmail.com>
References: <20120309235944.12863.28602.stgit@dungbeetle.mtv.corp.google.com>
	 <1331339140.26253.134.camel@work-vm>
	 <CAKUOC8Wo6-YgrX7POQ2fukNcVre7K_f4n1+gXNk5s3gsbF-s+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031000-7408-0000-0000-0000035766BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 16:28 -0800, Salman Qazi wrote:
> On Fri, Mar 9, 2012 at 4:25 PM, john stultz <johnstul@us.ibm.com> wrote:
> > So... Sorry, why did you change it from the shifted logic?
> >
> 
> It's more generally applicable.  The compiler is smart enough to do
> the right thing in the power-of-two
> constant case.
>
> >
> > Is the compiler really smart enough to avoid the divides?
> 
> Yes, it is.  I verified that.

Ok, great! Thanks again! (Although I probably need to put rewriting the
the big x86/include/asm/timer.h comment on my TODO, since its not as
relevant anymore)

Acked-by: John Stultz <john.stultz@linaro.org>

Ingo/Thomas, this should probably go tip/timers/urgent & be marked for
stable. I can queue it and send you a pull request, but it might be just
easier to just pick up the patch.

thanks
-john

