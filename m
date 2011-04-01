Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1DAOcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:32:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592Ab1DAOcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:32:31 -0400
Date: Fri, 1 Apr 2011 16:32:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, jbaron@redhat.com
Subject: Re: [PATCH 0/4] [GIT PULL] jump label: Cleanups for 2.6.39
Message-ID: <20110401143202.GA1910@jolsa.brq.redhat.com>
References: <20110317164148.550876008@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317164148.550876008@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 12:41:48PM -0400, Steven Rostedt wrote:
> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent

hi,

I have a change to use batch update for jump label key's entries.

I wanted to rebase it to latest Jason's changes, but I dont see them
in the mentioned git tree and branch.. not sure what I missed.

also, any idea when this could get in?

thanks,
jirka

> 
> 
> Jan Glauber (1):
>       jump label: Add s390 support
> 
> Jason Baron (3):
>       jump label: Introduce static_branch() interface
>       dynamic debug: Add jump label support
>       jump label: Add _ASM_ALIGN for x86 and x86_64
> 
> ----
>  arch/mips/include/asm/jump_label.h  |   22 +-
>  arch/s390/Kconfig                   |    1 +
>  arch/s390/include/asm/jump_label.h  |   37 +++
>  arch/s390/kernel/Makefile           |    2 +-
>  arch/s390/kernel/jump_label.c       |   59 ++++
>  arch/sparc/include/asm/jump_label.h |   25 +-
>  arch/x86/include/asm/alternative.h  |    3 +-
>  arch/x86/include/asm/jump_label.h   |   27 +-
>  arch/x86/kernel/alternative.c       |    2 +-
>  arch/x86/kernel/module.c            |    1 +
>  include/asm-generic/vmlinux.lds.h   |   14 +-
>  include/linux/dynamic_debug.h       |   44 +++-
>  include/linux/jump_label.h          |   89 ++++---
>  include/linux/jump_label_ref.h      |   44 ---
>  include/linux/perf_event.h          |   26 +-
>  include/linux/tracepoint.h          |   22 +-
>  kernel/jump_label.c                 |  539 ++++++++++++++---------------------
>  kernel/perf_event.c                 |    4 +-
>  kernel/tracepoint.c                 |   23 +-
>  lib/dynamic_debug.c                 |    4 +-
>  20 files changed, 494 insertions(+), 494 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
