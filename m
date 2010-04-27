Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0D0JRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:17:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48831 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0D0JRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:17:45 -0400
Date: Tue, 27 Apr 2010 11:17:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Fr?d?ric Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] perf probe fixes
Message-ID: <20100427091725.GB11348@elte.hu>
References: <20100426190634.GB28700@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100426190634.GB28700@ghostprotocols.net>
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
> 	Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> - Arnaldo
> 
> Masami Hiramatsu (4):
>   perf tools: Initialize dso->node member in dso__new
>   perf probe: Fix to use symtab only if no debuginfo
>   perf probe: Fix to exit callback soon after finding too many probe
>     points
>   perf probe: Add --max-probes option
> 
> Stefan Hajnoczi (1):
>   perf tools: Fix libdw-dev package name in error message
> 
>  tools/perf/Documentation/perf-probe.txt |    3 ++
>  tools/perf/Makefile                     |    2 +-
>  tools/perf/builtin-probe.c              |    9 +++++++-
>  tools/perf/util/probe-event.c           |   34 +++++++++++++++++-------------
>  tools/perf/util/probe-event.h           |    4 +-
>  tools/perf/util/probe-finder.c          |   15 +++++++++----
>  tools/perf/util/probe-finder.h          |    6 +++-
>  tools/perf/util/symbol.c                |    1 +
>  8 files changed, 48 insertions(+), 26 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
