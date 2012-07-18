Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2GRFL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:11:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9589 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2GRFLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:11:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f566d000005c8a-c5-50064595f698
Message-id: <50064593.1000302@samsung.com>
Date: Wed, 18 Jul 2012 14:11:47 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: amit kachhap <amit.kachhap@gmail.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-pm@lists.linux-foundation.org,
        akpm@linux-foundation.org, lenb@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        SangWook Ju <sw.ju@samsung.com>, Durgadoss <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5 5/5] ARM: exynos: add thermal sensor driver platform
 data support
References: <1342177825-19006-1-git-send-email-amit.kachhap@linaro.org>
 <1342177825-19006-6-git-send-email-amit.kachhap@linaro.org>
 <CAH9JG2XGWgX-FiBacnrGXS-oG_7rbN1aum3mpW5HUAukiwaB7A@mail.gmail.com>
 <CADGdYn6SPTosESY5YXa=Q0PoHTiW28VYgSJuZODj0tj0kU_y=g@mail.gmail.com>
In-reply-to: <CADGdYn6SPTosESY5YXa=Q0PoHTiW28VYgSJuZODj0tj0kU_y=g@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd2prmwBBnvuCVks39fPaHF51xw2
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlXFivVtBh03FmZZNzA2MU3W6GDk5JARMJGZv
	+csKYYtJXLi3ng3EFhJYxCix7ws/iM0rICjxY/I9li5GDg5mAXmJI5eyQcLMAuoSk+YtYu5i
	5AIqf8kocWvbVxaIei2JP+uPgs1hEVCVaF3/mBnEZhOQk3jb9I0RZI6oQITEr34OkLCIgKZE
	w7YFTCBzmAUeMEmse7UZbI6wQJTElvUP2CAWTGaSOHbuKjtIglMgWGL6j0amCYwCs5DcNwvh
	vllI7lvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzggn0nvYFzVYHGIUYCDUYmH94IT
	W4AQa2JZcWXuIUYJDmYlEV7B56wBQrwpiZVVqUX58UWlOanFhxilOViUxHlNvL/6CwmkJ5ak
	ZqemFqQWwWSZODilGhgzSoX+z96lI/vYeteDK+s4j/8KPpI3w+icwjOJP++mzvtx8+yitWWy
	qacVzzL89P6Z+ZBpswvnlvqTkU7TkyV5vbdfr5w/LyBsl/OBdxp1Qleu6fHemZ3vdeGotI7h
	SiWp6D+v3I8uW8mdVaGxh/fOpsVrphT88ew7071ra/H2IpEyoypeD7XZSizFGYmGWsxFxYkA
	wSdSx0QCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Amit,
