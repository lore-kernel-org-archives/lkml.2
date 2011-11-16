Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab1KPOKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:10:39 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:41075 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755238Ab1KPOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:10:38 -0500
Date: Wed, 16 Nov 2011 14:10:20 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: keguang.zhang@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, r0bertz@gentoo.org
Subject: Re: [PATCH V2 2/4] MIPS: Add board support for Loongson1B
Message-ID: <20111116141020.GD11111@linux-mips.org>
References: <1319192888-21465-1-git-send-email-keguang.zhang@gmail.com>
 <1319192888-21465-2-git-send-email-keguang.zhang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319192888-21465-2-git-send-email-keguang.zhang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 06:28:06PM +0800, keguang.zhang@gmail.com wrote:
> Date:   Fri, 21 Oct 2011 18:28:06 +0800
> From: keguang.zhang@gmail.com
> To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
> Cc: ralf@linux-mips.org, wuzhangjin@gmail.com, r0bertz@gentoo.org, Kelvin
>  Cheung <keguang.zhang@gmail.com>
> Subject: [PATCH V2 2/4] MIPS: Add board support for Loongson1B
> 
> From: Kelvin Cheung <keguang.zhang@gmail.com>
> 
> This patch adds basic platform support for Loongson1B
> including serial port, ethernet, and interrupt handler.
> 
> Loongson1B UART is compatible with NS16550A.
> Loongson1B GMAC is built around Synopsys IP Core.
> 
> Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
> ---
>  arch/mips/include/asm/mach-loongson1/irq.h       |   68 +++++++++
>  arch/mips/include/asm/mach-loongson1/loongson1.h |   44 ++++++
>  arch/mips/include/asm/mach-loongson1/platform.h  |   21 +++
>  arch/mips/include/asm/mach-loongson1/prom.h      |   24 +++
>  arch/mips/include/asm/mach-loongson1/regs-clk.h  |   32 ++++
>  arch/mips/include/asm/mach-loongson1/regs-intc.h |   25 ++++
>  arch/mips/include/asm/mach-loongson1/regs-wdt.h  |   21 +++
>  arch/mips/include/asm/mach-loongson1/war.h       |   25 ++++
>  arch/mips/loongson1/common/clock.c               |  165 ++++++++++++++++++++++
>  arch/mips/loongson1/common/irq.c                 |  136 ++++++++++++++++++
>  arch/mips/loongson1/common/platform.c            |   94 ++++++++++++
>  arch/mips/loongson1/common/prom.c                |   88 ++++++++++++
>  arch/mips/loongson1/common/reset.c               |   46 ++++++
>  arch/mips/loongson1/common/setup.c               |   29 ++++
>  arch/mips/loongson1/ls1b/board.c                 |   31 ++++
>  drivers/net/stmmac/descs.h                       |   68 +++++++++
>  drivers/net/stmmac/enh_desc.c                    |   16 ++

I take it you've split off the stmac parts from this patch?  Can you please
send an updated version of this patch or the entire series, if that should
be necessary?

Thanks,

  Ralf
