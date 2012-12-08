Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab2LHOp5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:45:57 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36585 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab2LHOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:45:56 -0500
Date: Sat, 8 Dec 2012 15:45:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] cputime: cleanups
Message-ID: <20121208144551.GE12011@gmail.com>
References: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353426161-18866-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the latest sched cleanups branch that can be found at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	tags/sched-cputime-for-mingo
> 
> for you to pull the HEAD 1b2852b152be5150fbef7b585388ec43cf6f4415
> ("vtime: Warn if irqs aren't disabled on system time accounting APIs")
> 
> Thanks.
> 
> ---
> Some more cputime cleanups:
> 
> * Get rid of underscores polluting the vtime namespace
> 
> * Consolidate context switch and tick handling
> 
> * Improve debuggability by detecting irq unsafe callers
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
> Frederic Weisbecker (5):
>   vtime: Remove the underscore prefix invasion
>   vtime: Explicitly account pending user time on process tick
>   vtime: Consolidate a bit the ctx switch code
>   vtime: No need to disable irqs on vtime_account()
>   vtime: Warn if irqs aren't disabled on system time accounting APIs
> 
>  arch/ia64/include/asm/cputime.h    |    2 ++
>  arch/ia64/kernel/time.c            |   26 ++++++--------------------
>  arch/powerpc/include/asm/cputime.h |    2 ++
>  arch/powerpc/kernel/time.c         |   24 ++++++++++--------------
>  arch/s390/include/asm/cputime.h    |    1 +
>  arch/s390/kernel/vtime.c           |   13 ++++++++++---
>  include/linux/kernel_stat.h        |    8 ++++++++
>  include/linux/kvm_host.h           |    4 ++--
>  include/linux/vtime.h              |    9 +++++----
>  kernel/sched/cputime.c             |   31 +++++++++++++++++++------------
>  10 files changed, 65 insertions(+), 55 deletions(-)

Pulled, thanks Frederic!

	Ingo
