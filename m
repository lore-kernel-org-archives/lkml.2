Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0LWNVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:21:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0LWNVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:21:22 -0500
Date: Thu, 23 Dec 2010 14:20:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20101223132056.GB7680@elte.hu>
References: <1293057396-21124-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293057396-21124-1-git-send-email-acme@infradead.org>
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
>   perf symbols: Improve kallsyms symbol end addr calculation
>   perf test: Look forward for symbol aliases
> 
> Franck Bui-Huu (1):
>   perf probe: Fix wrong warning in __show_one_line() if read(1) errors
>     happen
> 
>  tools/perf/builtin-test.c     |   23 ++++++++++++++---
>  tools/perf/util/event.c       |    3 +-
>  tools/perf/util/probe-event.c |    2 +-
>  tools/perf/util/symbol.c      |   56 ++++++++++++++++++++++++++++++----------
>  tools/perf/util/symbol.h      |    2 +-
>  5 files changed, 65 insertions(+), 21 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
