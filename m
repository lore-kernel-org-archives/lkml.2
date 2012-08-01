Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2HAJbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:31:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42735 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2HAJbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:31:40 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-b8-5018f778c052
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: joerg.roedel@amd.com, pullip.cho@samsung.com, patches@linaro.org
References: <1343811917-24054-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1343811917-24054-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH] iommu/exynos: Fix build error
Date: Wed, 01 Aug 2012 18:31:36 +0900
Message-id: <037001cd6fc8$72341290$569c37b0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1vxPBVyZM3TnIvRBi6mLrNJwUpggAA20IQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd2K7xIBBhc3KVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MX71qBX9ZKr79vc/WwLiApYuRk0NCwETi3sGN7BC2mMSFe+vZ
	uhi5OIQEpjNK7Hm1nRnCmcckseL7bDaQKjYBDYnD75+BdYgIeElcnP+bEcRmFnCReNV2HqxG
	SMBdYmLrHyYQm1PAQ+J6+zVWEFtYwEhi3acfYL0sAqoS02b8BevlFbCVmHzrJjuELSjxY/I9
	FoiZ6hKT5i1ihrC1JZ68uwA0hwPoUnWJR391IU4wkth5u4MNokREYt+Ld4wTGIVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBg/k9rBuLLB4hCjAAejEg/v
	RBOJACHWxLLiytxDjBIczEoivAU3gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jb2/+gsJpCeW
	pGanphakFsFkmTg4pRoYuRfVchyOn7Oad/a8oGuzE7y7inJsDSXPNsrYLiubEP7P50ll0sk9
	sxjWCwTc55/+sE/C8PZcrqoNa97J3PJLNBBdt7szVC7//oEPQWurZ/M533zPuy+s62SZdLSf
	nfF1ERnrv476e7kFXjTyBPRnNv61WLtnQUbvvLCVT835V7ZPZWI73s2oxFKckWioxVxUnAgA
	MNcIHF8CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Kamat wrote:
> 
> Fixes the following build error introduced by commit 3177bb76a8
> ("iommu/exynos: Implement DOMAIN_ATTR_GEOMETRY attribute"):
> 
> drivers/iommu/exynos-iommu.c: In function ‘exynos_iommu_domain_init’:
> drivers/iommu/exynos-iommu.c:735:2: error: ‘dom’ undeclared
> (first use in this function)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

