Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2JDTBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:01:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21907 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2JDTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:01:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6855"; a="243557545"
Message-ID: <506DDD0C.4080704@codeaurora.org>
Date: Thu, 04 Oct 2012 12:01:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Simon Horman <horms@verge.net.au>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org> <506D52D2.9060105@ti.com>
In-Reply-To: <506D52D2.9060105@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/12 02:11, Santosh Shilimkar wrote:
>> @@ -75,6 +77,8 @@ config SOC_OMAP5
>>       select CPU_V7
>>       select ARM_GIC
>>       select HAVE_SMP
>> +    select HAVE_ARM_SCU if SMP
>> +    select HAVE_ARM_TWD if LOCAL_TIMERS
>>       select ARM_CPU_SUSPEND if PM
>>       select SOC_HAS_REALTIME_COUNTER
>>       select ARM_ARCH_TIMER
> Drop this change.
>
> With that fixed, for OMAP changes
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Thanks. Will drop both lines in this hunk.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

