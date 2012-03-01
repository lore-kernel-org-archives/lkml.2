Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966053Ab2CAKjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:39:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52402 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2CAKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:39:29 -0500
Date: Thu, 01 Mar 2012 11:40:27 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v9 0/2] iommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
In-reply-to: <001801ccf5e3$69d79860$3d86c920$%cho@samsung.com>
To: pullip.cho@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Message-id: <00fe01ccf797$b7ced690$276c83b0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AczxzGDy6asCBWuSSRqWu8xyxQTsHQEFRunwAG1eZ5A=
References: <001801ccf5e3$69d79860$3d86c920$%cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, February 28, 2012 7:37 AM KyongHo Cho wrote:

> Changes since v8:
> - exynos_iommu_map/unmap() just works for the page sizes
>    that System MMU supports. (Joerg's comment)
> - 1 platform device for 1 H/W though a multimedia accelerator
>    with several System MMUs attached.
>    This make controlling System MMU simpler.
> - Information between System MMU and the accelerators:
>    Shifted to accelerator's device structure from System MMU's

Could you tell which kernel tree did you use as a base for this patch? 

It doesn't apply onto any of the known kernel trees (I've tried v3.2, v3.3-rc5 and
kgene/for-next). It looks that you have used some internal tree because cannot 
find arch/arm/mach-exynos/clock-exynos5.c or arch/arm/mach-exynos/clock-exynos4212.c
files in any of the public git repositories. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



