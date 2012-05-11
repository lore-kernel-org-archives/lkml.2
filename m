Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985Ab2EKUDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 16:03:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58053 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab2EKUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 16:03:15 -0400
Message-ID: <4FAD7E8B.6060407@samsung.com>
Date: Sat, 12 May 2012 06:03:07 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: KyongHo <pullip.cho@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>
Subject: Re: [PATCH] iommu/exynos: Add iommu driver for Exynos Platforms
References: <000001cd2f71$62c5c2f0$285148d0$%cho@samsung.com> <20120511124327.GB11750@amd.com>
In-Reply-To: <20120511124327.GB11750@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/12 21:43, Joerg Roedel wrote:
> On Fri, May 11, 2012 at 09:27:09PM +0900, KyongHo wrote:
>> This is the System MMU driver and IOMMU API implementation for Exynos SOC
>> platforms. Exynos platforms has more than 10 System MMUs dedicated for each
>> multimedia accelerators.
>>
>> The System MMU driver is already in arc/arm/plat-s5p but it is moved to
>> drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers there
>>
>> Any device driver in Exynos platforms that needs to control its System MMU must
>> call platform_set_sysmmu() to inform System MMU driver who will control it.
>> platform_set_sysmmu() is defined in<mach/sysmmu.h>
>>
>> To compile this patch,
>> you will need "for-next" branch of the linux-samsung.git:
>> git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
>> Other patches needed by this patch are merged to the above branch.
>>
>> Cc: Joerg Roedel<joerg.roedel@amd.com>
>> Cc: Kukjin Kim<kgene.kim@samsung.com>
>> Signed-off-by: KyongHo Cho<pullip.cho@samsung.com>
>
> Looks good.
>
> Acked-by: Joerg Roedel<joerg.roedel@amd.com>
>
> Please get this merged via the Samsung tree. Since the patch depends on
> that tree anyway it makes the most sense to be there.
>
Joerg,
OK, I applied with your ack.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
