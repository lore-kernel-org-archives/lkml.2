Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0K2Fpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 00:45:35 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40585 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751177Ab0K2Fpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 00:45:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18S/GY5Vk4SdIW3RNj/aoVwUbusLoQ7YL0r/4fKxa
	ELI8iwRtobSQ0R
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 06:45:28 +0100
Message-Id: <1291009528.9082.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 11:31 -0800, Linus Torvalds wrote:
> On Sun, Nov 28, 2010 at 6:24 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Something else is seriously wrong though.  36.1 with attached (plus
> > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > running, wakeup-latency is showing latencies of >100ms, amarok skips,
> > mouse lurches badly.. generally horrid.  Something went south.
> 
> Can you test -rc3? Is that still ok? And are you perhaps using
> Nouveau? There's a report of some graphics (?) regression since -rc3
> about bad desktop performance:

No Nouveau here, plain old boring nv.

>    https://bugzilla.kernel.org/show_bug.cgi?id=23912
> 
> but it doesn't have any more information yet (so if -rc3 _is_ good for
> you, and you can add anything to that report, it would be good. The
> original reporter is hopefully bisecting it now)

I'll hunt as soon as I can (inbox runneth over).

	-Mike

