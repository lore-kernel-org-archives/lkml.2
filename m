Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1JYDY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 23:24:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55852 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab1JYDY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 23:24:28 -0400
Date: Tue, 25 Oct 2011 05:22:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Ahern <dsahern@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Neil Horman <nhorman@tuxdriver.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/4] perf/core fixes and improvements
Message-ID: <20111025032236.GA10104@elte.hu>
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319397143-20301-1-git-send-email-acme@infradead.org>
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
>   perf ui browser: Use libslang to read keys
>   perf hists browser: Refuse 'a' hotkey on non symbolic views
> 
> Jiri Olsa (1):
>   perf tools: Fix tracing info recording
> 
> Ricardo Ribalda Delgado (1):
>   perf symbols: Increase symbol KSYM_NAME_LEN size
> 
>  tools/perf/Makefile                    |    1 +
>  tools/perf/builtin-annotate.c          |    8 +-
>  tools/perf/util/header.c               |   27 +++++++-
>  tools/perf/util/hist.h                 |    9 +--
>  tools/perf/util/symbol.c               |    2 +-
>  tools/perf/util/trace-event-info.c     |  112 +++++++++++++++++++++++++-------
>  tools/perf/util/trace-event.h          |   13 ++++-
>  tools/perf/util/ui/browser.c           |   79 +++++++++++++++-------
>  tools/perf/util/ui/browsers/annotate.c |   19 ++---
>  tools/perf/util/ui/browsers/hists.c    |   40 +++++++-----
>  tools/perf/util/ui/keysyms.h           |   25 +++++++
>  tools/perf/util/ui/libslang.h          |    2 +
>  tools/perf/util/ui/setup.c             |   13 ++++
>  13 files changed, 256 insertions(+), 94 deletions(-)
>  create mode 100644 tools/perf/util/ui/keysyms.h

Pulled, thanks a lot Arnaldo!

	Ingo
