Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0HaVKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:10:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0HaVKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:10:21 -0400
Date: Tue, 31 Aug 2010 23:10:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing/lockdep: Fix dependency of
 TRACE_IRQFLAGS
Message-ID: <20100831211005.GB8103@elte.hu>
References: <1283288038.1377.465.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283288038.1377.465.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This only fixes a build warning, so I'm guessing that it can wait till
> 2.6.37. If you think otherwise, I could add it to my tip/perf/urgent
> branch instead.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (1):
>       tracing/lockdep: Fix dependency of TRACE_IRQFLAGS
> 
> ----
>  lib/Kconfig.debug |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

Pulled, thanks Steve!

	Ingo
