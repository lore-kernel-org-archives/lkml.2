Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2ISQjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:39:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48246 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2ISQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:39:31 -0400
Date: Wed, 19 Sep 2012 18:39:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: MMF_RECALC_UPROBES + single-step fixes
Message-ID: <20120919163926.GA28297@gmail.com>
References: <20120917165016.GA27952@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917165016.GA27952@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> More recently dicussed and acked patches. Except 95cf00fa
> "ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic",
> nobody wants to ack it explicitly, but nobody objected.
> 
> Oleg Nesterov (9):
>       uprobes: uprobes_treelock should not disable irqs
>       uprobes: Introduce MMF_RECALC_UPROBES
>       uprobes: Teach find_active_uprobe() to clear MMF_HAS_UPROBES
>       ptrace/x86: Introduce set_task_blockstep() helper
>       ptrace/x86: Partly fix set_task_blockstep()->update_debugctlmsr() logic
>       uprobes/x86: Do not (ab)use TIF_SINGLESTEP/user_*_single_step() for single-stepping
>       uprobes/x86: Xol should send SIGTRAP if X86_EFLAGS_TF was set
>       uprobes/x86: Fix arch_uprobe_disable_step() && UTASK_SSTEP_TRAPPED interaction
>       uprobes: Make arch_uprobe_task->saved_trap_nr "unsigned int"
> 
> Sebastian Andrzej Siewior (3):
>       uprobes: Don't put NULL pointer in uprobe_register()
>       uprobes: Introduce arch_uprobe_enable/disable_step()
>       uprobes/x86: Implement x86 specific arch_uprobe_*_step
> 
>  arch/x86/include/asm/processor.h |    2 +
>  arch/x86/include/asm/uprobes.h   |    3 +-
>  arch/x86/kernel/step.c           |   53 +++++++++++++--------
>  arch/x86/kernel/uprobes.c        |   52 +++++++++++++++++++-
>  include/linux/sched.h            |    3 +-
>  include/linux/uprobes.h          |    2 +
>  kernel/events/uprobes.c          |   99 ++++++++++++++++++++++++++++++--------
>  7 files changed, 171 insertions(+), 43 deletions(-)

Pulled, thanks a lot Oleg!

	Ingo
