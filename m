Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab2CRN1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 09:27:48 -0400
Received: from 8bytes.org ([88.198.83.132]:49215 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2CRN1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 09:27:47 -0400
Date: Sun, 18 Mar 2012 14:27:46 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Subash Patel <subash.ramaswamy@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 2/3] ARM: EXYNOS: Change System MMU platform device
	definitions
Message-ID: <20120318132746.GL26973@8bytes.org>
References: <000201cd0286$2e6fbb40$8b4f31c0$%cho@samsung.com> <20120315111227.GA2384@amd.com> <4F61FF1D.5000502@samsung.com> <4F630841.2070307@linaro.org> <4F63A6F6.9050506@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63A6F6.9050506@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 01:47:50PM -0700, Kukjin Kim wrote:
> Anyway Joerg, how do you want to handle this? Do you want to pick up  
> 1/2/3 all of them in your tree? If so, 2nd patch should be on top of  
> some samsung topic stuff.

Since patch 2 only applies to the Samsung tree, it is best to carry
this in your tree for merging. Feel free to add my Acked-by to patch 3.
But any further patches for the Exynos IOMMU drivers should go through
my tree after it is merged.


Thanks,

	Joerg

