Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab2KEPLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:11:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47379 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab2KEPLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:11:09 -0500
Message-ID: <5097D6FC.7040202@ti.com>
Date: Mon, 5 Nov 2012 10:10:52 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <khilman@ti.com>,
        <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-3-git-send-email-m-karicheri2@ti.com> <50950908.1060302@ti.com>
In-Reply-To: <50950908.1060302@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 08:07 AM, Sekhar Nori wrote:
> On 10/25/2012 9:41 PM, Murali Karicheri wrote:
>> This is the driver for the Power Sleep Controller (PSC) hardware
>> found on DM SoCs as well Keystone SoCs (c6x). This driver borrowed
>> code from arch/arm/mach-davinci/psc.c and implemented the driver
>> as per common clock provider API. The PSC module is responsible for
>> enabling/disabling the Power Domain and Clock domain for different IPs
>> present in the SoC. The driver is configured through the clock data
>> passed to the driver through struct clk_psc_data.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
>> +/**
>> + * struct clk_psc - DaVinci PSC clock driver data
>> + *
>> + * @hw: clk_hw for the psc
>> + * @psc_data: Driver specific data
>> + */
>> +struct clk_psc {
>> +	struct clk_hw hw;
>> +	struct clk_psc_data *psc_data;
>> +	spinlock_t *lock;
> Unused member? I don't see this being used.

OK. Will remove.
>
> Thanks,
> Sekhar
>

