Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1BVHyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:54:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44426 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab1BVHyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:54:24 -0500
Date: Tue, 22 Feb 2011 08:54:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/2] perf/core fixes
Message-ID: <20110222075402.GA7001@elte.hu>
References: <1298338262-26258-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298338262-26258-1-git-send-email-acme@infradead.org>
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
>   perf probe: Fix error propagation leading to segfault
>   perf evsel: Fix inverted test for fixing up attr.inherit flag
> 
>  tools/perf/util/evsel.c        |   15 +++++++++++++--
>  tools/perf/util/probe-event.c  |    5 ++++-
>  tools/perf/util/probe-finder.c |    4 +++-
>  3 files changed, 20 insertions(+), 4 deletions(-)

Pulled, thanks a lot Arnaldo!

Thanks,

	Ingo
