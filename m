Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2INEeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:34:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65459 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2INEdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:33:35 -0400
X-AuditID: cbfee61b-b7f826d000005fb5-15-5052b39ee25a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Marc Zyngier'" <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
 <1347461906-13527-6-git-send-email-arnd@arndb.de>
In-reply-to: <1347461906-13527-6-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH v9 05/13] ARM: SoC: convert Exynos4 to SoC descriptor
Date: Fri, 14 Sep 2012 13:33:34 +0900
Message-id: <01ae01cd9232$19d78ff0$4d86afd0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2Q9xu4Rq29I4aTS0anwxPQPnvMUgAjJO9g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd15m4MCDO7vUbS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZCy91sxTc46z4tvcxawPjfvYuRk4OCQETianXD0PZYhIX7q1n
	62Lk4hASWMQocaprCwuEM49JYs+Cc0wgVWwCGhKH3z8D6xAR8JJo7NgCFmcWcJP429nNCmIL
	CRRKHLz0AszmFLCTmHV6IZgtLOApsXj1GjYQm0VAVeJo+0uwObwCthKdj3uhbEGJH5PvsUDM
	1JJYv/M41Hx5ic1r3jJ3MXIAXaou8eivLsQJRhLt73dAlYhI7HvxjnECo9AsJJNmIZk0C8mk
	WUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDuRn0jsYVzVYHGIU4GBU4uGNYA0K
	EGJNLCuuzD3EKMHBrCTCa6sNFOJNSaysSi3Kjy8qzUktPsQozcGiJM4r/CkwQEggPbEkNTs1
	tSC1CCbLxMEp1cCYJ5R147mC2hTm6ituOjprF5czet79J3l0/pwQ/9yA14L/K/NyZH9VKoe2
	rtPzSXOY9vXC8cmlZ4++XPhdYyf3eVGnDxkGOu9Y3Y/oFk+aW85fEudwM+Toa80nrAq7krnE
	y/7vqjm7fon449AsC8fYiBtTXJcuW7JX/kBOjqgRf/ckgTQ/2QVKLMUZiYZazEXFiQAFDevD
	YAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Convert Exynos4 to use the SoC descriptor to provide its SMP
> and CPU hotplug operations.
> 
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> Tested-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-exynos/common.h              |    5 +++++
>  arch/arm/mach-exynos/hotplug.c             |   18 +++---------------
>  arch/arm/mach-exynos/mach-armlex4210.c     |    1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c     |    1 +
>  arch/arm/mach-exynos/mach-nuri.c           |    1 +
>  arch/arm/mach-exynos/mach-origen.c         |    1 +
>  arch/arm/mach-exynos/mach-smdk4x12.c       |    2 ++
>  arch/arm/mach-exynos/mach-smdkv310.c       |    2 ++
>  arch/arm/mach-exynos/mach-universal_c210.c |    1 +
>  arch/arm/mach-exynos/platsmp.c             |   20 ++++++++++++++++----
>  10 files changed, 33 insertions(+), 19 deletions(-)

