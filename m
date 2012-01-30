Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2A3Kes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:34:48 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50044 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab2A3Keq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <017b01ccdc99$44a12420$cde36c60$%kim@samsung.com>
References: <001001ccc625$0afa7ee0$20ef7ca0$%cho@samsung.com>
	<20120123142706.GA6269@8bytes.org>
	<CAHQjnOMyoOH2cFjjGSzMvefZTQGROmQgaA8S0MmxnKGHWyQhyA@mail.gmail.com>
	<017b01ccdc99$44a12420$cde36c60$%kim@samsung.com>
Date: Mon, 30 Jan 2012 19:34:45 +0900
X-Google-Sender-Auth: oU088l603XFI4spbiAtLu2lPkmI
Message-ID: <CAHQjnOPi=+iQLkeZ49mSPj4Sq97QGFAjP4NYcugjMQ_3dPuyVw@mail.gmail.com>
Subject: Re: [PATCH v8 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, linux-samsung-soc@vger.kernel.org,
        Subash Patel <subash.ramaswamy@linaro.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 11:13 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> KyongHo Cho wrote:
>>
>> Hi,
>> On Mon, Jan 23, 2012 at 11:27 PM, Joerg Roedel <joro@8bytes.org> wrote:
>> > Hi,
>> >
>> > please also get and inclue Acks from the Exynos maintainer for the next
>> > post.
>> > Since I have a compiling config for exynos now I will merge the patches
>> > when you have the Acks and addressed or explained the issues I pointed
>> > out below.
>> >
>> Thanks for review!
>> I will include the Acks in the next patchset.
>
> If his updated patch is ok to me, let me reply then.
>
> As a note, I'm preparing for new EXYNOS SoC and so some exynos stuff such as
> clock can be modified. So would be better if KyongHo could update regarding
> arch/arm/ part based on that. Maybe in the beginning of Feb.?
>
Thanks.

I will post new patchset when Kukjin completes his job about EXYNOS SoC
because my patchset changes clock definitions of EXYNOS tree.

> Joerg, as I said, I need a topic branch for this to avoid conflict and I
> think, now you can provide it for samsung tree.
>
> If any problems, please let me know.
>
> Thanks.
>

Thank you.

  KyongHo.
