Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab0LAGQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 01:16:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60860 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751167Ab0LAGQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 01:16:17 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19WishMGtVWhtqgLnCR9XWa0xrUpeRcsc78/AEUjA
	Dp+5pRFCzJLuMt
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF5C379.8030204@google.com>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>  <4CF5C379.8030204@google.com>
Content-Type: text/plain
Date: Wed, 01 Dec 2010 07:16:13 +0100
Message-Id: <1291184173.7466.147.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 19:39 -0800, Paul Turner wrote:
> On 11/28/10 06:24, Mike Galbraith wrote:
> >
> > Something else is seriously wrong though.  36.1 with attached (plus
> > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > running, wakeup-latency is showing latencies of>100ms, amarok skips,
> > mouse lurches badly.. generally horrid.  Something went south.
> 
> I'm looking at this.
> 
> The share:share ratios looked good in static testing, but perhaps we 
> need a little more wake-up boost to improve interactivity.

Yeah, feels like a wakeup issue.  I too did a (brief) static test, and
that looked ok.

	-Mike

