Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2LTBk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:40:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2LTBkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:40:22 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a6-50d26c7f6b4d
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <50D26C7D.8010500@samsung.com>
Date: Thu, 20 Dec 2012 10:40:13 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myugnjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [rtc-linux] [RESEND PATCH] RTC: MAX77686: Add Maxim 77686 driver
References: <1354085457-18460-1-git-send-email-jonghwa3.lee@samsung.com>
 <20121218163009.fb21fec8.akpm@linux-foundation.org>
In-reply-to: <20121218163009.fb21fec8.akpm@linux-foundation.org>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zPd36nEsBBm0f+S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGrIfNLAVztCoOr1vN3sB4XLGLkYNDQsBEYsI53S5GTiBTTOLC
	vfVsXYxcHEICyxgl/vW0MEEkTCTOfZoGZgsJTGeU+DnBCMTmFRCU+DH5HguIzSygLjFp3iJm
	CFtE4ty332wQtrbEsoWvmSGGdjFJLH+5gxmiWUvi6JLXbCBHsAioSnS+NgUJswnISbxt+sYI
	EhYViJD41c8BEhYR0JVY9XwX2BhmgalMEp+OfmMFSQgL+ErsnPOEBeK2OoklHefBbE4BB4me
	ZSfZQWwWAQGJb5MPsUD8Kyux6QDYHAmBbnaJ1Y2fGSF+lJQ4uOIGywRG8VlIXpuF5LVZSF6b
	heS1BYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFC4kd6B+OqBotDjAIcjEo8vJIrLgQI
	sSaWFVfmHmKU4GBWEuFdeOtigBBvSmJlVWpRfnxRaU5q8SFGH6DLJzJLiSbnA2M7ryTe0NjA
	2NDQ0tDM1NLUAIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQZG83PZbDfu+t9seWPYWGN8
	zutCUd3c7lmGlUseW8UW2UZtnHSx+d8utTKJg+6X+PQ+sDqZ+syZkPpsVl1L5u+Uydwssw7F
	fBHIYq+PeMxzzWvZbhPzH6H8BxmXbt61QmRu2JXCSTqvqqbaLXXL5j6f8rxSQGLJG36tHX/m
	nEy7seTcsfIwb9scJZbijERDLeai4kQAxEzK2swCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jQd36nEsBBkc/cVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjOl9c9kKjmhW3Jl4lbGB
	8b1CFyMnh4SAicS5T9OYIGwxiQv31rOB2EIC0xklfk4wArF5BQQlfky+x9LFyMHBLCAvceRS
	NkiYWUBdYtK8RcxdjFxA5V1MEstf7mCGqNeSOLrkNRtIPYuAqkTna1OQMJuAnMTbpm+MIGFR
	gQiJX/0cIGERAV2JVc93gY1hFpjKJPHp6DdWkISwgK/EzjlPWCDOqZNY0nEezOYUcJDoWXaS
	fQKjwCwk181CuG4WkusWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOtWfSOxhXNVgc
	YhTgYFTi4ZVccSFAiDWxrLgy9xCjBAezkgjvwlsXA4R4UxIrq1KL8uOLSnNSiw8x+gD9NpFZ
	SjQ5H5gG8kriDY1NzIwsjcyMTcyNjXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpg7P9/
	3i3jxaXqyV8LS+/+OsfFF87Tw7RRwf2P9Hr9L8VN4uci30Sd+HWywEXx8Gqz++80rs64omj1
	1Vtni/a1S9sFv6VHRURsmN97xEjyRtvhHwXcJttmlPJKxh9NrnQVsbTKMq/rkjwuU/R922+1
	8lpXXWOeGS+v266axZga8DlcZse+C1EzlViKMxINtZiLihMBFq3uUeICAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,
On 2012년 12월 19일 09:30, Andrew Morton wrote:
> On Wed, 28 Nov 2012 15:50:57 +0900
> Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> 
>> Add driver for support max77686 rtc.
>> MAX77686 rtc support smpl and wtsr mode. It has two alarm register
>> which can be used for alarming to wake system up. This drvier uses regmap
>> to access its register.
>>
>> ...
>>
>> +static inline int max77686_rtc_calculate_wday(u8 shifted)
>> +{
>> +	int counter = -1;
>> +	while (shifted) {
>> +		shifted >>= 1;
>> +		counter++;
>> +	}
>> +	return counter;
>> +}
> 
> We should be able to use log2() in here?
> 
Okay, and I'd like to use Joe's recommendation. fls(shitfted) - 1

