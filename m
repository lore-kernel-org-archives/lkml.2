Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab0KRJjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:39:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab0KRJjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:39:41 -0500
Date: Thu, 18 Nov 2010 10:39:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Stefaniuc <mstefani@redhat.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>
Subject: Re: [GIT PULL] hw-breakpoint fixes
Message-ID: <20101118093914.GE28467@elte.hu>
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (1):
>       x86: Ignore trap bits on single step exceptions
> 
> Jason Wessel (1):
>       perf,hw_breakpoint: Initialize hardware api earlier
> 
> 
>  arch/x86/kernel/hw_breakpoint.c |    4 ++++
>  include/linux/hw_breakpoint.h   |    4 ++++
>  kernel/hw_breakpoint.c          |    3 +--
>  kernel/perf_event.c             |    6 ++++++
>  4 files changed, 15 insertions(+), 2 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
