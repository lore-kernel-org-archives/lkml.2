Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2KUJn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:43:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31375 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2KUJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:43:23 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-3a-50aca23a3de9
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353450155-1663-1-git-send-email-dianders@chromium.org>
In-reply-to: <1353450155-1663-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] ARM: exynos: dt: add all i2c busses to auxdata
Date: Wed, 21 Nov 2012 18:43:22 +0900
Message-id: <0dfe01cdc7cc$a5585da0$f00918e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HbaUqRzgn4yKSSCOWKGEHq5HDPAAO3JLg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zI12rRWsCDH5d1rbo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK+P13VaWgibeivWzZBoY/3J1MXJySAiYSKxY
	vZANwhaTuHBvPZDNxSEksIxRov/KCaYuRg6wojMnrSDiixglFl9fxwrh/GWU6DnQCdbNJqAh
	cfj9M3YQW0TAT+Lo8x1MIEXMAg8ZJd4/X8wOMklIwEWi/6kMSA2ngKvEpbezwOqFBZwlNi98
	yQxSwiKgKvHhDQtImFfAVuLBz/tsELagxI/J98DizAJaEut3HmeCsOUlNq95ywxxp7rEo7+6
	EBcYSTy+95wZokREYt+Ld4wgNouAgMS3yYdYIMplJTYdYIZ4fRu7xO/bNhC2pMTBFTdYJjBK
	zEKyeBaSxbOQLJ6FZMMCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFxJrWDcWWDxSFG
	AQ5GJR7ejWtXBwixJpYVV+YeYpTgYFYS4d00ZU2AEG9KYmVValF+fFFpTmrxIUYfoMMnMkuJ
	JucDU0BeSbyhsbGJmYmpibmlqbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYyz52+6
	udZ0m2LUQrk5YVP8ZOYWzj+YHVq8wN5i7SKtmUUm+364Ley943jyl6yxm2TlFK3AhIDOXSoW
	no/F86ozCz23z50R8jfgXLxQ33LZd+cZp6W9fLGhMl7zuOeW2xp18lrrOfmiZvv5mefdVjKw
	3b1iwcuk+5sscuLuzX9YeOLKD4sjq5YqsRRnJBpqMRcVJwIAGLC2FeACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAV2rRWsCDObvUbfo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHj9d1W
	loIm3or1s2QaGP9ydTFycEgImEicOWnVxcgJZIpJXLi3nq2LkYtDSGARo8Ti6+tYIZy/jBI9
	BzrZQKrYBDQkDr9/xg5iiwj4SRx9voMJpIhZ4CGjxPvni9lBpgoJuEj0P5UBqeEUcJW49HYW
	WL2wgLPE5oUvmUFKWARUJT68YQEJ8wrYSjz4eZ8NwhaU+DH5HlicWUBLYv3O40wQtrzE5jVv
	mSFuVpd49FcX4gIjicf3njNDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIjuNnUjsYVzZYHGIU4GBU4uHduHZ1gBBrYllxZe4hRgkOZiUR
	3k1T1gQI8aYkVlalFuXHF5XmpBYfYvQB+nMis5Rocj4wxeSVxBsam5gZWRqZWRiZmJvjEFYS
	5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwFgsae5y+qXnnpR7kpe7c6cuKlPkONkXaiWtzbBA
	wDn2ZYL25Uu3eJyS397crvs9tVL+zWy9pMfqwXxGJXcKvqsVcvC/v5Dd+HNjqvHXh768U+vM
	/IXPiHluCTlf+mbli9crHD7PP3XFojk9d9Ojve3/JtkfetB9zNt+Q3Xlp+hlUr6iP1V3lCux
	FGckGmoxFxUnAgDD+H3wEAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> From: Olof Johansson <olof@lixom.net>
> 
> Needed to match device ids for clocks, etc.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> ---
>  arch/arm/mach-exynos/mach-exynos5-dt.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-
> exynos/mach-exynos5-dt.c
> index ed37273..e1491f7 100644
> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
> @@ -52,6 +52,16 @@ static const struct of_dev_auxdata
> exynos5250_auxdata_lookup[] __initconst = {
>  				"s3c2440-i2c.1", NULL),
>  	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(2),
>  				"s3c2440-i2c.2", NULL),
> +	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(3),
> +				"s3c2440-i2c.3", NULL),
> +	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(4),
> +				"s3c2440-i2c.4", NULL),
> +	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(5),
> +				"s3c2440-i2c.5", NULL),
> +	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(6),
> +				"s3c2440-i2c.6", NULL),
> +	OF_DEV_AUXDATA("samsung,s3c2440-i2c", EXYNOS5_PA_IIC(7),
> +				"s3c2440-i2c.7", NULL),
>  	OF_DEV_AUXDATA("samsung,s3c2440-hdmiphy-i2c", EXYNOS5_PA_IIC(8),
>  				"s3c2440-hdmiphy-i2c", NULL),
>  	OF_DEV_AUXDATA("samsung,exynos5250-dw-mshc", EXYNOS5_PA_DWMCI0,
> --
> 1.7.7.3

Looks ok to me, applied.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

