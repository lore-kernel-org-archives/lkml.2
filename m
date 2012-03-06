Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab2CFNPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:15:21 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:41867 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758502Ab2CFNPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:15:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shubhrajyoti@ti.com designates 10.236.190.5 as permitted sender) smtp.mail=shubhrajyoti@ti.com
Message-ID: <4F560DE1.3090809@ti.com>
Date: Tue, 06 Mar 2012 18:45:13 +0530
From: Shubhrajyoti <shubhrajyoti@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] spi/omap: Trivial cleanup
References: <1330524246-8864-1-git-send-email-shubhrajyoti@ti.com> <4F55E412.5050409@ti.com>
In-Reply-To: <4F55E412.5050409@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012 03:46 PM, Cousson, Benoit wrote:
> Hi Shubhro,
>
> On 2/29/2012 3:04 PM, Shubhrajyoti D wrote:
>> The context is stored directly inside drvdata structure post
>> [f887876 spi/omap: Remove bus_num usage for instance index].
>> Remove the OMAP2_MCSPI_MAX_CTRL macro as it is not needed anymore.
>>
>> Cc: Benoit Cousson<b-cousson@ti.com>
>> Signed-off-by: Shubhrajyoti D<shubhrajyoti@ti.com>
>
> Thanks for that extra cleanup, I missed it.
>
> Acked-by: Benoit Cousson <b-cousson@ti.com>
>
>> ---
>> Applies on Benoit's for_3.4/dt_spi_eth
>>
>>   drivers/spi/spi-omap2-mcspi.c |    3 ---
>>   1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/spi/spi-omap2-mcspi.c
>> b/drivers/spi/spi-omap2-mcspi.c
>> index d1eb26c..3526281 100644
>> --- a/drivers/spi/spi-omap2-mcspi.c
>> +++ b/drivers/spi/spi-omap2-mcspi.c
>> @@ -45,9 +45,6 @@
>>
>>   #define OMAP2_MCSPI_MAX_FREQ        48000000
>>
>> -/* OMAP2 has 3 SPI controllers, while OMAP3 has 4 */
>> -#define OMAP2_MCSPI_MAX_CTRL         4
>> -
>
> I guess it can be included in the "spi/omap: Remove bus_num usage for
> instance index"?
> Is that OK for you?
Yes, sure.
>
>
> Thanks,
> Benoit
>

