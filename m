Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2KUCTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:19:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37856 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2KUCTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:19:22 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-d0-50ac3a27efb8
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <50AC3A26.6070602@samsung.com>
Date: Wed, 21 Nov 2012 11:19:18 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Kachhap <amit.kachhap@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
References: <1351823091-2540-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAK44p22c_KjyGdKqrXmXNgzTPws_rR8mr-SWqJVzVgEaTbZwYg@mail.gmail.com>
 <1353463228.2153.3.camel@rzhang1-mobl4>
In-reply-to: <1353463228.2153.3.camel@rzhang1-mobl4>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zbV11qzUBBo82G1pc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ2fprIXrA6smLaZ5EGxncOXYycHBICJhLPNh5ih7DF
	JC7cW8/WxcjFISSwjFHi7dtrTDBFT9bfZIdITGeUOLH0FViCV0BQ4sfkeywgNrOAusSkeYuY
	IWxRieZX05kgbG2JZQtfM0M0v2SUWPxxKlSzlkTLo1esIDaLgKrEyRMXweJsAnISb5u+MXYx
	cnCICkRI/OrnAAmLCChLLDq3lRFkDrPARSaJY8f/soDUCAvESnyYIg8xfwejxPRl28AO4gS6
	+urhxYwQ8wUkvk0+BFYvISArsekA2D0SApPZJQ5+X8MI8aWkxMEVN1gmMIrPQvLbLCS/zULy
	2ywkvy1gZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERJNUjsYVzZYHGIU4GBU4uHduHZ1
	gBBrYllxZe4hRgkOZiURXgb5NQFCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M9LySeENj
	A2NDQ0tDM1NLUwMcwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGPlTsp9KxV6farPk2JdH
	gV85l6SWGdd49Kxnurxz27wnuxJcZ25f8+LTluCyAiFVJ+vj3nm3V9VrzUwzqJ/a+znR+k7i
	ysvXX/rY2s3M2CLzX15z7cGryt/jos5e3xP09pXp4/WPBIXllq96bbDlEofd8RPBm+p5Op9q
	zN5y5uzdT3NDbZQzK/YosRRnJBpqMRcVJwIA2pkTktMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV11qzUBBjt6VSwu75rDZvG59wij
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZa8+fYS44HlGx
	+8oj9gbGLocuRk4OCQETiSfrb7JD2GISF+6tZ+ti5OIQEpjOKHFi6SsmkASvgKDEj8n3WLoY
	OTiYBeQljlzKBgkzC6hLTJq3iBmi/iWjxOKPU6HqtSRaHr1iBbFZBFQlTp64CBZnE5CTeNv0
	jRFkjqhAhMSvfg6QsIiAssSic1sZQeYwC1xkkjh2/C/YLmGBWIkPU+Qh5u9glJi+bBsLSAMn
	0NFXDy9mnMAoMAvJebMQzpuF5LwFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj75nU
	DsaVDRaHGAU4GJV4eDeuXR0gxJpYVlyZe4hRgoNZSYSXQX5NgBBvSmJlVWpRfnxRaU5q8SFG
	H6DnJjJLiSbnA5NCXkm8obGJmZGlkZmxibmxMQ5hJXHeZo+UACGB9MSS1OzU1ILUIphxTByc
	Ug2MOtcqdZRn9RjLLuP6Z825/zvL4emMsrse33Vb7XWPebnXFubXAsn79GyY1jMXLpl68rn1
	31rhKxNWKqy51FosEbOO3VndlvXJK9v+sMVPz9vzayb7BhQ8OPB8/rMpfS5L1NSsHPYmJV1Z
	UhW0Tvlm8uYPJ/KShC6LfD3ycdHdtOAu+1OCOu9fKrEUZyQaajEXFScCAHipLCzpAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 11월 21일 11:00, Zhang Rui wrote:
> On Thu, 2012-11-08 at 14:54 +0530, Amit Kachhap wrote:
>> Hi Jonghwa Lee,
>>
>> I tested this patch and it looks good. I have some minor comments below,
>>
>> Reviewed-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>>
> Hi, Lee,
>
> I suppose there should be an updated version being sent out soon, right?
>
> Thanks,
> rui
Hi, Rui,

Yes, there is. I'll re-post it as soon.

