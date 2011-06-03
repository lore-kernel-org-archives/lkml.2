Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab1FCPF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:05:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52884 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab1FCPFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:05:53 -0400
Date: Fri, 3 Jun 2011 17:05:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Gregory Haskins <ghaskins@novell.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [GIT PULL] sched: Remove unlikely likelys (take two)
Message-ID: <20110603150541.GB10449@elte.hu>
References: <1307040535.3667.23.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307040535.3667.23.camel@gandalf.stny.rr.com>
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

> Hi Ingo,
> 
> I noticed this pull request never made it into tip:
> 
>  https://lkml.org/lkml/2010/12/13/625
> 
> I tested it again by merging it into latest Linus's tree and running a
> bunch of tests on it. The tests show that it still works (besides the
> bugs it finds from the normal 3.0-rc release).
> 
> Please pull the latest unlikely/sched tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> unlikely/sched
> 
> 
> Steven Rostedt (3):
>       sched: Change pick_next_task_rt from unlikely to likely
>       sched: Remove unlikely() from rt_policy() in sched.c
>       sched: Remove unlikely() from ttwu_post_activation
> 
> Yong Zhang (1):
>       sched: Cleanup pre_schedule_rt
> 
> ----
>  kernel/sched.c    |    4 ++--
>  kernel/sched_rt.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
