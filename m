Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2KUPqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:46:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2KUPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:46:41 -0500
Message-ID: <50ACF755.9000706@samsung.com>
Date: Thu, 22 Nov 2012 00:46:29 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Joerg Roedel'" <joro@8bytes.org>, sw0312.kim@samsung.com,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        prathyush.k@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH v3 01/12] ARM: EXYNOS: remove system mmu initialization
 from exynos tree
References: <002701cdc7a5$756dbdf0$604939d0$%cho@samsung.com>
In-Reply-To: <002701cdc7a5$756dbdf0$604939d0$%cho@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/12 14:02, Cho KyongHo wrote:
> This removes System MMU initialization from arch/arm/mach-exynos/

Basically, looks OK to me, but I think, this removing change should be 
done after 03/12 patch :-)

> to move them to DT and the exynos-iommu driver except gating clock
> definitions.
>
> Change-Id: Ie29f587c01c645f28fc0e0b94eb3631a0170ebf5

No need 'Change-Id' here.

> Signed-off-by: KyongHo Cho<pullip.cho@samsung.com>
> ---
>   arch/arm/mach-exynos/Kconfig               |   5 -
>   arch/arm/mach-exynos/Makefile              |   1 -
>   arch/arm/mach-exynos/clock-exynos4.c       |  41 +++--
>   arch/arm/mach-exynos/clock-exynos4210.c    |   9 +-
>   arch/arm/mach-exynos/clock-exynos4212.c    |  23 ++-
>   arch/arm/mach-exynos/clock-exynos5.c       |  62 ++++---
>   arch/arm/mach-exynos/dev-sysmmu.c          | 274 -----------------------------
>   arch/arm/mach-exynos/include/mach/sysmmu.h |  66 -------
>   arch/arm/mach-exynos/mach-exynos4-dt.c     |  34 ++++
>   arch/arm/mach-exynos/mach-exynos5-dt.c     |  30 ++++
>   10 files changed, 137 insertions(+), 408 deletions(-)
>   delete mode 100644 arch/arm/mach-exynos/dev-sysmmu.c
>   delete mode 100644 arch/arm/mach-exynos/include/mach/sysmmu.h


Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.
