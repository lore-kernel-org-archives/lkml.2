Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2D3U2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:28:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35385 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2D3U2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:28:35 -0400
Message-ID: <4F9EF43C.3090608@gmail.com>
Date: Mon, 30 Apr 2012 16:21:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Chen Liqin <liqin.chen@sunplusct.com>, kosaki.motohiro@gmail.com
Subject: Re: [patch 21/29] score: Use generic init_task
References: <20120430194725.763322463@linutronix.de> <20120430194846.862605948@linutronix.de>
In-Reply-To: <20120430194846.862605948@linutronix.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/30/12 4:16 PM), Thomas Gleixner wrote:
> Same code. Use the generic version.
> 
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> Cc: Chen Liqin<liqin.chen@sunplusct.com>
> ---
>   arch/score/Kconfig         |    1 +
>   arch/score/kernel/Makefile |    2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Index: tip/arch/score/Kconfig
> ===================================================================
> --- tip.orig/arch/score/Kconfig
> +++ tip/arch/score/Kconfig
> @@ -9,6 +9,7 @@ config SCORE
>          select HAVE_MEMBLOCK_NODE_MAP
>          select ARCH_DISCARD_MEMBLOCK
>          select GENERIC_CPU_DEVICES
> +       select HAVE_GENERIC_INIT_TASK
> 
>   choice
>   	prompt "System type"
> Index: tip/arch/score/kernel/Makefile
> ===================================================================
> --- tip.orig/arch/score/kernel/Makefile
> +++ tip/arch/score/kernel/Makefile
> @@ -4,7 +4,7 @@
> 
>   extra-y	:= head.o vmlinux.lds
> 
> -obj-y += entry.o init_task.o irq.o process.o ptrace.o \
> +obj-y += entry.o irq.o process.o ptrace.o \
>   	setup.o signal.o sys_score.o time.o traps.o \
>   	sys_call_table.o

Almost patches delete arch specific init-task. But this patch doesn't.
Is this really intentional?


