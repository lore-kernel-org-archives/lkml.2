Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1LIXRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:17:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60237 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1LIXRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:17:43 -0500
Date: Fri, 9 Dec 2011 18:17:40 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kees Cook <kees@outflux.net>
cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: standardize /proc/iomem "Kernel code" name
In-Reply-To: <20111209211157.GA2146@outflux.net>
Message-ID: <alpine.LFD.2.02.1112091815400.2907@xanadu.home>
References: <20111209211157.GA2146@outflux.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Kees Cook wrote:

> All other ports use "Kernel code" to identify the Kernel text segment
> in /proc/iomem. Change the ARM resources to do the same.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

Please submit the patch here:
http://www.arm.linux.org.uk/developer/patches/

> ---
>  arch/arm/kernel/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 3448a3f..a34dbf6 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -158,7 +158,7 @@ static struct resource mem_res[] = {
>  		.flags = IORESOURCE_MEM
>  	},
>  	{
> -		.name = "Kernel text",
> +		.name = "Kernel code",
>  		.start = 0,
>  		.end = 0,
>  		.flags = IORESOURCE_MEM
> -- 
> 1.7.5.4
> 
> 
> -- 
> Kees Cook                                            @outflux.net
> 
