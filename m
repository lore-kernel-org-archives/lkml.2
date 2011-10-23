Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1JWB5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 21:57:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:39775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1JWB5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 21:57:18 -0400
Subject: Re: [PATCH 15/49] powerpc: irq: Remove IRQF_DISABLED
From: Geoff Levand <geoff@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Arnd Bergmann <arnd@arndb.de>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
In-Reply-To: <1319277421-9203-16-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
	 <1319277421-9203-16-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 18:57:08 -0700
Message-ID: <1319335028.4949.1.camel@pump>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-22 at 17:56 +0800, Yong Zhang wrote:
> Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/powerpc/include/asm/floppy.h              |    4 ++--
>  arch/powerpc/include/asm/xics.h                |    4 ++--
>  arch/powerpc/kernel/smp.c                      |    2 +-
>  arch/powerpc/platforms/cell/beat.c             |    2 +-
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
>  arch/powerpc/platforms/cell/iommu.c            |    3 +--
>  arch/powerpc/platforms/cell/pmu.c              |    2 +-
>  arch/powerpc/platforms/cell/spu_base.c         |    9 +++------
>  arch/powerpc/platforms/powermac/pic.c          |    1 -
>  arch/powerpc/platforms/powermac/smp.c          |    4 ++--
>  arch/powerpc/platforms/ps3/device-init.c       |    2 +-
>  arch/powerpc/sysdev/mpic.c                     |    2 --
>  arch/powerpc/sysdev/ppc4xx_soc.c               |    2 +-
>  arch/powerpc/sysdev/xics/xics-common.c         |    5 ++---
>  14 files changed, 18 insertions(+), 26 deletions(-)

Looks OK for PS3.

Acked-by: Geoff Levand <geoff@infradead.org>


