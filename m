Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab1IZErk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 00:47:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42604 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1IZEri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 00:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E7FE0A4.4050105@cn.fujitsu.com>
References: <5525949.50001316849744994.JavaMail.weblogic@epml24>
	<20110924093851.GB17169@n2100.arm.linux.org.uk>
	<CAHQjnOPMRQetGF5VnwsMD=_JxWC5C-LQ5WRyZhPs2HtCzis2Tg@mail.gmail.com>
	<4E7FE0A4.4050105@cn.fujitsu.com>
Date: Mon, 26 Sep 2011 13:47:37 +0900
X-Google-Sender-Auth: Yz1QZtInVORKidIQI5lYop0WYJ4
Message-ID: <CAHQjnOMAdkf6FUcVsr74zWM9Vij-5nduZWK+pa2MQC8KJUjRtw@mail.gmail.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: gaowanlong@cn.fujitsu.com
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>,
        =?UTF-8?B?7J207IOB7ZiE?= <sanghyun75.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I will try.

Regards,
Cho KyongHo.

On Mon, Sep 26, 2011 at 11:17 AM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> On 09/26/2011 08:44 AM, KyongHo Cho wrote:
>
>> Hi.
>>
>> On Sat, Sep 24, 2011 at 6:38 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>>> On Sat, Sep 24, 2011 at 07:35:45AM +0000, 조경호 wrote:
>>>> +# EXYNOS IOMMU support
>>>> +config EXYNOS_IOMMU
>>>> + bool "Exynos IOMMU Support"
>>>> + depends on ARCH_EXYNOS4
>>>> + select IOMMU_API
>>>> + select EXYNOS4_DEV_SYSMMU
>>>> + help
>>>
>>> Looks like your mailer converted tabs to one space.  This makes it more
>>> difficult to read this patch as a whole.  Don't expect good reviews as
>>> long as your mailer breaks stuff in this way.
>> Sorry for that :(
>> I will try another way to send patches correctly.
>
>
> Use *git send-email* instead.
>
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
