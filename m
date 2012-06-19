Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2FSIvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:51:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47445 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2FSIvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:51:07 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-de-4fe03d77afa7
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1339078540.25798.13.camel@x61.thuisdomein>
In-reply-to: <1339078540.25798.13.camel@x61.thuisdomein>
Subject: RE: [PATCH] ARM: s3c24xx: remove unused header
Date: Tue, 19 Jun 2012 17:51:02 +0900
Message-id: <019c01cd4df8$a80f5e20$f82e1a60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1EuAYQEBsJ9WzNT0Os7d+H1Gz+LgJP0HUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd1y2wf+Br2fdCwu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK61wYWTBSpWLrYtoHxkEAXIweHhICJxJt7bl2MnECm
	mMSFe+vZuhi5OIQEFjFK9OzqZYVw/jJK7Du6jhWkik1AQ+Lw+2fsILaIQLHE5j3XmEAGMQtk
	S2x5xQQSFhIwl/jQeI4RxOYUsJBYtOwtWFwYKN4wdyNYOYuAqsTRCVIgYV4BW4m+Y+uYIWxB
	iR+T77GA2MwC6hKT5i1ihrC1JZ68u8AKcbK6xKO/uiCmiICRxLP9rBAVIhL7XrxjnMAoNAvJ
	oFlIBs1CMmgWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLD+JnUDsaVDRaHGAU4
	GJV4eA/KPfAXYk0sK67MPcQowcGsJMK76v99fyHelMTKqtSi/Pii0pzU4kOM0hwsSuK8TdYX
	/IUE0hNLUrNTUwtSi2CyTBycUg2MQUyOXZmcqjfmV9/2nLpg3pQdaW6Jkhn+LGt4dd/acLxc
	ZHUq41cCq2X/4RTBRasrS58/09Baxf1+f29cyZxDVbUyut27WS+kNX1aJ3V1q5+R+Peq1cJv
	nprf19q5xXXSy6cvf9kcllAxnqw1aQJH97wJh5TW61Y1e6wS8ax4ouR/b4Kf1NuFSizFGYmG
	WsxFxYkA72cU018CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Since (at least) v2.6.12-rc2 there has been a bast-pmu.h header in the
> tree. Currently it can be found at
> arch/arm/mach-s3c24xx/include/mach/bast-pmu.h.
> 
> It seems that during that entire period nothing included that header and
> that none of the named constants it provided were ever used. That header
> can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested with "git grep". But it's again hard to imagine how this could
> break anything.
> 
>  arch/arm/mach-s3c24xx/include/mach/bast-pmu.h |   40 ---------------------
> ----
>  1 files changed, 0 insertions(+), 40 deletions(-)
>  delete mode 100644 arch/arm/mach-s3c24xx/include/mach/bast-pmu.h
> 
> diff --git a/arch/arm/mach-s3c24xx/include/mach/bast-pmu.h
> b/arch/arm/mach-s3c24xx/include/mach/bast-pmu.h
> deleted file mode 100644
> index 4c38b39..0000000
> --- a/arch/arm/mach-s3c24xx/include/mach/bast-pmu.h
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -/* arch/arm/mach-s3c2410/include/mach/bast-pmu.h
> - *
> - * Copyright (c) 2003-2004 Simtec Electronics
> - *	Ben Dooks <ben@simtec.co.uk>
> - *	Vincent Sanders <vince@simtec.co.uk>
> - *
> - * Machine BAST - Power Management chip
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> -*/
> -
> -#ifndef __ASM_ARCH_BASTPMU_H
> -#define __ASM_ARCH_BASTPMU_H "08_OCT_2004"
> -
> -#define BASTPMU_REG_IDENT	(0x00)
> -#define BASTPMU_REG_VERSION	(0x01)
> -#define BASTPMU_REG_DDCCTRL	(0x02)
> -#define BASTPMU_REG_POWER	(0x03)
> -#define BASTPMU_REG_RESET	(0x04)
> -#define BASTPMU_REG_GWO		(0x05)
> -#define BASTPMU_REG_WOL		(0x06)
> -#define BASTPMU_REG_WOR		(0x07)
> -#define BASTPMU_REG_UID		(0x09)
> -
> -#define BASTPMU_EEPROM		(0xC0)
> -
> -#define BASTPMU_EEP_UID		(BASTPMU_EEPROM + 0)
> -#define BASTPMU_EEP_WOL		(BASTPMU_EEPROM + 8)
> -#define BASTPMU_EEP_WOR		(BASTPMU_EEPROM + 9)
> -
> -#define BASTPMU_IDENT_0		0x53
> -#define BASTPMU_IDENT_1		0x42
> -#define BASTPMU_IDENT_2		0x50
> -#define BASTPMU_IDENT_3		0x4d
> -
> -#define BASTPMU_RESET_GUARD	(0x55)
> -
> -#endif /* __ASM_ARCH_BASTPMU_H */
> --
> 1.7.7.6

Yes, I think, no longer need above header. Will apply this into cleanup branch.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

