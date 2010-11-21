Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0KUNV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:21:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab0KUNV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:21:57 -0500
Date: Sun, 21 Nov 2010 14:21:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Matt Fleming <matt@console-pimps.org>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Morell <rmorell@nvidia.com>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/3] perf tools improvements
Message-ID: <20101121132134.GA5777@elte.hu>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
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

> From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> 
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
>   perf tools: Change my maintainer address
> 
> Robert Morell (1):
>   perf tools: Remove hardcoded include paths for elfutils
> 
> Stephane Eranian (1):
>   perf stat: Add no-aggregation mode to -a
> 
>  CREDITS                                |    2 -
>  MAINTAINERS                            |    2 +-
>  tools/perf/Documentation/perf-stat.txt |    5 +
>  tools/perf/Makefile                    |    4 +-
>  tools/perf/builtin-stat.c              |  169 +++++++++++++++++++++++++++-----
>  tools/perf/feature-tests.mak           |    4 +-
>  tools/perf/util/probe-finder.h         |    6 +-
>  7 files changed, 157 insertions(+), 35 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
