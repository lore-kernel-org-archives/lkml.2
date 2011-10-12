Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1JLISO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 04:18:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36756 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab1JLISM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 04:18:12 -0400
Date: Wed, 12 Oct 2011 10:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2 v2] [GIT PULL][v3.2] tracing: queued updates
Message-ID: <20111012081629.GA25086@elte.hu>
References: <20111011152026.701326733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011152026.701326733@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> I found the build bug with ftrace disabled. It was in the second to last
> patch of the series. It was a cut and paste error where the ftrace_is_dead()
> stub had "extern static inline" which caused the error.
> 
> I rebased and pushed to my git tree. Please check the SHA1, even though
> the mirrors should be updated by now.
> 
> I tested this branch with the following:
> 
>  allnoconfig + minconfig to boot
> 
>  full ftrace enabled to boot and test
> 
>  ftrace without function tracing to boot and test
> 
>  no tracing enabled to boot and test
> 
>  allmodconfig to boot and test - a call trace dumped from a non
>   related bug (in slub). I will investigate this later.
> 
>  allyesconfig to build - just made sure it builds.
> 
> I'm only sending out the last two patches as the other patches are
> still the same. The rebase started from the second patch.
> 
> -- Steve
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: d696b58ca2c3ca76e784ef89a7e0453d9b7ab187

Hm, even after 12+ hours of wait i can only pull 177e216 from your 
tip/perf/core. Is this a korg delay, or did you forget to push? The 
perf/urgent branch was there, so i don't think it's korg delay.

Thanks,

	Ingo
