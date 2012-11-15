Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768761Ab2KOTGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:06:03 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48225 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768646Ab2KOTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:06:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=WgbaTupjayMLmgptfLtNkkk_GZL8RYQrYn8O7FG5GpANswg@mail.gmail.com>
References: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
	<1352860489-19960-3-git-send-email-omar.luna@linaro.org>
	<CAK=WgbZm+sjavwb_Li_W5ygm0XuS9YMYfQEkdoB188Uir0arGg@mail.gmail.com>
	<CALLhW=46xUZzuEBaQD7vsOTQOGR7bwXMSM_mugN_gWa-oqwfuw@mail.gmail.com>
	<CAK=WgbaTupjayMLmgptfLtNkkk_GZL8RYQrYn8O7FG5GpANswg@mail.gmail.com>
Date: Thu, 15 Nov 2012 13:05:58 -0600
Message-ID: <CALLhW=6yKs8Moq6zAP06E6Nevhj8v5C-BGSgNyCsQbYXoJpLxQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: OMAP3/4: iommu: adapt to runtime pm
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>,
        Russell King <linux@arm.linux.org.uk>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2012 11:39, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> I do agree description is missing, again I thought I had done this
>> somewhere but looks like I didn't, will update these. If you think
>> these should be different patches please let me know, otherwise I
>> would like to keep a single *documented* patch.
>
> It seems like there are 3 different logical changes here:
>
> 1. remove clk_* invocations from iommu_fault_handler()
> 2. keep clocks enabled as long as iommu is enabled
> 3. convert to runtime pm
>
> If we split this to three patches in this order, you won't have to add
> and remove runtime pm functions.
>
> Let's do it, please. It's a small nuisance now, but may be really
> helpful in the future when someone tries to debug stuff and understand
> the motivation behind these changes. It'd make it much easier for you
> to document the changes, too: you have an entire commit log per
> change.

Ok, not a problem then.

Cheers,

Omar
