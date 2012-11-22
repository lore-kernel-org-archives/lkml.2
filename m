Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2KVS3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:29:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30530 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2KVS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:29:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fa66d0000004cf-bf-50ad8b92c0f9
Message-id: <50AD8B91.8030104@samsung.com>
Date: Thu, 22 Nov 2012 11:18:57 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Amit Daniel Kachhap'" <amit.kachhap@linaro.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
References: <007401cdc6ba$0742d6d0$15c88470$%choi@samsung.com>
 <CAH9JG2VKYSAQ=Og4-fgToV_aNwEV_aH-=UQZDbAOnA-ShfKdYw@mail.gmail.com>
 <50AC5250.3070203@samsung.com>
 <000701cdc84a$5602eda0$0208c8e0$%choi@samsung.com>
In-reply-to: <000701cdc84a$5602eda0$0208c8e0$%choi@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t8zbd3J3WsDDFadZbS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZvy68YCxYblGx/cBvlgbGh1pdjJwcEgImEste3WSHsMUkLtxb
	z9bFyMUhJLCMUWLd9ntACQ6Iosu1EPFFjBLdd9uYQRp4BQQlfky+xwJSwywgL3HkUjZImFlA
	XWLSvEVgJUICXUwSR1daQJRrSVz9NxEsziKgKtF8v4sJxGYTkJN42/SNEWSMqECExK9+DpCw
	iIC2RN/TWawQI28xShx9lQViCwu4Suye+pEF4pzbjBILFz8BK+IUsJe4/hDiFxYBAYlvkw+x
	QJwvK7HpADNIvYRAO7vE7OanTBD/SkocXHGDZQKj2Cwk38xC+GYWkm8WMDKvYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAiJBqkdjCsbLA4xCnAwKvHwajqvDRBiTSwrrsw9xCjBwawkwruo
	ACjEm5JYWZValB9fVJqTWnyI0Qfo2InMUqLJ+cBIzSuJNzQ2MDY0tDQ0M7U0NcAhrCTO2+yR
	EiAkkJ5YkpqdmlqQWgQzjomDU6qBUV2Et1iP7+t8wdld90P63hz48cmz+e8nc9ETDQ+Pzk99
	ODegz2++/r0VN4ulPt7SX/VltYgb40nzFJe9hZ/ynDbbGtlN84hYUhxm0LRN8Ht2iYj3px03
	lskaNtZu//bnmIL8mYsd1i935Pz+LPj2jk2AEU/X5Yy3enbnD7uuiL984Zk/V6yijhJLcUai
	oRZzUXEiABxeIyyzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAd1J3WsDDG5dsLC4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGb8uvGAsWG5Rsf3Ab5YG
	xodaXYwcHBICJhLLLtd2MXICmWISF+6tZ+ti5OIQEljEKNF9t40ZJMErICjxY/I9FpB6ZgF5
	iSOXskHCzALqEpPmLQIrERLoYpI4utIColxL4uq/iWBxFgFVieb7XUwgNpuAnMTbpm+MIGNE
	BSIkfvVzgIRFBLQl+p7OYoUYeYtR4uirLBBbWMBVYvfUjywQ59xmlFi4+AlYEaeAvcT1hzfZ
	JzAKzEJy3SyE62YhuW4BI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBYeya1g3Flg8Uh
	RgEORiUeXk3ntQFCrIllxZW5hxglOJiVRHgXFQCFeFMSK6tSi/Lji0pzUosPMfoAPTeRWUo0
	OR+YBvJK4g2NTcyMLI3MjE3MjY1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYJzqmfp1
	3rOdOfWxWvxluewdnx6Yn5630C37+FTd40fevOr/wf0jxMFaVW1mDJPGXK2dD/3LIy7ePyru
	FrPX3Ge2xGKTZQ/k3gjFKPioreMydn0/7yCLl2uYm7G+8/IJCkU39avPbzrtrh8Resn4sfit
	vp8Wxrtaf17MmiXe1Lk+4V351Acd7UosxRmJhlrMRcWJAIf+woriAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2012년 11월 22일 09:43, Jonghwan Choi wrote:
> Hi~
> 
> 
>>>>                                 data->base + EXYNOS_THD_TEMP_RISE);
>>>> @@ -665,6 +672,8 @@ static void exynos_tmu_control(struct
>> platform_device
>>>> *pdev, bool on)
>>>>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>>>>                 con |= pdata->noise_cancel_mode <<
>>>> EXYNOS_TMU_TRIP_MODE_SHIFT;
>>>>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>>>> +               if (pdata->trigger_levels[3])
>>>> +                       con |= EXYNOS_TMU_TRIP_EN;
>>>>         }
>> Why don't you support trigger_level[3] in exynos4210 either? Even though
>> 4210 doesn't support
>> hardware tripping,
>> I think it can be set in same way. I've done it in my local git with
>> following codes.
>>
> 
> As follows, TRIP_EN is applied SOC_ARCH_EXYNOS(for exynos4412 & exynos5250).  (SOC_ARCH_EXYNOS4210 for exynos4210)
> 
>         if (data->soc == SOC_ARCH_EXYNOS) {
>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>                 con |= pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT;
>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>                 if (pdata->trigger_levels[3])
>                         con |= EXYNOS_TMU_TRIP_EN;
>         }
> And. Trigger_level3_en is not stored in INTEN(only level0~level2en)
> 
> Especially when temperature exceeds a extremely high threshold temperature
> denoted as THRES_LEVEL_RISE3 field of THRESHOLD_TEMP_RISE register, then
> Exynos5250 should not be damaged by the hot temperature. In this case, TMU
> urgently sends active-high signal (THERM_TRIP) to PMU, and thermal tripping
> by hardware logic i.e PMU (Power Management Unit) is performed. (From TMU document.) 
> 
> Trigger_leves[3] is only used for THERM_TRIP. Trigger_levels3_en doesn't  effect h/w tripping mode.
> So i think trigger_levels[3] is better than trigger_level3_en.
> 
> Thanks~~^^
> 

