Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab2JKKfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:35:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43412 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab2JKKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:35:44 -0400
Message-ID: <5076A0DE.4070900@ti.com>
Date: Thu, 11 Oct 2012 16:05:10 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>, <khilman@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <mturquette@linaro.org>, <linux-c6x-dev@linux-c6x.org>,
        <arnd@arndb.de>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-keystone@list.ti.com>, <viresh.linux@gmail.com>,
        <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/13] clk: davinci - add Main PLL clock driver
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com> <1348682889-9509-2-git-send-email-m-karicheri2@ti.com> <507563C3.2000305@ti.com>
In-Reply-To: <507563C3.2000305@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 5:32 PM, Sekhar Nori wrote:
> Hi Murali,
> 
> On 9/26/2012 11:37 PM, Murali Karicheri wrote:
>> This is the driver for the main PLL clock hardware found on DM SoCs.
>> This driver borrowed code from arch/arm/mach-davinci/clock.c and
>> implemented the driver as per common clock provider API. The main PLL
>> hardware typically has a multiplier, a pre-divider and a post-divider.
>> Some of the SoCs has the divider fixed meaning they can not be
>> configured through a register. HAS_PREDIV and HAS_POSTDIV flags are used
>> to tell the driver if a hardware has these dividers present or not.
>> Driver is configured through the structure clk_davinci_pll_data
>> that has the platform data for the driver.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> Are you using git-format-patch to generate the patches? It should have
> added a diffstat here by default which is very useful in quickly
> understanding what the patch is touching.
>>
>> diff --git a/drivers/clk/davinci/clk-davinci-pll.c b/drivers/clk/davinci/clk-davinci-pll.c

Looking at how common clock framework for mxs has been implemented, this
file should simply be clk-pll.c. That makes sense as you are creating a
davinci folder anyway. Similar change required for psc as well.

Thanks,
Sekhar
