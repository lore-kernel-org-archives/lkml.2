Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1GYUZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:25:31 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37864 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1GYUZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:25:29 -0400
Date: Mon, 25 Jul 2011 16:25:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: ARM_PATCH_PHYS_VIRT_16BIT no longer depends
 on MSM
In-Reply-To: <1311614362-9011-2-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1107251624560.12766@xanadu.home>
References: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org> <1311614362-9011-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011, Stephen Boyd wrote:

> MSM no longer requires the 16bit version of dynamic P2V. Drop the
> dependency.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: David Brown <davidb@codeaurora.org>

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>



> ---
>  arch/arm/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c24f97a..da4508d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -209,8 +209,8 @@ config ARM_PATCH_PHYS_VIRT
>  	  for the MSM machine class.
>  
>  config ARM_PATCH_PHYS_VIRT_16BIT
> -	def_bool y
> -	depends on ARM_PATCH_PHYS_VIRT && ARCH_MSM
> +	bool
> +	depends on ARM_PATCH_PHYS_VIRT
>  	help
>  	  This option extends the physical to virtual translation patching
>  	  to allow physical memory down to a theoretical minimum of 64K
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
