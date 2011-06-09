Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1FIHHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:07:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60044 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab1FIHHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:07:20 -0400
Date: Thu, 9 Jun 2011 09:07:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL][v3.0] tracing: fixes
Message-ID: <20110609070709.GA20544@elte.hu>
References: <20110607170740.235441001@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607170740.235441001@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> GuoWen Li (1):
>       ftrace: Fix possible undefined return code
> 
> Steven Rostedt (2):
>       kprobes/trace: Fix kprobe selftest for gcc 4.6
>       ftrace: Revert 8ab2b7efd ftrace: Remove unnecessary disabling of irqs
> 
> ----
>  kernel/trace/ftrace.c       |    9 ++++++++-
>  kernel/trace/trace_kprobe.c |    8 ++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)

Pulled, thanks Steve!

	Ingo
