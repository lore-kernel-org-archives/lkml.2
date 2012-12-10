Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2LJBxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:53:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14884 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2LJBxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:53:17 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e1-50c54085b099
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Michael Spang'" <spang@chromium.org>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>
References: <1354749432-6028-1-git-send-email-spang@chromium.org>
In-reply-to: <1354749432-6028-1-git-send-email-spang@chromium.org>
Subject: RE: [PATCH] samsung: Add missing include guard to gpio-core.h
Date: Mon, 10 Dec 2012 10:53:09 +0900
Message-id: <032201cdd679$1afe4230$50fac690$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3TPsKbCzwsiV2lQzOxqpQunhE0zQDOkpkw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zI91Wh6MBBvfn61tc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGUcfHObreABZ8WWX8vZGhincXQxcnJICJhIbNzzlg3C
	FpO4cG89kM3FISSwjFHi4tz5TDBFM3esYIVITGeUeHvhBBOE85dRYvX7RlaQKjYBDYnD75+x
	g9giAm4SMxa0MIIUMQvMZJSYumQjC0hCSMBRYvKdP8wgNqeAk8Ta83/AVggDNXw72QM2iEVA
	VWLy+w9gcV4BW4kdi05D2YISPybfA5vDLKAlsXlbEyuELS+xec1boJkcQKeqSzz6qwtxg5HE
	ue0P2SFKRCT2vXjHCDFeQOLb5EMsEOWyEpsOMIOcKSGwjl3i2eZbrBAfS0ocXHGDZQKjxCwk
	m2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESZ1I7GFc2WBxiFOBg
	VOLhDVA8GiDEmlhWXJl7iFGCg1lJhJfr2JEAId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4H
	poC8knhDY2MTMxNTE3NLU3NTHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhjVdm5om/Uy
	o83n47att9V+3Zy7OPHv8iPrns58cVwrpTHv6fyuQpv4X2ff7HJpu35oWfqhZKOaaJEO/0fV
	fvPbZp/XPnAon+0wd5nGDBmxDH3rp5USbQ/+y9qbvd1x4fi6tfYFovsbK/OqX7fveHE9UE8i
	MD/mlLnwy39CgVKFJn+8J/E7OMUpsRRnJBpqMRcVJwIAVawiMeACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd1Wh6MBBi/6tC0u75rDZjHj/D4m
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzDr65zVbwgLNi
	y6/lbA2M0zi6GDk5JARMJGbuWMEKYYtJXLi3nq2LkYtDSGA6o8TbCyeYIJy/jBKr3zeCVbEJ
	aEgcfv+MHcQWEXCTmLGghRGkiFlgJqPE1CUbWUASQgKOEpPv/GEGsTkFnCTWnv/DBGILAzV8
	O9kDNohFQFVi8vsPYHFeAVuJHYtOQ9mCEj8m3wObwyygJbF5WxMrhC0vsXnNW6CZHECnqks8
	+qsLcYORxLntD9khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn
	5haX5qXrJefnbmIER/EzqR2MKxssDjEKcDAq8fAGKB4NEGJNLCuuzD3EKMHBrCTCy3XsSIAQ
	b0piZVVqUX58UWlOavEhRh+gRycyS4km5wMTTF5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAh
	gfTEktTs1NSC1CKYcUwcnFINjH5PFFtmZSVmzHlx/sfXqzvdxG0efb7IEH4zjWX2kgfxRl/+
	Ffb3PLq0aYdUauvp8KlyfpuWr+P98denL1rq88qbL14EnM022laTvV3kvcLbewVTsuQt/7sc
	9D3/zJE9c6V0t1rs/Xnlh1WDVq9RZNc326ixozFlF7eNdssMpZnL7btOPmD8c1CJpTgj0VCL
	uag4EQAp+bDPDwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Spang wrote:
> 
> Signed-off-by: Michael Spang <spang@chromium.org>
> ---
>  arch/arm/plat-samsung/include/plat/gpio-core.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h
> b/arch/arm/plat-samsung/include/plat/gpio-core.h
> index 1fe6917..8622c9a 100644
> --- a/arch/arm/plat-samsung/include/plat/gpio-core.h
> +++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
> @@ -11,6 +11,9 @@
>   * published by the Free Software Foundation.
>  */
> 
> +#ifndef __PLAT_SAMSUNG_GPIO_CORE_H
> +#define __PLAT_SAMSUNG_GPIO_CORE_H
> +
>  #define GPIOCON_OFF	(0x00)
>  #define GPIODAT_OFF	(0x04)
> 
> @@ -122,3 +125,5 @@ extern struct samsung_gpio_pm samsung_gpio_pm_4bit;
>  /* locking wrappers to deal with multiple access to the same gpio bank */
>  #define samsung_gpio_lock(_oc, _fl) spin_lock_irqsave(&(_oc)->lock, _fl)
>  #define samsung_gpio_unlock(_oc, _fl)
spin_unlock_irqrestore(&(_oc)->lock,
> _fl)
> +
> +#endif /* __PLAT_SAMSUNG_GPIO_CORE_H */
> --
> 1.7.7.3

Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

