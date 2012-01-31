Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2AaMHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:07:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab2AaMHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:07:19 -0500
Date: Tue, 31 Jan 2012 13:06:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Masanari Iida <standby24x7@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/9] perf/core fixes and improvements
Message-ID: <20120131120657.GC32010@elte.hu>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> The following changes since commit efb3040d481a1594592b1defb4526c406c7a4751:
> 
>   jump_label: Add some documentation (2012-01-27 12:14:46 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo
> 
> for you to fetch changes up to cfeb1d90a1b1db96383b48888cb7a5f10ca12e12:
> 
>   perf python: Use attr.watermark in twatch.py (2012-01-30 18:38:23 -0200)
> 
> ----------------------------------------------------------------
> perf/core fixes and improvements.
> 
> ----------------------------------------------------------------
> Akihiro Nagai (4):
>       perf script: Unify the expressions indicating "unknown"
>       perf script: Print branch_from and branch_to of BTS events
>       perf script: Add the offset field specifier
>       perf script: Add option resolving vmlinux path
> 
> Arnaldo Carvalho de Melo (1):
>       perf python: Use attr.watermark in twatch.py
> 
> Masanari Iida (1):
>       perf evsel: Fix spelling typo
> 
> Namhyung Kim (2):
>       perf lock: Document lock info subcommand
>       perf tools: Remove unnecessary ctype.h inclusion
> 
> Stephane Eranian (1):
>       perf top: Fix number of samples displayed
> 
>  tools/perf/Documentation/perf-lock.txt             |   20 ++++-
>  tools/perf/Documentation/perf-script.txt           |    5 +-
>  tools/perf/bench/mem-memcpy.c                      |    1 -
>  tools/perf/bench/mem-memset.c                      |    1 -
>  tools/perf/builtin-lock.c                          |    4 +-
>  tools/perf/builtin-script.c                        |   80 ++++++++++++++++----
>  tools/perf/builtin-top.c                           |   13 +++-
>  tools/perf/python/twatch.py                        |    2 +-
>  tools/perf/util/evsel.c                            |    2 +-
>  tools/perf/util/map.c                              |   15 ++++
>  tools/perf/util/map.h                              |    1 +
>  tools/perf/util/probe-finder.c                     |    1 -
>  .../util/scripting-engines/trace-event-python.c    |    1 -
>  tools/perf/util/session.c                          |   39 ++++------
>  tools/perf/util/session.h                          |    2 +-
>  tools/perf/util/symbol.c                           |   22 ++++++
>  tools/perf/util/symbol.h                           |    4 +
>  tools/perf/util/trace-event-parse.c                |    1 -
>  tools/perf/util/trace-event-read.c                 |    1 -
>  tools/perf/util/trace-event-scripting.c            |    1 -
>  tools/perf/util/ui/browsers/map.c                  |    2 +-
>  21 files changed, 159 insertions(+), 59 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
