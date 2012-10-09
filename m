Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2JINJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:09:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36733 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab2JINJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:09:40 -0400
Message-ID: <507421FF.2090309@ti.com>
Date: Tue, 9 Oct 2012 18:39:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <mikedunn@newsguy.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <hs@denx.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] mtd:nand:clk: preparation for switch to common clock
 framework
References: <1347899860-24358-1-git-send-email-m-karicheri2@ti.com> <1347899860-24358-2-git-send-email-m-karicheri2@ti.com> <507420A4.8090905@ti.com>
In-Reply-To: <507420A4.8090905@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/2012 6:33 PM, Sekhar Nori wrote:
> On 9/17/2012 10:07 PM, Murali Karicheri wrote:
>> As a first step towards migrating davinci platforms to use common clock
>> framework, replace all instances of clk_enable() with clk_prepare_enable()
>> and clk_disable() with clk_disable_unprepare(). Until the platform is
>> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
>> adds a might_sleep() call and would work without any issues.
>>
>> This will make it easy later to switch to common clk based implementation
>> of clk driver from DaVinci specific driver.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> Reviewed-by: Mike Turquette <mturquette@linaro.org>
> 
> Tested this using NAND flash on DA850 EVM.
> 
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> 
> Any chance this can make into the v3.7 kernel?

Just noticed another thread where Artem replied saying this patch is
pushed. Sorry about the noise.

Thanks,
Sekhar
