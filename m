Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2AHLjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:39:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2AHLjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:39:18 -0500
Date: Sun, 8 Jan 2012 12:37:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/6] perf/core cleanups, fixes and improvements
Message-ID: <20120108113704.GC26516@elte.hu>
References: <1325884564-23322-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325884564-23322-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> The following changes since commit 9e183426bfb52bb44bf3c443d6587e4d02478603:
> 
>   perf kvm: Fix copy & paste error in description (2012-01-03 15:17:14 -0200)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> Arnaldo Carvalho de Melo (3):
>       perf hists: Rename total_session to total_period
>       perf hists: Stop using 'self' for struct hist_entry
>       perf top: Don't update total_period on process_sample
> 
> Joerg Roedel (2):
>       perf kvm: Do guest-only counting by default
>       perf tools: Add support for guest/host-only profiling
> 
> Sebastian Andrzej Siewior (1):
>       perf tools: Add const.h to MANIFEST to make perf-tar-src-pkg work again
> 
>  tools/perf/Documentation/perf-list.txt |    2 +
>  tools/perf/MANIFEST                    |    1 +
>  tools/perf/builtin-kvm.c               |    6 +-
>  tools/perf/builtin-top.c               |    1 -
>  tools/perf/util/evlist.c               |    5 +-
>  tools/perf/util/hist.c                 |   97 ++++++++++++++++---------------
>  tools/perf/util/hist.h                 |    7 +--
>  tools/perf/util/parse-events.c         |   15 ++++-
>  tools/perf/util/util.c                 |   15 +++++
>  tools/perf/util/util.h                 |    4 +
>  10 files changed, 93 insertions(+), 60 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
