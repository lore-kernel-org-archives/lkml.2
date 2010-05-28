Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0E1Igm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:36:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0E1Igi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:36:38 -0400
Date: Fri, 28 May 2010 10:36:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] ring-buffer: Some minor fixes for the
 latest changes
Message-ID: <20100528083621.GC24058@elte.hu>
References: <20100525161259.568803673@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525161259.568803673@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1555]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (2):
>       ring-buffer: Reset "real_end" when page is filled
>       ring-buffer: Move zeroing out excess in page to ring buffer code
> 
> ----
>  kernel/trace/ring_buffer.c |   19 +++++++++++++++++--
>  kernel/trace/trace.c       |    6 ------
>  2 files changed, 17 insertions(+), 8 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
