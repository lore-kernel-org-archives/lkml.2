Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1EVItt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 04:49:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1EVItn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 04:49:43 -0400
Date: Sun, 22 May 2011 10:49:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] perf tools updates
Message-ID: <20110522084934.GB27167@elte.hu>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo, Arnaldo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       perf tools: Check we are able to read the event size on mmap
>       perf tools: Remove junk code in mmap size handling
>       perf tools: Move evlist sample helpers to evlist area
>       perf tools: Pre-check sample size before parsing
>       perf tools: Robustify dynamic sample content fetch
>       perf tools: Propagate event parse error handling
> 
> 
>  tools/perf/builtin-test.c |    9 ++++++++-
>  tools/perf/builtin-top.c  |    7 ++++++-
>  tools/perf/util/event.c   |   16 ++++++++++++++++
>  tools/perf/util/event.h   |   12 +++++++++++-
>  tools/perf/util/evlist.c  |   31 +++++++++++++++++++++++++++++++
>  tools/perf/util/evlist.h  |    3 +++
>  tools/perf/util/evsel.c   |   32 +++++++++++++++++++++++++++++++-
>  tools/perf/util/header.c  |   31 -------------------------------
>  tools/perf/util/header.h  |    2 --
>  tools/perf/util/python.c  |   13 ++++++++++---
>  tools/perf/util/session.c |   25 ++++++++++++++++++-------
>  tools/perf/util/session.h |    2 ++
>  12 files changed, 136 insertions(+), 47 deletions(-)

To get this upstream ASAP i pulled them into perf/urgent and resolved two 
conflicts there (a contextual and a semantic one) - please double check my 
resolutions.

Thanks,

	Ingo
