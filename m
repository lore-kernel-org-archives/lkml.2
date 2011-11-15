Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1KOKIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:08:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab1KOKIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:08:39 -0500
Date: Tue, 15 Nov 2011 11:06:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] oprofile updates for v3.2
Message-ID: <20111115100646.GA18676@elte.hu>
References: <20111108160513.GJ12451@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108160513.GJ12451@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes for v3.2 (tip/perf/urgent):
> 
>   git://amd64.org/linux/rric.git urgent
> 
> and oprofile updates for v3.3 (tip/perf/core):
> 
>   git://amd64.org/linux/rric.git core
> 
> The urgent branch is a subset of core and intended for v3.2. It only
> contains patches marked also for stable.
> 
> The merge is to resolve conflicts with perf/core.
> 
> See also here:
> 
>  http://www.amd64.org/gitweb/?p=linux/rric.git;a=summary
> 
> Commit ids:
> 
>  de346b6 Merge branch 'perf/core' into oprofile/master
>  dcfce4a oprofile, x86: Reimplement nmi timer mode using perf event
>  75c43a2 oprofile: Remove exit function for timer mode
>  159a80b oprofile, x86: Add kernel parameter oprofile.cpu_type=timer
>  97f7f81 oprofile, x86: Fix crash when unloading module (nmi timer mode)
>  87121ca oprofile: Fix crash when unloading module (hr timer mode)
> 
> Thanks,
> 
> -Robert
> 
> 
> 
> The following changes since commit 886605636e656afeb6fad5e83dbf36967f65cfa5:
> 
>   perf report: Add progress bar when processing time ordered events (2011-11-02 12:28:35 -0200)
> 
> are available in the git repository at:
>   git://amd64.org/linux/rric core
> 
> Robert Richter (6):
>       oprofile: Fix crash when unloading module (hr timer mode)
>       oprofile, x86: Fix crash when unloading module (nmi timer mode)
>       oprofile, x86: Add kernel parameter oprofile.cpu_type=timer
>       oprofile: Remove exit function for timer mode
>       oprofile, x86: Reimplement nmi timer mode using perf event
>       Merge branch 'perf/core' into oprofile/master
> 
>  Documentation/kernel-parameters.txt |    3 +
>  arch/Kconfig                        |    4 +
>  arch/x86/oprofile/Makefile          |    3 +-
>  arch/x86/oprofile/init.c            |   25 ++----
>  arch/x86/oprofile/nmi_int.c         |   27 ++++-
>  arch/x86/oprofile/nmi_timer_int.c   |   50 ----------
>  drivers/oprofile/nmi_timer_int.c    |  173 +++++++++++++++++++++++++++++++++++
>  drivers/oprofile/oprof.c            |   21 ++++-
>  drivers/oprofile/oprof.h            |    9 ++
>  drivers/oprofile/timer_int.c        |   29 +++---
>  kernel/events/core.c                |    2 +
>  11 files changed, 252 insertions(+), 94 deletions(-)
>  delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
>  create mode 100644 drivers/oprofile/nmi_timer_int.c

Pulled both branches, thanks a lot Robert!

	Ingo
