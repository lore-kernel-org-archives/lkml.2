Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab2KZIZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:25:32 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46043 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2KZIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:25:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAEk7JKYs2RiNX9vzrNr1eA6-CPMogVvgpO3j8VRhv6dFyPWhNg@mail.gmail.com>
References: <CAEk7JKYs2RiNX9vzrNr1eA6-CPMogVvgpO3j8VRhv6dFyPWhNg@mail.gmail.com>
Date: Mon, 26 Nov 2012 18:25:31 +1000
Message-ID: <CAPM=9tygxEKvF6Hi8LXTQoHjFwTn3OZ-UmFpj1znGhas=HziMA@mail.gmail.com>
Subject: Re: Questions about function detect_intel_iommu(void)
From: Dave Airlie <airlied@gmail.com>
To: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 4:36 PM, Li, Zhen-Hua <lizhenhua.dev@gmail.com> wrote:
> Hi all,
>      I am debugging a bug about iommu recently and got a question
> about the function detect_intel_opmmu,  Could anybody kindly help me?
>
>      In dmar.c, this function :
>                 void __init detect_intel_iommu(void)
>      In 2.6.32 and redhat enterprise kernel 2.6.18, it is called by
> x86_64 system . But in kernel 3.5.2, it is only needed on IA64 system.
>
>     And my question is: is this function really needed for x86_64 and
> i386 in 2.6.32?

Not sure why you think its IA64, its called from the iommu init code
in 3.x here.

via the IOMMU_INIT_POST macro
Dave.
>
>
> Thanks and Regards.
>
> Li, Zhen-Hua
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
