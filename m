Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1KWLq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:46:29 -0500
Received: from 8bytes.org ([88.198.83.132]:52352 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1KWLq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:46:28 -0500
Date: Wed, 23 Nov 2011 12:46:27 +0100
From: Joerg Roedel <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v7 0/2] iommu/exynos: Add IOMMU/System MMU driver for
	Samsung Exynos
Message-ID: <20111123114626.GH20535@8bytes.org>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 06:47:28PM +0900, KyongHo Cho wrote:
> Changes since v6:
> - Totally rewrite exynos_iommu_map() and exynos_iommu_unmap() according
>   to the change in iommu_map() and iommu_unmap().
> - Change special slab for Lv2 page table to kmalloc().

Okay, the driver looks good to me now. If there are no further
objections I am going to merge it for 3.3.


	Joerg

