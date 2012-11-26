Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2KZIoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:44:10 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35923 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2KZIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tygxEKvF6Hi8LXTQoHjFwTn3OZ-UmFpj1znGhas=HziMA@mail.gmail.com>
References: <CAEk7JKYs2RiNX9vzrNr1eA6-CPMogVvgpO3j8VRhv6dFyPWhNg@mail.gmail.com>
	<CAPM=9tygxEKvF6Hi8LXTQoHjFwTn3OZ-UmFpj1znGhas=HziMA@mail.gmail.com>
Date: Mon, 26 Nov 2012 16:44:08 +0800
Message-ID: <CAEk7JKYQVj6E-QoA+-5EwMGXXdN-6Yt_9_kUcsyZ7x89p=OOFQ@mail.gmail.com>
Subject: Re: Questions about function detect_intel_iommu(void)
From: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I read the code of kernel 3.5.2, and found this function is only
called in function void __init pci_iommu_alloc(void) in file
arch/ia64/kernel/pci-dma.c .
So I think it is only called on IA64 system.


On Mon, Nov 26, 2012 at 4:25 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Nov 26, 2012 at 4:36 PM, Li, Zhen-Hua <lizhenhua.dev@gmail.com> wrote:
>> Hi all,
>>      I am debugging a bug about iommu recently and got a question
>> about the function detect_intel_opmmu,  Could anybody kindly help me?
>>
>>      In dmar.c, this function :
>>                 void __init detect_intel_iommu(void)
>>      In 2.6.32 and redhat enterprise kernel 2.6.18, it is called by
>> x86_64 system . But in kernel 3.5.2, it is only needed on IA64 system.
>>
>>     And my question is: is this function really needed for x86_64 and
>> i386 in 2.6.32?
>
> Not sure why you think its IA64, its called from the iommu init code
> in 3.x here.
>
> via the IOMMU_INIT_POST macro
> Dave.
>>
>>
>> Thanks and Regards.
>>
>> Li, Zhen-Hua
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
