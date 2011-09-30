Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1I3XvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:51:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab1I3Xuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:50:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110930134243.GR2138@amd.com>
References: <016d01cc7f42$e58a0aa0$b09e1fe0$%kim@samsung.com>
	<20110930134243.GR2138@amd.com>
Date: Sat, 1 Oct 2011 08:50:51 +0900
X-Google-Sender-Auth: Qj108dTNZ359LTjayaleyCZbOuk
Message-ID: <CAHQjnOPVReT3Lk7_Mk864Z8fPVC1dMRCoXmr1tHuBvxspYBGiw@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] ARM: S5P: Remove system MMU driver from arm/plat-s5p
From: KyongHo Cho <pullip.cho@samsung.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        "younglak1004.kim@samsung.com" <younglak1004.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:42 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> On Fri, Sep 30, 2011 at 03:30:57AM -0400, Kukjin Kim wrote:
>> From: KyongHo Cho <pullip.cho@samsung.com>
>>
>> Due to Ohad Ben-Cohen gathered IOMMU drivers in drivers/iommu directory,
>> System MMU driver is moved to drivers/iommu directory and removed
>> from arch/arm/plat-s5p directory.
>>
>> Please see
>> https://lkml.org/lkml/2011/6/8/69
>>
>> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
>> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
>> ---
>>  arch/arm/plat-s5p/Kconfig               |    8 -
>>  arch/arm/plat-s5p/Makefile              |    1 -
>>  arch/arm/plat-s5p/include/plat/sysmmu.h |   95 ----------
>>  arch/arm/plat-s5p/sysmmu.c              |  312 -------------------------------
>
> You can use 'git mv' to just move the file. This ensures bisectability
> of your patches. No need to delete the code in one patch and re-add it
> in the next one (which breaks bisectability).
>
Thanks.
I will do that

Regards,
KyongHo.
