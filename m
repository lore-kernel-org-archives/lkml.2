Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab0JOENV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:13:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0JOENS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:13:18 -0400
Date: Fri, 15 Oct 2010 06:13:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-arch@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        John Reiser <jreiser@bitwagon.com>
Subject: Re: [PATCH][GIT PULL] ftrace: Rename config option
 HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
Message-ID: <20101015041307.GA31764@elte.hu>
References: <1287114319.23682.34.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287114319.23682.34.camel@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> Please pull the latest tip/perf/recordmcount-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/recordmcount-2
> 
> 
> Steven Rostedt (1):
>       ftrace: Rename config option HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
> 
> ----
>  Makefile             |    2 +-
>  arch/x86/Kconfig     |    2 +-
>  kernel/trace/Kconfig |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

The full diffstat (due to the previous commits) was:

 Makefile               |    6 +
 arch/x86/Kconfig       |    1 +
 kernel/trace/Kconfig   |    5 +
 scripts/Makefile       |    1 +
 scripts/Makefile.build |    4 +
 scripts/recordmcount.c |  345 +++++++++++++++++++++++++++++++++++++++++++++
 scripts/recordmcount.h |  366 ++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 728 insertions(+), 0 deletions(-)
 create mode 100644 scripts/recordmcount.c
 create mode 100644 scripts/recordmcount.h

Pulled, thanks a lot Steve!

	Ingo
