Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0IWGsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:48:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0IWGsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:48:19 -0400
Date: Thu, 23 Sep 2010 08:48:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v2.6.36] tracing: fixes for tracing virt
 guests
Message-ID: <20100923064808.GC17733@elte.hu>
References: <20100923030359.649647055@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923030359.649647055@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I actually did these fixes back in July for RHEL, but forgot about
> them for mainline :-(
> 
> Jeremy hit the same bug and set me a fix. It was only part of what
> I did in July, so I pulled in his fix and added the second part.
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Jeremy Fitzhardinge (1):
>       tracing/x86: Don't use mcount in pvclock.c
> 
> Steven Rostedt (1):
>       tracing/x86: Don't use mcount in kvmclock.c
> 
> ----
>  arch/x86/kernel/Makefile |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo
