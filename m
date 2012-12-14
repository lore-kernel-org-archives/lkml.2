Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2LNLvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:51:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14785 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2LNLvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:51:35 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cd-50cb12c5250b
From: Tomasz Figa <t.figa@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH 0/3] pinctrl: exynos: add support for Samsung's Exynos5250
Date: Fri, 14 Dec 2012 12:51:27 +0100
Message-id: <2775095.1QDAgbYSYJ@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.3 (Linux/3.5.7-gentoo; KDE/4.9.3; x86_64; ; )
In-reply-to: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jAd1jQqcDDN50slhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU8vjmZsWA7d8XWY19YGhhnc3YxcnJICJhIbHn/kx3C
	FpO4cG89WxcjF4eQwCJGiY1TbjFCOC1MEm1f1jCDVLEJqEl8bnjEBmKLCOhJHHz6kRWkiFlg
	E6PE/KYvLCAJYQE/id9zQRKcHCwCqhJLd/xjBLF5BTQlvn57CraOX0Bd4t22p0wgtqiAs8S+
	6x/AajgFvCTalneBzRES8JQ49OkTG0SvoMSPyffA4swC8hL79k9lhbC1JNbvPM40gVFwFpKy
	WUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOEyfSe9gXNVgcYhRgINRiYf3
	g9CpACHWxLLiytxDjBIczEoivJJHgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNL
	UrNTUwtSi2CyTBycUg2MDbaPFh7V32G17WyPv/RVJcUl7z7sTp116sbuUK4fH/zFNYVbo2Te
	zXq5LPhV2u7O6uM7E/T3Jqxo/RLjFTszOv5h+IL0nW089trVZ5o4/j94bXXY8Xre5K4/x6KK
	1kQtsvPsqFjfZ902L1P0BfMje+1p23t2W625aq7vWOygm1B27pjWhK5tSizFGYmGWsxFxYkA
	3PVidU8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thursday 13 of December 2012 17:24:01 Thomas Abraham wrote:
> This patch series adds pinctrl driver support for Samsung's Exynos5250
> SoC. The first patch adds the required Exynos5250 SoC specific data
> which is used by the Samsung pinctrl driver to setup the
> pinctrl/pinmux/eint controllers. The second and third patches skips the
> wakeup interrupt and gpiolib registration if the pinctrl support is
> enabled for Exynos5250.
> 
> Thomas Abraham (3):
>   pinctrl: exynos: add exynos5250 SoC specific data
>   gpio: samsung: skip gpiolib registration if pinctrl support is enabled
> for exynos5250 arm: exynos: skip wakeup interrupt registration for
> exynos5250 if pinctrl is enabled
> 
>  arch/arm/mach-exynos/common.c     |    1 +
>  drivers/gpio/gpio-samsung.c       |    1 +
>  drivers/pinctrl/pinctrl-exynos.c  |  108
> +++++++++++++++++++++++++++++++++++++ drivers/pinctrl/pinctrl-samsung.c
> |    2 +
>  drivers/pinctrl/pinctrl-samsung.h |    1 +
>  5 files changed, 113 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good. For the whole series:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Linux Platform

