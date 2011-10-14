Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1JNMe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:34:28 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:11488 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1JNMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:34:26 -0400
Message-ID: <4E982C35.2020206@atmel.com>
Date: Fri, 14 Oct 2011 14:33:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/21] ARM: drop unused Kconfig symbols
References: <1318595356.6132.69.camel@x61.thuisdomein>
In-Reply-To: <1318595356.6132.69.camel@x61.thuisdomein>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 02:29 PM, Paul Bolle :
> ARCH_AT91SAM9260_SAM9XE is simply unused.
> 
> MACH_TRIZEPS_UCONXS doesn't offfer anything MACH_TRIZEPS_ANY doesn't
> already offer (ie, providing a way to not select MACH_TRIZEPS_CONXS,
> which actually suggest the "choice" they are part of should be
> "optional").
> 
> Add a comment that CPU_IXP46X and CPU_IXP43X could be merged. What
> would be a nice new name?
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

For at91:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  arch/arm/mach-at91/Kconfig   |    6 ------
>  arch/arm/mach-ixp4xx/Kconfig |    1 +
>  arch/arm/mach-pxa/Kconfig    |    3 ---
>  3 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 2248467..db23f3d 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -190,12 +190,6 @@ if ARCH_AT91SAM9260
>  
>  comment "AT91SAM9260 Variants"
>  
> -config ARCH_AT91SAM9260_SAM9XE
> -	bool "AT91SAM9XE"
> -	help
> -	  Select this if you are using Atmel's AT91SAM9XE System-on-Chip.
> -	  They are basically AT91SAM9260s with various sizes of embedded Flash.
> -
>  comment "AT91SAM9260 / AT91SAM9XE Board Type"
>  
>  config MACH_AT91SAM9260EK
> diff --git a/arch/arm/mach-ixp4xx/Kconfig b/arch/arm/mach-ixp4xx/Kconfig
> index 6f991c5..56f867c 100644
> --- a/arch/arm/mach-ixp4xx/Kconfig
> +++ b/arch/arm/mach-ixp4xx/Kconfig
> @@ -151,6 +151,7 @@ config MACH_ARCOM_VULCAN
>  #
>  # Certain registers and IRQs are only enabled if supporting IXP465 CPUs
>  #
> +# XXX These two options can be merged. What is a nice name?
>  config CPU_IXP46X
>  	bool
>  	depends on MACH_IXDP465
> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
> index cd19309..4a03fda 100644
> --- a/arch/arm/mach-pxa/Kconfig
> +++ b/arch/arm/mach-pxa/Kconfig
> @@ -184,9 +184,6 @@ choice
>  config MACH_TRIZEPS_CONXS
>  	bool "ConXS Eval Board"
>  
> -config MACH_TRIZEPS_UCONXS
> -	bool "uConXS Eval Board"
> -
>  config MACH_TRIZEPS_ANY
>  	bool "another Board"
>  


-- 
Nicolas Ferre
