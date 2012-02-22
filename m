Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2BVKMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:12:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2BVKMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:12:49 -0500
Date: Wed, 22 Feb 2012 11:12:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Danny Kukawka <danny.kukawka@bisect.de>,
        Danny Kukawka <dkukawka@suse.de>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jovi Zhang <bookjovi@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20120222101221.GB30339@elte.hu>
References: <1329845727-21512-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329845727-21512-1-git-send-email-acme@infradead.org>
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

> The following changes since commit 09bda4432a8a4d4db2b2b94697abc8d732a9ff73:
> 
>   Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core (2012-02-17 12:55:07 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo
> 
> for you to fetch changes up to 6b1bee9035d430c4b4f586df6df4b3f840e89b5b:
> 
>   perf tools: fix broken perf record -a mode (2012-02-21 15:05:43 -0200)
> 
> ----------------------------------------------------------------
> Important fix from Stephane for system wide monitoring, problem
> introduced recently in the pid list patches.
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Danny Kukawka (1):
>       perf tools: Remove duplicated string.h includes
> 
> Stefan Hajnoczi (1):
>       perf tools: Allow expressions in __print_symbolic() fields
> 
> Stephane Eranian (1):
>       perf tools: fix broken perf record -a mode
> 
>  tools/perf/util/probe-event.c       |    1 -
>  tools/perf/util/thread_map.c        |    2 +-
>  tools/perf/util/trace-event-parse.c |   12 ++++++++++++
>  3 files changed, 13 insertions(+), 2 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
