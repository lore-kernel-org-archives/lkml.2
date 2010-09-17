Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0IQG77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:59:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab0IQG76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:59:58 -0400
Date: Fri, 17 Sep 2010 08:59:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matt Helsley <matthltc@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] hw_breakpoint fixes
Message-ID: <20100917065950.GA5402@elte.hu>
References: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
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
>       x86: Fix instruction breakpoint encoding
> 
> Matt Helsley (1):
>       hw breakpoints: Fix pid namespace bug
> 
> 
>  arch/x86/include/asm/hw_breakpoint.h |    2 +-
>  arch/x86/kernel/hw_breakpoint.c      |   40 ++++++++++++++++-----------------
>  kernel/hw_breakpoint.c               |    3 +-
>  3 files changed, 22 insertions(+), 23 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
