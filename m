Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab0EDGfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:35:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0EDGfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:35:08 -0400
Date: Tue, 4 May 2010 08:34:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL] lockdep stat fixes
Message-ID: <20100504063457.GA10464@elte.hu>
References: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272944736-25141-1-git-send-regression-fweisbec@gmail.com>
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
> Please pull the core/locking branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	core/locking
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (3):
>       lockdep: Provide off case for redundant_hardirqs_on increment
>       lockdep: Actually _dec_ in debug_atomic_dec
>       lockdep: No need to disable preemption in debug atomic ops
> 
> 
>  kernel/lockdep.c           |    2 +-
>  kernel/lockdep_internals.h |    8 ++++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)

Pulled, thanks!

	Ingo
