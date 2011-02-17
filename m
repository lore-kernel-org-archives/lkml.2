Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1BQNvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:51:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab1BQNvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:51:02 -0500
Date: Thu, 17 Feb 2011 14:50:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/6] perf/core improvements and fixes
Message-ID: <20110217135040.GA5242@elte.hu>
References: <1297896887-9983-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297896887-9983-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (3):
>   perf ui: Serialize screen updates
>   perf annotate: Check if offset is less than symbol size
>   perf annotate browser: Use the percent color for the whole line
> 
> Jesse Brandeburg (1):
>   perf tools: Update Makefile with some help
> 
> Masami Hiramatsu (2):
>   perf probe: Support function@filename syntax for --line
>   perf probe: Show filename which contains target function
> 
>  tools/perf/Documentation/Makefile       |   19 ++++++++++---------
>  tools/perf/Documentation/perf-probe.txt |    7 ++++---
>  tools/perf/Makefile                     |   31 +++++++++++++++++++++++++++++++
>  tools/perf/util/annotate.c              |    3 ++-
>  tools/perf/util/probe-event.c           |   17 +++++++++++++----
>  tools/perf/util/ui/browser.c            |    7 +++++++
>  tools/perf/util/ui/browsers/annotate.c  |    5 +++--
>  tools/perf/util/ui/helpline.c           |    5 ++++-
>  tools/perf/util/ui/setup.c              |    3 +++
>  tools/perf/util/ui/ui.h                 |    8 ++++++++
>  10 files changed, 85 insertions(+), 20 deletions(-)
>  create mode 100644 tools/perf/util/ui/ui.h

Pulled, thanks a lot Arnaldo!

	Ingo
