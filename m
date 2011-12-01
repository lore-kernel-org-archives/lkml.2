Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1LAH3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:29:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54003 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1LAH3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:29:22 -0500
X-AuditID: cbfee61a-b7b62ae0000030b0-d0-4ed72cd0398f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Joerg Roedel'" <joro@8bytes.org>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
 <20111123114626.GH20535@8bytes.org>
In-reply-to: <20111123114626.GH20535@8bytes.org>
Subject: RE: [PATCH v7 0/2] iommu/exynos: Add IOMMU/System MMU driver for
	Samsung Exynos
Date: Thu, 01 Dec 2011 16:29:17 +0900
Message-id: <045b01ccaffa$ef48c430$cdda4c90$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyp1YpHAmV6SjFdTN6nFjHQdqZD3wGDq7ZA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> 
> On Fri, Nov 18, 2011 at 06:47:28PM +0900, KyongHo Cho wrote:
> > Changes since v6:
> > - Totally rewrite exynos_iommu_map() and exynos_iommu_unmap() according
> >   to the change in iommu_map() and iommu_unmap().
> > - Change special slab for Lv2 page table to kmalloc().
> 
> Okay, the driver looks good to me now. If there are no further
> objections I am going to merge it for 3.3.
> 

Hi Joerg,

Sorry for late response, I came back just now from family travelling...

Anyway, that touches many Samsung stuff so it would be better if you could
create separate topic branch which can be merged into Samsung tree. And if
required, please add my ack on them.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

