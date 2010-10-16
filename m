Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0JPMtN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 08:49:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab0JPMtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 08:49:10 -0400
Date: Sat, 16 Oct 2010 14:49:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] ftrace: recordmcount fixes
Message-ID: <20101016124902.GB8751@elte.hu>
References: <20101015161334.766423984@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015161334.766423984@goodmis.org>
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
> Please pull the latest tip/perf/recordmcount tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/recordmcount
> 
> 
> Steven Rostedt (2):
>       ftrace: Do not process kernel/trace/ftrace.o with C recordmcount program
>       ftrace: Use objtree for C version of recordmcount
> 
> ----
>  scripts/Makefile.build |    2 +-
>  scripts/recordmcount.c |   22 ++++++++++++++++++++--
>  2 files changed, 21 insertions(+), 3 deletions(-)

Pulled, thanks Steve!

	Ingo
