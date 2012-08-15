Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2HOPXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:23:24 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:35705 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2HOPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:23:11 -0400
Date: Wed, 15 Aug 2012 17:22:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] s390: Remove leftover account_tick_vtime() header
Message-ID: <20120815172254.795e6818@de.ibm.com>
In-Reply-To: <1344953810-20564-5-git-send-email-fweisbec@gmail.com>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	<1344953810-20564-5-git-send-email-fweisbec@gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081515-8372-0000-0000-000003794804
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 16:16:50 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The function doesn't seem to exist anymore.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/s390/include/asm/switch_to.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/switch_to.h b/arch/s390/include/asm/switch_to.h
> index e7f9b3d..314cc94 100644
> --- a/arch/s390/include/asm/switch_to.h
> +++ b/arch/s390/include/asm/switch_to.h
> @@ -89,8 +89,6 @@ static inline void restore_access_regs(unsigned int *acrs)
>  	prev = __switch_to(prev,next);					\
>  } while (0)
> 
> -extern void account_tick_vtime(struct task_struct *);
> -
>  #define finish_arch_switch(prev) do {					     \
>  	set_fs(current->thread.mm_segment);				     \
>  } while (0)

Indeed..

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

