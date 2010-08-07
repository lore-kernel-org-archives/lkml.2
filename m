Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762040Ab0HGGoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:44:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60962 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761932Ab0HGGoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:44:00 -0400
Date: Sat, 7 Aug 2010 08:43:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/core fixes and improvements
Message-ID: <20100807064301.GA23108@elte.hu>
References: <1281144849-22896-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281144849-22896-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (2):
>   perf ui: Introduce list_head based generic ui_browser refresh routine
>   perf ui: Start breaking down newt.c into multiple files
> 
> Masami Hiramatsu (2):
>   perf probe: Fix to copy the type for raw parameters
>   perf probe: Fix memory leaks in add_perf_probe_events
> 
>  tools/perf/Makefile                  |   10 +-
>  tools/perf/util/include/linux/list.h |    8 +
>  tools/perf/util/newt.c               |  343 +++-------------------------------
>  tools/perf/util/probe-event.c        |   11 +-
>  tools/perf/util/probe-finder.c       |    8 +-
>  tools/perf/util/ui/browser.c         |  313 +++++++++++++++++++++++++++++++
>  tools/perf/util/ui/browser.h         |   43 +++++
>  7 files changed, 408 insertions(+), 328 deletions(-)
>  create mode 100644 tools/perf/util/ui/browser.c
>  create mode 100644 tools/perf/util/ui/browser.h

Pulled, thanks Arnaldo!

	Ingo
