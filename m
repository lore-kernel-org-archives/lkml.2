Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1LGI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:58:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65199 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1LGI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:58:08 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-e2-4edf2a9ea3cf
From: Boojin Kim <boojin.kim@samsung.com>
To: tushar.behera@linaro.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com
References: <03ed01ccb4b3$714b7ce0$53e276a0$%kim@samsung.com>
In-reply-to: <03ed01ccb4b3$714b7ce0$53e276a0$%kim@samsung.com>
Subject: RE: [PATCH 0/2] Add PM_RUNTIME related fixes for PL330
Date: Wed, 07 Dec 2011 17:58:06 +0900
Message-id: <000301ccb4be$55cc4ca0$0164e5e0$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy0BLXOPllIhq67SmO8RbByiy5Q5QArrkSgAAHCZvA=
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera [mailto:tushar.behera@linaro.org] wrote:

> Sent: Tuesday, December 06, 2011 7:46 PM
> To: linux-samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: kgene.kim@samsung.com; vinod.koul@intel.com;
> linaro-dev@lists.linaro.org; patches@linaro.org
> Subject: [PATCH 0/2] Add PM_RUNTIME related fixes for PL330
>
> Hi,
>
> When PM_RUNTIME is enabled, PL330 probe fails because of some
> mismatch in pm_runtime calls. This patchset fixes those issues.
>
> This patch is based on Kukjin's for-next branch and tested on
> EXYNOS4 based Origen board.
>

This patch works well when PM_RUNTIME is enabled.
Looks good to me. Thanks.

> d3d936c "Merge branch 'samsung-fixes-2' into for-next"
>
> Tushar Behera (2):
> To Vinod Koul <vinod.koul@intel.com>:
>   DMA: PL330: Remove pm_runtime_xxx calls from pl330 probe/remove
>
> To Kukjin Kim <kgene.kim@samsung.com>:
>   ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1
>
>  arch/arm/mach-exynos/clock.c |    1 +
>  drivers/dma/pl330.c          |   17 ++---------------
>  2 files changed, 3 insertions(+), 15 deletions(-)
>

> --
> 1.7.4.1


