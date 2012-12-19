Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2LSFpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:45:24 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:44694 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2LSFpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
References: <1355845182-14104-1-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 19 Dec 2012 11:15:16 +0530
Message-ID: <CAFp+6iEcBFDt_yts7uN7NbXmAEkciz=Tqy_75twOxfiaECaBpA@mail.gmail.com>
Subject: Re: [PATCH 0/2] ARM: Exynos5250: Enabling samsung usb phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: dianders@chromium.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, balbi@ti.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson.


On Tue, Dec 18, 2012 at 9:09 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> This patch-set enables the samsung-usbphy driver on exynos5250,
> which enables the support for USB2 type and USB3 type phys.
> The corresponding phy driver patches are available at:
>  1) https://lkml.org/lkml/2012/12/18/201
>  2) https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/024559.html
>
> Tested this patch-set on exynos5250 with following patch-sets for
> USB 2.0 and USB 3.0:
>  - https://patchwork.kernel.org/patch/1794651/
>  - https://lkml.org/lkml/2012/12/18/201
>  - https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-December/024559.html
>  - http://comments.gmane.org/gmane.linux.usb.general/76352
>  - https://lkml.org/lkml/2012/12/13/492
>
> Vivek Gautam (2):
>   ARM: Exynos5250: Enabling samsung-usbphy driver
>   ARM: Exynos5250: Enabling USB 3.0 phy for samsung-usbphy driver
>
>  arch/arm/boot/dts/exynos5250.dtsi       |   23 +++++++++++++++++++++++
>  arch/arm/mach-exynos/include/mach/map.h |    1 +
>  arch/arm/mach-exynos/mach-exynos5-dt.c  |    2 ++
>  3 files changed, 26 insertions(+), 0 deletions(-)
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
