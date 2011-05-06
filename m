Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab1EFTIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:08:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab1EFTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:08:40 -0400
Date: Fri, 6 May 2011 21:08:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf events, x86: Add SandyBridge
 stalled-cycles-frontend/backend events
Message-ID: <20110506190821.GA7151@elte.hu>
References: <1304666042-17577-1-git-send-email-ming.m.lin@intel.com>
 <tip-e04d1b23f9706186187dcb0be1a752e48dcc540b@git.kernel.org>
 <1304697112.25414.2523.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304697112.25414.2523.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2011-05-06 at 07:40 +0000, tip-bot for Lin Ming wrote:
> > Commit-ID:  e04d1b23f9706186187dcb0be1a752e48dcc540b
> > Gitweb:     http://git.kernel.org/tip/e04d1b23f9706186187dcb0be1a752e48dcc540b
> > Author:     Lin Ming <ming.m.lin@intel.com>
> > AuthorDate: Fri, 6 May 2011 07:14:02 +0000
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 6 May 2011 09:37:03 +0200
> > 
> > perf events, x86: Add SandyBridge stalled-cycles-frontend/backend events
> > 
> > Extend the Intel SandyBridge PMU driver with definitions
> > for generic front-end and back-end stall events.
> > 
> > ( As commit 3011203 "perf events, x86: Add Westmere stalled-cycles-frontend/backend
> >   events" says, these are only approximations. )
> 
> I now get the following build error:
> 
> In file included from /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event.c:1449:0:
> /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c: In function 'intel_pmu_init':
> /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c:1479:27: error: 'PERF_COUNT_HW_STALLED_CYCLES_FRONTEND' undeclared (first use in this fun
> ction)
> /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c:1479:27: note: each undeclared identifier is reported only once for each function it appe
> ars in
> /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/kernel/cpu/perf_event_intel.c:1481:27: error: 'PERF_COUNT_HW_STALLED_CYCLES_BACKEND' undeclared (first use in this func
> tion)
> 
> Config can be found here:
> 
> http://rostedt.homelinux.com/private/config-sandy-failed

Ok, could you check latest perf/core (57d524154ffe), does it work better?

Thanks,

	Ingo
