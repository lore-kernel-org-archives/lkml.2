Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab0D3SMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:12:05 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:44970 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab0D3SJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:09:01 -0400
Date: Fri, 30 Apr 2010 09:57:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] perf: Initial regression testing command
Message-ID: <20100430075749.GB20342@elte.hu>
References: <1272579244-3981-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272579244-3981-1-git-send-email-acme@infradead.org>
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

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> 	Now there are 7 patches in that repo.
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf symbols: Add machine helper routines
>   perf test: Initial regression testing command
> 
>  tools/perf/Documentation/perf-test.txt |   22 +++
>  tools/perf/Makefile                    |    1 +
>  tools/perf/builtin-kmem.c              |    2 +-
>  tools/perf/builtin-test.c              |  281 ++++++++++++++++++++++++++++++++
>  tools/perf/builtin.h                   |    1 +
>  tools/perf/command-list.txt            |    1 +
>  tools/perf/perf.c                      |    1 +
>  tools/perf/util/map.h                  |   25 +++-
>  tools/perf/util/symbol.c               |   77 +++++++---
>  tools/perf/util/symbol.h               |    7 +
>  10 files changed, 393 insertions(+), 25 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-test.txt
>  create mode 100644 tools/perf/builtin-test.c

Pulled, thanks a lot Arnaldo!

	Ingo
