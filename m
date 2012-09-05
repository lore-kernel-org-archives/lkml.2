Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab2IEVJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:09:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36205 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2IEVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:09:40 -0400
Date: Wed, 5 Sep 2012 17:09:37 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] ARM: Fix semihosting Kconfig text
In-Reply-To: <1346879011-7765-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1209051709040.1784@xanadu.home>
References: <1346879011-7765-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012, Stephen Boyd wrote:

> It seems we were missing some text in the title for the
> semihosting DEBUG_LL option. Add in the "/O" and fix up some
> minor typos in the help text.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
>  arch/arm/Kconfig.debug | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index f15f82b..e968a52 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -356,15 +356,15 @@ choice
>  		  is nothing connected to read from the DCC.
>  
>  	config DEBUG_SEMIHOSTING
> -		bool "Kernel low-level debug output via semihosting I"
> +		bool "Kernel low-level debug output via semihosting I/O"
>  		help
>  		  Semihosting enables code running on an ARM target to use
>  		  the I/O facilities on a host debugger/emulator through a
> -		  simple SVC calls. The host debugger or emulator must have
> +		  simple SVC call. The host debugger or emulator must have
>  		  semihosting enabled for the special svc call to be trapped
>  		  otherwise the kernel will crash.
>  
> -		  This is known to work with OpenOCD, as wellas
> +		  This is known to work with OpenOCD, as well as
>  		  ARM's Fast Models, or any other controlling environment
>  		  that implements semihosting.
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
