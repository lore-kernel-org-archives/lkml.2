Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1FVJKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:10:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15897 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1FVJKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:10:48 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-df-4e01b195cc8f
Date: Wed, 22 Jun 2011 18:10:35 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH] Samsung SoC: header file revised to prevent declaring
 duplicated.
In-reply-to: <1308214064-12796-1-git-send-email-myungjoo.ham@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com, dg77.kim@samsung.com
Message-id: <00be01cc30bc$450ee250$cf2ca6f0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwsAg7+2pfX5K94TwqzKstH4SbB8AEufxgQ
References: <1308213184-6607-1-git-send-email-myungjoo.ham@samsung.com>
 <1308214064-12796-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MyungJoo Ham wrote:
> 
> There has been no #ifndef - #define - #endif protection for this header
> file. The patch adds it for Exynos4-ADC support
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  arch/arm/plat-samsung/include/plat/devs.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-
> samsung/include/plat/devs.h
> index 4af108f..3c87779 100644
> --- a/arch/arm/plat-samsung/include/plat/devs.h
> +++ b/arch/arm/plat-samsung/include/plat/devs.h
> @@ -12,6 +12,9 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>  */
> +#ifndef __PLAT_DEVS_H
> +#define __PLAT_DEVS_H __FILE__
> +
>  #include <linux/platform_device.h>
> 
>  struct s3c24xx_uart_resources {
> @@ -159,3 +162,5 @@ extern struct platform_device s3c_device_ac97;
>   */
>  extern void *s3c_set_platdata(void *pd, size_t pdsize,
>  			      struct platform_device *pdev);
> +
> +#endif /* __PLAT_DEVS_H */
> --
> 1.7.4.1

OK, applied.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

