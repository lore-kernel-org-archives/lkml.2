Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0GIUS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:18:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab0GIUS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:18:56 -0400
Date: Fri, 9 Jul 2010 22:18:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zeev Tarantov <zeev.tarantov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH][GIT PULL][for 2.6.35] tracing: Add alignment to syscall
 metadata declarations
Message-ID: <20100709201838.GA1518@elte.hu>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278705402.1537.157.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0564]
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
> Steven Rostedt (1):
>       tracing: Add alignment to syscall metadata declarations
> 
> ----
>  include/linux/syscalls.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

Pulled, thanks Steve!

	Ingo
