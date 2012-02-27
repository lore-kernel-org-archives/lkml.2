Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2B0QE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:04:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60686 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124Ab2B0QE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:04:27 -0500
MIME-Version: 1.0
In-Reply-To: <000701ccf567$b9dee150$2d9ca3f0$%szyprowski@samsung.com>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
	<014601ccf2fa$a25c8560$e7159020$%szyprowski@samsung.com>
	<CAHQjnOPE5X=dn+8D348OruLqoYNGZwZk3eLtLRSERce-eTzXDg@mail.gmail.com>
	<000701ccf567$b9dee150$2d9ca3f0$%szyprowski@samsung.com>
Date: Tue, 28 Feb 2012 01:04:25 +0900
X-Google-Sender-Auth: J7uuknqITHc5afa7x-1RmKEiAG4
Message-ID: <CAHQjnON=Q9oR5s1geO_MWeG0aKKrNkyqbS2RAD1deH22fj5T0A@mail.gmail.com>
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
From: KyongHo Cho <pullip.cho@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 12:51 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:

>> The next patch will be submitted by 2/28.
>
> Ok, I will check it soon then.

Thank you a lot.

>> The next IOMMU driver defines just one platform device for a H/W device.
>> Thus, it defines just one SYSMMU_MFC platform device, for example.
>> (the previous one defines 2 platform devices for SYSMMU_MFC)
>
> Exynos4210 has 2 iommu controllers for MFC device - one for each memory bus.
> Each MFC bus can address 128MiB of IO address space. Do you mean that the new driver
> will merge these 2 controllers into one? This way we will lose half of address space
> for MFC device.

The situation seems somewhat different from our use of MFC. I also
heard from Jungtae Park
that it is better to define separate platform devices for the system
MMUs of MFC.

Regards,

Cho KyongHo.