On 2012년 07월 14일 16:30, amit kachhap wrote:
> On Sat, Jul 14, 2012 at 7:03 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On Fri, Jul 13, 2012 at 8:10 PM, Amit Daniel Kachhap
>> <amit.kachhap@linaro.org> wrote:
>>> Add necessary default platform data support needed for TMU driver.  This
>>> dt/non-dt values are tested for origen exynos4210 and smdk exynos5250
>>> platforms.
>> Looks good to me.
> Thanks.
>
>> just nitpicks below.
>>
>> Thank you,
>> Kyungmin Park
>>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>>> Cc: Donggeun Kim <dg77.kim@samsung.com>
>>> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
>>> Cc: SangWook Ju <sw.ju@samsung.com>
>>> Cc: Durgadoss <durgadoss.r@intel.com>
>>> Cc: Len Brown <lenb@kernel.org>
>>> Cc: Jean Delvare <khali@linux-fr.org>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>>  drivers/thermal/exynos_thermal.c |  111 +++++++++++++++++++++++++++++++++++++-
>>>  1 files changed, 110 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
>>> index 9ef8c37..07736ea 100644
>>> --- a/drivers/thermal/exynos_thermal.c
>>> +++ b/drivers/thermal/exynos_thermal.c
>>> @@ -662,14 +662,121 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
>>>  static struct thermal_sensor_conf exynos_sensor_conf = {
>>>         .name                   = "exynos-therm",
>>>         .read_temperature       = (int (*)(void *))exynos_tmu_read,
>>> +};
>>> +
>>> +#if defined(CONFIG_CPU_EXYNOS4210)
>> BTW, doesn't it same as exynos4412? does it different from exynos4412?
> Currently I only tested this only for origen and exynos5250 board.
> Maybe somebody can add 4412 support also.
Recently, I applied this patchset with exynos4412 and found it uses same
register map with exynos5250.
So, I think it should rename the any type of name containing exynos4 and
exynos5 (e.g. SOC_ARCH_EXYNOS4)
In my local, i renamed SOC_ARCH_EXYNOS4 to SOC_ARCH_EXYNOS4210 and
SOC_ARCH_EXYNOS5 to SOC_ARCH_EXYNOS and
other related name also. I recommend you to change all of name
>> If it's same, it's better to use CONFIG_SOC_EXYNOS4?
>>> +static struct exynos_tmu_platform_data const exynos4_default_tmu_data = {
>>> +       .threshold = 80,
>>> +       .trigger_levels[0] = 5,
>>> +       .trigger_levels[1] = 20,
>>> +       .trigger_levels[2] = 30,
>>> +       .trigger_level0_en = 1,
>>> +       .trigger_level1_en = 1,
>>> +       .trigger_level2_en = 1,
>>> +       .trigger_level3_en = 0,
>>> +       .gain = 15,
>>> +       .reference_voltage = 7,
>>> +       .cal_type = TYPE_ONE_POINT_TRIMMING,
>>> +       .freq_tab[0] = {
>>> +               .freq_clip_max = 800 * 1000,
>>> +               .temp_level = 85,
>>> +       },
>>> +       .freq_tab[1] = {
>>> +               .freq_clip_max = 200 * 1000,
>>> +               .temp_level = 100,
>>> +       },
>>> +       .freq_tab_count = 2,
>>> +       .type = SOC_ARCH_EXYNOS4,
>>> +};
>>> +#define EXYNOS4_TMU_DRV_DATA (&exynos4_default_tmu_data)
>>> +#else
>>> +#define EXYNOS4_TMU_DRV_DATA (NULL)
>>> +#endif
>>> +
>>> +#if defined(CONFIG_SOC_EXYNOS5250)
>> similar.
>>> +static struct exynos_tmu_platform_data const exynos5_default_tmu_data = {
>>> +       .trigger_levels[0] = 85,
>>> +       .trigger_levels[1] = 103,
>>> +       .trigger_levels[2] = 110,
>>> +       .trigger_level0_en = 1,
>>> +       .trigger_level1_en = 1,
>>> +       .trigger_level2_en = 1,
>>> +       .trigger_level3_en = 0,
>>> +       .gain = 8,
>>> +       .reference_voltage = 16,
>>> +       .noise_cancel_mode = 4,
>>> +       .cal_type = TYPE_ONE_POINT_TRIMMING,
>>> +       .efuse_value = 55,
>>> +       .freq_tab[0] = {
>>> +               .freq_clip_max = 800 * 1000,
>>> +               .temp_level = 85,
>>> +       },
>>> +       .freq_tab[1] = {
>>> +               .freq_clip_max = 200 * 1000,
>>> +               .temp_level = 103,
>>> +       },
>>> +       .freq_tab_count = 2,
>>> +       .type = SOC_ARCH_EXYNOS5,
>>> +};
>>> +#define EXYNOS5_TMU_DRV_DATA (&exynos5_default_tmu_data)
>>> +#else
>>> +#define EXYNOS5_TMU_DRV_DATA (NULL)
>>> +#endif
>>> +
>>> +#ifdef CONFIG_OF
>>> +static const struct of_device_id exynos_tmu_match[] = {
>>> +       {
>>> +               .compatible = "samsung,exynos4-tmu",
>>> +               .data = (void *)EXYNOS4_TMU_DRV_DATA,
>>> +       },
>>> +       {
>>> +               .compatible = "samsung,exynos5-tmu",
>>> +               .data = (void *)EXYNOS5_TMU_DRV_DATA,
>>> +       },
>>> +       {},
>>> +};
>>> +MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>>> +#else
>>> +#define  exynos_tmu_match NULL
>>> +#endif
>>> +
>>> +static struct platform_device_id exynos_tmu_driver_ids[] = {
>>> +       {
>>> +               .name           = "exynos4-tmu",
>>> +               .driver_data    = (kernel_ulong_t)EXYNOS4_TMU_DRV_DATA,
>>> +       },
>>> +       {
>>> +               .name           = "exynos5-tmu",
>>> +               .driver_data    = (kernel_ulong_t)EXYNOS5_TMU_DRV_DATA,
>>> +       },
>>> +       { },
>>> +};
>>> +MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
>>> +
>>> +static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>>> +                       struct platform_device *pdev)
>>> +{
>>> +#ifdef CONFIG_OF
>>> +       if (pdev->dev.of_node) {
>>> +               const struct of_device_id *match;
>>> +               match = of_match_node(exynos_tmu_match, pdev->dev.of_node);
>>> +               if (!match)
>>> +                       return NULL;
>>> +               return (struct exynos_tmu_platform_data *) match->data;
>>> +       }
>>> +#endif
>>> +       return (struct exynos_tmu_platform_data *)
>>> +                       platform_get_device_id(pdev)->driver_data;
>>>  }
>>> -;
>>>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>>>  {
>>>         struct exynos_tmu_data *data;
>>>         struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
>>>         int ret, i;
>>>
>>> +       if (!pdata)
>>> +               pdata = exynos_get_driver_data(pdev);
>>> +
>>>         if (!pdata) {
>>>                 dev_err(&pdev->dev, "No platform init data supplied.\n");
>>>                 return -ENODEV;
>>> @@ -838,9 +945,11 @@ static struct platform_driver exynos_tmu_driver = {
>>>                 .name   = "exynos-tmu",
>>>                 .owner  = THIS_MODULE,
>>>                 .pm     = EXYNOS_TMU_PM,
>>> +               .of_match_table = exynos_tmu_match,
>>>         },
>>>         .probe = exynos_tmu_probe,
>>>         .remove = __devexit_p(exynos_tmu_remove),
>>> +       .id_table = exynos_tmu_driver_ids,
>>>  };
>>>
>>>  module_platform_driver(exynos_tmu_driver);
>>> --
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Thanks.

