Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1AENMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:12:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60129 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1AENMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:12:01 -0500
Date: Wed, 5 Jan 2011 14:11:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 0/3] perf/core improvements and fixes
Message-ID: <20110105131117.GC10129@elte.hu>
References: <1294161485-28528-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294161485-28528-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf test: Clarify some error reports in the open syscall test
>   perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)
> 
> Stephane Eranian (1):
>   perf tools: Fix perf_event.h header usage
> 
>  tools/perf/builtin-test.c      |  124 +++++++++++++++++++++++++++++++++++++--
>  tools/perf/util/evsel.c        |   75 +++++++++++++-----------
>  tools/perf/util/evsel.h        |    2 +-
>  tools/perf/util/parse-events.h |    2 +-
>  4 files changed, 159 insertions(+), 44 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
