Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1HEIiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:38:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1HEIiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:38:01 -0400
Date: Fri, 5 Aug 2011 10:36:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL 0/4] perf/core improvements and fixes
Message-ID: <20110805083653.GB32299@elte.hu>
References: <1312469838-2884-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312469838-2884-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> 
> 	I still need to comb more for patches sent while I was away,
> the ones I checked you already merged, thanks.
> 
> Regards,
> 
> - Arnaldo
> 
> 
> Arnaldo Carvalho de Melo (3):
>   perf evlist: Introduce 'disable' method
>   perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables
>   perf report: Use ui__warning in some more places
> 
> Han Pingtian (1):
>   perf buildid-cache: Zero out buffer of filenames when adding/removing
>     buildid
> 
>  tools/perf/builtin-record.c |   19 +------
>  tools/perf/builtin-report.c |   15 +++---
>  tools/perf/util/evlist.c    |   13 +++++
>  tools/perf/util/evlist.h    |    2 +
>  tools/perf/util/header.c    |    8 ++--
>  tools/perf/util/python.c    |  115 +++++++++++++++++++++++++++++++++++++++++-
>  6 files changed, 140 insertions(+), 32 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
