Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2KUEC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:02:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36373 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KUEC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:02:27 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f616d00000319b-04-50ac52511e76
Message-id: <50AC5250.3070203@samsung.com>
Date: Wed, 21 Nov 2012 13:02:24 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Kyungmin Park <kmpark@infradead.org>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        "jonghwa3.lee" <jonghwa3.lee@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v3 2/2] therma: exynos: Supports thermal tripping
References: <007401cdc6ba$0742d6d0$15c88470$%choi@samsung.com>
 <CAH9JG2VKYSAQ=Og4-fgToV_aNwEV_aH-=UQZDbAOnA-ShfKdYw@mail.gmail.com>
In-reply-to: <CAH9JG2VKYSAQ=Og4-fgToV_aNwEV_aH-=UQZDbAOnA-ShfKdYw@mail.gmail.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t8zLd3AoDUBBl1PlS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG+dfL2Qv6ZSrmzYtoYHwl0sXIySEhYCJxsHk2C4QtJnHh3nq2
	LkYuDiGBZYwSJ/81ssEUffh2lRkisYhR4tTyC2AJXgFBiR+T7wF1c3AwC8hLHLmUDRJmFlCX
	mDRvEVR9F5NE08Kr7BD1WhJfGuaA9bIIqEpM2v2bGcRmE5CTeNv0jRFkjqhAhMSvfg6QsIiA
	hsTlXYfA5jALNDBJrGl6BXapsICrxO6pH1kgFrQySkxv3cYKkuAUCJZYsPodM8QCAYlvkw+B
	HSchICux6QDYIAmBbnaJGWtfQX0mKXFwxQ2WCYxis5D8Mwvhn1lI/lnAyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIyQipHcwrmqwOMQowMGoxMMrsW91gBBrYllxZe4hRgkOZiURXgb5
	NQFCvCmJlVWpRfnxRaU5qcWHGH2Ajp3ILCWanA+M1rySeENjA2NDQ0tDM1NLUwMcwkrivM0e
	KQFCAumJJanZqakFqUUw45g4OKUaGBOSP9b3/Ndsdfwzv9ncTGjGyb0Vggf51pR+/tTz06Z3
	xhf5Za8/zWAyNGYQdm9cp3+SdVO82VHfm6KbZqru/vs788q9zH3XlvRcFI+sfOqSzdPmefra
	+hVOJ1IMbVfKuobOyJipwPK8NCr9VWfGFU//Bw81Mz+Ef5Xx+2rN9GFWhc5GPYHARCWW4oxE
	Qy3mouJEANsqZOe1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd3AoDUBBts2S1pc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjPOvl7MX9MtUzJsX0cD4
	SqSLkZNDQsBE4sO3q8wQtpjEhXvr2boYuTiEBBYxSpxafoENJMErICjxY/I9li5GDg5mAXmJ
	I5eyQcLMAuoSk+YtYoao72KSaFp4lR2iXkviS8McsF4WAVWJSbt/gy1gE5CTeNv0jRFkjqhA
	hMSvfg6QsIiAhsTlXYfA5jALNDBJrGl6xQKSEBZwldg99SMLxIJWRonprdtYQRKcAsESC1a/
	Y57AKDALyX2zEO6bheS+BYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC4+2Z9A7GVQ0W
	hxgFOBiVeHgl9q0OEGJNLCuuzD3EKMHBrCTCyyC/JkCINyWxsiq1KD++qDQntfgQow/QdxOZ
	pUST84GpIK8k3tDYxMzI0sjM2MTc2BiHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGxn7f
	hnyH78LVCwxMl50TOenxpML+5Z4nvmv2fAiu+ig3Ze2KdoaH/SqRy9ycvr+9lrYh43r7lCr7
	mxtXR+9yEDv+4dn6hRe5ee9PyDEJUE3zNfJVMGk2Ldderd2cf+9X6GHJT0u113rESr3rlUx8
	9pPhw9vcy6v/GspNTnvm4OCtPltpjRgfvxJLcUaioRZzUXEiAE67UfnkAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On 2012년 11월 20일 10:40, Kyungmin Park wrote:
> On 11/20/12, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
>> TMU urgently sends active-high signal (thermal trip) to PMU,
>> and thermal tripping by hardware logic i.e PMU is performed.
>> Thermal tripping means that PMU cut off the whole power of SoC
>> by controlling external voltage regulator.
>>
>> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> Ackedy-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/thermal/exynos_thermal.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/thermal/exynos_thermal.c
>> b/drivers/thermal/exynos_thermal.c
>> index 129e827..569478d 100644
>> --- a/drivers/thermal/exynos_thermal.c
>> +++ b/drivers/thermal/exynos_thermal.c
>> @@ -58,6 +58,7 @@
>>  #define EXYNOS_TMU_CORE_ON             BIT(0)
>>  #define EXYNOS_TMU_CORE_ON_SHIFT       0
>>  #define EXYNOS_TMU_CORE_ON_MASK                (0x1 <<
>> EXYNOS_TMU_CORE_ON_SHIFT)
>> +#define EXYNOS_TMU_TRIP_EN             BIT(12)
>>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET     50
>>
>>  /* Exynos4210 specific registers */
>> @@ -631,6 +632,12 @@ static int exynos_tmu_initialize(struct
>> platform_device
>> *pdev)
>>                         goto out;
>>                 }
>>                 rising_threshold |= (threshold_code << 16);
>> +               threshold_code = temp_to_code(data,
>> pdata->trigger_levels[3]);
>> +               if (threshold_code < 0) {
>> +                       ret = threshold_code;
>> +                       goto out;
>> +               }
>> +               rising_threshold |= (threshold_code << 24);
>>
>>                 writel(rising_threshold,
>>                                 data->base + EXYNOS_THD_TEMP_RISE);
>> @@ -665,6 +672,8 @@ static void exynos_tmu_control(struct platform_device
>> *pdev, bool on)
>>                 con &= ~(EXYNOS_TMU_TRIP_MODE_MASK | EXYNOS_MUX_ADDR_MASK);
>>                 con |= pdata->noise_cancel_mode <<
>> EXYNOS_TMU_TRIP_MODE_SHIFT;
>>                 con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>> +               if (pdata->trigger_levels[3])
>> +                       con |= EXYNOS_TMU_TRIP_EN;
>>         }
Why don't you support trigger_level[3] in exynos4210 either? Even though 4210 doesn't support
hardware tripping,
I think it can be set in same way. I've done it in my local git with following codes.

if (data->soc == SOC_ARCH_EXYNOS4210)
interrupt_en |= pdata->trigger_level3_en << 12;
else
con |= pdata->trigger_level3_en <<12;

How do you think of it?

Thanks.
>>         if (on) {
>> @@ -770,6 +779,7 @@ static struct exynos_tmu_platform_data const
>> exynos_default_tmu_data = {
>>         .trigger_levels[0] = 85,
>>         .trigger_levels[1] = 103,
>>         .trigger_levels[2] = 110,
>> +       .trigger_levels[3] = 120,
>>         .trigger_level0_en = 1,
>>         .trigger_level1_en = 1,
>>         .trigger_level2_en = 1,
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

