Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab2CBFq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:46:29 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43763 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab2CBFpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:45:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of pullip.linux@gmail.com designates 10.152.132.130 as permitted sender) smtp.mail=pullip.linux@gmail.com; dkim=pass header.i=pullip.linux@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Vg8o_mm0gM042T0-kjMUoAdLzF+DeGErD7R86H0xqXZQ@mail.gmail.com>
References: <001801ccf5e3$69d79860$3d86c920$%cho@samsung.com>
	<CAH9JG2Vg8o_mm0gM042T0-kjMUoAdLzF+DeGErD7R86H0xqXZQ@mail.gmail.com>
Date: Fri, 2 Mar 2012 14:45:43 +0900
X-Google-Sender-Auth: dkqwrOaJoalSymwDXpq4bcwoQ_E
Message-ID: <CAHQjnONxO32WP40sJz80=rjv3kqxmx55MUvjvhhO_mo3DNH8-A@mail.gmail.com>
Subject: Re: [PATCH v9 0/2] iommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 4:01 PM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
> Hi,
>
> Some comments.
> 1. It's not same patch series. since it has additional feature,
> exynos5 series support which don't covered at previous time.
> 2. It assumes that name conversion is based on exynos5 as default. now
> you use gsc at exynos4 even though there's no gsc block. It should be
> fimc.

Thanks. I agree about the second and applied it in the next patchset.

>
> So I suggest to send exynos4 series patch as before and send
> additional exynos5 patch series next.
>

I will just extract a new patch that removes existing system MMU driver from
the previous 2 patches and the patchset will consist of 3 patches.
