Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab0DMDx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 23:53:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:33043 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0DMDx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 23:53:56 -0400
Subject: Re: [PATCH 04/39] lmb: Move lmb.c to mm/
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1270793048-23796-5-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 13:52:28 +1000
Message-ID: <1271130748.13059.48.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
> lmb.c is memory related, so move it to mm/. It is suggested by Ingo
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

> ---
>  lib/Makefile      |    2 --
>  mm/Makefile       |    2 ++
>  {lib => mm}/lmb.c |    0
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename {lib => mm}/lmb.c (100%)
> 
> diff --git a/lib/Makefile b/lib/Makefile
> index 2e152ae..a463a4d 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -85,8 +85,6 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
>  
>  lib-$(CONFIG_GENERIC_BUG) += bug.o
>  
> -obj-$(CONFIG_HAVE_LMB) += lmb.o
> -
>  obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
>  
>  obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
> diff --git a/mm/Makefile b/mm/Makefile
> index 6c2a73a..52492f9 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -15,6 +15,8 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
>  			   $(mmu-y)
>  obj-y += init-mm.o
>  
> +obj-$(CONFIG_HAVE_LMB) += lmb.o
> +
>  obj-$(CONFIG_BOUNCE)	+= bounce.o
>  obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
>  obj-$(CONFIG_HAS_DMA)	+= dmapool.o
> diff --git a/lib/lmb.c b/mm/lmb.c
> similarity index 100%
> rename from lib/lmb.c
> rename to mm/lmb.c


