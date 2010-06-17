Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab0FQUEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:04:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2841 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204Ab0FQUEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:04:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6016"; a="44614655"
Message-ID: <4C1A7FDA.1070607@codeaurora.org>
Date: Thu, 17 Jun 2010 13:04:42 -0700
From: Greg Bean <gbean@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add gpiolib support for MSM7200A-family
 chips.
References: <1276656228-9376-1-git-send-email-gbean@codeaurora.org>	 <1276656228-9376-2-git-send-email-gbean@codeaurora.org> <1276804850.29614.61.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1276804850.29614.61.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +config MSM7200A_GPIO
>> +	tristate "Qualcomm MSM7200A SoC GPIO support"
>> +	depends on GPIOLIB
>> +	help
>> +	  Say yes here to support GPIO functionality on Qualcomm's
>> +	  MSM chipsets which descend from the MSM7200a:
>> +	  MSM7x01(a), MSM7x25, MSM7x27, MSM7x30, QSD8x50(a).
>
> Can't we drop this? It's always going to be on right ?

Not on all targets.  There will be other drivers for chips from other 
lines.  However, I would think that it could be entirely reasonable to 
lose the Kconfig and just hard-wire it in based on ARCH, if you like. 
Is that preferred?

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