I think you misunderstood what I purposed to. I meant that it's better to support 3rd trigger level
in exynos4210 either in this modification. As you can see, there isn't supporting of 3rd trigger
level for all SOCs until this moment, and now your code will do this but only for 4x12 and 5250.
I know that differences between thermal trip and lower trigger level interrupts. However,
To satisfy the compatibility, we have to offer same interface regardless of SOC's type.
Maybe 'interface' is not proper word for this situation, anyway what I want to tell you is that it
is proper way to use platform data in same way whatever SOC's type is. So, with my former suggestion,
it can use 3rd thermal trigger level in both SOC group. And it will activate as THERMAL TRIP in
exynos4x12,5250 and as just 3rd Trigger levels in exynos4210. I do not just emphasize the use of
Trigger_level3_en, but I recommend you to support 3rd trigger level in exynos4210 either.

Thanks,
Jonghwa.

> 
> 
>> -----Original Message-----
>> From: jonghwa3.lee@samsung.com [mailto:jonghwa3.lee@samsung.com]
>> Sent: Wednesday, November 21, 2012 1:02 PM
>> To: Kyungmin Park
>> Cc: Jonghwan Choi; jonghwa3.lee; open list; Amit Daniel Kachhap; Zhang Rui;
>> Sachin Kamat
>> Subject: Re: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
>>
>> Hi,
>> On 2012년 11월 20일 10:40, Kyungmin Park wrote:
>>> On 11/20/12, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
>>>> TMU urgently sends active-high signal (thermal trip) to PMU,
>>>> and thermal tripping by hardware logic i.e PMU is performed.
>>>> Thermal tripping means that PMU cut off the whole power of SoC
>>>> by controlling external voltage regulator.
>>>>
>>>> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
>>> Ackedy-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  drivers/thermal/exynos_thermal.c |   10 ++++++++++
>>>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/thermal/exynos_thermal.c
>>>> b/drivers/thermal/exynos_thermal.c
>>>> index 129e827..569478d 100644
>>>> --- a/drivers/thermal/exynos_thermal.c
>>>> +++ b/drivers/thermal/exynos_thermal.c
>>>> @@ -58,6 +58,7 @@
>>>>  #define EXYNOS_TMU_CORE_ON             BIT(0)
>>>>  #define EXYNOS_TMU_CORE_ON_SHIFT       0
>>>>  #define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
>>>> EXYNOS_TMU_CORE_ON_SHIFT)
>>>> +#define EXYNOS_TMU_TRIP_EN             BIT(12)
>>>>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
>>>>
>>>>  /* Exynos4210 specific registers */
>>>> @@ -631,6 +632,12 @@ static int exynos_tmu_initialize(struct
>>>> platform_device
>>>> *pdev)
>>>>                         goto out;
>>>>                 }
>>>>                 rising_threshold |= (threshold_code << 16);
>>>> +               threshold_code = temp_to_code(data,
>>>> pdata->trigger_levels[3]);
>>>> +               if (threshold_code < 0) {
>>>> +                       ret = threshold_code;
>>>> +                       goto out;
>>>> +               }
>>>> +               rising_threshold |= (threshold_code << 24);
>>>>
>>>>                 writel(rising_threshold,
>>>>                                 data->base + EXYNOS_THD_TEMP_RISE);
>>>> @@ -665,6 +672,8 @@ static void exynos_tmu_control(struct
>> platform_device
>>>> *pdev, bool on)
>>>>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>>>>                 con |= pdata->noise_cancel_mode <<
>>>> EXYNOS_TMU_TRIP_MODE_SHIFT;
>>>>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>>>> +               if (pdata->trigger_levels[3])
>>>> +                       con |= EXYNOS_TMU_TRIP_EN;
>>>>         }
>> Why don't you support trigger_level[3] in exynos4210 either? Even though
>> 4210 doesn't support
>> hardware tripping,
>> I think it can be set in same way. I've done it in my local git with
>> following codes.
>>
>> if (data->soc == SOC_ARCH_EXYNOS4210)
>> interrupt_en |= pdata->trigger_level3_en << 12;
>> else
>> con |= pdata->trigger_level3_en <<12;
>>
>> How do you think of it?
>>
>> Thanks.
>>>>         if (on) {
>>>> @@ -770,6 +779,7 @@ static struct exynos_tmu_platform_data const
>>>> exynos_default_tmu_data = {
>>>>         .trigger_levels[0] = 85,
>>>>         .trigger_levels[1] = 103,
>>>>         .trigger_levels[2] = 110,
>>>> +       .trigger_levels[3] = 120,
>>>>         .trigger_level0_en = 1,
>>>>         .trigger_level1_en = 1,
>>>>         .trigger_level2_en = 1,
>>>> --
>>>> 1.7.4.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
> 
> 
