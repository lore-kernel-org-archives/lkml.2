Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0IHP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:59:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab0IHP7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:59:42 -0400
Date: Wed, 8 Sep 2010 17:59:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Swiecki <swiecki@google.com>,
        Chris Wright <chrisw@sous-sol.org>, Tavis Ormandy <taviso@google.com>,
        Eugene Teo <eugene@redhat.com>, vendor-sec <vendor-sec@lst.de>,
        stable@kernel.org
Subject: Re: [PATCH][GIT PULL][v2.6.36 & stable] tracing: Do not allow llseek
 to set_ftrace_filter
Message-ID: <20100908155918.GB18064@elte.hu>
References: <1283961195.5133.140.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283961195.5133.140.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> root (1):
>       tracing: Do not allow llseek to set_ftrace_filter
> 
> ----
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
