Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0HUTPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:15:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50487 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0HUTPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:15:34 -0400
Date: Sat, 21 Aug 2010 21:15:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/2] perf/core improvements
Message-ID: <20100821191520.GB25122@elte.hu>
References: <1282412712-3547-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282412712-3547-1-git-send-email-acme@infradead.org>
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
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (1):
>   perf tools: Add --tui and --stdio to choose the UI
> 
> Kirill A. Shutemov (1):
>   perf tools: add test for strlcpy()
> 
>  tools/perf/Documentation/perf-annotate.txt |   11 +++++++++--
>  tools/perf/Documentation/perf-report.txt   |    7 +++++++
>  tools/perf/Makefile                        |    9 +++++++++
>  tools/perf/builtin-annotate.c              |    9 ++++++++-
>  tools/perf/builtin-report.c                |   11 ++++++++++-
>  tools/perf/feature-tests.mak               |   11 +++++++++++
>  tools/perf/util/cache.h                    |    2 ++
>  tools/perf/util/path.c                     |    3 ++-
>  8 files changed, 58 insertions(+), 5 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
