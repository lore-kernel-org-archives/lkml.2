Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab0K3EOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:14:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44173 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751287Ab0K3EOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:14:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9nx0ajNe9t3Ltr5KuBsnYLKLHbqlKcWwNL0mO7A
	EQzt7NXEKExQDo
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 30 Nov 2010 05:14:15 +0100
Message-Id: <1291090455.7550.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 19:39 -0800, Paul Turner wrote:
> On Mon, Nov 29, 2010 at 11:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Mike Galbraith <efault@gmx.de> wrote:
> >
> >> > I know, from the testing so far we _thought_ it was fairly sane. Apparently
> >> > there's still some work to do.
> >>
> >> Damn thing bisected to:
> >>
> >> commit 92fd4d4d67b945c0766416284d4ab236b31542c4
> >> Merge: fe7de49 e53beac
> >> Author: Ingo Molnar <mingo@elte.hu>
> >> Date:   Thu Nov 18 13:22:14 2010 +0100
> >>
> >>     Merge commit 'v2.6.37-rc2' into sched/core
> >>
> >>     Merge reason: Move to a .37-rc base.
> >>
> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>
> >> 92fd4d4d67b945c0766416284d4ab236b31542c4 is the first bad commit
> >
> > Hm, i'd suggest to double check the two originator points:
> >
> >  e53beac - is it really 'bad' ?
> >  fe7de49 - is it really 'good'?
> >
> > Thanks,
> >
> >        Ingo
> >
> 
> https://lkml.org/lkml/2010/11/29/566
> 
> Should fix this.

No, I had it in place where pertinent.  Problem with bisection is that
there are a couple of spots where X doesn't work.  With X, it's obvious,
less so in text console.  Looks like I must have miscalled one of those.

	-Mike

