Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030336Ab2HQJcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:32:23 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56056 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab2HQJcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:32:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rBLqOhoHNpqwpabd+AZb2
Date: Fri, 17 Aug 2012 02:32:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 30/31] arm64: Build infrastructure
Message-ID: <20120817093213.GT11011@atomide.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [120814 11:00]:
> --- /dev/null
> +++ b/arch/arm64/Kconfig
> @@ -0,0 +1,261 @@
> +config ARM64
> +	def_bool y
> +	select OF
> +	select OF_EARLY_FLATTREE
> +	select IRQ_DOMAIN
> +	select HAVE_AOUT
> +	select HAVE_DMA_ATTRS
> +	select HAVE_DMA_API_DEBUG
> +	select HAVE_IDE
> +	select HAVE_MEMBLOCK
> +	select RTC_LIB
> +	select SYS_SUPPORTS_APM_EMULATION
> +	select HAVE_GENERIC_DMA_COHERENT
> +	select GENERIC_IOMAP
> +	select HAVE_IRQ_WORK
> +	select HAVE_PERF_EVENTS
> +	select HAVE_ARCH_TRACEHOOK
> +	select PERF_USE_VMALLOC
> +	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> +	select HAVE_GENERIC_HARDIRQS
> +	select GENERIC_HARDIRQS_NO_DEPRECATED
> +	select HAVE_SPARSE_IRQ
> +	select SPARSE_IRQ
> +	select GENERIC_IRQ_SHOW
> +	select GENERIC_SMP_IDLE_THREAD
> +	select NO_BOOTMEM
> +	help
> +	  ARM 64-bit (AArch64) Linux support.

Anything we should select here for ARM generic timers and
interrupts assuming we can always expect to boot using those?

Other than that:

Acked-by: Tony Lindgren <tony@atomide.com>
