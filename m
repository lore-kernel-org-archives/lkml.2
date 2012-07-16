Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2GPGzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:55:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5630 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2GPGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:55:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 15 Jul 2012 23:51:49 -0700
Message-ID: <5003B917.9040808@nvidia.com>
Date: Mon, 16 Jul 2012 12:17:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 4/5] gpio: tps6586x: add gpio support through platform
 driver
References: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>	<1342175967-10087-5-git-send-email-ldewangan@nvidia.com> <CACRpkdadrHaH0kCfn22T+GnO=TKNvexcup+TsajPgnQgkiQ9Gw@mail.gmail.com>
In-Reply-To: <CACRpkdadrHaH0kCfn22T+GnO=TKNvexcup+TsajPgnQgkiQ9Gw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 July 2012 03:48 AM, Linus Walleij wrote:
> On Fri, Jul 13, 2012 at 12:39 PM, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>
>> Converting the gpio driver of tps6586x to a platform
>> driver in place of registering the gpio through core
>> driver.
>> The motivation of the change is:
>> - This is inline with the mfd drivers implementation.
>> - This will move the related gpio support to gpio driver
>>    folder where all gpio related drivers are available.
>>    This will be easy the maintenance and enhancement is
>>    anything done for gpio.
>> - The gpio functionality can be selected through config
>>    variable.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Overall this is very, very good and you're doing the right thing.
>
>> --- /dev/null
>> +++ b/drivers/gpio/gpio-tps6586x.c
>> +#include<linux/i2c.h>
> Why?
>

Removed this inclusion as it is not require.

> Reviewed-by: Linus Walleij<linus.walleij@linaro.org>

I will add your reviewed-by in my next patch for easyness.


