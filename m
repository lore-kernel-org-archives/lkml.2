Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1ERWfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:35:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61109 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1ERWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:35:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="91959485"
Message-ID: <4DD449BA.3090907@codeaurora.org>
Date: Wed, 18 May 2011 15:35:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/7] gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org> <1305755453-31112-8-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1305755453-31112-8-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 02:50 PM, David Brown wrote:
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index aa5a3f9..235b6c9 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -139,6 +139,14 @@ config GPIO_MSM_V1
>  	  Qualcomm MSM chips.  Most of the pins on the MSM can be
>  	  selected for GPIO, and are controlled by this driver.
>  
> +config GPIO_MSM_V2
> +	tristate "Qualcomm MSM GPIO v2"
> +	depends on GPIOLIB && ARCH_MSM
> +	help
> +	  Say yes here to support the GPIO interface on ARM many v7

s/many// ?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

