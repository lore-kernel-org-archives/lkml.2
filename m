Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2ERO5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:57:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:58689 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2ERO5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:57:05 -0400
Message-ID: <1337353008.573.49.camel@twins>
Subject: Re: [tip:sched/numa] sched: Make find_busiest_queue a method
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        riel@redhat.com, bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 16:56:48 +0200
In-Reply-To: <tip-3n9wqw2rdmhtu7qjhpoegh7u@git.kernel.org>
References: <tip-3n9wqw2rdmhtu7qjhpoegh7u@git.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 03:36 -0700, tip-bot for Peter Zijlstra wrote:

> sched: Make find_busiest_queue a method
> 
> Its a bit awkward but it was the least painful means of modifying the
> queue selection. Used in a later patch to conditionally use a random
> queue.
> 

> ---
>  include/linux/mm_types.h |    8 +
>  include/linux/sched.h    |   14 +
>  init/Kconfig             |    2 +-
>  kernel/fork.c            |    2 +
>  kernel/sched/Makefile    |    1 +
>  kernel/sched/core.c      |   22 ++-
>  kernel/sched/debug.c     |    3 +
>  kernel/sched/fair.c      |  257 +++++++++++++++--
>  kernel/sched/features.h  |   12 +
>  kernel/sched/numa.c      |  741 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/sched.h     |   34 +++
>  mm/init-mm.c             |   10 +
>  12 files changed, 1079 insertions(+), 27 deletions(-)


Something went wrong here.. this were 3 patches:

Subject: sched: Make find_busiest_queue a method
Subject: sched: Implement home-node awareness
Subject: sched, numa: Numa balancer



