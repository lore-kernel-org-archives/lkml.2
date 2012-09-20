Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2ITUOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:14:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39424 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2ITUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:14:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="237035798"
Message-ID: <505B7919.6020206@codeaurora.org>
Date: Thu, 20 Sep 2012 13:14:17 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] gpio: Make gpio-msm-v1 into a platform driver
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org> <1348038044-1790-5-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1348038044-1790-5-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/2012 12:00 AM, Stephen Boyd wrote:
> Doing this removes the dependence of this driver on the
> msm_iomap.h and cpu.h mach include headers provied by MSM. This
> is necessary to support single zImage work in the future and
> allows us to remove cpu.h entirely and brings us closer to
> removing msm_iomap.h.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Rohit Vaswani <rvaswani@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>   arch/arm/mach-msm/board-halibut.c   |   1 +
>   arch/arm/mach-msm/board-msm7x30.c   |   1 +
>   arch/arm/mach-msm/board-qsd8x50.c   |   1 +
>   arch/arm/mach-msm/board-trout.c     |   1 +
>   arch/arm/mach-msm/devices-msm7x00.c |  31 +++++
>   arch/arm/mach-msm/devices-msm7x30.c |  31 +++++
>   arch/arm/mach-msm/devices-qsd8x50.c |  31 +++++
>   arch/arm/mach-msm/devices.h         |   4 +
>   drivers/gpio/gpio-msm-v1.c          | 220 ++++++++++++++++++++++++------------
>   9 files changed, 250 insertions(+), 71 deletions(-)
>

Tested-by: Rohit Vaswani <rvaswani@codeaurora.org>
Acked-by: Rohit Vaswani <rvaswani@codeaurora.org>

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

