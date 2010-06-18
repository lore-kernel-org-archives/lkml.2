Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab0FRIzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 04:55:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab0FRIzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 04:55:02 -0400
Date: Fri, 18 Jun 2010 10:54:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andy Isaacson <adi@hexapodia.org>,
       Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Chase Douglas <chase.douglas@canonical.com>,
       "David S. Miller" <davem@davemloft.net>,
       Eric B Munson <ebmunson@us.ibm.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/7] perf/core improvements and fixes for 2.6.36
Message-ID: <20100618085401.GC24562@elte.hu>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
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
> Andy Isaacson (2):
>   perf debug: fix hex dump partial final line
>   perf session: fix error message on failure to open perf.data
> 
> Chase Douglas (1):
>   perf probe: Add kernel source path option
> 
> Eric B Munson (1):
>   perf symbols: Function descriptor symbol lookup
> 
> Kirill Smelkov (1):
>   perf tools: .gitignore += config.make config.make.autogen
> 
> Stephane Eranian (2):
>   perf record: Avoid synthesizing mmap() for all processes in per-thread mode
>   perf record: Add option to avoid updating buildid cache
> 
>  tools/perf/.gitignore                    |    2 +
>  tools/perf/Documentation/perf-probe.txt  |    4 ++
>  tools/perf/Documentation/perf-record.txt |    6 +++
>  tools/perf/builtin-probe.c               |    2 +
>  tools/perf/builtin-record.c              |    7 +++-
>  tools/perf/util/debug.c                  |   10 ++---
>  tools/perf/util/header.c                 |   10 +++++-
>  tools/perf/util/probe-finder.c           |   58 ++++++++++++++++++++++++++++--
>  tools/perf/util/session.c                |    6 ++-
>  tools/perf/util/symbol.c                 |   37 +++++++++++++++++--
>  tools/perf/util/symbol.h                 |    1 +
>  tools/perf/util/util.h                   |    1 +
>  12 files changed, 128 insertions(+), 16 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
