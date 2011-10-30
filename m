Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1J3LGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:06:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34336 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab1J3LGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:06:36 -0400
Date: Sun, 30 Oct 2011 12:04:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20111030110453.GA3119@elte.hu>
References: <1319909151-11432-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319909151-11432-1-git-send-email-acme@infradead.org>
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

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf hists browser: Warn about lost events
>   perf report: Add progress bar when processing time ordered events
> 
> Masami Hiramatsu (1):
>   perf tools: Fix a typo of command name as trace-cmd
> 
>  tools/perf/builtin-top.c            |   41 +++++++++++++++++++++--------
>  tools/perf/util/hist.h              |    1 +
>  tools/perf/util/session.c           |   38 ++++++++++++++++++++++----
>  tools/perf/util/session.h           |    1 +
>  tools/perf/util/top.h               |    1 -
>  tools/perf/util/trace-event-info.c  |    2 +-
>  tools/perf/util/ui/browser.c        |   21 ++++++++++++---
>  tools/perf/util/ui/browser.h        |    3 +-
>  tools/perf/util/ui/browsers/hists.c |   49 ++++++++++++++++++++++++++++++----
>  9 files changed, 127 insertions(+), 30 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
