Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab1FBHlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:41:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59296 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702Ab1FBHlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:41:21 -0400
Date: Thu, 2 Jun 2011 09:40:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 4/6] MAINTAINERS: Remove unused PERFORMANCE EVENTS pattern
Message-ID: <20110602074057.GE2150@elte.hu>
References: <cover.1306950701.git.joe@perches.com>
 <8d1e596980a6b6fec79432bb5a5953985cf85c2f.1306950701.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d1e596980a6b6fec79432bb5a5953985cf85c2f.1306950701.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Joe Perches <joe@perches.com> wrote:

> No arch/*/lib/perf_event* files exist so remove the pattern.
> 
> cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> cc: Paul Mackerras <paulus@samba.org>
> cc: Ingo Molnar <mingo@elte.hu>
> cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ab6340f..6f6a8ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4908,7 +4908,6 @@ F:	arch/*/kernel/perf_event*.c
>  F:	arch/*/kernel/*/perf_event*.c
>  F:	arch/*/kernel/*/*/perf_event*.c
>  F:	arch/*/include/asm/perf_event.h
> -F:	arch/*/lib/perf_event*.c
>  F:	arch/*/kernel/perf_callchain.c
>  F:	tools/perf/

The arch/*/lib/ hierarchy is a common place to put stuff into, it 
does not hurt at all to have it mentioned.

In Linux there's 10+ really important, not yet implemented features 
to implement, there's 100+ under-maintained subsystems to maintain, 
there's 1000+ not yet fixed bugs to fix, there's 10,000+ ugly driver 
files to be improved and there's 1,000,000+ stylistic errors to fix.

Mucking with the MAINTAINERS file on the level you did in this patch 
comes some time after we've fixed the 1,000,000+ stylistic errors.

Could you please stop mucking with these patterns and start dealing 
with some of the more important problems we have?

Thanks,

	Ingo
