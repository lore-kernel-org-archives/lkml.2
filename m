Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857Ab2JaNYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:24:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58975 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935543Ab2JaNYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:24:06 -0400
Message-ID: <50912667.9030909@ti.com>
Date: Wed, 31 Oct 2012 09:23:51 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: <mturquette@linaro.org>, <arnd@arndb.de>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <rob.herring@calxeda.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <nsekhar@ti.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <sshtylyov@mvista.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-keystone@list.ti.com>
Subject: Re: [PATCH v3 01/11] clk: davinci - add main PLL clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-2-git-send-email-m-karicheri2@ti.com> <CACRpkdaa8f7N90hknaqZmNeYD1SjQx6Fm35nS34CxwnH+fwEfg@mail.gmail.com>
In-Reply-To: <CACRpkdaa8f7N90hknaqZmNeYD1SjQx6Fm35nS34CxwnH+fwEfg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 03:18 PM, Linus Walleij wrote:
> On Thu, Oct 25, 2012 at 6:11 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>
>> This is the driver for the main PLL clock hardware found on DM SoCs.
>> This driver borrowed code from arch/arm/mach-davinci/clock.c and
>> implemented the driver as per common clock provider API. The main PLL
>> hardware typically has a multiplier, a pre-divider and a post-divider.
>> Some of the SoCs has the divider fixed meaning they can not be
>> configured through a register. HAS_PREDIV and HAS_POSTDIV flags are used
>> to tell the driver if a hardware has these dividers present or not.
>> Driver is configured through the struct clk_pll_data that has the
>> SoC specific clock data.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> This looks good to me.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
>
>
Linus,

Thanks. I will add your Acked-by in the next revision of the patch.

Murali
