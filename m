Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232Ab0FQUA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:00:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21860 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab0FQUA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:00:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44614193"
Subject: Re: [PATCH 1/2] arm: msm: Add gpiolib support for MSM7200A-family
 chips.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1276656228-9376-2-git-send-email-gbean@codeaurora.org>
References: <1276656228-9376-1-git-send-email-gbean@codeaurora.org>
	 <1276656228-9376-2-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 13:00:50 -0700
Message-ID: <1276804850.29614.61.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 19:43 -0700, Gregory Bean wrote:
> Add support for uniprocessor MSM chips whose TLMM/GPIO design
> is the same as the MSM7200A.
> This includes, but is not necessarily limited to, the:
> MSM7200A, MSM7x25, MSM7x27, MSM7x30, QSD8x50, QSD8x50A
> 
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig         |    7 ++
>  arch/arm/mach-msm/Makefile        |    2 +-
>  arch/arm/mach-msm/msm7200a-gpio.c |  187 +++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/msm7200a-gpio.h |   62 ++++++++++++
>  4 files changed, 257 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-msm/msm7200a-gpio.c
>  create mode 100644 arch/arm/mach-msm/msm7200a-gpio.h
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 47264a7..d919b90 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -106,4 +106,11 @@ config MSM_SMD_PKG3
>  config MSM_SMD
>  	bool
>  
> +config MSM7200A_GPIO
> +	tristate "Qualcomm MSM7200A SoC GPIO support"
> +	depends on GPIOLIB
> +	help
> +	  Say yes here to support GPIO functionality on Qualcomm's
> +	  MSM chipsets which descend from the MSM7200a:
> +	  MSM7x01(a), MSM7x25, MSM7x27, MSM7x30, QSD8x50(a).

Can't we drop this? It's always going to be on right ?

Daniel

