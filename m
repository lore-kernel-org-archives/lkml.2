Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0JSSxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:53:37 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34337 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752006Ab0JSSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:53:36 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/9i8wXZc39OzIRk7QapXGgPluLS4KNU+fo1hdVNZ
	Qr5tFBX9zV5vtA
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1287511983.7417.45.camel@marge.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 19 Oct 2010 20:53:30 +0200
Message-Id: <1287514410.7368.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-10-19 at 08:28 -0700, Linus Torvalds wrote:
> >
> >  If people compare with a non-CGROUP_SCHED
> > kernel, will a desktop-optimized kernel suddenly have horrible pipe
> > latency due to much higher scheduling cost? Right now that whole
> > feature is hidden by EXPERIMENTAL, I don't know how much it hurts, and
> > I never timed it when I tried it out long ago..

Q/D test of kernels w/wo, with same .config using pipe-test (pure sched)
gives on my box ~590khz with tty_sched active, 620khz without cgroups
acitve in same kernel/config without patch.  last time I measured
stripped down config (not long ago, but not yesterday either) gave max
ctx rate ~690khz on this box.

(note: very Q, very D numbers, no variance testing, ballpark)

	-Mike

