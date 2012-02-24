Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab2BXNqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:46:05 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41961 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BXNqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Fri, 24 Feb 2012 14:45:56 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
In-reply-to: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
To: pullip.cho@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Message-id: <014601ccf2fa$a25c8560$e7159020$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczGJMkQSC3xCF3PRT6v7FM7y8tKXgszhwyQ
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, December 29, 2011 1:24 PM KyongHo Cho wrote:

> Changes since v7:
> - Rebased with the recent commits of the following git branches
>   * git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git/next
>   * git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/for-next
> - Changed magic numbers into macros
> - Setting owner of a System MMU in 'iommu' field of dev_archdata
> - Verbose message in the default fault handler
> - Some bug fixes.

(snipped)

The time is flying away and v3.4 merge windows will open soon. Do you plan to
send an updated version of the SYSMMU driver anytime soon? It will be really 
nice to have it finally merged to v3.4.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



