Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1CQSyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:54:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1CQSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:53:59 -0400
Subject: Re: [PATCH 0/4] [GIT PULL] jump label: Cleanups for 2.6.39
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110317164148.550876008@goodmis.org>
References: <20110317164148.550876008@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 19:55:48 +0100
Message-ID: <1300388148.2250.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 12:41 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
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

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

