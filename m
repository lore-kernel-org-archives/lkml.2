Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1GTOo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:44:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1GTOoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:44:55 -0400
Date: Wed, 20 Jul 2011 16:43:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.0] ftrace: urgent fixes
Message-ID: <20110720144354.GA25681@elte.hu>
References: <20110715033855.206223173@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715033855.206223173@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I noticed that tip/perf/urgent wasn't pulled yet. I added it to this
> pull request. The first patch is what you reported to me, the second
> is a regression that Thomas stumbled upon.
> 
> Please pull the latest tip/perf/urgent-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent-2
> 
> Head SHA1: f7bc8b61f65726ff98f52e286b28e294499d7a08
> 
> 
> Steven Rostedt (2):
>       ftrace: Fix warning when CONFIG_FUNCTION_TRACER is not defined
>       ftrace: Fix regression where ftrace breaks when modules are loaded
> 
> ----
>  include/linux/ftrace.h |    4 ++--
>  kernel/trace/ftrace.c  |   30 ++++++++++++++++++++++++++++--
>  2 files changed, 30 insertions(+), 4 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
