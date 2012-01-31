Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2AaMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:04:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2AaMEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:04:44 -0500
Date: Tue, 31 Jan 2012 13:04:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, David Daney <david.daney@cavium.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/3] perf/urgent fixes
Message-ID: <20120131120422.GB32010@elte.hu>
References: <1327972879-29214-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327972879-29214-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> The following changes since commit d0caf292505d051b1026e85faf3a85e907566f31:
> 
>   x86/dumpstack: Remove unneeded check in dump_trace() (2012-01-28 13:09:06 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-urgent-for-mingo
> 
> for you to fetch changes up to 509605dbe9395ce1abbfac1dba375f074ff57a53:
> 
>   perf top: Fix number of samples displayed (2012-01-30 22:29:49 -0200)
> 
> ----------------------------------------------------------------
> Fixes cherry picked from perf/core.
> 
> ----------------------------------------------------------------
> David Daney (1):
>       perf tools: Fix broken build by defining _GNU_SOURCE in Makefile
> 
> Stephane Eranian (2):
>       perf tools: Fix strlen() bug in perf_event__synthesize_event_type()
>       perf top: Fix number of samples displayed
> 
>  tools/perf/Makefile                 |    7 ++-----
>  tools/perf/builtin-probe.c          |    2 --
>  tools/perf/builtin-top.c            |   13 ++++++++++---
>  tools/perf/util/header.c            |    2 +-
>  tools/perf/util/probe-event.c       |    2 --
>  tools/perf/util/symbol.c            |    1 -
>  tools/perf/util/trace-event-parse.c |    3 +--
>  tools/perf/util/ui/browsers/hists.c |    2 --
>  tools/perf/util/ui/helpline.c       |    1 -
>  tools/perf/util/util.h              |    1 -
>  10 files changed, 14 insertions(+), 20 deletions(-)

Pulled, thanks a lot Arnaldo!

I've also merged these into perf/core straight away, to make 
sure the cherry-picks do not interfere and cause conflicts with 
subequent work on those files.

Thanks,

	Ingo