>>
>> ...
>>
>> +static inline int max77686_rtc_update(struct max77686_rtc_info *info,
>> +	enum MAX77686_RTC_OP op)
>> +{
>> +	int ret;
>> +	unsigned int data;
>> +
>> +	switch (op) {
>> +	case MAX77686_RTC_WRITE:
>> +		data = 1 << RTC_UDR_SHIFT;
>> +		break;
>> +	case MAX77686_RTC_READ:
>> +		data = 1 << RTC_RBUDR_SHIFT;
>> +		break;
>> +	}
>> +
>> +	ret = regmap_update_bits(info->max77686->rtc_regmap,
>> +				 MAX77686_RTC_UPDATE0, data, data);
>> +	if (ret < 0)
>> +		dev_err(info->dev, "%s: fail to write update reg(ret=%d, data=0x%x)\n",
>> +				__func__, ret, data);
>> +	else {
>> +		/* Minimum 16ms delay required before RTC update. */
>> +		msleep(MAX77686_RTC_UPDATE_DELAY);
>> +	}
>> +
>> +	return ret;
>> +}
> 
> This function has about ten callers.  No way in the world do we want it
> to be inlined!  Probably the compiler will just ignore your `inline',
> but we should remove it to be sure.
> 
Okay, I'll remove it.
>>
>> ...
>>
>> +static const struct rtc_class_ops max77686_rtc_ops = {
>> +	.read_time = max77686_rtc_read_time,
>> +	.set_time = max77686_rtc_set_time,
>> +	.read_alarm = max77686_rtc_read_alarm,
>> +	.set_alarm = max77686_rtc_set_alarm,
>> +	.alarm_irq_enable = max77686_rtc_alarm_irq_enable,
>> +};
>> +
>> +#ifdef MAX77686_RTC_WTSR_SMPL
> 
> hm, this is always undefined.  Why is this code here?
>
Yes, you're right, It isn't needed. I'll fix it right.

>> +static void max77686_rtc_enable_wtsr(struct max77686_rtc_info *info, bool enable)
>> +{
>> +	int ret;
>> +	unsigned int val, mask;
>> +
>> +	if (enable)
>> +		val = (1 << WTSR_EN_SHIFT) | (3 << WTSRT_SHIFT);
>> +	else
>> +		val = 0;
>> +
>> +	mask = WTSR_EN_MASK | WTSRT_MASK;
>> +
>> +	dev_info(info->dev, "%s: %s WTSR\n", __func__,
>> +			enable ? "enable" : "disable");
>> +
>> +	ret = regmap_update_bits(info->max77686->rtc_regmap,
>> +				 MAX77686_WTSR_SMPL_CNTL, mask, val);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
>> +				__func__, ret);
>> +		return;
>> +	}
>> +
>> +	max77686_rtc_update(info, MAX77686_RTC_WRITE);
>> +}
>> +
>> +static void max77686_rtc_enable_smpl(struct max77686_rtc_info *info, bool enable)
>> +{
>> +	int ret;
>> +	unsigned int val, mask;
>> +
>> +	if (enable)
>> +		val = (1 << SMPL_EN_SHIFT) | (0 << SMPLT_SHIFT);
>> +	else
>> +		val = 0;
>> +
>> +	mask = SMPL_EN_MASK | SMPLT_MASK;
>> +
>> +	dev_info(info->dev, "%s: %s SMPL\n", __func__,
>> +			enable ? "enable" : "disable");
>> +
>> +	ret = regmap_update_bits(info->max77686->rtc_regmap,
>> +				 MAX77686_WTSR_SMPL_CNTL, mask, val);
>> +	if (ret < 0) {
>> +		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
>> +				__func__, ret);
>> +		return;
>> +	}
>> +
>> +	max77686_rtc_update(info, MAX77686_RTC_WRITE);
>> +
>> +	val = 0;
>> +	regmap_read(info->max77686->rtc_regmap, MAX77686_WTSR_SMPL_CNTL, &val);
>> +	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
>> +}
>> +#endif /* MAX77686_RTC_WTSR_SMPL */
>>
>> ...
>>
>> +static int __devinit max77686_rtc_probe(struct platform_device *pdev)
> 
> CONFIG_HOTPLUG is removed, so we should stop using devinit, devexit,
> devinit_p, etc.
> 
>>
>> ...
>>
> 
> --- a/drivers/rtc/rtc-max77686.c~rtc-max77686-add-maxim-77686-driver-fix
> +++ a/drivers/rtc/rtc-max77686.c
> @@ -129,7 +129,7 @@ static int max77686_rtc_tm_to_data(struc
>  	return 0;
>  }
>  
> -static inline int max77686_rtc_update(struct max77686_rtc_info *info,
> +static int max77686_rtc_update(struct max77686_rtc_info *info,
>  	enum MAX77686_RTC_OP op)
>  {
>  	int ret;
> @@ -501,7 +501,7 @@ static struct regmap_config max77686_rtc
>  	.val_bits = 8,
>  };
>  
> -static int __devinit max77686_rtc_probe(struct platform_device *pdev)
> +static int max77686_rtc_probe(struct platform_device *pdev)
>  {
>  	struct max77686_dev *max77686 = dev_get_drvdata(pdev->dev.parent);
>  	struct max77686_rtc_info *info;
> @@ -575,7 +575,7 @@ out:
>  	return ret;
>  }
>  
> -static int __devexit max77686_rtc_remove(struct platform_device *pdev)
> +static int max77686_rtc_remove(struct platform_device *pdev)
>  {
>  	struct max77686_rtc_info *info = platform_get_drvdata(pdev);
>  
> @@ -623,7 +623,7 @@ static struct platform_driver max77686_r
>  		.owner	= THIS_MODULE,
>  	},
>  	.probe		= max77686_rtc_probe,
> -	.remove		= __devexit_p(max77686_rtc_remove),
> +	.remove		= max77686_rtc_remove,
>  	.shutdown	= max77686_rtc_shutdown,
>  	.id_table	= rtc_id,
>  };
> _
> 
> 
Best regards
Jonghwa.
