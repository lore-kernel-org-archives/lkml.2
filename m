Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1ERWoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:44:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5520 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab1ERWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:43:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="92157261"
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/7] gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
	<1305755453-31112-8-git-send-email-davidb@codeaurora.org>
	<4DD449BA.3090907@codeaurora.org>
Date: Wed, 18 May 2011 15:43:56 -0700
In-Reply-To: <4DD449BA.3090907@codeaurora.org> (Stephen Boyd's message of
	"Wed, 18 May 2011 15:35:38 -0700")
Message-ID: <8ya39kbmxxv.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18 2011, Stephen Boyd wrote:

> On 05/18/2011 02:50 PM, David Brown wrote:
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index aa5a3f9..235b6c9 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -139,6 +139,14 @@ config GPIO_MSM_V1
>>  	  Qualcomm MSM chips.  Most of the pins on the MSM can be
>>  	  selected for GPIO, and are controlled by this driver.
>>  
>> +config GPIO_MSM_V2
>> +	tristate "Qualcomm MSM GPIO v2"
>> +	depends on GPIOLIB && ARCH_MSM
>> +	help
>> +	  Say yes here to support the GPIO interface on ARM many v7
>
> s/many// ?

My intent was 'on many ARM v7 based Qualcomm MSM chips'.  I suppose I
can say just on 'v7' based chips, but the future is hard to predict.
I'll just take out the many.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
