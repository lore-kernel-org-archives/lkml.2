Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2HJGso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:48:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8269 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2HJGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:48:42 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-e1-5024aec9ce02
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
 <1344437248-20560-6-git-send-email-arnd@arndb.de>
In-reply-to: <1344437248-20560-6-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH 05/11] ARM: exynos: exynos_pm_add_dev_to_genpd may be unused
Date: Fri, 10 Aug 2012 15:48:40 +0900
Message-id: <0de601cd76c4$2d5846c0$8808d440$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac11dMLkwdAZL9LtTxOSm3zZjTy5lwBTvjtQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd2T61QCDKa+5rC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ6y88YS14w1bx9NcitgbGG6xdjJwcEgImElv+d7JD2GISF+6t
	ZwOxhQQWMUosOKnTxcgFZM9jknjz6zcjSIJNQEPi8PtnYA0iAp4SZ04uYAGxmQXaGSXuLxaH
	aC6UOLfpHtggTgE7icVX3oLVCAsESCx42ghmswioSmxq3skMYvMK2Epsad0EZQtK/Jh8D2qm
	lsT6nceZIGx5ic1r3gLVcAAdqi7x6K8uxAlGEueP7IMqEZHY9+Id4wRGoVlIJs1CMmkWkkmz
	kLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcxs+kdzCuarA4xCjAwajEw2ugpxIg
	xJpYVlyZe4hRgoNZSYQ35YVygBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeE++v/kIC6Yklqdmp
	qQWpRTBZJg5OqQbGmedrgnnOfpPfXDlfz221ooH88ZtHXryuXMU/XdX9hURlfht3VRzLYqYN
	2g8EJrrN3PX3q+pbthO7b5h+jS00zk36mv8tukXsO8vklKWJ+VuXbjLWqHRcnbHGP0rU6VdS
	uJabhVy8mM9nhW1XI57sSlJ+c+ZK8rJMjTMzVz0X7jWerHxjyxlGJZbijERDLeai4kQAhioO
	sV8CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> exynos_pm_add_dev_to_genpd is used if one or more out of a large
> number of Kconfig symbols are enabled. However the new
> exynos_defconfig selects none of those, so the function becomes
> unused. Marking it so lets the compiler automatically discard
> it.
> 
> Without this patch, building exynos_defconfig results in:
> 
> arch/arm/mach-exynos/pm_domains.c:118:123: warning:
> 'exynos_pm_add_dev_to_genpd' defined but not used [-Wunused-function]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

