Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1BWH3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:29:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1BWH3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:29:02 -0500
Date: Wed, 23 Feb 2011 08:28:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/2] perf/core TUI live annotate and a cleanup
Message-ID: <20110223072842.GC15175@elte.hu>
References: <1298400790-29453-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298400790-29453-1-git-send-email-acme@infradead.org>
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
> 	Mike, if you can give it some stress, I'd appreciate.
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf probe: Remove redundant checks
>   perf top: Live TUI Annotation

Yummie! :-)

>  tools/perf/builtin-top.c               |   36 +++++-----
>  tools/perf/util/annotate.h             |    6 +-
>  tools/perf/util/probe-event.c          |    2 +-
>  tools/perf/util/probe-finder.c         |    5 +-
>  tools/perf/util/top.h                  |    1 +
>  tools/perf/util/ui/browsers/annotate.c |  126 +++++++++++++++++++++++---------
>  tools/perf/util/ui/browsers/top.c      |   45 +++++++++++-
>  7 files changed, 159 insertions(+), 62 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
