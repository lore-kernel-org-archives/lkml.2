Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1C3Sxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:53:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36543 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1C3Sxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:53:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6301"; a="82796168"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: allow hotplug on msm
References: <1301078861-1991-1-git-send-email-johlstei@codeaurora.org>
Date: Wed, 30 Mar 2011 11:54:42 -0700
In-Reply-To: <1301078861-1991-1-git-send-email-johlstei@codeaurora.org> (Jeff
	Ohlstein's message of "Fri, 25 Mar 2011 11:47:41 -0700")
Message-ID: <8yabp0ssakt.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25 2011, Jeff Ohlstein wrote:

> Hotplug support was added in 9f1890a (msm: hotplug: support cpu hotplug
> on msm, 2010-12-02)
>
> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> ---
>  arch/arm/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 172e918..9485b6c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1358,7 +1358,6 @@ config NR_CPUS
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
>  	depends on SMP && HOTPLUG && EXPERIMENTAL
> -	depends on !ARCH_MSM
>  	help
>  	  Say Y here to experiment with turning CPUs off and on.  CPUs
>  	  can be controlled through /sys/devices/system/cpu.

This looks fine by me.  Russell, would you like Jeff to submit this to
your patch tracking system?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
