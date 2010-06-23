Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0FWPCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:02:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0FWPCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:02:32 -0400
Date: Wed, 23 Jun 2010 17:02:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing: Fix undeclared ENOSYS in
 include/linux/tracepoint.h
Message-ID: <20100623150224.GA6603@elte.hu>
References: <1277298250.9181.32.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277298250.9181.32.camel@gandalf.stny.rr.com>
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
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Wu Zhangjin (1):
>       tracing: Fix undeclared ENOSYS in include/linux/tracepoint.h
> 
> ----
>  include/linux/tracepoint.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo
