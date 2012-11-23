Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2KWGo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:44:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63810 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2KWGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:44:26 -0500
Message-ID: <50AF1B62.1000209@linaro.org>
Date: Fri, 23 Nov 2012 12:14:50 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 0/7] i2c: s3c2410: Add devm_* apis and cleanup
References: <1353650353-17576-1-git-send-email-tushar.behera@linaro.org> <CAM=Q2cs=oYq4e17LXxUEhATiYLAjnzoTH-+nsO5KNQwGj2qSBA@mail.gmail.com>
In-Reply-To: <CAM=Q2cs=oYq4e17LXxUEhATiYLAjnzoTH-+nsO5KNQwGj2qSBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 11:45 AM, Shubhrajyoti Datta wrote:
> On Fri, Nov 23, 2012 at 11:29 AM, Tushar Behera
> <tushar.behera@linaro.org> wrote:
>> This patchset cleans up the probe function of i2c-s3c2410 driver.
>> These have been tested on Exynos4210 based Origen board.
>>
>> Tushar Behera (7):
>>   i2c: s3c2410: Remove unnecessary label err_noclk
>>   i2c: s3c2410: Convert to use devm_clk_get()
>>   i2c: s3c2410: Convert to use devm_request_mem_region()
>>   i2c: s3c2410: Convert to use devm_ioremap()
>>   i2c: s3c2410: Convert to use devm_request_irq()
> 
> You may want to consider request_and_ioremap.
> 

Thanks. I will redo the patchset and submit again.

> 
>>   i2c: s3c2410: Move location of clk_prepare_enable() call in probe
>>     function
>>   i2c: s3c2410: Remove err_cpufreq label
>>
>>  drivers/i2c/busses/i2c-s3c2410.c |   74 ++++++++++++--------------------------
>>  1 files changed, 23 insertions(+), 51 deletions(-)
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Tushar Behera
