Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab1LNCiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:38:24 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36068 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1LNCiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:38:23 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-65-4ee80c1e57db
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <4EE80C1C.7080704@samsung.com>
Date: Wed, 14 Dec 2011 11:38:20 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419
 Thunderbird/3.1.9
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH RESEND 1/2] MFD: MAX8997: add platform data and devices for
 LED control
References: <1323764033-3979-1-git-send-email-dg77.kim@samsung.com>
 <1323764033-3979-2-git-send-email-dg77.kim@samsung.com>
 <20111213205905.GH2796@sortiz-mobl>
In-reply-to: <20111213205905.GH2796@sortiz-mobl>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 2011년 12월 14일 05:59, Samuel Ortiz wrote:
> Hi Donggeun,
> 
> On Tue, Dec 13, 2011 at 05:13:52PM +0900, Donggeun Kim wrote:
>> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
>> index 5be53ae..cb83a7a 100644
>> --- a/drivers/mfd/max8997.c
>> +++ b/drivers/mfd/max8997.c
>> @@ -43,7 +43,8 @@ static struct mfd_cell max8997_devs[] = {
>>  	{ .name = "max8997-battery", },
>>  	{ .name = "max8997-haptic", },
>>  	{ .name = "max8997-muic", },
>> -	{ .name = "max8997-flash", },
> That doesn't seem to be related to this patch.
> 
> 
Actually, the name of 'max8997-flash' is intended to be used for LED
driver. I think the device name has 'led' suffix rather than 'flash', as
the driver of MAX8997 is included in led class.
>> +	{ .name = "max8997-led", .id = 1 },
>> +	{ .name = "max8997-led", .id = 2 },
>>  };
>> @@ -172,7 +194,8 @@ struct max8997_platform_data {
>>  
>>  	/* HAPTIC: Not implemented */
>>  	/* RTC: Not implemented */
>> -	/* Flash: Not implemented */
>> +	/* ---- Flash ---- */
>> +	struct max8997_led_platform_data *led_pdata;
> This is a bit confusing: Flash and LED ?
> 
LED would be better. I will fix it.
> Cheers,
> Samuel.
> 

Thanks.
-Donggeun
