Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1HOPeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:34:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42083 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1HOPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:34:04 -0400
Date: Mon, 15 Aug 2011 16:33:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: footbridge: Netwinder: Add KConfig select
	CLKEVT_I8253 to fix build failure
Message-ID: <20110815153338.GA525@n2100.arm.linux.org.uk>
References: <1313422280-21942-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313422280-21942-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 05:31:20PM +0200, Peter Huewe wrote:
> diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
> index dc26fff..c8e7afc 100644
> --- a/arch/arm/mach-footbridge/Kconfig
> +++ b/arch/arm/mach-footbridge/Kconfig
> @@ -62,6 +62,7 @@ config ARCH_EBSA285_HOST
>  config ARCH_NETWINDER
>  	bool "NetWinder"
>  	select CLKSRC_I8253
> +	select CLKEVT_I8253

Could you please add this in alphabetical order, just like the rest of the
'select' options here?

>  	select FOOTBRIDGE_HOST
>  	select ISA
>  	select ISA_DMA

Then I'll take it through the patch system into my fixes branch.  Thanks.
