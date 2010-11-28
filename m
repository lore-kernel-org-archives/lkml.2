Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0K1UTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 15:19:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52276 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab0K1UTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 15:19:09 -0500
Date: Sun, 28 Nov 2010 21:18:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101128201851.GA20555@elte.hu>
References: <20101121133744.GA10765@elte.hu>
 <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net>
 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Nov 28, 2010 at 6:24 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > Something else is seriously wrong though.  36.1 with attached (plus
> > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > running, wakeup-latency is showing latencies of >100ms, amarok skips,
> > mouse lurches badly.. generally horrid.  Something went south.
> 
> Can you test -rc3? Is that still ok? And are you perhaps using
> Nouveau? There's a report of some graphics (?) regression since -rc3
> about bad desktop performance:
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=23912
> 
> but it doesn't have any more information yet (so if -rc3 _is_ good for
> you, and you can add anything to that report, it would be good. The
> original reporter is hopefully bisecting it now)

Mike, the last pure -rc3 -tip commit is 92c883adf03b - you could try to check that 
out too: it has most of the current sched/core commits, but has none of the post-rc3 
DRM changes.

Thanks,

	Ingo
