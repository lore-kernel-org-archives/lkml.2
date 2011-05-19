Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1ESRZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:25:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52710 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab1ESRZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:25:41 -0400
Date: Thu, 19 May 2011 19:25:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [GIT PULL] (missing patch) ftrace/kbuild: Add recordmcount files
 to force full build
Message-ID: <20110519172523.GB27370@elte.hu>
References: <1305809312.11267.29.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305809312.11267.29.camel@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> This is the missing patch that was suppose to be in tip/perf/core-2 but
> was missing due to git mirror lag.
> 
> I waited till the git mirrors updated this time.
> 
> Please pull the latest tip/perf/core-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core-3
> 
> 
> Michal Marek (1):
>       ftrace/kbuild: Add recordmcount files to force full build
> 
> ----
>  scripts/Makefile.build |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Pulled, thanks Steve!

	Ingo
