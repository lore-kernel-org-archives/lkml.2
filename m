Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab2KXCKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 21:10:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55916 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab2KXCKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 21:10:09 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e3-50b02c809be5
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Cesar Eduardo Barros'" <cesarb@cesarb.net>, linux-kernel@vger.kernel.org
Cc: "'Ben Dooks'" <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
 <1353716808-16375-4-git-send-email-cesarb@cesarb.net>
In-reply-to: <1353716808-16375-4-git-send-email-cesarb@cesarb.net>
Subject: RE: [PATCH 03/24] MAINTAINERS: remove arch/arm/plat-s5p/
Date: Sat, 24 Nov 2012 11:10:08 +0900
Message-id: <122701cdc9e8$d397d0b0$7ac77210$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3J2nUzbskzHWAOQ5KkiB/ZkuzwOwADWN6g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI90GnQ0BBss3K1hc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXMOvecqeA8T8W6wx/ZGhiPcHUxcnJICJhIrPh2ixnC
	FpO4cG89WxcjF4eQwDJGifauX0wwRdtXrWaBSExnlJiy+SkrhPOXUeL+yWcsIFVsAhoSh98/
	YwexRQR8JO41X2MEsZkFCiQOHXnLBmILCVRKXP/8HizOKeAksXv3HLDVwgKOEn+v/wOaw8HB
	IqAqsftdDUiYV8BWYl/fdjYIW1Dix+R7LBAjtSTW7zzOBGHLS2xe85YZpFVCQF3i0V9diAuM
	JDbNWwlVIiKx78U7sK0sAgIS3yYfYoEol5XYdIAZ5BMJgVXsEluebWCB+FdS4uCKGywTGCVm
	Idk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MkBiT2sG4ssHiEKMA
	B6MSD++Bq+sDhFgTy4orcw8xSnAwK4nwfq0ACvGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+
	MP7zSuINjY1NzExMTcwtTc1NcQgrifM2e6QECAmkJ5akZqemFqQWwYxj4uCUamD0EX/QfvxL
	xR4mx4SAKGuJQwzrmU+c0/n58IlV6Uypy63GyyarvOpVe3FhDv/qN0IBeyU+CmjUnAubppok
	Oe/pQvZrXd5f7y/fqNYYtdpja8SbykjjOQdSz0SbGaWZnRB7wFow16YjzvKHWnVcvde2MKke
	xhyzEo0fWvtbJvz/8HfhqfDLty8qsRRnJBpqMRcVJwIAZwMwBt4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd0GnQ0BBlf+yVhc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmzDr3nKngPE/F
	usMf2RoYj3B1MXJySAiYSGxftZoFwhaTuHBvPVsXIxeHkMB0Rokpm5+yQjh/GSXun3wGVsUm
	oCFx+P0zdhBbRMBH4l7zNUYQm1mgQOLQkbdsILaQQKXE9c/vweKcAk4Su3fPYQaxhQUcJf5e
	/wc0h4ODRUBVYve7GpAwr4CtxL6+7WwQtqDEj8n3WCBGakms33mcCcKWl9i85i0zSKuEgLrE
	o7+6EBcYSWyatxKqRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwBD+T2sG4ssHiEKMAB6MSD++Bq+sDhFgTy4orcw8xSnAwK4nwfq0ACvGm
	JFZWpRblxxeV5qQWH2L0AfpzIrOUaHI+MLnklcQbGpuYGVkamVkYmZib4xBWEudt9kgJEBJI
	TyxJzU5NLUgtghnHxMEp1cCYspatoc1T7kVPldbrh+oCeZOOyMXsmy/OMLGOJY6vvHPXeT2P
	b5PXX3jypVAsMYDh3vLrWmHPW57dEsuQVlC0f6VbdEnaVFqx85ha1uX+/wzts3qXznYSf7ux
	c4PvjdyKhWV7J/XuCVAXy+CXdZooLNpl3iMUcVTuQ0Xnnaam+4+Vdwu9Z1ZiKc5INNRiLipO
	BAAqsku4DQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cesar Eduardo Barros wrote:
> 
> These files were merged into plat-samsung.
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 041872a..9bdd5f3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1074,7 +1074,6 @@ W:	http://www.fluff.org/ben/linux/
>  S:	Maintained
>  F:	arch/arm/plat-samsung/
>  F:	arch/arm/plat-s3c24xx/
> -F:	arch/arm/plat-s5p/
>  F:	arch/arm/mach-s3c24*/
>  F:	arch/arm/mach-s3c64xx/
>  F:	drivers/*/*s3c2410*
> @@ -1105,7 +1104,6 @@ M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
>  L:	linux-arm-kernel@lists.infradead.org
>  L:	linux-media@vger.kernel.org
>  S:	Maintained
> -F:	arch/arm/plat-s5p/dev-fimc*
>  F:	arch/arm/plat-samsung/include/plat/*fimc*
>  F:	drivers/media/platform/s5p-fimc/
> 
> @@ -1116,7 +1114,7 @@ M:	Jeongtae Park <jtp.park@samsung.com>
>  L:	linux-arm-kernel@lists.infradead.org
>  L:	linux-media@vger.kernel.org
>  S:	Maintained
> -F:	arch/arm/plat-s5p/dev-mfc.c
> +F:	arch/arm/plat-samsung/s5p-dev-mfc.c
>  F:	drivers/media/platform/s5p-mfc/
> 
>  ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
> --
> 1.7.11.7

