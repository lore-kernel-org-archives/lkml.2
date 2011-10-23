Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1JWMAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:00:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45340 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1JWMAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:00:19 -0400
Date: Sun, 23 Oct 2011 13:00:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 16/16] ARM: LPAE: Add the Kconfig entries
Message-ID: <20111023120008.GE17912@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-17-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-17-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:39PM +0100, Catalin Marinas wrote:
> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 88633fe..2df5504 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -629,6 +629,19 @@ config IO_36
>  
>  comment "Processor Features"
>  
> +config ARM_LPAE
> +	bool "Support for the Large Physical Address Extension"
> +	depends on MMU && CPU_V7
> +	help
> +	  Say Y if you have an ARMv7 processor supporting the LPAE page table
> +	  format and you would like to access memory beyond the 4GB limit.

This help text is entirely insufficient.  It doesn't tell people what the
implications are for enabling this option on CPUs without LPAE support.
(It won't boot.)  It doesn't suggest what people should select when they're
unsure what setting to use.
