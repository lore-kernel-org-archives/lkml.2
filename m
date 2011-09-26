Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab1IZCSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 22:18:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62637 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab1IZCS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 22:18:29 -0400
Message-ID: <4E7FE0A4.4050105@cn.fujitsu.com>
Date: Mon, 26 Sep 2011 10:17:08 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: KyongHo Cho <pullip.cho@samsung.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
        =?UTF-8?B?7J207IOB?= =?UTF-8?B?7ZiE?= 
	<sanghyun75.lee@samsung.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
References: <5525949.50001316849744994.JavaMail.weblogic@epml24>	<20110924093851.GB17169@n2100.arm.linux.org.uk> <CAHQjnOPMRQetGF5VnwsMD=_JxWC5C-LQ5WRyZhPs2HtCzis2Tg@mail.gmail.com>
In-Reply-To: <CAHQjnOPMRQetGF5VnwsMD=_JxWC5C-LQ5WRyZhPs2HtCzis2Tg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-26 10:16:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-26 10:16:54
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 08:44 AM, KyongHo Cho wrote:

> Hi.
> 
> On Sat, Sep 24, 2011 at 6:38 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Sat, Sep 24, 2011 at 07:35:45AM +0000, 조경호 wrote:
>>> +# EXYNOS IOMMU support
>>> +config EXYNOS_IOMMU
>>> + bool "Exynos IOMMU Support"
>>> + depends on ARCH_EXYNOS4
>>> + select IOMMU_API
>>> + select EXYNOS4_DEV_SYSMMU
>>> + help
>>
>> Looks like your mailer converted tabs to one space.  This makes it more
>> difficult to read this patch as a whole.  Don't expect good reviews as
>> long as your mailer breaks stuff in this way.
> Sorry for that :(
> I will try another way to send patches correctly.


Use *git send-email* instead.

Thanks
