Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab2LHOdP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:33:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42328 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab2LHOdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:33:13 -0500
Date: Sat, 8 Dec 2012 15:33:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [GIT PULL] cputime: Cleanups on adjusted cputime code
Message-ID: <20121208143306.GA12011@gmail.com>
References: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
 <1354211111-12113-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354211111-12113-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 
> Ingo,
> 
> Please pull the latest cputime adjustment cleanups that can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git cputime/adjustment-v2
> 
> for you to fetch changes up to fa09205783d11cc05122ad6e4ce06074624b2c0c:
> 
>   cputime: Comment cputime's adjusting code (2012-11-28 17:08:20 +0100)
> 
> Note it's not related to my previous cputime pull request. Both are independant.
> 
> Thanks.
> 
> ----------------------------------------------------------------
> Cputime cleanups on reader side:
> 
> * Improve naming and code location
> 
> * Consolidate adjustment code
> 
> * Comment the adjustement code
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> ----------------------------------------------------------------
> Frederic Weisbecker (4):
>       cputime: Move thread_group_cputime() to sched code
>       cputime: Rename thread_group_times to thread_group_cputime_adjusted
>       cputime: Consolidate cputime adjustment code
>       cputime: Comment cputime's adjusting code
> 
>  fs/proc/array.c           |    4 +-
>  include/linux/sched.h     |   27 ++++++++++---
>  kernel/exit.c             |    4 +-
>  kernel/fork.c             |    2 +-
>  kernel/posix-cpu-timers.c |   24 -----------
>  kernel/sched/cputime.c    |   98 ++++++++++++++++++++++++++++++++-------------
>  kernel/sys.c              |    6 +--
>  7 files changed, 99 insertions(+), 66 deletions(-)

Pulled into sched/core, thanks a lot Frederic!

	Ingo
