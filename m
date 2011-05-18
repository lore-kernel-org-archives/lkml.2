Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab1ERSCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:02:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335Ab1ERSCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:02:18 -0400
Date: Wed, 18 May 2011 20:02:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/15] [GIT PULL] ftrace/recordmcount: cleanups and
 updates for recordmcount processing
Message-ID: <20110518180204.GA8190@elte.hu>
References: <20110518160809.724215604@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518160809.724215604@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/perf/core-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core-2
> 
> 
> Martin Schwidefsky (3):
>       ftrace/recordmcount: mcount address adjustment
>       ftrace/x86: mcount offset calculation
>       ftrace/s390: mcount offset calculation
> 
> Michal Marek (1):
>       ftrace/kbuild: Add recordmcount files to force full build
> 
> Steven Rostedt (11):
>       ftrace/trivial: Clean up recordmcount.c to use Linux style comparisons
>       ftrace/trivial: Clean up record mcount to use Linux switch style
>       ftrace: Add .kprobe.text section to whitelist for recordmcount.c
>       ftrace/recordmcount: Modify only executable sections
>       ftrace/recordmcount: Make ignored mcount calls into nops at compile time
>       ftrace/recordmcount: Add warning logic to warn on mcount not recorded
>       kbuild/recordmcount: Add RECORDMCOUNT_WARN to warn about mcount callers
>       ftrace: Avoid recording mcount on .init sections directly
>       ftrace/x86: Do not trace .discard.text section
>       ftrace/recordmcount: Remove duplicate code to find mcount symbol
>       ftrace/recordmcount: Add helper function get_sym_str_and_relp()
> 
> ----
>  Makefile                       |    1 +
>  arch/s390/include/asm/ftrace.h |    4 +-
>  arch/x86/include/asm/ftrace.h  |    7 +-
>  arch/x86/include/asm/setup.h   |    2 +-
>  include/linux/init.h           |   14 ++--
>  scripts/Makefile.build         |   12 ++-
>  scripts/recordmcount.c         |  168 ++++++++++++++++++++++++++------------
>  scripts/recordmcount.h         |  174 +++++++++++++++++++++++++++++++--------
>  scripts/recordmcount.pl        |    5 +
>  9 files changed, 279 insertions(+), 108 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
