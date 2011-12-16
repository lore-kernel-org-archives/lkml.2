Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775Ab1LPOPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:15:32 -0500
Received: from 8bytes.org ([88.198.83.132]:36868 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509Ab1LPOPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:15:10 -0500
Date: Fri, 16 Dec 2011 15:15:07 +0100
From: "'Joerg Roedel'" <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>
Subject: Re: [PATCH] iommu: Initialize domain->handler in
	iommu_domain_alloc()
Message-ID: <20111216141507.GB28302@8bytes.org>
References: <1323760466-30333-1-git-send-email-pullip.cho@samsung.com> <20111215081056.GC4475@8bytes.org> <000401ccbbef$9b0389e0$d10a9da0$%cho@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401ccbbef$9b0389e0$d10a9da0$%cho@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 09:38:25PM +0900, KyongHo Cho wrote:
> Subject: [PATCH] iommu: Initialize domain->handler in iommu_domain_alloc()
> 
> Since it is not guaranteed that an iommu driver initializes in its
> domain_init() function, it must be initialized with NULL to prevent
> calling a function in an arbitrary location when iommu fault occurred.
> 
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>

Applied to iommu/fixes, thanks a lot.

