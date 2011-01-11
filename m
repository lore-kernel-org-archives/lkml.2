Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1AKLJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:09:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55989 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab1AKLJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:09:28 -0500
Date: Tue, 11 Jan 2011 12:09:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Lai Jiangshan <eag0628@gmail.com>
Subject: Re: [GIT PULL] rtmutex: Fix comment about why new_owner can be NULL
 in wake_futex_pi()
Message-ID: <20110111110914.GD5253@elte.hu>
References: <1294719469.26623.246.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294719469.26623.246.camel@gandalf.stny.rr.com>
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
> While porting Lai Jiangshan's rt-pi patch to the -rt kernel, I found
> that the comment about why rt_mutex_next_owner() can return NULL is
> incorrect. This caused Lai to remove the following if condition, which
> caused a bit of headache in debugging why his patch was causing a crash.
> 
> Please pull the latest tip/futex tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/futex
> 
> 
> Steven Rostedt (1):
>       rtmutex: Fix comment about why new_owner can be NULL in wake_futex_pi()
> 
> ----
>  kernel/futex.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)

Pulled into tip:core/urgent, thanks Steve!

	Ingo