Thanks.
>> Thanks,
>> Amit Daniel
>> On 2 November 2012 07:54, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>>> This patch supports exynos's emulation mode with newly created sysfs node.
>>> Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
>>> management unit. Thermal emulation mode supports software debug for TMU's
>>> operation. User can set temperature manually with software code and TMU
>>> will read current temperature from user value not from sensor's value.
>>> This patch includes also documentary placed under Documentation/thermal/.
>>>
>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> ---
>>> v4
>>>  - Fix Typo.
>>>  - Remove unnecessary codes.
>>>  - Add comments about feature of exynos emulation operation to the document.
>>>
>>> v3
>>>  - Remove unnecessay variables.
>>>  - Do some code clean in exynos_tmu_emulation_store().
>>>  - Make wrapping function of sysfs node creation function to use
>>>    #ifdefs in minimum.
>>>
>>> v2
>>>  exynos_thermal.c
>>>  - Fix build error occured by wrong emulation control register name.
>>>  - Remove exynos5410 dependent codes.
>>>  exynos_thermal_emulation
>>>  - Align indentation.
>>>
>>>  Documentation/thermal/exynos_thermal_emulation |   56 +++++++++++++++
>>>  drivers/thermal/Kconfig                        |    9 +++
>>>  drivers/thermal/exynos_thermal.c               |   91 ++++++++++++++++++++++++
>>>  3 files changed, 156 insertions(+), 0 deletions(-)
>>>  create mode 100644 Documentation/thermal/exynos_thermal_emulation
>>>
>>> diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
>>> new file mode 100644
>>> index 0000000..a6ea06f
>>> --- /dev/null
>>> +++ b/Documentation/thermal/exynos_thermal_emulation
>>> @@ -0,0 +1,56 @@
>>> +EXYNOS EMULATION MODE
>>> +========================
>>> +
>>> +Copyright (C) 2012 Samsung Electronics
>>> +
>>> +Written by Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> +
>>> +Description
>>> +-----------
>>> +
>>> +Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal management unit.
>>> +Thermal emulation mode supports software debug for TMU's operation. User can set temperature
>>> +manually with software code and TMU will read current temperature from user value not from
>>> +sensor's value.
>>> +
>>> +Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
>>> +When it's enabled, sysfs node will be created under
>>> +/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
>>> +
>>> +The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
>>> +temperature you want to update to sysfs node, it automatically enable emulation mode and
>>> +current temperature will be changed into it.
>>> +(Exynos also supports user changable delay time which would be used to delay of
>>> + changing temperature. However, this node only uses same delay of real sensing time, 938us.)
>>> +
>>> +Exynos emulation mode requires synchronous of value changing and enabling. It means when you
>>> +want to update the any value of delay or next temperature, then you have to enable emulation
>>> +mode at the same time. (Or you have to keep the mode enabling.) If you don't, it fails to
>>> +change the value to updated one and just use last succeessful value repeatedly. That's why
>>> +this node gives users the right to change termerpature only. Just one interface makes it more
>>> +simply to use.
>>> +
>>> +Disabling emulation mode only requires writing value 0 to sysfs node.
>>> +
>>> +
>>> +TEMP   120 |
>>> +           |
>>> +       100 |
>>> +           |
>>> +        80 |
>>> +           |                            +-----------
>>> +        60 |                            |          |
>>> +           |              +-------------|          |
>>> +        40 |              |             |          |
>>> +           |              |             |          |
>>> +        20 |              |             |          +----------
>>> +           |              |             |          |          |
>>> +         0 |______________|_____________|__________|__________|_________
>>> +                  A             A          A                  A     TIME
>>> +                  |<----->|     |<----->|  |<----->|          |
>>> +                  | 938us |     |       |  |       |          |
>>> +emulation    :  0  50     |     70      |  20      |          0
>>> +current temp :   sensor   50            70         20        sensor
>>> +
>>> +
>>> +
>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>> index e1cb6bd..c02a66c 100644
>>> --- a/drivers/thermal/Kconfig
>>> +++ b/drivers/thermal/Kconfig
>>> @@ -55,3 +55,12 @@ config EXYNOS_THERMAL
>>>         help
>>>           If you say yes here you get support for TMU (Thermal Managment
>>>           Unit) on SAMSUNG EXYNOS series of SoC.
>>> +
>>> +config EXYNOS_THERMAL_EMUL
>>> +       bool "EXYNOS TMU emulation mode support"
>>> +       depends on !CPU_EXYNOS4210 && EXYNOS_THERMAL
>> Instead of using CPU_EXYNOS4210 here it is better to use data->soc ==
>> SOC_ARCH_EXYNOS4210 inside the emulation show/store functions.
>>> +       help
>>> +         Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
>>> +         Enable this option will be make sysfs node in exynos thermal platform
>>> +         device directory to support emulation mode. With emulation mode sysfs
>>> +         node, you can manually input temperature to TMU for simulation purpose.
>>> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
>>> index fd03e85..eebd4e5 100644
>>> --- a/drivers/thermal/exynos_thermal.c
>>> +++ b/drivers/thermal/exynos_thermal.c
>>> @@ -99,6 +99,14 @@
>>>  #define IDLE_INTERVAL 10000
>>>  #define MCELSIUS       1000
>>>
>>> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
>>> +#define EXYNOS_EMUL_TIME       0x57F0
>>> +#define EXYNOS_EMUL_TIME_SHIFT 16
>>> +#define EXYNOS_EMUL_DATA_SHIFT 8
>>> +#define EXYNOS_EMUL_DATA_MASK  0xFF
>>> +#define EXYNOS_EMUL_ENABLE     0x1
>>> +#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
>>> +
>>>  /* CPU Zone information */
>>>  #define PANIC_ZONE      4
>>>  #define WARN_ZONE       3
>>> @@ -832,6 +840,82 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>>>         return (struct exynos_tmu_platform_data *)
>>>                         platform_get_device_id(pdev)->driver_data;
>>>  }
>>> +
>>> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
>>> +static ssize_t exynos_tmu_emulation_show(struct device *dev,
>>> +                                        struct device_attribute *attr,
>>> +                                        char *buf)
>>> +{
>>> +       struct platform_device *pdev = container_of(dev,
>>> +                                       struct platform_device, dev);
>>> +       struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>>> +       unsigned int reg;
>>> +       u8 temp_code;
>>> +       int temp = 0;
>>> +
>>> +       mutex_lock(&data->lock);
>>> +       clk_enable(data->clk);
>>> +       reg = readl(data->base + EXYNOS_EMUL_CON);
>>> +       clk_disable(data->clk);
>>> +       mutex_unlock(&data->lock);
>>> +
>>> +       if (reg & EXYNOS_EMUL_ENABLE) {
>>> +               reg >>= EXYNOS_EMUL_DATA_SHIFT;
>>> +               temp_code = reg & EXYNOS_EMUL_DATA_MASK;
>>> +               temp = code_to_temp(data, temp_code);
>>> +       }
>>> +
>>> +       return sprintf(buf, "%d\n", temp);
>> Currently in  /sys/devices/virtual/thermal/thermal_zone0/ all
>> temperatures are shown in millicelsius so it is better show this in
>> millicelsius also.
>>> +}
>>> +
>>> +static ssize_t exynos_tmu_emulation_store(struct device *dev,
>>> +                                       struct device_attribute *attr,
>>> +                                       const char *buf, size_t count)
>>> +{
>>> +       struct platform_device *pdev = container_of(dev,
>>> +                                       struct platform_device, dev);
>>> +       struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>>> +       unsigned int reg;
>>> +       int temp;
>>> +
>>> +       if (!sscanf(buf, "%d\n", &temp) || temp < 0)
>>> +               return -EINVAL;
>>> +
>>> +       mutex_lock(&data->lock);
>>> +       clk_enable(data->clk);
>>> +
>>> +       reg = readl(data->base + EXYNOS_EMUL_CON);
>>> +
>>> +       if (temp)
>>> +               reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
>>> +                       (temp_to_code(data, temp) << EXYNOS_EMUL_DATA_SHIFT) |
>> Same as above.
>>> +                       EXYNOS_EMUL_ENABLE;
>>> +       else
>>> +               reg &= ~EXYNOS_EMUL_ENABLE;
>>> +
>>> +       writel(reg, data->base + EXYNOS_EMUL_CON);
>>> +
>>> +       clk_disable(data->clk);
>>> +       mutex_unlock(&data->lock);
>>> +
>>> +       return count;
>>> +}
>>> +
>>> +static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
>>> +                                       exynos_tmu_emulation_store);
>>> +static int create_emulation_sysfs(struct device *dev)
>>> +{
>>> +       return device_create_file(dev, &dev_attr_emulation);
>>> +}
>>> +static void remove_emulation_sysfs(struct device *dev)
>>> +{
>>> +       device_remove_file(dev, &dev_attr_emulation);
>>> +}
>>> +#else
>>> +static inline int create_emulation_sysfs(struct device *dev) {return 0;}
>>> +static inline void remove_emulation_sysfs(struct device *dev){}
>>> +#endif
>>> +
>>>  static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>>>  {
>>>         struct exynos_tmu_data *data;
>>> @@ -930,6 +1014,11 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
>>>                 dev_err(&pdev->dev, "Failed to register thermal interface\n");
>>>                 goto err_clk;
>>>         }
>>> +
>>> +       ret = create_emulation_sysfs(&pdev->dev);
>>> +       if (ret)
>>> +               dev_err(&pdev->dev, "Failed to create emulation mode sysfs node\n");
>>> +
>>>         return 0;
>>>  err_clk:
>>>         platform_set_drvdata(pdev, NULL);
>>> @@ -941,6 +1030,8 @@ static int __devexit exynos_tmu_remove(struct platform_device *pdev)
>>>  {
>>>         struct exynos_tmu_data *data = platform_get_drvdata(pdev);
>>>
>>> +       remove_emulation_sysfs(&pdev->dev);
>>> +
>>>         exynos_tmu_control(pdev, false);
>>>
>>>         exynos_unregister_thermal();
>>> --
>>> 1.7.4.1
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

