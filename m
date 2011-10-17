Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab1JQS4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:56:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1JQS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:56:17 -0400
Date: Mon, 17 Oct 2011 20:54:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
Message-ID: <20111017185440.GB5545@elte.hu>
References: <20111017174938.842273454@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017174938.842273454@goodmis.org>
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
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core
> 
> Head SHA1: 436fc280261dcfce5af38f08b89287750dc91cd2
> 
> 
> Geunsik Lim (1):
>       ftrace: Fix README to state tracing_on to start/stop tracing
> 
> Steven Rostedt (1):
>       tracing: Fix returning of duplicate data after EOF in trace_pipe_raw
> 
> ----
>  kernel/trace/trace.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

Pulled, thanks Steve.

How about the m32r build fix? I think we should apply it to perf/core 
if everyone else was fine with your fix.

Thanks,

	Ingo
