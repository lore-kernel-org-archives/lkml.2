Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab1A1RUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:20:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49144 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab1A1RUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:20:02 -0500
Date: Fri, 28 Jan 2011 18:19:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, Han Pingtian <phan@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/4] perf/core improvements and fix
Message-ID: <20110128171932.GA7402@elte.hu>
References: <1296234783-17491-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296234783-17491-1-git-send-email-acme@infradead.org>
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
> Han Pingtian (1):
>   perf test: Fix return values checking
> 
> Masami Hiramatsu (3):
>   perf tools: Add strfilter for general purpose string filter
>   perf probe: Add variable filter support
>   perf probe: Add filters support for available functions
> 
>  tools/perf/Documentation/perf-probe.txt |   15 +++
>  tools/perf/Makefile                     |    2 +
>  tools/perf/builtin-probe.c              |   43 +++++++-
>  tools/perf/builtin-test.c               |    6 +-
>  tools/perf/util/probe-event.c           |   89 ++++++++------
>  tools/perf/util/probe-event.h           |    5 +-
>  tools/perf/util/strfilter.c             |  200 +++++++++++++++++++++++++++++++
>  tools/perf/util/strfilter.h             |   48 ++++++++
>  8 files changed, 366 insertions(+), 42 deletions(-)
>  create mode 100644 tools/perf/util/strfilter.c
>  create mode 100644 tools/perf/util/strfilter.h

Pulled, thanks a lot Arnaldo!

	Ingo
