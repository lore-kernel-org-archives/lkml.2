Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1DUI6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:58:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1DUI6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:58:43 -0400
Date: Thu, 21 Apr 2011 10:58:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/6] perf/core improvements and fixes
Message-ID: <20110421085822.GA4262@elte.hu>
References: <1303316636-11923-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303316636-11923-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (1):
>   perf symbols: Give more useful names to 'self' parameters
> 
> Arun Sharma (1):
>   perf script: Add support for PERF_TYPE_RAW
> 
> Michael Witten (4):
>   perf tools: Makefile: Clean up `python/perf.so' rule
>   perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility
>   perf tools: Move `try-cc'
>   perf tools: git mv tools/perf/{features-tests.mak,config/}
> 
>  tools/perf/Makefile                 |  107 +++++--
>  tools/perf/builtin-script.c         |   14 +-
>  tools/perf/config/feature-tests.mak |  128 +++++++
>  tools/perf/config/utilities.mak     |  188 +++++++++++
>  tools/perf/feature-tests.mak        |  130 -------
>  tools/perf/util/symbol.c            |  629 ++++++++++++++++++-----------------
>  tools/perf/util/symbol.h            |   78 +++--
>  7 files changed, 771 insertions(+), 503 deletions(-)
>  create mode 100644 tools/perf/config/feature-tests.mak
>  create mode 100644 tools/perf/config/utilities.mak
>  delete mode 100644 tools/perf/feature-tests.mak

Pulled, thanks a lot Arnaldo!

	Ingo
