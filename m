Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1GFNu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:50:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1GFNu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:50:57 -0400
Date: Wed, 6 Jul 2011 15:50:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] sched/preempt fixes
Message-ID: <20110706135042.GA4037@elte.hu>
References: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309881868-9483-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the sched/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	sched/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (3):
>       m32r: Use generic PREEMPT config
>       h8300: Use generic config PREEMPT definition
>       xtensa: Use generic config PREEMPT definition
> 
> 
>  arch/h8300/Kconfig.cpu |    4 +---
>  arch/m32r/Kconfig      |   12 +-----------
>  arch/xtensa/Kconfig    |   13 +------------
>  3 files changed, 3 insertions(+), 26 deletions(-)

Pulled, thanks Frederic!

	Ingo
