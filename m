Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab0FQJUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:20:55 -0400
Received: from smtp.nokia.com ([192.100.122.233]:40939 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab0FQJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:20:51 -0400
Date: Thu, 17 Jun 2010 12:24:19 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Peter Huewe <PeterHuewe@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm/include: Fix missing semicolon in module.h
Message-ID: <20100617092419.GI17639@pcarmody-desktop>
References: <201006161932.00542.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006161932.00542.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Jun 2010 09:19:55.0680 (UTC) FILETIME=[40003200:01CB0DFE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/10 19:32 +0200, ext Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes a missing semicolon which introduced buildfailures [2] for
> almost every arm defconfig, introduced by patch cecaa4c6b [1]
> 
> This issue arises only if CONFIG_ARM_UNWIND is not set.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

My bad, sorry. 

Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

> ---
> KernelVersion: linux-next-20100616
> References:
> [1] cecaa4c6b ARM: 6172/1: module - additional unwind tables for exit/devexit
> [2] http://kisskb.ellerman.id.au/kisskb/compiler/11/
> [3] http://kisskb.ellerman.id.au/kisskb/buildresult/2725882/
> 
>  arch/arm/include/asm/module.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
> index fcff0d2..cbb0bc2 100644
> --- a/arch/arm/include/asm/module.h
> +++ b/arch/arm/include/asm/module.h
> @@ -26,7 +26,7 @@ struct mod_arch_specific {
>  };
>  #else
>  struct mod_arch_specific {
> -}
> +};
>  #endif
>  
>  /*
> -- 
> 1.6.4.4
