Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0J3TYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:24:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446Ab0J3TYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:24:47 -0400
Date: Sat, 30 Oct 2010 21:24:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL] jump label: fixes and work arounds
Message-ID: <20101030192432.GD26503@elte.hu>
References: <20101029190050.674141729@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029190050.674141729@goodmis.org>
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

> Ingo,
> 
> Please pull the latest tip/perf/jump-label-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/jump-label-2
> 
> 
> David Miller (1):
>       jump_label: Fix unaligned traps on sparc.
> 
> H. Peter Anvin (1):
>       x86, ftrace: Use safe noops, drop trap test
> 
> Jason Baron (2):
>       jump label: Fix module __init section race
>       jump label: Fix deadlock b/w jump_label_mutex vs. text_mutex
> 
> Steven Rostedt (3):
>       jump label: Fix error with preempt disable holding mutex
>       jump label: Make arch_jump_label_text_poke_early() optional
>       jump label: Add work around to i386 gcc asm goto bug
> 
> ----
>  arch/Kconfig                        |   14 ++++++
>  arch/sparc/include/asm/jump_label.h |    1 +
>  arch/x86/Makefile_32.cpu            |   13 +++++-
>  arch/x86/kernel/alternative.c       |   69 +++++++------------------------
>  include/linux/jump_label.h          |    7 +++-
>  kernel/jump_label.c                 |   77 ++++++++++++++++++++++++++++++-----
>  kernel/kprobes.c                    |   26 +++++++-----
>  7 files changed, 130 insertions(+), 77 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
