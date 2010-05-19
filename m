Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab0ESLKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:10:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46087 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab0ESLKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:10:33 -0400
Date: Wed, 19 May 2010 13:10:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [GIT PULL] Lockup detector updates
Message-ID: <20100519111027.GA12845@elte.hu>
References: <1274265455-1948-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274265455-1948-1-git-send-regression-fweisbec@gmail.com>
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
> Please pull the perf/nmi branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/nmi
> 
> Thanks,
> 	Frederic
> ---
> 
> Don Zickus (1):
>       lockup_detector: Convert per_cpu to __get_cpu_var for readability
> 
> Frederic Weisbecker (1):
>       lockup_detector: Don't enable the lockup detector by default
> 
> 
>  kernel/watchdog.c |   35 +++++++++++++++++------------------
>  lib/Kconfig.debug |    1 -
>  2 files changed, 17 insertions(+), 19 deletions(-)

Pulled, thanks!

	Ingo
